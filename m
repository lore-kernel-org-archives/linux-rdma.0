From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH libibcm] Return errors from the kernel consistently
Date: Mon, 19 Oct 2009 23:58:34 -0600
Message-ID: <20091020055834.GA26350@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This fixes one subtle bug, where a return of 0 from the kernel will
result in a success report from the library, and fixes a terrible
API in the process. Use errno, or return the code, or both.
Not half and half..

It is easier to return errno than to fixup the cases that don't,
so lets stick with that.

Codes should have been be positive for alignment with POSIX, but
it is much too late for that..

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 src/cm.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

librdmacm has the same basic flaw too.

What do you think Sean?

diff --git a/src/cm.c b/src/cm.c
index 7370abe..4807e2d 100644
--- a/src/cm.c
+++ b/src/cm.c
@@ -261,7 +261,7 @@ int ib_cm_destroy_id(struct ib_cm_id *cm_id)
 
 	result = write(cm_id->device->fd, msg, size);
 	if (result != size)
-		return (result > 0) ? -ENODATA : result;
+		return (result >= 0) ? -ENODATA : -1*errno;
 
 	VALGRIND_MAKE_MEM_DEFINED(resp, sizeof *resp);
 
@@ -292,7 +292,7 @@ int ib_cm_attr_id(struct ib_cm_id *cm_id, struct ib_cm_attr_param *param)
 
 	result = write(cm_id->device->fd, msg, size);
 	if (result != size)
-		return (result > 0) ? -ENODATA : result;
+		return (result >= 0) ? -ENODATA : -1*errno;
 
 	VALGRIND_MAKE_MEM_DEFINED(resp, sizeof *resp);
 
@@ -322,7 +322,7 @@ int ib_cm_init_qp_attr(struct ib_cm_id *cm_id,
 
 	result = write(cm_id->device->fd, msg, size);
 	if (result != size)
-		return (result > 0) ? -ENODATA : result;
+		return (result >= 0) ? -ENODATA : -1*errno;
 
 	VALGRIND_MAKE_MEM_DEFINED(resp, sizeof *resp);
 
@@ -348,7 +348,7 @@ int ib_cm_listen(struct ib_cm_id *cm_id,
 
 	result = write(cm_id->device->fd, msg, size);
 	if (result != size)
-		return (result > 0) ? -ENODATA : result;
+		return (result >= 0) ? -ENODATA : -1*errno;
 
 	return 0;
 }
@@ -407,7 +407,7 @@ int ib_cm_send_req(struct ib_cm_id *cm_id, struct ib_cm_req_param *param)
 
 	result = write(cm_id->device->fd, msg, size);
 	if (result != size)
-		return (result > 0) ? -ENODATA : result;
+		return (result >= 0) ? -ENODATA : -1*errno;
 
 	return 0;
 }
@@ -442,7 +442,7 @@ int ib_cm_send_rep(struct ib_cm_id *cm_id, struct ib_cm_rep_param *param)
 
 	result = write(cm_id->device->fd, msg, size);
 	if (result != size)
-		return (result > 0) ? -ENODATA : result;
+		return (result >= 0) ? -ENODATA : -1*errno;
 
 	return 0;
 }
@@ -467,7 +467,7 @@ static inline int cm_send_private_data(struct ib_cm_id *cm_id,
 
 	result = write(cm_id->device->fd, msg, size);
 	if (result != size)
-		return (result > 0) ? -ENODATA : result;
+		return (result >= 0) ? -ENODATA : -1*errno;
 
 	return 0;
 }
@@ -508,7 +508,7 @@ static int cm_establish(struct ib_cm_id *cm_id)
 
 	result = write(cm_id->device->fd, msg, size);
 	if (result != size)
-		return (result > 0) ? -ENODATA : result;
+		return (result >= 0) ? -ENODATA : -1*errno;
 
 	return 0;
 }
@@ -533,7 +533,7 @@ int ib_cm_notify(struct ib_cm_id *cm_id, enum ibv_event_type event)
 
 	result = write(cm_id->device->fd, msg, size);
 	if (result != size)
-		return (result > 0) ? -ENODATA : result;
+		return (result >= 0) ? -ENODATA : -1*errno;
 
 	return 0;
 }
@@ -567,7 +567,7 @@ static inline int cm_send_status(struct ib_cm_id *cm_id,
 
 	result = write(cm_id->device->fd, msg, size);
 	if (result != size)
-		return (result > 0) ? -ENODATA : result;
+		return (result >= 0) ? -ENODATA : -1*errno;
 
 	return 0;
 }
@@ -617,7 +617,7 @@ int ib_cm_send_mra(struct ib_cm_id *cm_id,
 
 	result = write(cm_id->device->fd, msg, size);
 	if (result != size)
-		return (result > 0) ? -ENODATA : result;
+		return (result >= 0) ? -ENODATA : -1*errno;
 
 	return 0;
 }
@@ -652,7 +652,7 @@ int ib_cm_send_lap(struct ib_cm_id *cm_id,
 
 	result = write(cm_id->device->fd, msg, size);
 	if (result != size)
-		return (result > 0) ? -ENODATA : result;
+		return (result >= 0) ? -ENODATA : -1*errno;
 
 	return 0;
 }
@@ -692,7 +692,7 @@ int ib_cm_send_sidr_req(struct ib_cm_id *cm_id,
 
 	result = write(cm_id->device->fd, msg, size);
 	if (result != size)
-		return (result > 0) ? -ENODATA : result;
+		return (result >= 0) ? -ENODATA : -1*errno;
 
 	return 0;
 }
@@ -726,7 +726,7 @@ int ib_cm_send_sidr_rep(struct ib_cm_id *cm_id,
 
 	result = write(cm_id->device->fd, msg, size);
 	if (result != size)
-		return (result > 0) ? -ENODATA : result;
+		return (result >= 0) ? -ENODATA : -1*errno;
 
 	return 0;
 }
@@ -836,7 +836,7 @@ int ib_cm_get_event(struct ib_cm_device *device, struct ib_cm_event **event)
 
 	result = write(device->fd, msg, size);
 	if (result != size) {
-		result = (result > 0) ? -ENODATA : result;
+		return (result >= 0) ? -ENODATA : -1*errno;
 		goto done;
 	}
 
-- 
1.6.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
