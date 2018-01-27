From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 2/3] RDMA/iwpm: Adjust a variable initialisation in
 iwpm_create_nlmsg()
Date: Sat, 27 Jan 2018 22:20:24 +0100
Message-ID: <4f13c537-5adb-cb38-5ba6-206699033849@users.sourceforge.net>
References: <b1df0889-b967-97ae-3a3d-0dde0d7258cd@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <b1df0889-b967-97ae-3a3d-0dde0d7258cd@users.sourceforge.net>
Content-Language: en-GB
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Chien Tin Tung <chien.tin.tung@intel.com>, Doug Ledford <dledford@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Jason Gunthorpe <jgg@ziepe.ca>, Johannes Berg <johannes.berg@intel.com>, Leon Romanovsky <leonro@mellanox.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 27 Jan 2018 21:56:54 +0100

The local variable "skb" will be reassigned by a following statement.
Thus adjust the initialisation at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/core/iwpm_util.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/iwpm_util.c b/drivers/infiniband/core/iwpm_util.c
index 9821ae900f6d..9eb527074c32 100644
--- a/drivers/infiniband/core/iwpm_util.c
+++ b/drivers/infiniband/core/iwpm_util.c
@@ -436,9 +436,8 @@ int iwpm_compare_sockaddr(struct sockaddr_storage *a_sockaddr,
 struct sk_buff *iwpm_create_nlmsg(u32 nl_op, struct nlmsghdr **nlh,
 						int nl_client)
 {
-	struct sk_buff *skb = NULL;
+	struct sk_buff *skb = dev_alloc_skb(IWPM_MSG_SIZE);
 
-	skb = dev_alloc_skb(IWPM_MSG_SIZE);
 	if (!skb)
 		goto create_nlmsg_exit;
 
-- 
2.16.1

