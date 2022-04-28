cmake_minimum_required(VERSION 3.12)

add_executable(gpio_toggle_demo.elf
  Src/main.c
  Src/logging.c
  Src/stm32u5xx_hal_timebase_tim_template.c
)

if("${DEBUG_AUTH_PUBKEY}" STREQUAL "")
  if (OPENSSL)
    add_custom_command(OUTPUT debug_auth.priv.key debug_auth.pub.key
      COMMAND openssl ecparam -name prime256v1 -genkey -noout -out debug_auth.priv.key
      COMMAND openssl ec -in debug_auth.priv.key -pubout -out debug_auth.pub.key
    )

    add_custom_target(debug_keys ALL
      ${CMAKE_COMMAND} -E echo "Generating debug keys"
      DEPENDS debug_auth.priv.key debug_auth.pub.key
    )

    set(DEBUG_AUTH_PUBKEY debug_auth.pub.key)
  else(OPENSSL)
    message("Can't find openssl, will not generate debug keys")
  endif(OPENSSL)
endif()

add_custom_command(OUTPUT gpio_toggle_demo.nodebug.bundle
  DEPENDS gpio_toggle_demo.elf
  COMMAND python3 "${CMAKE_SOURCE_DIR}/twilio-microvisor-tools/bundler-py/bundler.py" gpio_toggle_demo.elf gpio_toggle_demo.nodebug.bundle
)
add_custom_target(nodebug_bundler ALL
  ${CMAKE_COMMAND} -E echo "Generating non-debug bundle"
  DEPENDS gpio_toggle_demo.nodebug.bundle
)

if(NOT "${DEBUG_AUTH_PUBKEY}" STREQUAL "")
  add_custom_command(OUTPUT gpio_toggle_demo.debug.bundle
    DEPENDS gpio_toggle_demo.elf
    COMMAND python3 "${CMAKE_SOURCE_DIR}/twilio-microvisor-tools/bundler-py/bundler.py" --debug-auth-pubkey "${DEBUG_AUTH_PUBKEY}" gpio_toggle_demo.elf gpio_toggle_demo.debug.bundle
  )

  add_custom_target(debug_bundler ALL
    ${CMAKE_COMMAND} -E echo "Generating debug bundle"
    DEPENDS gpio_toggle_demo.debug.bundle
  )
else()
    message("No debug key specified, and couldn't generate them either, won't create a debug bundle")
endif()

target_include_directories(gpio_toggle_demo.elf PUBLIC
  Inc/
)

target_link_libraries(gpio_toggle_demo.elf LINK_PUBLIC ST_Code twilio-microvisor-hal-stm32u5 FreeRTOS)

# Optional informational and additional format generation
add_custom_command(OUTPUT EXTRAS
  DEPENDS gpio_toggle_demo.elf
  COMMAND ${CMAKE_SIZE} --format=berkeley "gpio_toggle_demo.elf"
  COMMAND ${CMAKE_OBJDUMP} -h -S "gpio_toggle_demo.elf" > "gpio_toggle_demo.list"
  COMMAND ${CMAKE_OBJCOPY} -O binary "gpio_toggle_demo.elf" "gpio_toggle_demo.bin"
)

add_custom_target(extras ALL
  ${CMAKE_COMMAND} -E echo "Outputting additional artifacts"
  DEPENDS EXTRAS
)
