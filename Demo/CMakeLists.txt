cmake_minimum_required(VERSION 3.12)

add_executable(${PROJECT_NAME}
  Src/main.c
  Src/logging.c
  Src/stm32u5xx_hal_timebase_tim_template.c
)

target_include_directories(${PROJECT_NAME} PUBLIC
  Inc/
)

target_link_libraries(${PROJECT_NAME} LINK_PUBLIC ST_Code twilio-microvisor-hal-stm32u5 FreeRTOS)

# Optional informational and additional format generation
add_custom_command(OUTPUT EXTRAS
  DEPENDS "${PROJECT_NAME}"
  COMMAND cp "${PROJECT_NAME}" "${PROJECT_NAME}.elf"
  COMMAND ${CMAKE_SIZE} --format=berkeley "${PROJECT_NAME}.elf"
  COMMAND ${CMAKE_OBJDUMP} -h -S "${PROJECT_NAME}.elf" > "${PROJECT_NAME}.list"
  COMMAND ${CMAKE_OBJCOPY} -O binary "${PROJECT_NAME}.elf" "${PROJECT_NAME}.bin"
  COMMAND python3 ../../twilio-microvisor-tools/bundler-py/bundler.py "${PROJECT_NAME}.elf" "${PROJECT_NAME}.zip"
  COMMAND rm -f ../../null.d
)

add_custom_target(extras ALL DEPENDS EXTRAS)
