From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] RDMA/nes: IB_QPT_RAW_PACKET QP type support for nes driver
Date: Tue, 06 Jul 2010 11:50:13 +0300
Message-ID: <4C32EE45.9030906@Voltaire.com>
References: <20100705135438.26042.55865.stgit@gkslx010.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100705135438.26042.55865.stgit-dAdtdUp2yJRU7keBU/FxOFDQ4js95KgL@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

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
