From: Colin King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH] i40iw: fix spelling mistake: "allloc_buf" -> "alloc_buf"
Date: Fri, 21 Jul 2017 23:13:41 +0100
Message-ID: <20170721221341.32155-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Trivial fix to spelling mistake in i40iw_debug  message and
also split up a couple of lines that are too long and cause
checkpatch warnings

Signed-off-by: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_puda.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_puda.c b/drivers/infiniband/hw/i40iw/i40iw_puda.c
index db41ab40da9c..86f6cf7cee0a 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_puda.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_puda.c
@@ -946,14 +946,16 @@ enum i40iw_status_code i40iw_puda_create_rsrc(struct i40iw_sc_vsi *vsi,
 		ret = i40iw_puda_qp_create(rsrc);
 	}
 	if (ret) {
-		i40iw_debug(dev, I40IW_DEBUG_PUDA, "[%s] error qp_create\n", __func__);
+		i40iw_debug(dev, I40IW_DEBUG_PUDA, "[%s] error qp_create\n",
+			    __func__);
 		goto error;
 	}
 	rsrc->completion = PUDA_QP_CREATED;
 
 	ret = i40iw_puda_allocbufs(rsrc, info->tx_buf_cnt + info->rq_size);
 	if (ret) {
-		i40iw_debug(dev, I40IW_DEBUG_PUDA, "[%s] error allloc_buf\n", __func__);
+		i40iw_debug(dev, I40IW_DEBUG_PUDA, "[%s] error alloc_buf\n",
+			    __func__);
 		goto error;
 	}
 
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
