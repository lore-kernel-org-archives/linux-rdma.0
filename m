From: Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] IB/mlx4: Remove unnecessary parentheses
Date: Wed, 19 Sep 2018 20:32:29 -0700
Message-ID: <20180920033229.15102-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Yishai Hadas <yishaih@mellanox.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>, Nathan Chancellor <natechancellor@gmail.com>
List-Id: linux-rdma@vger.kernel.org

Clang warns when more than one set of parentheses are used in single
conditional statements.

drivers/infiniband/hw/mlx4/mcg.c:676:16: warning: equality comparison
with extraneous parentheses [-Wparentheses-equality]
                        if ((method == IB_MGMT_METHOD_GET_RESP)) {
                             ~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/infiniband/hw/mlx4/mcg.c:676:16: note: remove extraneous
parentheses around the comparison to silence this warning
                        if ((method == IB_MGMT_METHOD_GET_RESP)) {
                            ~       ^                         ~
drivers/infiniband/hw/mlx4/mcg.c:676:16: note: use '=' to turn this
equality comparison into an assignment
                        if ((method == IB_MGMT_METHOD_GET_RESP)) {
                                    ^~
                                    =

Remove the unnecessary parentheses to silence this warning.

Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/infiniband/hw/mlx4/mcg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/mcg.c b/drivers/infiniband/hw/mlx4/mcg.c
index 81ffc007e0a1..d844831179cf 100644
--- a/drivers/infiniband/hw/mlx4/mcg.c
+++ b/drivers/infiniband/hw/mlx4/mcg.c
@@ -673,7 +673,7 @@ static void mlx4_ib_mcg_work_handler(struct work_struct *work)
 			if (!list_empty(&group->pending_list))
 				req = list_first_entry(&group->pending_list,
 						struct mcast_req, group_list);
-			if ((method == IB_MGMT_METHOD_GET_RESP)) {
+			if (method == IB_MGMT_METHOD_GET_RESP) {
 					if (req) {
 						send_reply_to_slave(req->func, group, &req->sa_mad, status);
 						--group->func[req->func].num_pend_reqs;
-- 
2.19.0
