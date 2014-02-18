From: Fabio Estevam <fabio.estevam-KZfg59tc24xl57MIdRCFDg@public.gmane.org>
Subject: [PATCH] infiniband: usnic_uiom: Remove '0x' when using %pa format
Date: Tue, 18 Feb 2014 09:54:27 -0300
Message-ID: <1392728067-11028-1-git-send-email-fabio.estevam@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, festevam-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Fabio Estevam <fabio.estevam-KZfg59tc24xl57MIdRCFDg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

%pa format already prints in hexadecimal format, so remove the '0x' annotation
to avoid a double '0x0x' pattern.

Signed-off-by: Fabio Estevam <fabio.estevam-KZfg59tc24xl57MIdRCFDg@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_uiom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
index 16755cd..801a1d6 100644
--- a/drivers/infiniband/hw/usnic/usnic_uiom.c
+++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
@@ -286,7 +286,7 @@ iter_chunk:
 				err = iommu_map(pd->domain, va_start, pa_start,
 							size, flags);
 				if (err) {
-					usnic_err("Failed to map va 0x%lx pa 0x%pa size 0x%zx with err %d\n",
+					usnic_err("Failed to map va 0x%lx pa %pa size 0x%zx with err %d\n",
 						va_start, &pa_start, size, err);
 					goto err_out;
 				}
-- 
1.8.1.2


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
