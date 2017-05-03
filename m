From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 15/15] IB/hfi1: Clean up on context initialization failure
Date: Wed, 3 May 2017 10:35:48 +0300
Message-ID: <20170503073548.GC22833@mtr-leonro.local>
References: <20170503003734.6965.67405.stgit@scvm10.sc.intel.com>
 <20170503004229.6965.97776.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6zdv2QT/q3FMhpsV"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170503004229.6965.97776.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--6zdv2QT/q3FMhpsV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 02, 2017 at 05:42:30PM -0700, Dennis Dalessandro wrote:
> From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> The error path for context initialization is not consistent. Cleanup all
> resources on failure.
>
> Removed unused variable user_event_mask.
>
> Add the _BASE_FAILED bit to the event flags so that a base context can
> notify waiting sub contexts that they cannot continue.
>
> Running out of sub contexts is an EBUSY result, not EINVAL.
>
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/hfi1/file_ops.c     |  114 +++++++++++------------------
>  drivers/infiniband/hw/hfi1/hfi.h          |   16 ++--
>  drivers/infiniband/hw/hfi1/init.c         |   10 +--
>  drivers/infiniband/hw/hfi1/user_exp_rcv.c |   28 ++++---
>  drivers/infiniband/hw/hfi1/user_sdma.c    |   60 +++++++--------
>  drivers/infiniband/hw/hfi1/vnic_main.c    |    8 +-
>  6 files changed, 103 insertions(+), 133 deletions(-)
>
> diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
> index 84e6342..0ea842d 100644
> --- a/drivers/infiniband/hw/hfi1/file_ops.c
> +++ b/drivers/infiniband/hw/hfi1/file_ops.c
> @@ -82,7 +82,7 @@
>  static int init_subctxts(struct hfi1_ctxtdata *uctxt,
>  			 const struct hfi1_user_info *uinfo);
>  static int init_user_ctxt(struct hfi1_filedata *fd);
> -static int user_init(struct hfi1_ctxtdata *uctxt);
> +static void user_init(struct hfi1_ctxtdata *uctxt);
>  static int get_ctxt_info(struct hfi1_filedata *fd, void __user *ubase,
>  			 __u32 len);
>  static int get_base_info(struct hfi1_filedata *fd, void __user *ubase,
> @@ -847,7 +847,7 @@ static u64 kvirt_to_phys(void *addr)
>
>  static int assign_ctxt(struct hfi1_filedata *fd, struct hfi1_user_info *uinfo)
>  {
> -	int ret = 0;
> +	int ret;
>  	unsigned int swmajor, swminor;
>
>  	swmajor = uinfo->userversion >> 16;
> @@ -857,14 +857,16 @@ static int assign_ctxt(struct hfi1_filedata *fd, struct hfi1_user_info *uinfo)
>  	swminor = uinfo->userversion & 0xffff;
>
>  	mutex_lock(&hfi1_mutex);
> -	/* First, lets check if we need to get a sub context? */
> +	/*
> +	 * Get a sub context if necessary.
> +	 * ret < 0 error, 0 no context, 1 sub-context found
> +	 */
> +	ret = 0;
>  	if (uinfo->subctxt_cnt) {
> -		/* < 0 error, 0 no context, 1 sub-context found */
>  		ret = find_sub_ctxt(fd, uinfo);
> -		if (ret > 0) {
> +		if (ret > 0)
>  			fd->rec_cpu_num =
>  				hfi1_get_proc_affinity(fd->uctxt->numa_id);
> -		}
>  	}
>
>  	/*
> @@ -885,17 +887,27 @@ static int assign_ctxt(struct hfi1_filedata *fd, struct hfi1_user_info *uinfo)
>  		ret = wait_event_interruptible(fd->uctxt->wait, !test_bit(
>  					       HFI1_CTXT_BASE_UNINIT,
>  					       &fd->uctxt->event_flags));
> +		if (test_bit(HFI1_CTXT_BASE_FAILED, &fd->uctxt->event_flags)) {
> +			clear_bit(fd->subctxt, fd->uctxt->in_use_ctxts);
> +			return -ENOMEM;
> +		}
>  		/* The only thing a sub context needs is the user_xxx stuff */
>  		if (!ret)
> -			init_user_ctxt(fd);
> +			ret = init_user_ctxt(fd);
> +
> +		if (ret)
> +			clear_bit(fd->subctxt, fd->uctxt->in_use_ctxts);
>  	} else if (!ret) {
>  		ret = setup_base_ctxt(fd);
> -
> -		/*
> -		 * Base context is done, notify anybody using a sub-context
> -		 * that is waiting for this completion
> -		 */
> -		if (!ret && fd->uctxt->subctxt_cnt) {
> +		if (fd->uctxt->subctxt_cnt) {
> +			/* If there is an error, set the failed bit. */
> +			if (ret)
> +				set_bit(HFI1_CTXT_BASE_FAILED,
> +					&fd->uctxt->event_flags);
> +			/*
> +			 * Base context is done, notify anybody using a
> +			 * sub-context that is waiting for this completion
> +			 */
>  			clear_bit(HFI1_CTXT_BASE_UNINIT,
>  				  &fd->uctxt->event_flags);
>  			wake_up(&fd->uctxt->wait);
> @@ -916,7 +928,7 @@ static int find_sub_ctxt(struct hfi1_filedata *fd,
>  	struct hfi1_devdata *dd = fd->dd;
>  	u16 subctxt;
>
> -	for (i = dd->first_user_ctxt; i < dd->num_rcv_contexts; i++) {
> +	for (i = dd->first_dyn_alloc_ctxt; i < dd->num_rcv_contexts; i++) {
>  		struct hfi1_ctxtdata *uctxt = dd->rcd[i];
>
>  		/* Skip ctxts which are not yet open */
> @@ -925,6 +937,10 @@ static int find_sub_ctxt(struct hfi1_filedata *fd,
>  				 HFI1_MAX_SHARED_CTXTS))
>  			continue;
>
> +		/* Skip dynamically allocated kernel contexts */
> +		if (uctxt->sc && (uctxt->sc->type == SC_KERNEL))
> +			continue;
> +
>  		/* Skip ctxt if it doesn't match the requested one */
>  		if (memcmp(uctxt->uuid, uinfo->uuid,
>  			   sizeof(uctxt->uuid)) ||
> @@ -932,55 +948,17 @@ static int find_sub_ctxt(struct hfi1_filedata *fd,
>  		    uctxt->subctxt_id != uinfo->subctxt_id ||
>  		    uctxt->subctxt_cnt != uinfo->subctxt_cnt)
>  			continue;
> -<<<<<<< HEAD
> -		for (i = dd->first_dyn_alloc_ctxt;
> -		     i < dd->num_rcv_contexts; i++) {
> -			struct hfi1_ctxtdata *uctxt = dd->rcd[i];
> -
> -			/* Skip ctxts which are not yet open */
> -			if (!uctxt || !uctxt->cnt)
> -				continue;
> -
> -			/* Skip dynamically allocted kernel contexts */
> -			if (uctxt->sc && (uctxt->sc->type == SC_KERNEL))
> -				continue;
> -
> -			/* Skip ctxt if it doesn't match the requested one */
> -			if (memcmp(uctxt->uuid, uinfo->uuid,
> -				   sizeof(uctxt->uuid)) ||
> -			    uctxt->jkey != generate_jkey(current_uid()) ||
> -			    uctxt->subctxt_id != uinfo->subctxt_id ||
> -			    uctxt->subctxt_cnt != uinfo->subctxt_cnt)
> -				continue;
> -
> -			/* Verify the sharing process matches the master */
> -			if (uctxt->userversion != uinfo->userversion ||
> -			    uctxt->cnt >= uctxt->subctxt_cnt) {
> -				ret = -EINVAL;
> -				goto done;
> -			}
> -			fd->uctxt = uctxt;
> -			fd->subctxt  = uctxt->cnt++;
> -			uctxt->active_slaves |= 1 << fd->subctxt;
> -			ret = 1;
> -			goto done;
> -=======
>
>  		/* Verify the sharing process matches the master */
>  		if (uctxt->userversion != uinfo->userversion)
>  			return -EINVAL;
> -<<<<<<< HEAD
> ->>>>>>> f1f8a68... IB/hfi1: Search shared contexts on the opened device, not all devices
> -		}
> -=======
>
>  		/* Find an unused context */
>  		subctxt = find_first_zero_bit(uctxt->in_use_ctxts,
>  					      HFI1_MAX_SHARED_CTXTS);
>  		if (subctxt >= uctxt->subctxt_cnt)
> -			return -EINVAL;
> +			return -EBUSY;
>
> ->>>>>>> d409d3d... IB/hfi1: Fix an assign/ordering issue with shared context IDs

Denny,

You forgot to fix the rebase conflict :)


>  		fd->uctxt = uctxt;
>  		fd->subctxt = subctxt;
>  		__set_bit(fd->subctxt, uctxt->in_use_ctxts);
> @@ -1009,10 +987,6 @@ static int allocate_ctxt(struct hfi1_filedata *fd, struct hfi1_devdata *dd,
>  		return -EIO;
>  	}
>
> -<<<<<<< HEAD
> -	for (ctxt = dd->first_dyn_alloc_ctxt;
> -	     ctxt < dd->num_rcv_contexts; ctxt++)
> -=======
>  	/*
>  	 * This check is sort of redundant to the next EBUSY error. It would
>  	 * also indicate an inconsistancy in the driver if this value was
> @@ -1021,8 +995,8 @@ static int allocate_ctxt(struct hfi1_filedata *fd, struct hfi1_devdata *dd,
>  	if (!dd->freectxts)
>  		return -EBUSY;
>
> -	for (ctxt = dd->first_user_ctxt; ctxt < dd->num_rcv_contexts; ctxt++)
> ->>>>>>> f1f8a68... IB/hfi1: Search shared contexts on the opened device, not all devices
> +	for (ctxt = dd->first_dyn_alloc_ctxt;
> +	     ctxt < dd->num_rcv_contexts; ctxt++)
>  		if (!dd->rcd[ctxt])
>  			break;
>
> @@ -1156,7 +1130,7 @@ static int setup_subctxt(struct hfi1_ctxtdata *uctxt)
>  	return ret;
>  }
>
> -static int user_init(struct hfi1_ctxtdata *uctxt)
> +static void user_init(struct hfi1_ctxtdata *uctxt)
>  {
>  	unsigned int rcvctrl_ops = 0;
>
> @@ -1206,8 +1180,6 @@ static int user_init(struct hfi1_ctxtdata *uctxt)
>  	else
>  		rcvctrl_ops |= HFI1_RCVCTRL_TAILUPD_DIS;
>  	hfi1_rcvctrl(uctxt->dd, rcvctrl_ops, uctxt->ctxt);
> -
> -	return 0;
>  }
>
>  static int get_ctxt_info(struct hfi1_filedata *fd, void __user *ubase,
> @@ -1276,28 +1248,32 @@ static int setup_base_ctxt(struct hfi1_filedata *fd)
>  	/* Now allocate the RcvHdr queue and eager buffers. */
>  	ret = hfi1_create_rcvhdrq(dd, uctxt);
>  	if (ret)
> -		goto done;
> +		return ret;
>
>  	ret = hfi1_setup_eagerbufs(uctxt);
>  	if (ret)
> -		goto done;
> +		goto setup_failed;
>
>  	/* If sub-contexts are enabled, do the appropriate setup */
>  	if (uctxt->subctxt_cnt)
>  		ret = setup_subctxt(uctxt);
>  	if (ret)
> -		goto done;
> +		goto setup_failed;
>
>  	ret = hfi1_user_exp_rcv_grp_init(fd);
>  	if (ret)
> -		goto done;
> +		goto setup_failed;
>
>  	ret = init_user_ctxt(fd);
>  	if (ret)
> -		goto done;
> +		goto setup_failed;
>
> -	ret = user_init(uctxt);
> -done:
> +	user_init(uctxt);
> +
> +	return 0;
> +
> +setup_failed:
> +	hfi1_free_ctxtdata(dd, uctxt);
>  	return ret;
>  }
>
> diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
> index f3d75fc..509df98 100644
> --- a/drivers/infiniband/hw/hfi1/hfi.h
> +++ b/drivers/infiniband/hw/hfi1/hfi.h
> @@ -196,12 +196,6 @@ struct hfi1_ctxtdata {
>  	void *rcvhdrq;
>  	/* kernel virtual address where hdrqtail is updated */
>  	volatile __le64 *rcvhdrtail_kvaddr;
> -	/*
> -	 * Shared page for kernel to signal user processes that send buffers
> -	 * need disarming.  The process should call HFI1_CMD_DISARM_BUFS
> -	 * or HFI1_CMD_ACK_EVENT with IPATH_EVENT_DISARM_BUFS set.
> -	 */
> -	unsigned long *user_event_mask;
>  	/* when waiting for rcv or pioavail */
>  	wait_queue_head_t wait;
>  	/* rcvhdrq size (for freeing) */
> @@ -1724,12 +1718,14 @@ struct cc_state *get_cc_state_protected(struct hfi1_pportdata *ppd)
>  #define HFI1_PBC_LENGTH_MASK                     ((1 << 11) - 1)
>
>  /* ctxt_flag bit offsets */
> +		/* base context has not finished initializing */
> +#define HFI1_CTXT_BASE_UNINIT 1
> +		/* base context initaliation failed */
> +#define HFI1_CTXT_BASE_FAILED 2
>  		/* waiting for a packet to arrive */
> -#define HFI1_CTXT_WAITING_RCV   2
> -		/* master has not finished initializing */
> -#define HFI1_CTXT_BASE_UNINIT 4
> +#define HFI1_CTXT_WAITING_RCV 3
>  		/* waiting for an urgent packet to arrive */
> -#define HFI1_CTXT_WAITING_URG 5
> +#define HFI1_CTXT_WAITING_URG 4
>
>  /* free up any allocated data at closes */
>  struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
> diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
> index 694a8ec..4a11d4d 100644
> --- a/drivers/infiniband/hw/hfi1/init.c
> +++ b/drivers/infiniband/hw/hfi1/init.c
> @@ -964,7 +964,6 @@ void hfi1_free_ctxtdata(struct hfi1_devdata *dd, struct hfi1_ctxtdata *rcd)
>  	kfree(rcd->egrbufs.buffers);
>
>  	sc_free(rcd->sc);
> -	vfree(rcd->user_event_mask);
>  	vfree(rcd->subctxt_uregbase);
>  	vfree(rcd->subctxt_rcvegrbuf);
>  	vfree(rcd->subctxt_rcvhdr_base);
> @@ -1683,8 +1682,6 @@ int hfi1_create_rcvhdrq(struct hfi1_devdata *dd, struct hfi1_ctxtdata *rcd)
>  	dd_dev_err(dd,
>  		   "attempt to allocate 1 page for ctxt %u rcvhdrqtailaddr failed\n",
>  		   rcd->ctxt);
> -	vfree(rcd->user_event_mask);
> -	rcd->user_event_mask = NULL;
>  	dma_free_coherent(&dd->pcidev->dev, amt, rcd->rcvhdrq,
>  			  rcd->rcvhdrq_dma);
>  	rcd->rcvhdrq = NULL;
> @@ -1851,7 +1848,7 @@ int hfi1_setup_eagerbufs(struct hfi1_ctxtdata *rcd)
>  			  "ctxt%u: current Eager buffer size is invalid %u\n",
>  			  rcd->ctxt, rcd->egrbufs.rcvtid_size);
>  		ret = -EINVAL;
> -		goto bail;
> +		goto bail_rcvegrbuf_phys;
>  	}
>
>  	for (idx = 0; idx < rcd->egrbufs.alloced; idx++) {
> @@ -1859,7 +1856,8 @@ int hfi1_setup_eagerbufs(struct hfi1_ctxtdata *rcd)
>  			     rcd->egrbufs.rcvtids[idx].dma, order);
>  		cond_resched();
>  	}
> -	goto bail;
> +
> +	return 0;
>
>  bail_rcvegrbuf_phys:
>  	for (idx = 0; idx < rcd->egrbufs.alloced &&
> @@ -1873,6 +1871,6 @@ int hfi1_setup_eagerbufs(struct hfi1_ctxtdata *rcd)
>  		rcd->egrbufs.buffers[idx].dma = 0;
>  		rcd->egrbufs.buffers[idx].len = 0;
>  	}
> -bail:
> +
>  	return ret;
>  }
> diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
> index bfaf159..0462d9d 100644
> --- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
> +++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
> @@ -160,6 +160,7 @@ int hfi1_user_exp_rcv_grp_init(struct hfi1_filedata *fd)
>  	struct hfi1_devdata *dd = fd->dd;
>  	u32 tidbase;
>  	u32 i;
> +	struct tid_group *grp, *gptr;
>
>  	exp_tid_group_init(&uctxt->tid_group_list);
>  	exp_tid_group_init(&uctxt->tid_used_list);
> @@ -168,17 +169,10 @@ int hfi1_user_exp_rcv_grp_init(struct hfi1_filedata *fd)
>  	tidbase = uctxt->expected_base;
>  	for (i = 0; i < uctxt->expected_count /
>  		     dd->rcv_entries.group_size; i++) {
> -		struct tid_group *grp;
> -
>  		grp = kzalloc(sizeof(*grp), GFP_KERNEL);
> -		if (!grp) {
> -			/*
> -			 * If we fail here, the groups already
> -			 * allocated will be freed by the close
> -			 * call.
> -			 */
> -			return -ENOMEM;
> -		}
> +		if (!grp)
> +			goto grp_failed;
> +
>  		grp->size = dd->rcv_entries.group_size;
>  		grp->base = tidbase;
>  		tid_group_add_tail(grp, &uctxt->tid_group_list);
> @@ -186,6 +180,15 @@ int hfi1_user_exp_rcv_grp_init(struct hfi1_filedata *fd)
>  	}
>
>  	return 0;
> +
> +grp_failed:
> +	list_for_each_entry_safe(grp, gptr, &uctxt->tid_group_list.list,
> +				 list) {
> +		list_del_init(&grp->list);
> +		kfree(grp);
> +	}
> +
> +	return -ENOMEM;
>  }
>
>  /*
> @@ -213,8 +216,11 @@ int hfi1_user_exp_rcv_init(struct hfi1_filedata *fd)
>  		fd->invalid_tids = kcalloc(uctxt->expected_count,
>  					   sizeof(u32),
>  					   GFP_KERNEL);
> -		if (!fd->invalid_tids)
> +		if (!fd->invalid_tids) {
> +			kfree(fd->entry_to_rb);
> +			fd->entry_to_rb = NULL;
>  			return -ENOMEM;
> +		}
>
>  		/*
>  		 * Register MMU notifier callbacks. If the registration
> diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
> index 6b72267..e38fa88 100644
> --- a/drivers/infiniband/hw/hfi1/user_sdma.c
> +++ b/drivers/infiniband/hw/hfi1/user_sdma.c
> @@ -374,40 +374,25 @@ static void sdma_kmem_cache_ctor(void *obj)
>  int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt,
>  				struct hfi1_filedata *fd)
>  {
> -	int ret = 0;
> +	int ret = -ENOMEM;
> +	unsigned memsize;
>  	char buf[64];
>  	struct hfi1_devdata *dd;
>  	struct hfi1_user_sdma_comp_q *cq;
>  	struct hfi1_user_sdma_pkt_q *pq;
>  	unsigned long flags;
>
> -	if (!uctxt || !fd) {
> -		ret = -EBADF;
> -		goto done;
> -	}
> +	if (!uctxt || !fd)
> +		return -EBADF;
>
> -	if (!hfi1_sdma_comp_ring_size) {
> -		ret = -EINVAL;
> -		goto done;
> -	}
> +	if (!hfi1_sdma_comp_ring_size)
> +		return -EINVAL;
>
>  	dd = uctxt->dd;
>
>  	pq = kzalloc(sizeof(*pq), GFP_KERNEL);
>  	if (!pq)
> -		goto pq_nomem;
> -
> -	pq->reqs = kcalloc(hfi1_sdma_comp_ring_size,
> -			   sizeof(*pq->reqs),
> -			   GFP_KERNEL);
> -	if (!pq->reqs)
> -		goto pq_reqs_nomem;
> -
> -	pq->req_in_use = kcalloc(BITS_TO_LONGS(hfi1_sdma_comp_ring_size),
> -				 sizeof(*pq->req_in_use),
> -				 GFP_KERNEL);
> -	if (!pq->req_in_use)
> -		goto pq_reqs_no_in_use;
> +		return -ENOMEM;
>
>  	INIT_LIST_HEAD(&pq->list);
>  	pq->dd = dd;
> @@ -423,10 +408,21 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt,
>  	iowait_init(&pq->busy, 0, NULL, defer_packet_queue,
>  		    activate_packet_queue, NULL);
>  	pq->reqidx = 0;
> +
> +	memsize = sizeof(*pq->reqs) * hfi1_sdma_comp_ring_size;
> +	pq->reqs = kzalloc(memsize, GFP_KERNEL);
> +	if (!pq->reqs)
> +		goto pq_reqs_nomem;
> +
> +	memsize = BITS_TO_LONGS(hfi1_sdma_comp_ring_size) * sizeof(long);
> +	pq->req_in_use = kzalloc(memsize, GFP_KERNEL);
> +	if (!pq->req_in_use)
> +		goto pq_reqs_no_in_use;
> +
>  	snprintf(buf, 64, "txreq-kmem-cache-%u-%u-%u", dd->unit, uctxt->ctxt,
>  		 fd->subctxt);
>  	pq->txreq_cache = kmem_cache_create(buf,
> -			       sizeof(struct user_sdma_txreq),
> +					    sizeof(struct user_sdma_txreq),
>  					    L1_CACHE_BYTES,
>  					    SLAB_HWCACHE_ALIGN,
>  					    sdma_kmem_cache_ctor);
> @@ -435,7 +431,7 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt,
>  			   uctxt->ctxt);
>  		goto pq_txreq_nomem;
>  	}
> -	fd->pq = pq;
> +
>  	cq = kzalloc(sizeof(*cq), GFP_KERNEL);
>  	if (!cq)
>  		goto cq_nomem;
> @@ -446,20 +442,25 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt,
>  		goto cq_comps_nomem;
>
>  	cq->nentries = hfi1_sdma_comp_ring_size;
> -	fd->cq = cq;
>
>  	ret = hfi1_mmu_rb_register(pq, pq->mm, &sdma_rb_ops, dd->pport->hfi1_wq,
>  				   &pq->handler);
>  	if (ret) {
>  		dd_dev_err(dd, "Failed to register with MMU %d", ret);
> -		goto done;
> +		goto pq_mmu_fail;
>  	}
>
> +	fd->pq = pq;
> +	fd->cq = cq;
> +
>  	spin_lock_irqsave(&uctxt->sdma_qlock, flags);
>  	list_add(&pq->list, &uctxt->sdma_queues);
>  	spin_unlock_irqrestore(&uctxt->sdma_qlock, flags);
> -	goto done;
>
> +	return 0;
> +
> +pq_mmu_fail:
> +	vfree(cq->comps);
>  cq_comps_nomem:
>  	kfree(cq);
>  cq_nomem:
> @@ -470,10 +471,7 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt,
>  	kfree(pq->reqs);
>  pq_reqs_nomem:
>  	kfree(pq);
> -	fd->pq = NULL;
> -pq_nomem:
> -	ret = -ENOMEM;
> -done:
> +
>  	return ret;
>  }
>
> diff --git a/drivers/infiniband/hw/hfi1/vnic_main.c b/drivers/infiniband/hw/hfi1/vnic_main.c
> index 392f4d5..b601c29 100644
> --- a/drivers/infiniband/hw/hfi1/vnic_main.c
> +++ b/drivers/infiniband/hw/hfi1/vnic_main.c
> @@ -67,9 +67,7 @@ static int setup_vnic_ctxt(struct hfi1_devdata *dd, struct hfi1_ctxtdata *uctxt)
>  	unsigned int rcvctrl_ops = 0;
>  	int ret;
>
> -	ret = hfi1_init_ctxt(uctxt->sc);
> -	if (ret)
> -		goto done;
> +	hfi1_init_ctxt(uctxt->sc);
>
>  	uctxt->do_interrupt = &handle_receive_interrupt;
>
> @@ -82,8 +80,6 @@ static int setup_vnic_ctxt(struct hfi1_devdata *dd, struct hfi1_ctxtdata *uctxt)
>  	if (ret)
>  		goto done;
>
> -	set_bit(HFI1_CTXT_SETUP_DONE, &uctxt->event_flags);
> -
>  	if (uctxt->rcvhdrtail_kvaddr)
>  		clear_rcvhdrtail(uctxt);
>
> @@ -209,7 +205,7 @@ static void deallocate_vnic_ctxt(struct hfi1_devdata *dd,
>  	uctxt->event_flags = 0;
>
>  	hfi1_clear_tids(uctxt);
> -	hfi1_clear_ctxt_pkey(dd, uctxt->ctxt);
> +	hfi1_clear_ctxt_pkey(dd, uctxt);
>
>  	hfi1_stats.sps_ctxts--;
>  	hfi1_free_ctxtdata(dd, uctxt);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--6zdv2QT/q3FMhpsV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkJiFQACgkQ5GN7iDZy
WKdenQ/+KQ+xahIoNJ3FvwxipQ5hwVi7fRKKazb9msSxTkm2HHUgHp6hIYHEvLox
uQGlyI1m3xCoFTaiYlRRgBu5ltC32KUMLlOkI4ezwvAy006pxbhAWtDEfvI8kO/2
62O8QiUkDkqo2aJhHKIhAI7yPTyqcpj7nkb+2XLNc7C+bye6FvmRk89aWDoFYsjZ
J/UgQl7a9/YaghjezPhobhty7svGC0yenMO19YDZNgWByg8reonq3U9fRfnoHYlL
BaVOtr7ziligFJesa9Z3f5UQcNMwfQ93oJTHB0AP3cbS0KMLDqIP4C1IQn+Odpi3
YBAq2vOQwSpOlcl/OOmCCM69vcZ4Oeqw9nex+6LkZNQSQylL+B8c2RzrXnH1bKGl
KoCAgo/WFIemKdmVatlrZDArSU3Tpf9HRyw8a7imiErTs8UhTubhTSC74cm1XaOo
pdQle7ukSx2qt46OsVNsb/4l2rSFlmfIhfO2mAOVXxT3K0qQLbviDJg2RsWz1CRL
O5KT1rNmjL2fdVRjNCQz0jh3v4oMxIR3NpBDHiftbJ8Xqi0rIhfQMnRJQOnc20Cu
lueIs5IDTr7IcjIHcpBn4XX4vr+gi43Ya/yMK+BYkF7xQ2IG9X/eLomw1yT0AAfb
gAusU5c5SbW1WfpTUuaro3+1cxxKFe48Soeh/lGfWbDuLuNtThU=
=NhOO
-----END PGP SIGNATURE-----

--6zdv2QT/q3FMhpsV--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
