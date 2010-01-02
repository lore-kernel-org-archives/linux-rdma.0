From: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: [PATCH] IB/srp: Fix initiator lockup
Date: Sat, 2 Jan 2010 09:05:02 -0700
Message-ID: <f3177b9e1001020805k4dce1991u3733c5a7f6d46aaa@mail.gmail.com>
References: <e2e108261001020419l36319156hb9d625edc2e15d06@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e2e108261001020419l36319156hb9d625edc2e15d06-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Cc: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Would this fix effect the Window's SRP initiator too?

Thanks for this fix, Bart!

Chris
---------- Forwarded message ----------
=46rom: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Sat, Jan 2, 2010 at 5:19 AM
Subject: [PATCH] IB/srp: Fix initiator lockup
To: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


When the SRP initiator is communicating with an SRP target under load i=
t can
happen that the SRP initiator locks up. The communication pattern that =
causes
the lockup is as follows:
* SRP initiator sends (req_lim - 2) SRP_CMD requests to the target.
* The REQUEST LIMIT DELTA field of each SRP_RSP response is zero.
* The target sends an SRP_CRED_REQ information unit with non-zero REQUE=
ST
=A0LIMIT DELTA.

The above communication pattern brings the initiator in the following s=
tate:
* srp_queuecommand() always returns SCSI_MLQUEUE_HOST_BUSY.
* The per-session variable zero_req_lim keeps increasing.
The initiator never leaves this state because it ignores SRP_CRED_REQ
information units.

This patch fixes this issue by adding support for SRP_CRED_REQ informat=
ion
units in the SRP initiator. Additionally, this patch makes the per-sess=
ion
variable req_lim visible through sysfs, which makes observing the initi=
ator
state easier.

See also http://bugzilla.kernel.org/show_bug.cgi?id=3D14235

