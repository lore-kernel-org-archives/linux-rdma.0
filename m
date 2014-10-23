From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] complib/cl_dispatcher.c: Check registrations vector
 size when searching for handlers
Date: Thu, 23 Oct 2014 10:00:14 -0400
Message-ID: <544909EE.9030505@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When cl_disp_post is called with message_id != CL_DISP_MSGID_NONE, it
searches for the handler for the message in a vector using message_id as
the index.

This change adds a check to verify that the message_id that is used as
an index is not larger than vector's size.
This change adds resiliency to the code when cl_disp_post() is
called with an invalid message_id.

Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 complib/cl_dispatcher.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/complib/cl_dispatcher.c b/complib/cl_dispatcher.c
index 6736d67..1255c83 100644
--- a/complib/cl_dispatcher.c
+++ b/complib/cl_dispatcher.c
@@ -302,6 +302,11 @@ cl_status_t cl_disp_post(IN const cl_disp_reg_handle_t handle,
 
 	cl_spinlock_acquire(&p_disp->lock);
 	/* Check that the recipient exists. */
+	if (cl_ptr_vector_get_size(&p_disp->reg_vec) <= msg_id) {
+		cl_spinlock_release(&p_disp->lock);
+		return (CL_NOT_FOUND);
+	}
+
 	p_dest_reg = cl_ptr_vector_get(&p_disp->reg_vec, msg_id);
 	if (!p_dest_reg) {
 		cl_spinlock_release(&p_disp->lock);
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
