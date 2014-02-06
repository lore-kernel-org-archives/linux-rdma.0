From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [patch] RDMA/cxgb3: remove a couple unneeded conditions
Date: Thu, 6 Feb 2014 15:39:34 +0300
Message-ID: <20140206123934.GA12503@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We know that "reset_tpt_entry" is false on this side of the if else
statement so there is no need to check again.

Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.c b/drivers/infiniband/hw/cxgb3/cxio_hal.c
index c3f5aca4ef00..de1c61b417d6 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_hal.c
+++ b/drivers/infiniband/hw/cxgb3/cxio_hal.c
@@ -735,14 +735,12 @@ static int __cxio_tpt_op(struct cxio_rdev *rdev_p, u32 reset_tpt_entry,
 			((perm & TPT_MW_BIND) ? F_TPT_MW_BIND_ENABLE : 0) |
 			V_TPT_ADDR_TYPE((zbva ? TPT_ZBTO : TPT_VATO)) |
 			V_TPT_PAGE_SIZE(page_size));
-		tpt.rsvd_pbl_addr = reset_tpt_entry ? 0 :
-				    cpu_to_be32(V_TPT_PBL_ADDR(PBL_OFF(rdev_p, pbl_addr)>>3));
+		tpt.rsvd_pbl_addr = cpu_to_be32(V_TPT_PBL_ADDR(PBL_OFF(rdev_p, pbl_addr)>>3));
 		tpt.len = cpu_to_be32(len);
 		tpt.va_hi = cpu_to_be32((u32) (to >> 32));
 		tpt.va_low_or_fbo = cpu_to_be32((u32) (to & 0xFFFFFFFFULL));
 		tpt.rsvd_bind_cnt_or_pstag = 0;
-		tpt.rsvd_pbl_size = reset_tpt_entry ? 0 :
-				  cpu_to_be32(V_TPT_PBL_SIZE(pbl_size >> 2));
+		tpt.rsvd_pbl_size = cpu_to_be32(V_TPT_PBL_SIZE(pbl_size >> 2));
 	}
 	err = cxio_hal_ctrl_qp_write_mem(rdev_p,
 				       stag_idx +
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
