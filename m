From: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [ofa-general][PATCH 3/4] SRP fail-over faster
Date: Tue, 13 Oct 2009 13:09:06 +0200
Message-ID: <e2e108260910130409m7994a9d4v6d7ae21f63864cb0@mail.gmail.com>
References: <4AD3B453.3030109@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AD3B453.3030109-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 13, 2009 at 12:57 AM, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>
>
> Introducing srp_dev_loss_tmo module parameter. Creating a timer to cl=
ean up
> connection after srp_dev_loss_tmo expired. During srp_dev_loss_tmo, t=
he qp
> is in error state, srp will return DID_RESET for outstanding I/O and =
return
> FAILED for abort_cmd, reset_lun, and return SUCCESS (without trying
> reconnect) on reset_host.
>
> Signed-off-by: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
>
>
> Index: ofed_kernel/drivers/infiniband/ulp/srp/ib_srp.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- ofed_kernel.orig/drivers/infiniband/ulp/srp/ib_srp.c
> +++ ofed_kernel/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -78,6 +77,13 @@
> =A0MODULE_PARM_DESC(mellanox_workarounds,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Enable workarounds for Mellanox SRP =
target bugs if !=3D 0");
>
> +static int srp_dev_loss_tmo =3D 60;
> +
> +module_param(srp_dev_loss_tmo, int, 0444);
> +MODULE_PARM_DESC(srp_dev_loss_tmo,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"Default number of seconds that srp =
transport should \
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 insulate the lost of a remote port =
(default is 60 secs");
> +
> =A0static void srp_add_one(struct ib_device *device);
> =A0static void srp_remove_one(struct ib_device *device);
> =A0static void srp_completion(struct ib_cq *cq, void *target_ptr);
> @@ -898,6 +926,48 @@
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0DMA_FROM_DEVICE);
> =A0}
>
> +static void srp_reconnect_work(struct work_struct *work)
> +{
> + =A0 =A0 =A0 struct srp_target_port *target =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 container_of(work, struct srp_target_po=
rt, work);
> +
> + =A0 =A0 =A0 srp_reconnect_target(target);
> + =A0 =A0 =A0 target->work_in_progress =3D 0;
> +}
> +
> +static void srp_qp_in_err_timer(unsigned long data)
> +{
> + =A0 =A0 =A0 struct srp_target_port *target =3D (struct srp_target_p=
ort *)data;
> + =A0 =A0 =A0 struct srp_request *req, *tmp;
> +
> + =A0 =A0 =A0 if (target->state !=3D SRP_TARGET_LIVE)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> +
> + =A0 =A0 =A0 spin_lock_irq(target->scsi_host->host_lock);
> + =A0 =A0 =A0 list_for_each_entry_safe(req, tmp, &target->req_queue, =
list)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 srp_reset_req(target, req);
> + =A0 =A0 =A0 spin_unlock_irq(target->scsi_host->host_lock);
> +
> + =A0 =A0 =A0 spin_lock_irq(target->scsi_host->host_lock);
> + =A0 =A0 =A0 if (!target->work_in_progress) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 target->work_in_progress =3D 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 INIT_WORK(&target->work, srp_reconnect_=
work);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 schedule_work(&target->work);
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 spin_unlock_irq(target->scsi_host->host_lock);
> +}
> +
> +static void srp_qp_err_add_timer(struct srp_target_port *target, int=
 time)
> +{
> + =A0 =A0 =A0 if (!timer_pending(&target->qp_err_timer)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 setup_timer(&target->qp_err_timer,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 srp_qp_in_err_t=
imer,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (unsigned long)=
target);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 target->qp_err_timer.expires =3D time *=
 HZ + jiffies;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 add_timer(&target->qp_err_timer);
> + =A0 =A0 =A0 }
> +}

What will happen when the ib_srp kernel module is removed after the
timer has been set up but before the timer has fired ? Isn't a call to
del_timer_sync() missing in srp_remove_work() ?

> +
> =A0static void srp_completion(struct ib_cq *cq, void *target_ptr)
> =A0{
> =A0 =A0 =A0 =A0struct srp_target_port *target =3D target_ptr;
> @@ -960,11 +980,20 @@
> =A0 =A0 =A0 =A0ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
> =A0 =A0 =A0 =A0while (ib_poll_cq(cq, 1, &wc) > 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (wc.status) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned long flags;
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0shost_printk(KERN_ERR,=
 target->scsi_host,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 PFX "failed %s status %d\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 wc.wr_id & SRP_OP_RECV ? "receive" :
> "send",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 wc.status);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 target->qp_in_error =3D=
 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock_irqsave(targe=
t->scsi_host->host_lock,
> flags);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!target->qp_in_erro=
r &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 target->state =3D=
=3D SRP_TARGET_LIVE) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 target-=
>qp_in_error =3D 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 srp_qp_=
err_add_timer(target,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0srp_dev_loss_tmo - 55);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irqrestore(=
target->scsi_host->host_lock,
> flags);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> @@ -1274,5 +1299,6 @@
> =A0 =A0 =A0 =A0int attr_mask =3D 0;
> =A0 =A0 =A0 =A0int comp =3D 0;
> =A0 =A0 =A0 =A0int opcode =3D 0;
> + =A0 =A0 =A0 unsigned long flags;
>
> =A0 =A0 =A0 =A0switch (event->event) {
> @@ -1301,6 +1381,14 @@
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0shost_printk(KERN_ERR, target->scsi_ho=
st,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 PFX "connecti=
on closed\n");
>
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock_irqsave(target->scsi_host->ho=
st_lock, flags);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!target->qp_in_error &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 target->state =3D=3D SRP_TARGET=
_LIVE) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 target->qp_in_error =3D=
 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 srp_qp_err_add_timer(ta=
rget,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0srp_dev_loss_tmo - 55);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irqrestore(target->scsi_hos=
t->host_lock, flags);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0target->status =3D 0;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
>
> @@ -1443,9 +1529,22 @@
> =A0static int srp_reset_host(struct scsi_cmnd *scmnd)
> =A0{
> =A0 =A0 =A0 =A0struct srp_target_port *target =3D host_to_target(scmn=
d->device->host);
> + =A0 =A0 =A0 struct srp_request *req, *tmp;
> =A0 =A0 =A0 =A0int ret =3D FAILED;
>
> - =A0 =A0 =A0 shost_printk(KERN_ERR, target->scsi_host, PFX "SRP rese=
t_host
> called\n");
> + =A0 =A0 =A0 shost_printk(KERN_ERR, target->scsi_host,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0PFX "SRP reset_host called s=
tate %d qp_err %d\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0target->state, target->qp_in=
_error);
> +
> + =A0 =A0 =A0 spin_lock_irq(target->scsi_host->host_lock);
> + =A0 =A0 =A0 if (timer_pending(&target->qp_err_timer) || target->qp_=
in_error ||
> + =A0 =A0 =A0 =A0 =A0 target->state !=3D SRP_TARGET_LIVE) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_for_each_entry_safe(req, tmp, &tar=
get->req_queue, list)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 srp_reset_req(target, r=
eq);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irq(target->scsi_host->host=
_lock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return SUCCESS;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 spin_unlock_irq(target->scsi_host->host_lock);
>
> =A0 =A0 =A0 =A0if (!srp_reconnect_target(target))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D SUCCESS;
> @@ -2150,6 +2342,9 @@
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sizeof (struct srp=
_indirect_buf) +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0srp_sg_tablesize *=
 16);
>
> + =A0 =A0 =A0 if (srp_dev_loss_tmo < 60)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 srp_dev_loss_tmo =3D 60;
> +
> =A0 =A0 =A0 =A0ret =3D class_register(&srp_class);
> =A0 =A0 =A0 =A0if (ret) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk(KERN_ERR PFX "couldn't register=
 class
> infiniband_srp\n");
> Index: ofed_kernel/drivers/infiniband/ulp/srp/ib_srp.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- ofed_kernel.orig/drivers/infiniband/ulp/srp/ib_srp.h
> +++ ofed_kernel/drivers/infiniband/ulp/srp/ib_srp.h
> @@ -153,12 +159,14 @@
> =A0 =A0 =A0 =A0struct srp_request =A0 =A0 =A0req_ring[SRP_SQ_SIZE];
>
> =A0 =A0 =A0 =A0struct work_struct =A0 =A0 =A0work;
> + =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 work_in_pro=
gress;
>
> =A0 =A0 =A0 =A0struct list_head =A0 =A0 =A0 =A0list;
> =A0 =A0 =A0 =A0struct completion =A0 =A0 =A0 done;
> =A0 =A0 =A0 =A0int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 status;
> =A0 =A0 =A0 =A0enum srp_target_state =A0 state;
> =A0 =A0 =A0 =A0int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 qp_in_erro=
r;
> + =A0 =A0 =A0 struct timer_list =A0 =A0 =A0 qp_err_timer;
> =A0};
>
> =A0struct srp_iu {
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
