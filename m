From: Colin King <colin.king@canonical.com>
Subject: [PATCH] RDMA/drivers: fix spelling mistake "initalize" -> "initialize"
Date: Wed, 28 Nov 2018 15:11:16 +0000
Message-ID: <20181128151116.13216-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Benvenuti <benve@cisco.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Fix spelling mistake in usnic_err error message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/infiniband/hw/usnic/usnic_ib_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/infiniband/hw/usnic/usnic_ib_main.c
index 73bd00f8d2c8..413fa5732e2b 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_main.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
@@ -649,7 +649,7 @@ static int __init usnic_ib_init(void)
 
 	err = usnic_uiom_init(DRV_NAME);
 	if (err) {
-		usnic_err("Unable to initalize umem with err %d\n", err);
+		usnic_err("Unable to initialize umem with err %d\n", err);
 		return err;
 	}
 
-- 
2.19.1
