From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: ib_isert RDMA_CM_EVENT_DEVICE_REMOVAL events
Date: Tue, 28 Oct 2014 18:34:58 +0200
Message-ID: <544FC5B2.70104@dev.mellanox.co.il>
References: <1414130562.15076.27.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414130562.15076.27.camel-XoQW25Eq2zviZyQQd+hFbcojREIfoBdhmpATvIKMPHk@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/24/2014 9:02 AM, Nicholas A. Bellinger wrote:
<SNIP>
> AFAICT, it looks like the assumption in isert_disconnected_handler() to
> dereference rdma_cm_id->context as isert_conn (in all cases) is wrong,
> and the above RDMA_CM_EVENT_DEVICE_REMOVAL has iscsi_np stored in
> ->context from the original rdma_create_id() at isert_setup_np() time.
>
> So, is there a way to tell the difference how rdma_cm_id->context should
> be dereferenced when DEVICE_REMOVAL occurs..?  Does DEVICE_REMOVAL occur
> on just the listener rdma_cm_id, or on all accepted children as well..?
>
> Anything else to consider wrt to other CMA events being kicked off into
> isert_disconnected_handler()..?
>

Hey Nic,

Terribly sorry for the late response, I'm juggling between 5 different
projects...

This is indeed a bug, and I indeed noticed it.

This will happen if the network portal cm id listens on a specific
address (e.g. not any - 0.0.0.0), in this case the cm id will acquire
the relevant device (see rdma_bind_addr) - hence will sense
DEVICE_REMOVAL events. And yes, all the accepted children will of course
get the event as well.

Notice that cma_remove_one sequence (that fires DEVICE_REMOVAL event to
all the relevant cma ids) requires the cmd is owner to finish cleanup
before the end of the callback because in the end of it, it will allow
the device to remove. So I do plan to get disconnected_handler to the
callback instead of the deferred work.

I think this should make the bug you hit go away:
iser-target: Handle DEVICE_REMOVAL event on network portal listener 
correctly

In this case the cm_id->context is the isert_np, and the cm_id->qp
is NULL, so use that to distinct the cases.

Since we don't expect any other events on this cm_id we can
just return -1 for explicit termination of the cm_id by the
cma layer.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
  drivers/infiniband/ulp/isert/ib_isert.c |   29 
+++++++++++++++++++----------
  1 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c 
b/drivers/infiniband/ulp/isert/ib_isert.c
index 5552f93..d620d5e 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -803,14 +803,25 @@ wake_up:
         complete(&isert_conn->conn_wait);
  }

-static void
+static int
  isert_disconnected_handler(struct rdma_cm_id *cma_id, bool disconnect)
  {
-       struct isert_conn *isert_conn = (struct isert_conn 
*)cma_id->context;
+       struct isert_conn *isert_conn;
+
+       if (!cma_id->qp) {
+               struct isert_np *isert_np = cma_id->context;
+
+               isert_np->np_cm_id = NULL;
+               return -1;
+       }
+
+       isert_conn = (struct isert_conn *)cma_id->context;

         isert_conn->disconnect = disconnect;
         INIT_WORK(&isert_conn->conn_logout_work, isert_disconnect_work);
         schedule_work(&isert_conn->conn_logout_work);
+
+       return 0;
  }

  static int
@@ -825,6 +836,9 @@ isert_cma_handler(struct rdma_cm_id *cma_id, struct 
rdma_cm_event *event)
         switch (event->event) {
         case RDMA_CM_EVENT_CONNECT_REQUEST:
                 ret = isert_connect_request(cma_id, event);
+               if (ret)
+                       pr_err("isert_cma_handler failed RDMA_CM_EVENT: 
0x%08x %d\n",
+                              event->event, ret);
                 break;
         case RDMA_CM_EVENT_ESTABLISHED:
                 isert_connected_handler(cma_id);
@@ -834,7 +848,7 @@ isert_cma_handler(struct rdma_cm_id *cma_id, struct 
rdma_cm_event *event)
         case RDMA_CM_EVENT_DEVICE_REMOVAL: /* FALLTHRU */
                 disconnect = true;
         case RDMA_CM_EVENT_TIMEWAIT_EXIT:  /* FALLTHRU */
-               isert_disconnected_handler(cma_id, disconnect);
+               ret = isert_disconnected_handler(cma_id, disconnect);
                 break;
         case RDMA_CM_EVENT_CONNECT_ERROR:
         default:
@@ -842,12 +856,6 @@ isert_cma_handler(struct rdma_cm_id *cma_id, struct 
rdma_cm_event *event)
                 break;
         }

-       if (ret != 0) {
-               pr_err("isert_cma_handler failed RDMA_CM_EVENT: 0x%08x 
%d\n",
-                      event->event, ret);
-               dump_stack();
-       }
-
         return ret;
  }

@@ -3203,7 +3211,8 @@ isert_free_np(struct iscsi_np *np)
  {
         struct isert_np *isert_np = (struct isert_np *)np->np_context;

-       rdma_destroy_id(isert_np->np_cm_id);
+       if (isert_np->np_cm_id)
+               rdma_destroy_id(isert_np->np_cm_id);

         np->np_context = NULL;
         kfree(isert_np);
--
1.7.1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
