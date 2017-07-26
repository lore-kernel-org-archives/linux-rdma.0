From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-rc 10/11] Revert "IB/core: Allow QP state transition from reset to error"
Date: Wed, 26 Jul 2017 21:12:31 +0300
Message-ID: <20170726181232.7363-11-leon@kernel.org>
References: <20170726181232.7363-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170726181232.7363-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The commit ebc9ca43e1d5 ("IB/core: Allow QP state transition from reset to error")
allowed transition from Reset to Error state for the QPs. This behavior
doesn't follow the IBTA specification 1.3, which in 10.3.1 QUEUE PAIR AND
EE CONTEXT STATES section.

The quote from the spec:
"An error can be forced from any state, except Reset, with
the Modify QP/EE Verb."

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index fb98ed67d5bc..7f8fe443df46 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -895,7 +895,6 @@ static const struct {
 } qp_state_table[IB_QPS_ERR + 1][IB_QPS_ERR + 1] = {
 	[IB_QPS_RESET] = {
 		[IB_QPS_RESET] = { .valid = 1 },
-		[IB_QPS_ERR] =   { .valid = 1 },
 		[IB_QPS_INIT]  = {
 			.valid = 1,
 			.req_param = {
-- 
2.13.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
