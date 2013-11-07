#
# This policy configuration will be used by all products that
# inherit from ChaOS
#

BOARD_SEPOLICY_DIRS += \
    vendor/cos/sepolicy

BOARD_SEPOLICY_UNION += \
    file_contexts \
    seapp_contexts \
    mac_permissions.xml
