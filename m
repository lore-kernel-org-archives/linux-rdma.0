From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 1/3] RDMA/iwpm: Delete an error message for a failed memory
 allocation in iwpm_create_nlmsg()
Date: Sat, 27 Jan 2018 22:19:05 +0100
Message-ID: <ac5f9bdd-4924-2613-f074-0dd285427604@users.sourceforge.net>
References: <b1df0889-b967-97ae-3a3d-0dde0d7258cd@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b1df0889-b967-97ae-3a3d-0dde0d7258cd@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Chien Tin Tung <chien.tin.tung@intel.com>, Doug Ledford <dledford@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Jason Gunthorpe <jgg@ziepe.ca>, Johannes Berg <johannes.berg@intel.com>, Leon Romanovsky <leonro@mellanox.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 27 Jan 2018 21:48:01 +0100

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/core/iwpm_util.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/iwpm_util.c b/drivers/infiniband/core/iwpm_util.c
index 81528f64061a..9821ae900f6d 100644
--- a/drivers/infiniband/core/iwpm_util.c
+++ b/drivers/infiniband/core/iwpm_util.c
@@ -439,10 +439,9 @@ struct sk_buff *iwpm_create_nlmsg(u32 nl_op, struct nlmsghdr **nlh,
 	struct sk_buff *skb = NULL;
 
 	skb = dev_alloc_skb(IWPM_MSG_SIZE);
-	if (!skb) {
-		pr_err("%s Unable to allocate skb\n", __func__);
+	if (!skb)
 		goto create_nlmsg_exit;
-	}
+
 	if (!(ibnl_put_msg(skb, nlh, 0, 0, nl_client, nl_op,
 			   NLM_F_REQUEST))) {
 		pr_warn("%s: Unable to put the nlmsg header\n", __func__);
-- 
2.16.1