Signed-off-by: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reported-by: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c
b/drivers/infiniband/ulp/srp/ib_srp.c
index 54c8fe2..2006a0a 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1,5 +1,6 @@
=A0/*
=A0* Copyright (c) 2005 Cisco Systems. =A0All rights reserved.
+ * Copyright (c) 2009 Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>.
=A0*
=A0* This software is available to you under a choice of one of two
=A0* licenses. =A0You may choose to be licensed under the terms of the =
GNU
@@ -53,6 +54,8 @@
=A0#define PFX =A0 =A0 =A0 =A0 =A0 =A0DRV_NAME ": "
=A0#define DRV_VERSION =A0 =A0"0.2"
=A0#define DRV_RELDATE =A0 =A0"November 1, 2005"
+/* Similar to is_power_of_2(), but can be evaluated at compile time. *=
/
+#define IS_POWER_OF_2(n) ((n) !=3D 0 && (((n) & ((n) - 1)) =3D=3D 0))

=A0MODULE_AUTHOR("Roland Dreier");
=A0MODULE_DESCRIPTION("InfiniBand SCSI RDMA Protocol initiator "
@@ -82,6 +85,11 @@ static void srp_add_one(struct ib_device *device);
=A0static void srp_remove_one(struct ib_device *device);
=A0static void srp_completion(struct ib_cq *cq, void *target_ptr);
=A0static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event=
 *event);
+static void srp_process_cred_req(struct srp_target_port *target,
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct=
 srp_cred_req *req);
+static void srp_process_aer_req(struct srp_target_port *target,
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct sr=
p_cred_req *req);
+static int srp_post_recv(struct srp_target_port *target);

=A0static struct scsi_transport_template *ib_srp_transport_template;

@@ -237,7 +245,7 @@ static int srp_create_target_ib(struct
srp_target_port *target)
=A0 =A0 =A0 =A0ib_req_notify_cq(target->cq, IB_CQ_NEXT_COMP);

=A0 =A0 =A0 =A0init_attr->event_handler =A0 =A0 =A0 =3D srp_qp_event;
- =A0 =A0 =A0 init_attr->cap.max_send_wr =A0 =A0 =3D SRP_SQ_SIZE;
+ =A0 =A0 =A0 init_attr->cap.max_send_wr =A0 =A0 =3D SRP_SQ_SIZE + SRP_=
TXP_SIZE;
=A0 =A0 =A0 =A0init_attr->cap.max_recv_wr =A0 =A0 =3D SRP_RQ_SIZE;
=A0 =A0 =A0 =A0init_attr->cap.max_recv_sge =A0 =A0=3D 1;
=A0 =A0 =A0 =A0init_attr->cap.max_send_sge =A0 =A0=3D 1;
@@ -272,10 +280,12 @@ static void srp_free_target_ib(struct
srp_target_port *target)
=A0 =A0 =A0 =A0ib_destroy_qp(target->qp);
=A0 =A0 =A0 =A0ib_destroy_cq(target->cq);

- =A0 =A0 =A0 for (i =3D 0; i < SRP_RQ_SIZE; ++i)
+ =A0 =A0 =A0 for (i =3D 0; i < ARRAY_SIZE(target->rx_ring); ++i)
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0srp_free_iu(target->srp_host, target->rx=
_ring[i]);
- =A0 =A0 =A0 for (i =3D 0; i < SRP_SQ_SIZE + 1; ++i)
+ =A0 =A0 =A0 for (i =3D 0; i < ARRAY_SIZE(target->tx_ring); ++i)
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0srp_free_iu(target->srp_host, target->tx=
_ring[i]);
+ =A0 =A0 =A0 for (i =3D 0; i < ARRAY_SIZE(target->txp_ring); ++i)
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 srp_free_iu(target->srp_host, target->txp=
_ring[i]);
=A0}

=A0static void srp_path_rec_completion(int status,
@@ -888,6 +898,14 @@ static void srp_handle_recv(struct
srp_target_port *target, struct ib_wc *wc)
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 PFX "Got target=
 logout request\n");
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;

+ =A0 =A0 =A0 case SRP_CRED_REQ:
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 srp_process_cred_req(target, iu->buf);
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
+
+ =A0 =A0 =A0 case SRP_AER_REQ:
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 srp_process_aer_req(target, iu->buf);
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
+
=A0 =A0 =A0 =A0default:
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0shost_printk(KERN_WARNING, target->scsi_=
host,
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 PFX "Unhandled =
SRP opcode 0x%02x\n", opcode);
@@ -908,7 +926,11 @@ static void srp_completion(struct ib_cq *cq, void
*target_ptr)
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (wc.status) {
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0shost_printk(KERN_ERR, t=
arget->scsi_host,
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 PFX "failed %s status %d\n",
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
wc.wr_id & SRP_OP_RECV ?
"receive" : "send",
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
wc.wr_id & SRP_OP_RECV
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
? "receiving"
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: wc.wr_id & SRP_OP_TXP
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
? "sending response"
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: "sending request",
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 wc.status);
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0target->qp_in_error =3D =
1;
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
@@ -916,6 +938,8 @@ static void srp_completion(struct ib_cq *cq, void
*target_ptr)

=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (wc.wr_id & SRP_OP_RECV)
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0srp_handle_recv(target, =
&wc);
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (wc.wr_id & SRP_OP_TXP)
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++target->txp_tail;
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0++target->tx_tail;
=A0 =A0 =A0 =A0}
@@ -961,15 +985,19 @@ static int srp_post_recv(struct srp_target_port *=
target)
=A0}

=A0/*
+ * Obtain an information unit for sending a request to the target.
+ *
=A0* Must be called with target->scsi_host->host_lock held to protect
=A0* req_lim and tx_head. =A0Lock cannot be dropped between call here a=
nd
- * call to __srp_post_send().
+ * call to __srp_post_send_req().
=A0*/
=A0static struct srp_iu *__srp_get_tx_iu(struct srp_target_port *target=
,
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0enum srp_request_type req_type)
=A0{
=A0 =A0 =A0 =A0s32 min =3D (req_type =3D=3D SRP_REQ_TASK_MGMT) ? 1 : 2;

+ =A0 =A0 =A0 BUILD_BUG_ON(!IS_POWER_OF_2(ARRAY_SIZE(target->tx_ring)))=
;
+
=A0 =A0 =A0 =A0if (target->tx_head - target->tx_tail >=3D SRP_SQ_SIZE)
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return NULL;

@@ -978,26 +1006,31 @@ static struct srp_iu *__srp_get_tx_iu(struct
srp_target_port *target,
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return NULL;
=A0 =A0 =A0 =A0}

- =A0 =A0 =A0 return target->tx_ring[target->tx_head & SRP_SQ_SIZE];
+ =A0 =A0 =A0 return target->tx_ring[target->tx_head
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0& (ARRAY_S=
IZE(target->tx_ring) - 1)];
=A0}

