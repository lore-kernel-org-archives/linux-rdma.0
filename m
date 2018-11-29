From: Colin King <colin.king@canonical.com>
Subject: [PATCH] IB/usnic: fix spelling mistake "miniumum" -> "minimum"
Date: Thu, 29 Nov 2018 10:42:13 +0000
Message-ID: <20181129104213.17593-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Benvenuti <benve@cisco.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a usnic_err error message, fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
index bf5136533d49..0cdb156e165e 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
@@ -681,7 +681,7 @@ usnic_ib_qp_grp_create(struct usnic_fwd_dev *ufdev, struct usnic_ib_vf *vf,
 	err = usnic_vnic_res_spec_satisfied(&min_transport_spec[transport],
 						res_spec);
 	if (err) {
-		usnic_err("Spec does not meet miniumum req for transport %d\n",
+		usnic_err("Spec does not meet minimum req for transport %d\n",
 				transport);
 		log_spec(res_spec);
 		return ERR_PTR(err);
-- 
2.19.1
