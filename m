From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] IB/core: Temporarily disable ex_query_device uverb
Date: Sun,  1 Feb 2015 15:35:30 +0200
Message-ID: <1422797730-14571-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Commit 5a77abf9a97a ("IB/core: Add support for extended query device caps")
added a new extended verb to query the capabilities of RDMA devices, but the
semantics of this verb are still under debate [1].

Block access to this verb from user-space until the new semantics are in
place.

Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

[1] [PATCH v1 0/5] IB/core: extended query device caps cleanup for v3.19
    http://www.spinics.net/lists/linux-rdma/msg22904.html

Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

Hi Roland,

As I wrote in a separate mail, I hope you can accept Yann's patches to modify
the new query device verb [1] in time for kernel 3.19. 

If you decide to revert the extended query device verb, here is a minimal patch
to do block this verb temporarily, leaving the rest of the ODP infrastructure
in-place.

Regards,
Haggai

 drivers/infiniband/core/uverbs_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index e6c23b9eab33..5db1a8cc388d 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -123,7 +123,6 @@ static int (*uverbs_ex_cmd_table[])(struct ib_uverbs_file *file,
 				    struct ib_udata *uhw) = {
 	[IB_USER_VERBS_EX_CMD_CREATE_FLOW]	= ib_uverbs_ex_create_flow,
 	[IB_USER_VERBS_EX_CMD_DESTROY_FLOW]	= ib_uverbs_ex_destroy_flow,
-	[IB_USER_VERBS_EX_CMD_QUERY_DEVICE]	= ib_uverbs_ex_query_device
 };
 
 static void ib_uverbs_add_one(struct ib_device *device);
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