=A0/*
+ * Send a request to the target.
+ *
=A0* Must be called with target->scsi_host->host_lock held to protect
=A0* req_lim and tx_head.
=A0*/
-static int __srp_post_send(struct srp_target_port *target,
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct srp_iu *iu,=
 int len)
+static int __srp_post_send_req(struct srp_target_port *target,
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct srp=
_iu *iu, int len)
=A0{
=A0 =A0 =A0 =A0struct ib_sge list;
=A0 =A0 =A0 =A0struct ib_send_wr wr, *bad_wr;
=A0 =A0 =A0 =A0int ret =3D 0;

+ =A0 =A0 =A0 BUILD_BUG_ON(!IS_POWER_OF_2(ARRAY_SIZE(target->tx_ring)))=
;
+
=A0 =A0 =A0 =A0list.addr =A0 =3D iu->dma;
=A0 =A0 =A0 =A0list.length =3D len;
=A0 =A0 =A0 =A0list.lkey =A0 =3D target->srp_host->srp_dev->mr->lkey;

=A0 =A0 =A0 =A0wr.next =A0 =A0 =A0 =3D NULL;
- =A0 =A0 =A0 wr.wr_id =A0 =A0 =A0=3D target->tx_head & SRP_SQ_SIZE;
+ =A0 =A0 =A0 wr.wr_id =A0 =A0 =A0=3D target->tx_head & (ARRAY_SIZE(tar=
get->tx_ring) - 1);
=A0 =A0 =A0 =A0wr.sg_list =A0 =A0=3D &list;
=A0 =A0 =A0 =A0wr.num_sge =A0 =A0=3D 1;
=A0 =A0 =A0 =A0wr.opcode =A0 =A0 =3D IB_WR_SEND;
@@ -1013,6 +1046,117 @@ static int __srp_post_send(struct
srp_target_port *target,
=A0 =A0 =A0 =A0return ret;
=A0}

+/*
+ * Obtain an information unit for sending a response to the target.
+ *
+ * Must be called with target->scsi_host->host_lock held to protect
+ * req_lim and tx_head. =A0Lock cannot be dropped between call here an=
d
+ * call to __srp_post_send_rsp().
+ */
+static struct srp_iu *__srp_get_txp_iu(struct srp_target_port *target)
+{
+ =A0 =A0 =A0 BUILD_BUG_ON(!IS_POWER_OF_2(SRP_TXP_SIZE));
+
+ =A0 =A0 =A0 if (WARN_ON(target->txp_head - target->txp_tail >=3D SRP_=
TXP_SIZE))
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
+
+ =A0 =A0 =A0 return target->txp_ring[target->txp_head & (SRP_TXP_SIZE =
- 1)];
+}
+
+/*
+ * Send a response to a request received from the target.
+ *
+ * Must be called with target->scsi_host->host_lock held to protect tx=
p_head.
+ */
+static int __srp_post_send_rsp(struct srp_target_port *target,
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct srp=
_iu *iu, int len)
+{
+ =A0 =A0 =A0 struct ib_sge list;
+ =A0 =A0 =A0 struct ib_send_wr wr, *bad_wr;
+ =A0 =A0 =A0 int ret =3D 0;
+
+ =A0 =A0 =A0 BUILD_BUG_ON(!IS_POWER_OF_2(SRP_TXP_SIZE));
+
+ =A0 =A0 =A0 list.addr =A0 =3D iu->dma;
+ =A0 =A0 =A0 list.length =3D len;
+ =A0 =A0 =A0 list.lkey =A0 =3D target->srp_host->srp_dev->mr->lkey;
+
+ =A0 =A0 =A0 wr.next =A0 =A0 =A0 =3D NULL;
+ =A0 =A0 =A0 wr.wr_id =A0 =A0 =A0=3D (target->txp_head & (SRP_TXP_SIZE=
 - 1)) | SRP_OP_TXP;
+ =A0 =A0 =A0 wr.sg_list =A0 =A0=3D &list;
+ =A0 =A0 =A0 wr.num_sge =A0 =A0=3D 1;
+ =A0 =A0 =A0 wr.opcode =A0 =A0 =3D IB_WR_SEND;
+ =A0 =A0 =A0 wr.send_flags =3D IB_SEND_SIGNALED;
+
+ =A0 =A0 =A0 ret =3D ib_post_send(target->qp, &wr, &bad_wr);
+
+ =A0 =A0 =A0 if (!ret)
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++target->txp_head;
+
+ =A0 =A0 =A0 return ret;
+}
+
+static void srp_process_cred_req(struct srp_target_port *target,
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct=
 srp_cred_req *req)
+{
+ =A0 =A0 =A0 struct ib_device *dev;
+ =A0 =A0 =A0 struct srp_iu *iu;
+ =A0 =A0 =A0 struct srp_cred_rsp *rsp;
+ =A0 =A0 =A0 unsigned long flags;
+ =A0 =A0 =A0 int res;
+ =A0 =A0 =A0 s32 delta;
+ =A0 =A0 =A0 u64 tag;
+
+ =A0 =A0 =A0 dev =3D target->srp_host->srp_dev->dev;
+ =A0 =A0 =A0 delta =3D (s32) be32_to_cpu(req->req_lim_delta);
+ =A0 =A0 =A0 tag =3D req->tag;
+
+ =A0 =A0 =A0 spin_lock_irqsave(target->scsi_host->host_lock, flags);
+
+ =A0 =A0 =A0 target->req_lim +=3D delta;
+
+ =A0 =A0 =A0 iu =3D __srp_get_txp_iu(target);
+ =A0 =A0 =A0 if (!iu)
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
+
+ =A0 =A0 =A0 rsp =3D iu->buf;
+
+ =A0 =A0 =A0 ib_dma_sync_single_for_cpu(dev, iu->dma, sizeof(*rsp),
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0DM=
A_TO_DEVICE);
+
+ =A0 =A0 =A0 memset(rsp, 0, sizeof *rsp);
+ =A0 =A0 =A0 rsp->opcode =3D SRP_CRED_RSP;
+ =A0 =A0 =A0 rsp->tag =A0 =A0=3D tag;
+
+ =A0 =A0 =A0 ib_dma_sync_single_for_device(dev, iu->dma, srp_max_iu_le=
n,
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 DMA_TO_DEVICE);
+
+ =A0 =A0 =A0 if (__srp_post_send_rsp(target, iu, sizeof(*rsp)))
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 shost_printk(KERN_ERR, target->scsi_host,
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0PFX "Sending r=
esponse failed\n");
+
+ =A0 =A0 =A0 res =3D __srp_post_recv(target);
+ =A0 =A0 =A0 if (res)
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 shost_printk(KERN_ERR, target->scsi_host,
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0PFX "ib_post_r=
ecv() failed -- res =3D %d\n", res);
+
+out:
+ =A0 =A0 =A0 spin_unlock_irqrestore(target->scsi_host->host_lock, flag=
s);
+}
+
+static void srp_process_aer_req(struct srp_target_port *target,
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct=
 srp_cred_req *req)
+{
+ =A0 =A0 =A0 int res;
+
+ =A0 =A0 =A0 shost_printk(KERN_ERR, target->scsi_host,
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0PFX "received and ignored SRP_=
AER_REQ\n");
+ =A0 =A0 =A0 res =3D srp_post_recv(target);
+ =A0 =A0 =A0 if (res)
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 shost_printk(KERN_ERR, target->scsi_host,
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0PFX "ib_post_r=
ecv() failed -- res =3D %d\n", res);
+}
+
=A0static int srp_queuecommand(struct scsi_cmnd *scmnd,
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0void (*done)(str=
uct scsi_cmnd *))
=A0{
@@ -1075,8 +1219,9 @@ static int srp_queuecommand(struct scsi_cmnd *scm=
nd,
=A0 =A0 =A0 =A0ib_dma_sync_single_for_device(dev, iu->dma, srp_max_iu_l=
en,
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0DMA_TO_DEVICE);

- =A0 =A0 =A0 if (__srp_post_send(target, iu, len)) {
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 shost_printk(KERN_ERR, target->scsi_host,=
 PFX "Send failed\n");
+ =A0 =A0 =A0 if (__srp_post_send_req(target, iu, len)) {
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 shost_printk(KERN_ERR, target->scsi_host,
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0PFX "Sending r=
equest failed\n");
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto err_unmap;
=A0 =A0 =A0 =A0}

@@ -1095,7 +1240,7 @@ static int srp_alloc_iu_bufs(struct
srp_target_port *target)
=A0{
=A0 =A0 =A0 =A0int i;

- =A0 =A0 =A0 for (i =3D 0; i < SRP_RQ_SIZE; ++i) {
+ =A0 =A0 =A0 for (i =3D 0; i < ARRAY_SIZE(target->rx_ring); ++i) {
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0target->rx_ring[i] =3D srp_alloc_iu(targ=
et->srp_host,
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0target->max_ti_iu_len,
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0GFP_KERNEL, DMA_FROM_DEVICE);
@@ -1103,7 +1248,7 @@ static int srp_alloc_iu_bufs(struct
srp_target_port *target)
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto err;
=A0 =A0 =A0 =A0}

- =A0 =A0 =A0 for (i =3D 0; i < SRP_SQ_SIZE + 1; ++i) {
+ =A0 =A0 =A0 for (i =3D 0; i < ARRAY_SIZE(target->tx_ring); ++i) {
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0target->tx_ring[i] =3D srp_alloc_iu(targ=
et->srp_host,
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0srp_max_iu_len,
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0GFP_KERNEL, DMA_TO_DEVICE);
@@ -1111,19 +1256,32 @@ static int srp_alloc_iu_bufs(struct
srp_target_port *target)
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto err;
=A0 =A0 =A0 =A0}

+ =A0 =A0 =A0 for (i =3D 0; i < ARRAY_SIZE(target->txp_ring); ++i) {
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 target->txp_ring[i] =3D srp_alloc_iu(targ=
et->srp_host,
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 srp_max_iu_len,
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 GFP_KERNEL, DMA_TO_DEVICE);
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!target->txp_ring[i])
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto err;
+ =A0 =A0 =A0 }
+
=A0 =A0 =A0 =A0return 0;

=A0err:
- =A0 =A0 =A0 for (i =3D 0; i < SRP_RQ_SIZE; ++i) {
+ =A0 =A0 =A0 for (i =3D 0; i < ARRAY_SIZE(target->rx_ring); ++i) {
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0srp_free_iu(target->srp_host, target->rx=
_ring[i]);
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0target->rx_ring[i] =3D NULL;
=A0 =A0 =A0 =A0}

- =A0 =A0 =A0 for (i =3D 0; i < SRP_SQ_SIZE + 1; ++i) {
+ =A0 =A0 =A0 for (i =3D 0; i < ARRAY_SIZE(target->tx_ring); ++i) {
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0srp_free_iu(target->srp_host, target->tx=
_ring[i]);
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0target->tx_ring[i] =3D NULL;
=A0 =A0 =A0 =A0}

+ =A0 =A0 =A0 for (i =3D 0; i < ARRAY_SIZE(target->txp_ring); ++i) {
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 srp_free_iu(target->srp_host, target->txp=
_ring[i]);
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 target->tx_ring[i] =3D NULL;
+ =A0 =A0 =A0 }
+
=A0 =A0 =A0 =A0return -ENOMEM;
=A0}

@@ -1211,6 +1369,7 @@ static int srp_cm_handler(struct ib_cm_id
*cm_id, struct ib_cm_event *event)
=A0{
=A0 =A0 =A0 =A0struct srp_target_port *target =3D cm_id->context;
=A0 =A0 =A0 =A0struct ib_qp_attr *qp_attr =3D NULL;
+ =A0 =A0 =A0 int i;
=A0 =A0 =A0 =A0int attr_mask =3D 0;
=A0 =A0 =A0 =A0int comp =3D 0;
=A0 =A0 =A0 =A0int opcode =3D 0;
@@ -1263,7 +1422,11 @@ static int srp_cm_handler(struct ib_cm_id
*cm_id, struct ib_cm_event *event)
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (target->status)
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;

- =A0 =A0 =A0 =A0 =A0 =A0 =A0 target->status =3D srp_post_recv(target);
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i < SRP_RXR_SIZE; ++i) {
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 target->status =3D srp_po=
st_recv(target);
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (target->status)
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (target->status)
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;

@@ -1353,7 +1516,7 @@ static int srp_send_tsk_mgmt(struct
srp_target_port *target,
=A0 =A0 =A0 =A0tsk_mgmt->tsk_mgmt_func =3D func;
=A0 =A0 =A0 =A0tsk_mgmt->task_tag =A0 =A0 =A0=3D req->index;

- =A0 =A0 =A0 if (__srp_post_send(target, iu, sizeof *tsk_mgmt))
+ =A0 =A0 =A0 if (__srp_post_send_req(target, iu, sizeof *tsk_mgmt))
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;

=A0 =A0 =A0 =A0req->tsk_mgmt =3D iu;
@@ -1529,6 +1692,18 @@ static ssize_t show_orig_dgid(struct device *dev=
,
=A0 =A0 =A0 =A0return sprintf(buf, "%pI6\n", target->orig_dgid);
=A0}

+static ssize_t show_req_lim(struct device *dev,
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct device_att=
ribute *attr, char *buf)
+{
+ =A0 =A0 =A0 struct srp_target_port *target =3D host_to_target(class_t=
o_shost(dev));
+
+ =A0 =A0 =A0 if (target->state =3D=3D SRP_TARGET_DEAD ||
+ =A0 =A0 =A0 =A0 =A0 target->state =3D=3D SRP_TARGET_REMOVED)
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENODEV;
+
+ =A0 =A0 =A0 return sprintf(buf, "%d\n", target->req_lim);
+}
+
=A0static ssize_t show_zero_req_lim(struct device *dev,
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct =
device_attribute *attr, char *buf)
=A0{
@@ -1563,6 +1738,7 @@ static DEVICE_ATTR(service_id, =A0 =A0 =A0 =A0S_I=
RUGO,
show_service_id, =A0 =A0 =A0 =A0 =A0 NULL);
=A0static DEVICE_ATTR(pkey, =A0 =A0 =A0 =A0 =A0 S_IRUGO, show_pkey, =A0=
 =A0 =A0 =A0 =A0 =A0NULL);
=A0static DEVICE_ATTR(dgid, =A0 =A0 =A0 =A0 =A0 S_IRUGO, show_dgid, =A0=
 =A0 =A0 =A0 =A0 =A0NULL);
=A0static DEVICE_ATTR(orig_dgid, =A0 =A0 =A0S_IRUGO, show_orig_dgid, =A0=
 =A0 =A0 NULL);
+static DEVICE_ATTR(req_lim, =A0 =A0 =A0 =A0S_IRUGO, show_req_lim, =A0 =
=A0 =A0 =A0 NULL);
=A0static DEVICE_ATTR(zero_req_lim, =A0 =A0S_IRUGO, show_zero_req_lim,
=A0 =A0 NULL);
=A0static DEVICE_ATTR(local_ib_port, =A0 S_IRUGO, show_local_ib_port, =A0=
 NULL);
=A0static DEVICE_ATTR(local_ib_device, S_IRUGO, show_local_ib_device, N=
ULL);
@@ -1574,6 +1750,7 @@ static struct device_attribute *srp_host_attrs[] =
=3D {
=A0 =A0 =A0 =A0&dev_attr_pkey,
=A0 =A0 =A0 =A0&dev_attr_dgid,
=A0 =A0 =A0 =A0&dev_attr_orig_dgid,
+ =A0 =A0 =A0 &dev_attr_req_lim,
=A0 =A0 =A0 =A0&dev_attr_zero_req_lim,
=A0 =A0 =A0 =A0&dev_attr_local_ib_port,
=A0 =A0 =A0 =A0&dev_attr_local_ib_device,
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h
b/drivers/infiniband/ulp/srp/ib_srp.h
index e185b90..c553a03 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -57,10 +57,20 @@ enum {
=A0 =A0 =A0 =A0SRP_MAX_LUN =A0 =A0 =A0 =A0 =A0 =A0 =3D 512,
=A0 =A0 =A0 =A0SRP_DEF_SG_TABLESIZE =A0 =A0=3D 12,

+ =A0 =A0 =A0 /*
+ =A0 =A0 =A0 =A0* Receive queue: queue for receiving responses and req=
uests from the
+ =A0 =A0 =A0 =A0* target.
+ =A0 =A0 =A0 =A0*/
=A0 =A0 =A0 =A0SRP_RQ_SHIFT =A0 =A0 =A0 =A0 =A0 =A0=3D 6,
=A0 =A0 =A0 =A0SRP_RQ_SIZE =A0 =A0 =A0 =A0 =A0 =A0 =3D 1 << SRP_RQ_SHIF=
T,
- =A0 =A0 =A0 SRP_SQ_SIZE =A0 =A0 =A0 =A0 =A0 =A0 =3D SRP_RQ_SIZE - 1,
- =A0 =A0 =A0 SRP_CQ_SIZE =A0 =A0 =A0 =A0 =A0 =A0 =3D SRP_SQ_SIZE + SRP=
_RQ_SIZE,
+ =A0 =A0 =A0 /* Number of receive slots reserved for receiving request=
s. */
+ =A0 =A0 =A0 SRP_RXR_SIZE =A0 =A0 =A0 =A0 =A0 =A0=3D 2,
+ =A0 =A0 =A0 /* Send queue: queue for sending requests to the target. =
*/
+ =A0 =A0 =A0 SRP_SQ_SIZE =A0 =A0 =A0 =A0 =A0 =A0 =3D SRP_RQ_SIZE - SRP=
_RXR_SIZE - 1,
+ =A0 =A0 =A0 /* Size of the queue for sending responses to the target.=
 */
+ =A0 =A0 =A0 SRP_TXP_SIZE =A0 =A0 =A0 =A0 =A0 =A0=3D 2,
+ =A0 =A0 =A0 /* Completion queue. */
+ =A0 =A0 =A0 SRP_CQ_SIZE =A0 =A0 =A0 =A0 =A0 =A0 =3D SRP_SQ_SIZE + SRP=
_TXP_SIZE + SRP_RQ_SIZE,

=A0 =A0 =A0 =A0SRP_TAG_TSK_MGMT =A0 =A0 =A0 =A0=3D 1 << (SRP_RQ_SHIFT +=
 1),

@@ -69,6 +79,9 @@ enum {
=A0 =A0 =A0 =A0SRP_FMR_DIRTY_SIZE =A0 =A0 =A0=3D SRP_FMR_POOL_SIZE / 4
=A0};

+/* wr_id / wc_id flag for marking responses sent to the target. */
+#define SRP_OP_TXP =A0 =A0 =A0 =A0 =A0 =A0 (1 << 30)
+/* wr_id / wc_id flag for marking receive operations. */
=A0#define SRP_OP_RECV =A0 =A0 =A0 =A0 =A0 =A0(1 << 31)

=A0enum srp_target_state {
@@ -141,12 +154,20 @@ struct srp_target_port {

=A0 =A0 =A0 =A0int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 zero_req_lim=
;

+
+ =A0 =A0 =A0 /* Receive ring for responses and requests received by th=
e initiator. */
=A0 =A0 =A0 =A0unsigned =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rx_head;
=A0 =A0 =A0 =A0struct srp_iu =A0 =A0 =A0 =A0 =A0*rx_ring[SRP_RQ_SIZE];

+ =A0 =A0 =A0 /* Transmit ring for requests sent to the target. */
=A0 =A0 =A0 =A0unsigned =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tx_head;
=A0 =A0 =A0 =A0unsigned =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tx_tail;
- =A0 =A0 =A0 struct srp_iu =A0 =A0 =A0 =A0 =A0*tx_ring[SRP_SQ_SIZE + 1=
];
+ =A0 =A0 =A0 struct srp_iu =A0 =A0 =A0 =A0 =A0*tx_ring[SRP_SQ_SIZE + S=
RP_RXR_SIZE + 1];
+
+ =A0 =A0 =A0 /* Transmit ring for responses sent to the target. */
+ =A0 =A0 =A0 unsigned =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0txp_head;
+ =A0 =A0 =A0 unsigned =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0txp_tail;
+ =A0 =A0 =A0 struct srp_iu =A0 =A0 =A0 =A0 =A0*txp_ring[SRP_TXP_SIZE];

=A0 =A0 =A0 =A0struct list_head =A0 =A0 =A0 =A0free_reqs;
=A0 =A0 =A0 =A0struct list_head =A0 =A0 =A0 =A0req_queue;
diff --git a/include/scsi/srp.h b/include/scsi/srp.h
index ad178fa..55c16c7 100644
--- a/include/scsi/srp.h
+++ b/include/scsi/srp.h
@@ -239,4 +239,26 @@ struct srp_rsp {
=A0 =A0 =A0 =A0u8 =A0 =A0 =A0data[0];
=A0} __attribute__((packed));

+/*
+ * SRP_CRED_REQ information unit, as defined in section 6.10 of the
+ * T10 SRP r16a document.
+ */
+struct srp_cred_req {
+ =A0 =A0 =A0 u8 =A0 =A0 =A0opcode;
+ =A0 =A0 =A0 u8 =A0 =A0 =A0sol_not;
+ =A0 =A0 =A0 u8 =A0 =A0 =A0reserved[2];
+ =A0 =A0 =A0 __be32 =A0req_lim_delta;
+ =A0 =A0 =A0 u64 =A0 =A0 tag;
+} __attribute__((packed));
+
+/*
+ * SRP_CRED_RSP information unit, as defined in section 6.11 of the
+ * T10 SRP r16a document.
+ */
+struct srp_cred_rsp {
+ =A0 =A0 =A0 u8 =A0 =A0 =A0opcode;
+ =A0 =A0 =A0 u8 =A0 =A0 =A0reserved[7];
+ =A0 =A0 =A0 u64 =A0 =A0 tag;
+} __attribute__((packed));
+
=A0#endif /* SCSI_SRP_H */
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
