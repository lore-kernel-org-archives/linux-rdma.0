Return-Path: <SRS0=fQuC=EH=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69D43C4741F
	for <linux-rdma@archiver.kernel.org>; Sun,  1 Nov 2020 19:50:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 319BF22253
	for <linux-rdma@archiver.kernel.org>; Sun,  1 Nov 2020 19:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604260255;
	bh=ggvoVwwLIzKiSDItohf4zJ0R+fBUJRlqriGIhjydae8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=GI0Nxb5Hs589iCMbKUsYWQN4UZGSHzODxsFSGCY6SaDB1rMRD1kOA09XefpJ2uVzA
	 TJ4xR9/ghpnpEYycqCT5mBSjRdvrOZTQWWSYveZJtOidd5rRhenP1Ba8w0dxVAF8B9
	 30DhlbxwEuHvDOW0Oqzm76RRchD3pmivztmgL4+4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbgKATuy (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 1 Nov 2020 14:50:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:52320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726790AbgKATuy (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 1 Nov 2020 14:50:54 -0500
Received: from localhost (host-213-179-129-39.customer.m-online.net [213.179.129.39])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90327208B6;
        Sun,  1 Nov 2020 19:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604260253;
        bh=ggvoVwwLIzKiSDItohf4zJ0R+fBUJRlqriGIhjydae8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qEYxzv1vwTB402op7PJL2cPdmf5feB2evrGSKOTRqrmiKqQhtkoEfMrwaVKQen0PY
         w4+YCdzaeNIIaaUnNAznWhNTzjCDrznPSPPabGqBARLvXcBwi/Lg+xmoJyP3v6wTe8
         2Lsao4TpzJYcr+TtZMPFZYWxuynJjjl6E84jcSzs=
Date:   Sun, 1 Nov 2020 21:50:49 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH rdma-rc 1/3] RDMA/core: Postpone uobject cleanup on
 failure till FD close
Message-ID: <20201101195049.GC5429@unreal>
References: <20201012045600.418271-1-leon@kernel.org>
 <20201012045600.418271-2-leon@kernel.org>
 <20201027165508.GA2267703@nvidia.com>
 <20201027171122.GP1523783@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027171122.GP1523783@nvidia.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Oct 27, 2020 at 02:11:22PM -0300, Jason Gunthorpe wrote:
> On Tue, Oct 27, 2020 at 01:55:08PM -0300, Jason Gunthorpe wrote:
>
> > diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
> > index 3d366cb79cef42..3ae878f3d173d3 100644
> > +++ b/drivers/infiniband/core/rdma_core.c
> > @@ -540,6 +540,9 @@ static int __must_check destroy_hw_idr_uobject(struct ib_uobject *uobj,
> >  	if (ret)
> >  		return ret;
> >
> > +	if (why == RDMA_REMOVE_ABORT)
> > +		return 0;
> > +
> >  	ib_rdmacg_uncharge(&uobj->cg_obj, uobj->context->device,
> >  			   RDMACG_RESOURCE_HCA_OBJECT);
> >
> > @@ -727,10 +730,8 @@ void release_ufile_idr_uobject(struct ib_uverbs_file *ufile)
> >  	 *
> >  	 * This is an optimized equivalent to remove_handle_idr_uobject
> >  	 */
> > -	xa_for_each(&ufile->idr, id, entry) {
> > -		WARN_ON(entry->object);
> > +	xa_for_each(&ufile->idr, id, entry)
> >  		uverbs_uobject_put(entry);
> > -	}
>
> Actually this is not a good idea
>
> This one is better:

This causes to many syzkaller bugs, I didn't debug yet.

Thanks

>
> diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
> index 3d366cb79cef42..fd012be700ccc2 100644
> --- a/drivers/infiniband/core/rdma_core.c
> +++ b/drivers/infiniband/core/rdma_core.c
> @@ -540,6 +540,9 @@ static int __must_check destroy_hw_idr_uobject(struct ib_uobject *uobj,
>  	if (ret)
>  		return ret;
>
> +	if (why == RDMA_REMOVE_ABORT)
> +		return 0;
> +
>  	ib_rdmacg_uncharge(&uobj->cg_obj, uobj->context->device,
>  			   RDMACG_RESOURCE_HCA_OBJECT);
>
> @@ -845,11 +848,17 @@ static int __uverbs_cleanup_ufile(struct ib_uverbs_file *ufile,
>  		 * racing with a lookup_get.
>  		 */
>  		WARN_ON(uverbs_try_lock_object(obj, UVERBS_LOOKUP_WRITE));
> +		if (reason == RDMA_REMOVE_DRIVER_FAILURE)
> +			obj->object = NULL;
>  		if (!uverbs_destroy_uobject(obj, reason, &attrs))
>  			ret = 0;
>  		else
>  			atomic_set(&obj->usecnt, 0);
>  	}
> +	if (reason == RDMA_REMOVE_DRIVER_FAILURE) {
> +		WARN_ON(!list_empty(&ufile->uobjects));
> +		return 0;
> +	}
>  	return ret;
>  }
>
> @@ -862,9 +871,6 @@ static int __uverbs_cleanup_ufile(struct ib_uverbs_file *ufile,
>  void uverbs_destroy_ufile_hw(struct ib_uverbs_file *ufile,
>  			     enum rdma_remove_reason reason)
>  {
> -	struct ib_uobject *obj, *next_obj;
> -	unsigned long flags;
> -
>  	down_write(&ufile->hw_destroy_rwsem);
>
>  	/*
> @@ -875,25 +881,10 @@ void uverbs_destroy_ufile_hw(struct ib_uverbs_file *ufile,
>  		goto done;
>
>  	while (!list_empty(&ufile->uobjects))
> -		if (__uverbs_cleanup_ufile(ufile, reason)) {
> -			/*
> -			 * No entry was cleaned-up successfully during this
> -			 * iteration. It is a driver bug to fail destruction.
> -			 */
> -			WARN_ON(!list_empty(&ufile->uobjects));
> +		if (__uverbs_cleanup_ufile(ufile, reason))
>  			break;
> -		}
> -
> -	list_for_each_entry_safe (obj, next_obj, &ufile->uobjects, list) {
> -		spin_lock_irqsave(&ufile->uobjects_lock, flags);
> -		list_del_init(&obj->list);
> -		spin_unlock_irqrestore(&ufile->uobjects_lock, flags);
> -		/*
> -		 * Pairs with the get in rdma_alloc_commit_uobject(), could
> -		 * destroy uobj.
> -		 */
> -		uverbs_uobject_put(obj);
> -	}
> +	if (WARN_ON(!list_empty(&ufile->uobjects)))
> +		__uverbs_cleanup_ufile(ufile, RDMA_REMOVE_DRIVER_FAILURE);
>  	ufile_destroy_ucontext(ufile, reason);
>
>  done:
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index edfc1d7d3766ca..7e330f4a6d33ff 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -1471,6 +1471,8 @@ enum rdma_remove_reason {
>  	RDMA_REMOVE_DRIVER_REMOVE,
>  	/* uobj is being cleaned-up before being committed */
>  	RDMA_REMOVE_ABORT,
> +	/* The driver failed to destroy the uobject and is being disconnected */
> +	RDMA_REMOVE_DRIVER_FAILURE,
>  };
>
>  struct ib_rdmacg_object {
