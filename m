From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] IB/usnic: Delete an error message for a failed memory
 allocation in usnic_transport_init()
Date: Fri, 12 May 2017 22:00:29 +0200
Message-ID: <c7e810c9-703e-6d08-c885-d0ce9209ca04@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Christian Benvenuti <benve@cisco.com>, Dave Goodell <dgoodell@cisco.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 12 May 2017 21:53:51 +0200

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Link: http://events.linuxfoundation.org/sites/events/files/slides/LCJ16-Refactor_Strings-WSang_0.pdf
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/usnic/usnic_transport.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_transport.c b/drivers/infiniband/hw/usnic/usnic_transport.c
index de318389a301..2e9bba52a686 100644
--- a/drivers/infiniband/hw/usnic/usnic_transport.c
+++ b/drivers/infiniband/hw/usnic/usnic_transport.c
@@ -201,10 +201,8 @@ int usnic_transport_sock_get_addr(struct socket *sock, int *proto,
 int usnic_transport_init(void)
 {
 	roce_bitmap = kzalloc(ROCE_BITMAP_SZ, GFP_KERNEL);
-	if (!roce_bitmap) {
-		usnic_err("Failed to allocate bit map");
+	if (!roce_bitmap)
 		return -ENOMEM;
-	}
 
 	/* Do not ever allocate bit 0, hence set it here */
 	bitmap_set(roce_bitmap, 0, 1);
-- 
2.12.3
