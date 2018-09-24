From: Colin King <colin.king@canonical.com>
Subject: [PATCH] IB/usnic: fix spelling mistake "unvalid" -> "invalid"
Date: Mon, 24 Sep 2018 18:27:38 +0100
Message-ID: <20180924172738.3508-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Benvenuti <benve@cisco.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in usnic_err error message.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/infiniband/hw/usnic/usnic_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_transport.c b/drivers/infiniband/hw/usnic/usnic_transport.c
index e0a95538c364..82dd810bc000 100644
--- a/drivers/infiniband/hw/usnic/usnic_transport.c
+++ b/drivers/infiniband/hw/usnic/usnic_transport.c
@@ -121,7 +121,7 @@ void usnic_transport_unrsrv_port(enum usnic_transport_type type, u16 port_num)
 	if (type == USNIC_TRANSPORT_ROCE_CUSTOM) {
 		spin_lock(&roce_bitmap_lock);
 		if (!port_num) {
-			usnic_err("Unreserved unvalid port num 0 for %s\n",
+			usnic_err("Unreserved invalid port num 0 for %s\n",
 					usnic_transport_to_str(type));
 			goto out_roce_custom;
 		}
-- 
2.17.1
