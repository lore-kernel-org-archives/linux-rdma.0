From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for v3.13 6/7] IB/uverbs: check reserved fields in create_flow
Date: Tue, 26 Nov 2013 23:02:44 +0100
Message-ID: <f00917eca422bf63421b2de495336681d5bb44ff.1385501822.git.ydroneaud@opteya.com>
References: <cover.1385501822.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1385501822.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1385501822.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1385501822.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

As noted by Daniel Vetter in its article "Botching up ioctls"[1]

  "Check *all* unused fields and flags and all the padding for
   whether it's 0, and reject the ioctl if that's not the case.
   Otherwise your nice plan for future extensions is going right
   down the gutters since someone *will* submit an ioctl struct
   with random stack garbage in the yet unused parts. Which then
   bakes in the ABI that those fields can never be used for
   anything else but garbage."

It's important to ensure that reserved fields are set to known
value, so that it will be possible to use them latter to extend
the ABI.

The same reasonning apply to comp_mask field present in newer
uverbs command: per commit 22878dbc9173, unsupported values in
comp_mask are rejected.

[1] http://blog.ffwll.ch/2013/11/botching-up-ioctls.html

Link: http://marc.info/?i=cover.1385501822.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index f1ba441cd2ed..dd1c5b6ab019 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2593,6 +2593,9 @@ out_put:
 static int kern_spec_to_ib_spec(struct ib_uverbs_flow_spec *kern_spec,
 				union ib_flow_spec *ib_spec)
 {
+	if (kern_spec->reserved)
+		return -EINVAL;
+
 	ib_spec->type = kern_spec->type;
 
 	switch (ib_spec->type) {
@@ -2671,6 +2674,10 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 	    (cmd.flow_attr.num_of_specs * sizeof(struct ib_uverbs_flow_spec)))
 		return -EINVAL;
 
+	if (cmd.flow_attr.reserved[0] ||
+	    cmd.flow_attr.reserved[1])
+		return -EINVAL;
+
 	if (cmd.flow_attr.num_of_specs) {
 		kern_flow_attr = kmalloc(sizeof(*kern_flow_attr) + cmd.flow_attr.size,
 					 GFP_KERNEL);
-- 
1.8.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
