From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH TRIVIAL opensm] complib/cl_event_wheel.h: Some cosmetic fixes
Date: Wed, 26 Jun 2013 09:59:16 -0400
Message-ID: <51CAF3B4.7090400@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Fix indentation in cl_event_wheel.h

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/complib/cl_event_wheel.h |   76 +++++++++++++++++++-------------------
 1 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/include/complib/cl_event_wheel.h b/include/complib/cl_event_wheel.h
index ac02242..4883353 100644
--- a/include/complib/cl_event_wheel.h
+++ b/include/complib/cl_event_wheel.h
@@ -35,7 +35,7 @@
 
 /*
  * Abstract:
- * 	Declaration of event wheel abstraction.
+ *	Declaration of event wheel abstraction.
  */
 
 #ifndef _CL_EVENT_WHEEL_H_
@@ -62,11 +62,11 @@ BEGIN_C_DECLS
 *
 * DESCRIPTION
 *	The Event_Wheel provides a facility for registering delayed events
-*	and getting called once they timeout.
+*  and getting called once they timeout.
 *
 *	The Event_Wheel functions operate on a cl_event_wheel_t structure
-*	which should be treated as opaque and should be manipulated
-*	only through the provided functions.
+*  which should be treated as opaque and should be manipulated
+*  only through the provided functions.
 *
 * SEE ALSO
 *	Structures:
@@ -85,8 +85,8 @@ BEGIN_C_DECLS
 *
 * DESCRIPTION
 *	This typedef defines the prototype for client functions invoked
-*	by the Event_Wheel.  The Event_Wheel calls the corresponding
-*	client function when the specific item has aged.
+*  by the Event_Wheel.  The Event_Wheel calls the corresponding
+*  client function when the specific item has aged.
 *
 * SYNOPSIS
 */
@@ -95,12 +95,12 @@ typedef uint64_t
 			       IN uint32_t num_regs, IN void *context);
 /*
 * PARAMETERS
-*  key
-*     [in] The key used for registering the item in the call to
-*     cl_event_wheel_reg
+*	key
+*		[in] The key used for registering the item in the call to
+*		cl_event_wheel_reg.
 *
-*  num_regs
-*     [in] The number of times this event was registered (pushed in time).
+*	num_regs
+*		[in] The number of times this event was registered (pushed in time).
 *
 *	context
 *		[in] Client specific context specified in a call to
@@ -113,8 +113,8 @@ typedef uint64_t
 *
 * NOTES
 *	This typedef provides a function prototype reference for
-*	the function provided by Event_Wheel clients as a parameter
-*	to the cl_event_wheel_reg function.
+*  the function provided by Event_Wheel clients as a parameter
+*  to the cl_event_wheel_reg function.
 *
 * SEE ALSO
 *	Event_Wheel, cl_event_wheel_reg
@@ -130,7 +130,7 @@ typedef uint64_t
 *	The Event_Wheel is thread safe.
 *
 *	The cl_event_wheel_t structure should be treated as opaque and should
-*	be manipulated only through the provided functions.
+*  be manipulated only through the provided functions.
 *
 * SYNOPSIS
 */
@@ -148,16 +148,16 @@ typedef struct _cl_event_wheel {
 *	lock
 *		Spinlock to guard internal structures.
 *
-*       p_external_lock
-*               Reference to external spinlock to guard internal structures
-*               if the event wheel is part of a larger object protected by its own lock
+*	p_external_lock
+*		Reference to external spinlock to guard internal structures
+*		if the event wheel is part of a larger object protected by its own lock
 *
 *	events_map
 *		A Map holding all registered event items by their key.
 *
-*  closing
-*     A flag indicating the event wheel is closing. This means that
-*     callbacks that are called when closing == TRUE should just be ignored.
+*	closing
+*		A flag indicating the event wheel is closing. This means that
+*		callbacks that are called when closing == TRUE should just be ignored.
 *
 *	events_wheel
 *		A list of the events sorted by expiration time.
@@ -193,23 +193,23 @@ typedef struct _cl_event_wheel_reg_info {
 } cl_event_wheel_reg_info_t;
 /*
 * FIELDS
-*  map_item
-*     The map item of this event
+*	map_item
+*		The map item of this event
 *
-*  list_item
-*     The sorted by aging time list item
+*	list_item
+*		The sorted by aging time list item
 *
-*  key
-*     The key by which one can find the event
+*	key
+*		The key by which one can find the event
 *
 *	pfn_aged_callback
 *		The clients Event-Aged callback
 *
-*  aging_time
-*     The delta time [msec] for which the event should age.
+*	aging_time
+*		The delta time [msec] for which the event should age.
 *
-*  num_regs
-*     The number of times the same event (key) was registered
+*	num_regs
+*		The number of times the same event (key) was registered
 *
 *	context
 *		Client's context for event-aged callback.
@@ -285,12 +285,12 @@ cl_event_wheel_init_ex(IN cl_event_wheel_t * const p_event_wheel,
 
 /*
 * PARAMETERS
-*  p_event_wheel
-*     [in] Pointer to a Event_Wheel.
+*	p_event_wheel
+*		[in] Pointer to a Event_Wheel.
 *
-*  p_external_lock
-*     [in] Reference to external spinlock to guard internal structures
-*          if the event wheel is part of a larger object protected by its own lock
+*	p_external_lock
+*		[in] Reference to external spinlock to guard internal structures
+*		if the event wheel is part of a larger object protected by its own lock
 *
 * RETURN VALUE
 *	CL_SUCCESS if the operation is successful.
@@ -375,8 +375,8 @@ cl_event_wheel_reg(IN cl_event_wheel_t * const p_event_wheel,
 *	key
 *		[in] The specifc Key by which events are registered.
 *
-*  aging_time_usec
-*     [in] The absolute time this event should age in usec
+*	aging_time_usec
+*		[in] The absolute time this event should age in usec
 *
 *	pfn_callback
 *		[in] Event Aging callback.  The Event_Wheel calls this
@@ -417,7 +417,7 @@ cl_event_wheel_unreg(IN cl_event_wheel_t * const p_event_wheel,
 *	This function does not return a value.
 *
 * NOTES
-*  After the event has aged it is automatically removed from
+*	After the event has aged it is automatically removed from
 *  the event wheel. So it should only be invoked when the need arises
 *  to remove existing events before they age.
 *
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
