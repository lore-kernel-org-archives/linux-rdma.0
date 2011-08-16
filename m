From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Question about libibcm
Date: Tue, 16 Aug 2011 23:28:57 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E402F6@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Is the test for NULL pointer in path is not needed or the pointer dereference
> should be protected?

param->path is required.  The NULL pointer check is not needed.

I added the following patch to my local tree.


ib_send_sidr_req: Remove NULL check for param->path

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The path parameter must be provided to send a SIDR REQ.  Remove
the check for NULL, since path has already been dereferenced
before it.

Problem pointed out by Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/cm.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)
 mode change 100644 => 100755 src/cm.c

diff --git a/src/cm.c b/src/cm.c
old mode 100644
new mode 100755
index 440ea45..e9f1afc
--- a/src/cm.c
+++ b/src/cm.c
@@ -705,7 +705,7 @@ int ib_cm_send_sidr_req(struct ib_cm_id *cm_id,
 	int result;
 	int size;
 
-	if (!param)
+	if (!param || !param->path)
 		return ERR(EINVAL);
 
 	CM_CREATE_MSG_CMD(msg, cmd, IB_USER_CM_CMD_SEND_SIDR_REQ, size);
@@ -715,14 +715,12 @@ int ib_cm_send_sidr_req(struct ib_cm_id *cm_id,
 	cmd->pkey           = param->path->pkey;
 	cmd->max_cm_retries = param->max_cm_retries;
 
-	if (param->path) {
-		abi_path = alloca(sizeof(*abi_path));
-		if (!abi_path)
-			return ERR(ENOMEM);
+	abi_path = alloca(sizeof(*abi_path));
+	if (!abi_path)
+		return ERR(ENOMEM);
 
-		ibv_copy_path_rec_to_kern(abi_path, param->path);
-		cmd->path = (uintptr_t) abi_path;
-	}
+	ibv_copy_path_rec_to_kern(abi_path, param->path);
+	cmd->path = (uintptr_t) abi_path;
 
 	if (param->private_data && param->private_data_len) {
 		cmd->data = (uintptr_t) param->private_data;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
