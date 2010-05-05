From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 4/4] mlx4: implement XRC RCV qp's
Date: Wed, 5 May 2010 14:44:28 +0300
Message-ID: <201005051444.28556.jackm@dev.mellanox.co.il>
References: <201002281102.55944.jackm@dev.mellanox.co.il> <adar5lyxc01.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adar5lyxc01.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thursday 29 April 2010 23:03, Roland Dreier wrote:
>  > @@ -175,7 +175,7 @@ struct ib_cq *mlx4_ib_create_cq(struct ib_device *ibdev, int entries, int vector
>  >  	if (entries < 1 || entries > dev->dev->caps.max_cqes)
>  >  		return ERR_PTR(-EINVAL);
>  >  
>  > -	cq = kmalloc(sizeof *cq, GFP_KERNEL);
>  > +	cq = kzalloc(sizeof *cq, GFP_KERNEL);
> 
> What's the reason for this change?

Because mlx4_ib_create_cq is used in mlx4_ib_alloc_xrcd (to allocate the dummy cq), and I did not
want to worry about unitialized data being present in the struct ib_cq portion of struct mlx4_ib_cq.

>  > @@ -477,23 +483,51 @@ static struct ib_xrcd *mlx4_ib_alloc_xrcd(struct ib_device *ibdev,
>  > +	pd = mlx4_ib_alloc_pd(ibdev, NULL, NULL);
>  > +	cq = mlx4_ib_create_cq(ibdev, 1, 0, NULL, NULL);
> 
> Why does every xrcd get a PD and a CQ now?  Just in case someone wants
> to create a rcv QP?
 
Yes.  This way, we have a dummy PD and CQ available to satisfy the ConnectX requirement
that every QP have a PD and CQ.
  
> (The spec is unclear on this -- for "create XRC 
> target QP" it says "A set of initial QP attributes must be specified by
> the Consumer," but then doesn't mention anything in the input modifiers,
> so it's not clear what PD/CQ is supposed to be used)

>From the XRC Annex to the IB Spec:

A12.5.2.3 XRC TARGET QP
A12.5.2.3.1 CREATE XRC TARGET QP
Description:
Creates a XRC Target QP for the specified HCA.
A set of initial QP attributes must be specified by the Consumer.
On success, a handle to the newly created XRC QP and the XRC QP 
number are returned.
Input Modifiers:
 Same as RC QP except for:
==>   no SQ or RQ or SRQ (WQEs, num of s/g elements, CQs, signaling type, etc.)
      no need for initiator resources (initiator depth)
==>   no PD
      add XRC domain to be associated with this QP. 

>  > +			(1ull << IB_USER_VERBS_CMD_DESTROY_XRC_RCV_QP);
>  >  	}
>  >  
>  > -
> 
> This seems to be repairing whitespace damage from the previous patch.

I will fix both patches.
 
>  > +int mlx4_ib_reg_xrc_rcv_qp(struct ib_xrcd *xrcd, void *context, u32 qp_num)
> 
>  > +	mutex_lock(&mibqp->mutex);
>  > +	list_for_each_entry(tmp, &mibqp->xrc_reg_list, list)
>  > +		if (tmp->context == context) {
>  > +			mutex_unlock(&mibqp->mutex);
>  > +			kfree(ctx_entry);
>  > +			mutex_unlock(&to_mdev(xrcd->device)->xrc_reg_mutex);
>  > +			return 0;
>  > +		}
>  > +
>  > +	ctx_entry->context = context;
>  > +	list_add_tail(&ctx_entry->list, &mibqp->xrc_reg_list);
>  > +	mutex_unlock(&mibqp->mutex);
> 
> This list handling looks completely generic and is what I was saying
> should probably be in the core uverbs module.
This list is used to send async events for this xrc rcv QP to all processes using
the QP (either registered for the qp, or the creating process).

Moving this to the core layer would require significant modifications.  I responded to
this in my response to your first mail.

>  > +int mlx4_ib_query_xrc_rcv_qp(struct ib_xrcd *ibxrcd, u32 qp_num,
>  > +			     struct ib_qp_attr *qp_attr, int qp_attr_mask,
>  > +			     struct ib_qp_init_attr *qp_init_attr)
> 
> Virtually all of this function seems identical to the existing query QP
> operation.  We should avoid the mass duplication of code.
> 
> Also I'm not clear why this function takes a qp_num instead of a QP
> handle.  Why does the consumer have to pass in the XRCD?  The IB spec
> XRC annex just shows the QP handle as input to this verb.  Is it because
> the reg_xrc_rcv_qp doesn't give a QP handle back?

Yes, I considered the handle to be the pair (xrc domain, qp_number).

> 
> Finally, in this implementation, what happens if the consumer passes in
> a QP that isn't an XRC rcv QP?
> 
>  > +	mqp = __mlx4_qp_lookup(dev->dev, qp_num);
>  > +	if (unlikely(!mqp)) {
>  > +		printk(KERN_WARNING "mlx4_ib_reg_xrc_rcv_qp: "
>  > +		       "unknown QPN %06x\n", qp_num);
>  > +		goto err_out;
>  > +	}
>  > +
>  > +	qp = to_mibqp(mqp);
>  > +	if (xrcd->xrcdn != to_mxrcd(qp->ibqp.xrcd)->xrcdn)
>  > +		goto err_out;
> 
> In other words is that dereference of ->xrcdn safe if ibqp.xrcd is not set?
> (And the error message talks about reg_xrc_rcv_qp instead of query)
You are correct -- I will fix both of these (error msg and unprotected dereference).

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
