From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] RDMA/ocrdma: fix a type issue in ocrdma_put_pd_num()
Date: Thu, 23 Feb 2017 13:40:16 +0300
Message-ID: <20170223104016.GA27526@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Selvin Xavier <selvin.xavier@avagotech.com>
Cc: Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

We want to return zero on success or negative error codes.  The type
should be int and not u8.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index e06ad7250963..b1b075763eaa 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -371,7 +371,7 @@ static int _ocrdma_pd_mgr_put_bitmap(struct ocrdma_dev *dev, u16 pd_id,
 	return 0;
 }
 
-static u8 ocrdma_put_pd_num(struct ocrdma_dev *dev, u16 pd_id,
+static int ocrdma_put_pd_num(struct ocrdma_dev *dev, u16 pd_id,
 				   bool dpp_pool)
 {
 	int status;
