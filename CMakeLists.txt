######################################################################################
# We can't pass command-line arguments to CMake with the VSCode extension,
# so we set them here as early as possible
######################################################################################

# Required - set toolchain location here
SET(TOOLCHAIN_PREFIX "C:/Program Files (x86)/GNU Tools ARM Embedded/7 2018-q2-update")
MESSAGE(STATUS "TOOLCHAIN_PREFIX: ${TOOLCHAIN_PREFIX}")

# Required - set the STM32 device here
SET(STM32_CHIP STM32L051C8Tx)
MESSAGE(STATUS "STM32_CHIP: ${STM32_CHIP}")

# Should not have to change this
SET(CMAKE_TOOLCHAIN_FILE "cmake/gcc_stm32.cmake")
MESSAGE(STATUS "CMAKE_TOOLCHAIN_FILE: ${CMAKE_TOOLCHAIN_FILE}")

# Should not have to change this
SET(STM32Cube_DIR ${CMAKE_CURRENT_SOURCE_DIR})
MESSAGE(STATUS "STM32Cube_DIR: ${STM32Cube_DIR}")

# Required - Change the line below to match the CubeMX generated linker script
SET(STM32_LINKER_SCRIPT "${CMAKE_CURRENT_SOURCE_DIR}/STM32L051CBTx_FLASH.ld")
MESSAGE(STATUS "STM32_LINKER_SCRIPT: ${STM32_LINKER_SCRIPT}")

# Required - Change the name of your project
PROJECT(displayTest)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)
ENABLE_LANGUAGE(ASM)

SET(PROJECT_INC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/Inc)
SET(PROJECT_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/Src)

FIND_PACKAGE(CMSIS REQUIRED)

# To use STM32CubeMX LL, uncomment line below.  Optionally, set componenets
#FIND_PACKAGE(STM32LL COMPONENTS sdmmc fmc usb REQUIRED)

# To use STM32CubeMX HAL, uncomment line below.  Optionally, set components
#FIND_PACKAGE(STM32HAL COMPONENTS adc cec cortex crc dcmi dma dma2d 
#                                 eth exti flash gpio hash hcd i2c i2s irda 
#                                 iwdg lptim ltdc mmc pcd pwr qspi rcc rtc
#                                 sai sd sdram smartcard spdifrx spi
#                                 tim uart usart wwdg REQUIRED)

# To use FreeRTOS, uncomment line below.  Must set heap implementation
#SET(FREERTOS_HEAP_IMPL 4)
#FIND_PACKAGE(FreeRTOS REQUIRED)

# To use FatFs, uncomment line below.  Must set storage drivers from the 
#  following list SDCARD SDRAM SRAM USBH
#SET(STORAGE_DRIVER "SDCARD")
#FIND_PACKAGE(FATFS REQUIRED)

# To use USBDevice, uncomment line below.  Optionally, set the class(es) in use
#FIND_PACKAGE(USBDevice COMPONENTS CDC REQUIRED)

# To use USBHost, uncomment line below.  Optionally, set the class(es) in use
#FIND_PACKAGE(USBHost COMPONENTS CDC REQUIRED)

# To use uGFX, uncomment line below.  Optionally set components
#SET(uGFX_DIR ${CMAKE_CURRENT_SOURCE_DIR}/Lib/uGFX)
#FIND_PACKAGE(uGFX COMPONENTS gos gos_freertos gdisp gdisp_fonts gdisp_image gevent gtimer gwin ginput driver_FT5336 driver_STM32LTDC REQUIRED)

INCLUDE_DIRECTORIES(
    ${PROJECT_INC_DIR}
    ${CMSIS_INCLUDE_DIRS}
    ${STM32HAL_INCLUDE_DIR}
    ${STM32LL_INCLUDE_DIR}
    ${FreeRTOS_INCLUDE_DIRS}
    ${FATFS_INCLUDE_DIRS}
    ${USBDevice_INCLUDE_DIR}
    ${USBHost_INCLUDE_DIR}
    ${uGFX_INCLUDE_DIRS}
)

SET(PROJECT_SOURCES
    ${PROJECT_SOURCE_DIR}/main.c
    ${PROJECT_SOURCE_DIR}/stm32${STM32_FAMILY}xx_hal_msp.c
    ${PROJECT_SOURCE_DIR}/stm32${STM32_FAMILY}xx_hal_timebase_tim.c
    ${PROJECT_SOURCE_DIR}/stm32${STM32_FAMILY}xx_it.c 
    ${PROJECT_SOURCE_DIR}/freertos.c
    ${PROJECT_SOURCE_DIR}/fatfs_platform.c
    ${PROJECT_SOURCE_DIR}/fatfs.c
    ${PROJECT_SOURCE_DIR}/bsp_driver_sd.c
    ${PROJECT_SOURCE_DIR}/usb_host.c
    ${PROJECT_SOURCE_DIR}/usbh_conf.c
    ${PROJECT_SOURCE_DIR}/usbh_platform.c
    ${PROJECT_SOURCE_DIR}/stm32f7_i2c.c
    ${PROJECT_SOURCE_DIR}/stm32f746g_discovery_sdram.c
#    ${PROJECT_SOURCE_DIR}/usb_device.c
#    ${PROJECT_SOURCE_DIR}/usbd_conf.c
#    ${PROJECT_SOURCE_DIR}/usbd_platform.c
)

MESSAGE(STATUS "STM32_LINKER_SCRIPT: ${STM32_LINKER_SCRIPT}")
MESSAGE(STATUS "TARGET_LD_FLAGS: ${TARGET_LD_FLAGS}")

ADD_EXECUTABLE(${CMAKE_PROJECT_NAME} ${PROJECT_SOURCES} ${CMSIS_SOURCES} ${STM32HAL_SOURCES} ${STM32LL_SOURCES} 
                                     ${FreeRTOS_SOURCES} ${FATFS_SOURCES} ${USBDevice_SOURCES} ${USBHost_SOURCES}
                                     ${uGFX_SOURCES})

STM32_SET_TARGET_PROPERTIES(${CMAKE_PROJECT_NAME})
STM32_ADD_HEX_BIN_TARGETS(${CMAKE_PROJECT_NAME})
STM32_PRINT_SIZE_OF_TARGETS(${CMAKE_PROJECT_NAME})