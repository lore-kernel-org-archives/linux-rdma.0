From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 2/4] ib_core: implement XRC RCV qp's
Date: Wed, 5 May 2010 08:36:28 +0300
Message-ID: <201005050836.28660.jackm@dev.mellanox.co.il>
References: <201002281102.21207.jackm@dev.mellanox.co.il> <adaljcfmkj9.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaljcfmkj9.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thursday 22 April 2010 21:03, Roland Dreier wrote:
> So I'm looking at merging this, and I'm wondering about one thing.
> Seems like it's just a mistake but I want to make sure I understand
> properly:
> 
>  > @@ -1078,6 +1079,7 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
>  >  		goto err_put;
>  >  	}
>  >  
>  > +	attr.create_flags  = 0;
>  >  	attr.event_handler = ib_uverbs_qp_event_handler;
> 
> This looks redundant, because this function already sets create_flags to
> 0 a few lines later.  So I think this line is just a remnant from some
> other patch.
You're correct.

> 
> But then ib_uverbs_create_xrc_rcv_qp() doesn't set create_flags before
> the call to device->create_xrc_rcv_qp() -- which maybe is OK, since that
> function is not going to look at create_flags right now, but for the
> future we should probably set it to 0, right?
Can't hurt.

> Also it's not 100% clear to me why the low-level driver needs a special
> create_xrc_rcv_qp method, rather than having uverbs just call create_qp
> with the right parameters.
I did not want to have the verbs layer dictate implementation details to the
low-level driver.  It is more correct, in my opinion, to have each low-level
driver decide for itself on implementation.  Therefore, the separate method.
However, please note that I re-use the qp_create_common() method in
mlx4_ib_create_xrc_rcv_qp.

> But I haven't looked throught carefully to 
> see the differences between eg query_xrc_rcv_qp() vs query_qp() methods.
> 
Same comment.
>  - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
