From: =?UTF-8?q?Markus=20B=C3=B6hme?= <markus.boehme-cl+VPiYnx/1AfugRpC6u6w@public.gmane.org>
Subject: [PATCH] staging/rdma/hfi1: select CRC32
Date: Fri,  1 Apr 2016 01:04:05 +0200
Message-ID: <1459465467-31367-1-git-send-email-markus.boehme@mailbox.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: =?UTF-8?q?Markus=20B=C3=B6hme?= <markus.boehme-cl+VPiYnx/1AfugRpC6u6w@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The function parse_platform_config in firmware.c calls crc32_le.
Building without CRC32 selected causes a link error:

drivers/built-in.o: In function `parse_platform_config':
(.text+0x92ffa): undefined reference to `crc32_le'

Signed-off-by: Markus B=C3=B6hme <markus.boehme-cl+VPiYnx/1AfugRpC6u6w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/rdma/hfi1/Kconfig b/drivers/staging/rdma/h=
fi1/Kconfig
index 3e668d8..a925fb0 100644
--- a/drivers/staging/rdma/hfi1/Kconfig
+++ b/drivers/staging/rdma/hfi1/Kconfig
@@ -2,6 +2,7 @@ config INFINIBAND_HFI1
 	tristate "Intel OPA Gen1 support"
 	depends on X86_64 && INFINIBAND_RDMAVT
 	select MMU_NOTIFIER
+	select CRC32
 	default m
 	---help---
 	This is a low-level driver for Intel OPA Gen1 adapter.
--=20
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
