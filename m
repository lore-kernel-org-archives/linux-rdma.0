From: Colin King <colin.king@canonical.com>
Subject: [PATCH] i40iw: fix spelling mistake: "allloc_buf" -> "alloc_buf"
Date: Fri, 21 Jul 2017 23:19:33 +0100
Message-ID: <20170721221933.32347-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Faisal Latif <faisal.latif@intel.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in i40iw_debug  message and
also split up a couple of lines that are too long and cause
checkpatch warnings

Signed-off-by: Colin Ian King <colin.king@canonical.com>
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
