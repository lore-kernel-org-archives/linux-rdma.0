From: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] RDMA/nes: IB_QPT_RAW_PACKET QP type support for nes
 driver
Date: Tue, 6 Jul 2010 11:43:15 +0100
Message-ID: <BE2BFE91933D1B4089447C64486040801EBB3C34@irsmsx503.ger.corp.intel.com>
References: <20100705135438.26042.55865.stgit@gkslx010.igk.intel.com>
 <4C32EE45.9030906@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C32EE45.9030906-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Cc: "rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org" <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Or, 

<Or>I still don't see what is the performance issue with the uverbs post_send/post_recv and if there is such why it can't be fixed, to avoid introducing lib/driver nes special char device. Could you explain it with some more details? You were mention the rdma-cm device file, but the uverbs cmd api is used by libibverbs / uverbs and not by librdmacm / rdma-ucm, which is anyway a slow path.

<Mirek> From my measuremnts it looks like the problem is related to memory allocation in the user-space and kernel path, that is a very, very expesive operation. Look for the tx path (rx is very similar).
Ibv_post_send()
	post_send_wrapper_1_0
		for (w = wr; w; w = w->next) {
                real_wr = alloca(sizeof *real_wr);  <- 1. dyn alloc 
                real_wr->wr_id = w->wr_id;
			  next the call to HW specific part
			and prepare message to send

        cmd  = alloca(cmd_size);  <- 2. dyn allocation

        IBV_INIT_CMD_RESP(cmd, cmd_size, POST_SEND, &resp, sizeof resp);	dive to kernel:
	ib_uverbs_post_send()
		user_wr = kmalloc(cmd.wqe_size, GFP_KERNEL); <- 3. dyn alloc
		next = kmalloc(ALIGN(sizeof *next, sizeof (struct ib_sge)) +
                               user_wr->num_sge * sizeof (struct ib_sge),
                               GFP_KERNEL); <- 4. dyn alloc 
				
 		And now there is finel call to driver. 

Adding the additional device makes possible diving to kernel without that memory allocations. 

<Or> Also, I understand that .read (.write) entry maps to posting a receive (send) buffer, what is the use case for .mmap entry

<Mirek> Not exactly. Diving to kernel is treated as a something like passing signal to kernel that there is prepared information to post_send/post_recv. The information about buffers are passed through shared page (available to userspace through mmap) to avoid copying of data. Write() ops is used to passing signal about post_send. Read() ops is used to pass information about post_recv(). We avoid additional copying of the data that way.


> @@ -2939,6 +3130,9 @@ int nes_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
>  			nesqp->hwqp.qp_id, attr->qp_state, nesqp->ibqp_state,
>  			nesqp->iwarp_state, atomic_read(&nesqp->refcount));
>  
> +	if (ibqp->qp_type == IB_QPT_RAW_PACKET)
> +		return 0;

<Or> isn't a raw qp associated with a specific port of the device?

<Mirek> In NES architecture the QP type and number defines a specific device or port. It is one to one mapping  

Regards,

Mirek

-----Original Message-----
From: Or Gerlitz [mailto:ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org] 
Sent: Tuesday, July 06, 2010 10:50 AM
To: Walukiewicz, Miroslaw
Cc: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org
Subject: Re: [PATCH] RDMA/nes: IB_QPT_RAW_PACKET QP type support for nes driver

miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> adds a IB_QPT_RAW_PACKET QP type implementation for nes driver 

> +++ b/drivers/infiniband/hw/nes/nes_ud.c
> +static const struct file_operations nes_ud_sksq_fops = {
> +	.owner = THIS_MODULE,
> +	.open = nes_ud_sksq_open,
> +	.release = nes_ud_sksq_close,
> +	.write = nes_ud_sksq_write,
> +	.read = nes_ud_sksq_read,
> +	.mmap = nes_ud_sksq_mmap,
> +};
> +
> +
> +static struct miscdevice nes_ud_sksq_misc = {
> +	.minor = MISC_DYNAMIC_MINOR,
> +	.name = "nes_ud_sksq",
> +	.fops = &nes_ud_sksq_fops,
> +};

Reading through the May 2010 "RDMA/nes: IB_QPT_RAW_PACKET QP type support for nes driver" email thread, e.g at the below links, you say


> The non-bypass post_send/recv channel (using /dev/infiniband/rdma_cm) is shared with
> all other user-kernel  communication and it is quite complex. It is a perfect path
> for QP/CQ/PD/mem management but for me it is too complex for traffic acceleration.
> The user<->kernel  path  through additional driver, shared page for lkey/vaddr/len
> passing and SW memory translation in kernel is much more effective.

http://marc.info/?l=linux-rdma&m=127299659017928
http://marc.info/?l=linux-rdma&m=127306694704653

I still don't see what is the performance issue with the uverbs post_send/post_recv and if there is such why it can't be fixed, to avoid introducing lib/driver nes special char device. Could you explain it with some more details? You were mention the rdma-cm device file, but the uverbs cmd api is used by libibverbs / uverbs and not by librdmacm / rdma-ucm, which is anyway a slow path.

Also, I understand that .read (.write) entry maps to posting a receive (send) buffer, what is the use case for .mmap entry

> --- a/drivers/infiniband/hw/nes/nes_verbs.c
> +++ b/drivers/infiniband/hw/nes/nes_verbs.c

> @@ -1139,7 +1141,6 @@ static struct ib_qp *nes_create_qp(struct ib_pd *ibpd,
[...]
> -	atomic_inc(&qps_created);
> @@ -1405,10 +1406,122 @@ static struct ib_qp *nes_create_qp(struct ib_pd *ibpd,
[...]
> +			/* moved here to be sure that QP is really created */
> +			/*(now it counted a number of QP creation trials */
> +			atomic_inc(&qps_created);

best if this change and couple more of its such will be placed in a clean-up patch to nes_verbs.c, such that the amount of RAW QP related changes to review is minimized.

> @@ -2939,6 +3130,9 @@ int nes_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
>  			nesqp->hwqp.qp_id, attr->qp_state, nesqp->ibqp_state,
>  			nesqp->iwarp_state, atomic_read(&nesqp->refcount));
>  
> +	if (ibqp->qp_type == IB_QPT_RAW_PACKET)
> +		return 0;

isn't a raw qp associated with a specific port of the device?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
