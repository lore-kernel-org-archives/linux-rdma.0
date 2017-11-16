From: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Subject: [PATCH/RFC] RDMA/iwpm: Fix uninitialized error code in iwpm_send_mapinfo()
Date: Thu, 16 Nov 2017 11:26:04 +0100
Message-ID: <1510827964-11100-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

With gcc-4.1.2:

    drivers/infiniband/core/iwpm_util.c: In function ‘iwpm_send_mapinfo’:
    drivers/infiniband/core/iwpm_util.c:647: warning: ‘ret’ may be used uninitialized in this function

Indeed, if nl_client is not found in any of the scanned has buckets, ret
will be used uninitialized.

Preinitialize ret to zero to fix this.

Fixes: 30dc5e63d6a5ad24 ("RDMA/core: Add support for iWARP Port Mapper user space service")
Signed-off-by: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
---
RFC as I have no idea if this can ever happen, and if yes, what's the
correct behavior to handle it:
  - return 0,
  - return an error code,
  - don't send anything,
  - anything else?
---
 drivers/infiniband/core/iwpm_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/iwpm_util.c b/drivers/infiniband/core/iwpm_util.c
index 3c4faadb8cddd7fd..eb000b540495acd1 100644
--- a/drivers/infiniband/core/iwpm_util.c
+++ b/drivers/infiniband/core/iwpm_util.c
@@ -644,7 +644,7 @@ int iwpm_send_mapinfo(u8 nl_client, int iwpm_pid)
 	int i = 0, nlmsg_bytes = 0;
 	unsigned long flags;
 	const char *err_str = "";
-	int ret;
+	int ret = 0;
 
 	skb = dev_alloc_skb(NLMSG_GOODSIZE);
 	if (!skb) {
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
