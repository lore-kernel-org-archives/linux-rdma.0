From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] An argument for allowing applications to manually send RMPP
 packets if desired
Date: Mon, 12 Sep 2011 11:02:23 -0500
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB4A5387E899@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Consider an HPC cluster with 3000 compute nodes and a single SM, where each
compute node has 16 CPUs.

Now consider an HPC application running on all cores and all processes are
starting at roughly the same time and each process is querying the SM for a
list of all nodes in the fabric.  If the application uses some local sharing of
data, this will lead to 3,000 queries at the same time. (If it is naive, it
would lead to 48,000 queries hitting the SM!)

Under the OFED model, the SM would be required to build 3,000 distinct buffers
containing 3,000 slightly different replies. At 128 bytes per Node Info record,
each reply would be roughly 384k long and each would consume 384k of kernel
memory until the response was completely sent to the destination. In the case
we just described, this could result in a bit over a gigabyte of kernel memory
being allocated. (In the naive case, it would be much worse - 6 gigabytes of
kernel memory allocated to handle redundant data!)

But is this really needed? Consider that these 3,000 replies only differ in
their destination addresses - the actual data is identical in all of them.
Moreover, the data returned for a query like this changes only rarely in a
production fabric - which means that the response could be generated once and
then and then re-used to provide responses to multiple clients.

To allow this, however, the SM must be allowed to explicitly manage its own
RMPP transmissions instead of sending each response as a complete unit. If this
is allowed, then the kernel no longer needs to allocate large amounts of buffer
space, and the SM can build the results of certain queries in advance, updating
them only when the fabric changes, instead of recreating them each time it
receives an IB_MAD_METHOD_GET_TABLE.

Notes about this version of the patch:

This code incorporates feedback from spring 2010, when it was requested
that the patch provide an explicit pass-through rmpp version instead of
overriding version zero. Unlike the previous version of this patch this
version does not affect how RMPP responses are received, these are still
handled as normal.  All it does is permit RMPP packets sent by the SM to be
delivered without alteration. I've tested this work by writing a sample
program based on ibsysstat.c to demonstrate that large MAD responses
can be sent and received using both RMPP version 1 and RMPP pass-through.

Signed-off-by: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/mad.c      |    6 ++++++
 drivers/infiniband/core/user_mad.c |   26 ++++++++++++++++++--------
 include/rdma/ib_mad.h              |    2 ++
 3 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index b4d8672..d506bc0 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -207,12 +207,17 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
        int ret2, qpn;
        unsigned long flags;
        u8 mgmt_class, vclass;
+       u8 rmpp_passthru;

        /* Validate parameters */
        qpn = get_spl_qp_index(qp_type);
        if (qpn == -1)
                goto error1;

+       rmpp_passthru = (rmpp_version == IB_MGMT_RMPP_PASSTHRU);
+       if (rmpp_passthru)
+               rmpp_version = 0;
+
        if (rmpp_version && rmpp_version != IB_MGMT_RMPP_VERSION)
                goto error1;

@@ -309,6 +314,7 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
        mad_agent_priv->qp_info = &port_priv->qp_info[qpn];
        mad_agent_priv->reg_req = reg_req;
        mad_agent_priv->agent.rmpp_version = rmpp_version;
+       mad_agent_priv->agent.rmpp_passthru = rmpp_passthru;
        mad_agent_priv->agent.device = device;
        mad_agent_priv->agent.recv_handler = recv_handler;
        mad_agent_priv->agent.send_handler = send_handler;
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 8d261b6..1993aad 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -501,7 +501,8 @@ static ssize_t ib_umad_write(struct file *filp, const char __user *buf,

        rmpp_mad = (struct ib_rmpp_mad *) packet->mad.data;
        hdr_len = ib_get_mad_data_offset(rmpp_mad->mad_hdr.mgmt_class);
-       if (!ib_is_mad_class_rmpp(rmpp_mad->mad_hdr.mgmt_class)) {
+       if (agent->rmpp_passthru ||
+           !ib_is_mad_class_rmpp(rmpp_mad->mad_hdr.mgmt_class)) {
                copy_offset = IB_MGMT_MAD_HDR;
                rmpp_active = 0;
        } else {
@@ -553,14 +554,23 @@ static ssize_t ib_umad_write(struct file *filp, const char __user *buf,
                rmpp_mad->mad_hdr.tid = *tid;
        }

-       spin_lock_irq(&file->send_lock);
-       ret = is_duplicate(file, packet);
-       if (!ret)
+       if (agent->rmpp_passthru &&
+           ib_is_mad_class_rmpp(rmpp_mad->mad_hdr.mgmt_class) &&
+           (ib_get_rmpp_flags(&rmpp_mad->rmpp_hdr) &
+               IB_MGMT_RMPP_FLAG_ACTIVE)) {
+               spin_lock_irq(&file->send_lock);
                list_add_tail(&packet->list, &file->send_list);
-       spin_unlock_irq(&file->send_lock);
-       if (ret) {
-               ret = -EINVAL;
-               goto err_msg;
+               spin_unlock_irq(&file->send_lock);
+       } else {
+               spin_lock_irq(&file->send_lock);
+               ret = is_duplicate(file, packet);
+               if (!ret)
+                       list_add_tail(&packet->list, &file->send_list);
+               spin_unlock_irq(&file->send_lock);
+               if (ret) {
+                       ret = -EINVAL;
+                       goto err_msg;
+               }
        }

        ret = ib_post_send_mad(packet->msg, NULL);
diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index d3b9401..ee40330 100644
--- a/include/rdma/ib_mad.h
+++ b/include/rdma/ib_mad.h
@@ -79,6 +79,7 @@

 /* RMPP information */
 #define IB_MGMT_RMPP_VERSION                   1
+#define IB_MGMT_RMPP_PASSTHRU                  255

 #define IB_MGMT_RMPP_TYPE_DATA                 1
 #define IB_MGMT_RMPP_TYPE_ACK                  2
@@ -360,6 +361,7 @@ struct ib_mad_agent {
        u32                     hi_tid;
        u8                      port_num;
        u8                      rmpp_version;
+       u8                      rmpp_passthru;
 };

 /**

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
