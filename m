From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 11/28] IB/srpt: Document all structure members in ib_srpt.h
Date: Wed,  3 Jan 2018 13:39:21 -0800
Message-ID: <20180103213938.11664-12-bart.vanassche@wdc.com>
References: <20180103213938.11664-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180103213938.11664-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch avoids that the following command reports any warnings:

scripts/kernel-doc -none drivers/infiniband/ulp/srpt/ib_srpt.h

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.h | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 3f4142edc53b..3cf917720b35 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -159,6 +159,7 @@ enum srpt_command_state {
 
 /**
  * struct srpt_ioctx - Shared SRPT I/O context information.
+ * @cqe:   Completion queue element.
  * @buf:   Pointer to the buffer.
  * @dma:   DMA address of the buffer.
  * @index: Index of the I/O context in its ioctx_ring array.
@@ -190,10 +191,18 @@ struct srpt_rw_ctx {
  * struct srpt_send_ioctx - SRPT send I/O context.
  * @ioctx:       See above.
  * @ch:          Channel pointer.
+ * @s_rw_ctx:    @rw_ctxs points here if only a single rw_ctx is needed.
+ * @rw_ctxs:     RDMA read/write contexts.
+ * @rdma_cqe:    RDMA completion queue element.
+ * @free_list:   Node in srpt_rdma_ch.free_list.
  * @spinlock:    Protects 'state'.
  * @state:       I/O context state.
  * @cmd:         Target core command data structure.
  * @sense_data:  SCSI sense data.
+ * @n_rdma:      Number of work requests needed to transfer this ioctx.
+ * @n_rw_ctx:    Size of rw_ctxs array.
+ * @queue_status_only: Send a SCSI status back to the initiator but no data.
+ * @sense_data:  Sense data to be sent to the initiator.
  */
 struct srpt_send_ioctx {
 	struct srpt_ioctx	ioctx;
@@ -236,9 +245,11 @@ enum rdma_ch_state {
  * @cm_id:         IB CM ID associated with the channel.
  * @qp:            IB queue pair used for communicating over this channel.
  * @cq:            IB completion queue for this channel.
+ * @zw_cqe:	   Zero-length write CQE.
  * @rcu:           RCU head.
+ * @kref:	   kref for this channel.
  * @rq_size:       IB receive queue size.
- * @rsp_size	   IB response message size in bytes.
+ * @rsp_size:	   IB response message size in bytes.
  * @sq_wr_avail:   number of work requests available in the send queue.
  * @sport:         pointer to the information of the HCA port used by this
  *                 channel.
@@ -322,7 +333,7 @@ struct srpt_port_attrib {
  * @port_guid_wwn: WWN associated with target port GUID.
  * @port_gid_tpg:  TPG associated with target port GID.
  * @port_gid_wwn:  WWN associated with target port GID.
- * @port_acl_list: Head of the list with all node ACLs for this port.
+ * @port_attrib:   Port attributes that can be accessed through configfs.
  */
 struct srpt_port {
 	struct srpt_device	*sdev;
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
