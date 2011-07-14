From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Questions regarding CMA
Date: Thu, 14 Jul 2011 17:46:30 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237302E14C@ORSMSX101.amr.corp.intel.com>
References: <201107141058.29879.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201107141058.29879.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 1. In procedure cma_ib_listen (and elsewhere), if the call to ib_create_cm_id
> fails,
>    id_priv->cm_id.ib is left with the (non-zero) error value instead of NULL.
>    However, if there is a failure later in the procedure, you set id_priv-
> >cm_id.ib to NULL.
> 
>    Is there a reason for this difference in behavior?
>    (code snippet from current code is below)
> 	int cma_ib_listen(struct rdma_id_
> 
>        		id_priv->cm_id.ib = ib_create_cm_id(id_priv->id.device,
> cma_req_handler,
>                                             	    id_priv);
> 	       	if (IS_ERR(id_priv->cm_id.ib))
>                		return PTR_ERR(id_priv->cm_id.ib);

This looks like a bug.
 
> 
> 		....
> 	        if (ret) {
>                 	ib_destroy_cm_id(id_priv->cm_id.ib);
>                 	id_priv->cm_id.ib = NULL;
>         	}
> 
> 
> 2. procedure cma_has_cm_dev looks as follows:
> 
> 	static int cma_has_cm_dev(struct rdma_id_private *id_priv)
> 	{
> 		return (id_priv->id.device && id_priv->cm_id.ib);
> 	}
> 
>    Shouldn't the line be:
> 		return (id_priv->id.device && id_priv->cm_id.ib &&
> 			!IS_ERR(id_priv->cm_id.ib));

Given the current code, adding IS_ERR makes sense, but see below.  Thinking about this, we shouldn't need to check id_priv->id.device.  If we have id_priv->cm_id.ib, then the device pointer must be valid.

(fyi: cma_has_cm_dev() was added by commit 6c719f5c6c823901fac2d46b83db5a69ba7e9152.  It replaced a state check with the above device check to handle device removal.)

> 3. There are several places where the value of id_priv->cm_id.ib
>    is checked to be not NULL.
> 
>    Wouldn't it be better to call cma_has_cm_dev in these places
>    (when cma_has_cm_dev has been fixed, as I suggested in 2 above).

Although it's a minor performance gain, I'm leaning towards keeping id_priv->cm_id.ib = NULL on failure, either by resetting it or using a local variable.  cma_has_cm_dev() can then be replaced by checking id_priv->cm_id.ib for non-NULL, and checks for IS_ERR(id_priv->cm_id.ib) are removed.

> Please consider the patch below as a starting point (I did not touch the iwarp
> code).
> Please let me know (ASAP) what you think.
> (I still leave a window here where id_priv->cm_id.ib is ERR. Is this a
> problem?
>  Would it be better to use a local variable instead of id_priv->cm_id.ib, and
>  only assign to id_priv->cm_id.ib when all the error checks have passed?
>  This would leave a window where a successful cm_id creation is not
> immediately assigned
>  to the CMA object -- would this be a problem?).

Without adding more synchronization, we need to ensure that id_priv->cm_id.ib is set before a user can receive any callbacks.  This restricts our use of a local variable to the create_cm_id calls only.  See cma_connect_iw() for an example of using this approach.

Thanks,
- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
