From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 14/23] rdmacm: Fix typos
Date: Wed, 21 Sep 2016 16:08:40 -0600
Message-ID: <1474495729-17604-15-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474495729-17604-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474495729-17604-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org> (debian)
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 librdmacm/include/rdma/rdma_cma.h | 2 +-
 librdmacm/man/mckey.1             | 2 +-
 librdmacm/man/rdma_cm.7           | 4 ++--
 librdmacm/man/rdma_migrate_id.3   | 2 +-
 librdmacm/man/rdma_post_write.3   | 2 +-
 librdmacm/man/rdma_post_writev.3  | 2 +-
 librdmacm/man/rdma_reg_msgs.3     | 2 +-
 librdmacm/man/rdma_set_option.3   | 2 +-
 8 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/librdmacm/include/rdma/rdma_cma.h b/librdmacm/include/rdma/rdma_cma.h
index 4826c0304b0b..2055665a1496 100644
--- a/librdmacm/include/rdma/rdma_cma.h
+++ b/librdmacm/include/rdma/rdma_cma.h
@@ -278,7 +278,7 @@ int rdma_create_ep(struct rdma_cm_id **id, struct rdma_addrinfo *res,
 
 /**
  * rdma_destroy_ep - Deallocates a communication identifier and qp.
- * @id: The communication identifer to destroy.
+ * @id: The communication identifier to destroy.
  * Description:
  *   Destroys the specified rdma_cm_id and any associated QP created
  *   on that id.
diff --git a/librdmacm/man/mckey.1 b/librdmacm/man/mckey.1
index 441881919dd2..86a51a35e971 100644
--- a/librdmacm/man/mckey.1
+++ b/librdmacm/man/mckey.1
@@ -47,7 +47,7 @@ UDP (0x0111) or IPoIB (0x0002) port space.  (default RDMA_PS_UDP)
 Basic usage is to start mckey -m multicast_address on a server system,
 then run mckey -m multicast_address -s on a client system.
 .P
-Unique Infiniband SA assigned multicast GIDs can be retrived by
+Unique Infiniband SA assigned multicast GIDs can be retrieved by
 invoking mckey with a zero MGID or IP address.  (Example, -M 0 or
 -m 0.0.0.0).  The assigned address will be displayed to allow
 mckey clients to join the created group. 
diff --git a/librdmacm/man/rdma_cm.7 b/librdmacm/man/rdma_cm.7
index ee8427a29223..451035bfb588 100644
--- a/librdmacm/man/rdma_cm.7
+++ b/librdmacm/man/rdma_cm.7
@@ -67,7 +67,7 @@ low level call details shown.  For
 synchronous operation, calls to rdma_create_event_channel, rdma_get_cm_event,
 rdma_ack_cm_event, and rdma_destroy_event_channel
 would be eliminated.  Abstracted calls, such as rdma_create_ep encapsulate
-serveral of these calls under a single API.
+several of these calls under a single API.
 Users may also refer to the example applications for
 code samples.  A general connection flow would be:
 .IP rdma_getaddrinfo
@@ -171,7 +171,7 @@ regarding the reason for the failure.
 .P
 Prior versions of the library would return -errno and not set errno for some cases
 related to ENOMEM, ENODEV, ENODATA, EINVAL, and EADDRNOTAVAIL codes. Applications
-that want to check these codes and have compatability with prior library versions
+that want to check these codes and have compatibility with prior library versions
 must manually set errno to the negative of the return code if it is < -1.
 .SH "SEE ALSO"
 rdma_accept(3),
diff --git a/librdmacm/man/rdma_migrate_id.3 b/librdmacm/man/rdma_migrate_id.3
index 8683c93090bf..8c2d7dd6e40a 100644
--- a/librdmacm/man/rdma_migrate_id.3
+++ b/librdmacm/man/rdma_migrate_id.3
@@ -1,6 +1,6 @@
 .TH "RDMA_MIGRATE_ID" 3 "2007-11-13" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
 .SH NAME
-rdma_migrate_id \- Move a communication identifer to a different event channel.
+rdma_migrate_id \- Move a communication identifier to a different event channel.
 .SH SYNOPSIS
 .B "#include <rdma/rdma_cma.h>"
 .P
diff --git a/librdmacm/man/rdma_post_write.3 b/librdmacm/man/rdma_post_write.3
index 896996ce5f62..5ab4fdb5dc4b 100644
--- a/librdmacm/man/rdma_post_write.3
+++ b/librdmacm/man/rdma_post_write.3
@@ -34,7 +34,7 @@ The registered memory key associated with the remote address.
 .SH "DESCRIPTION"
 Posts a work request to the send queue of the queue pair associated
 with the rdma_cm_id.  The contents of the local data buffer will be
-writen into the remote memory region.
+written into the remote memory region.
 .SH "RETURN VALUE"
 Returns 0 on success, or -1 on error.  If an error occurs, errno will be
 set to indicate the failure reason.
diff --git a/librdmacm/man/rdma_post_writev.3 b/librdmacm/man/rdma_post_writev.3
index f5b23fdcb7bc..1fc7b0a6c709 100644
--- a/librdmacm/man/rdma_post_writev.3
+++ b/librdmacm/man/rdma_post_writev.3
@@ -31,7 +31,7 @@ The registered memory key associated with the remote address.
 .SH "DESCRIPTION"
 Posts a work request to the send queue of the queue pair associated
 with the rdma_cm_id.  The contents of the local data buffers will be
-writen into the remote memory region.
+written into the remote memory region.
 .SH "RETURN VALUE"
 Returns 0 on success, or -1 on error.  If an error occurs, errno will be
 set to indicate the failure reason.
diff --git a/librdmacm/man/rdma_reg_msgs.3 b/librdmacm/man/rdma_reg_msgs.3
index c2c93593bba9..4f5656313734 100644
--- a/librdmacm/man/rdma_reg_msgs.3
+++ b/librdmacm/man/rdma_reg_msgs.3
@@ -21,7 +21,7 @@ Registers an array of memory buffers used for sending and receiving
 messages or for RDMA operations.  Memory buffers registered using
 rdma_reg_msgs may be posted to an rdma_cm_id using
 rdma_post_send or rdma_post_recv, or specified as the target of an RDMA
-read operation or the source of an RDMA write reqeust.
+read operation or the source of an RDMA write request.
 .SH "RETURN VALUE"
 Returns a reference to the registered memory region on success, or NULL on
 error.  If an error occurs, errno will be set to indicate the failure reason.
diff --git a/librdmacm/man/rdma_set_option.3 b/librdmacm/man/rdma_set_option.3
index 8e344abc3f8a..74bf5ceba88d 100644
--- a/librdmacm/man/rdma_set_option.3
+++ b/librdmacm/man/rdma_set_option.3
@@ -28,6 +28,6 @@ the default system settings.
 Returns 0 on success, or -1 on error.  If an error occurs, errno will be
 set to indicate the failure reason.
 .SH "NOTES"
-Option details may be found in the relevent header files.
+Option details may be found in the relevant header files.
 .SH "SEE ALSO"
 rdma_create_id(3)
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
