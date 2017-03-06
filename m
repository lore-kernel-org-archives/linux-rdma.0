From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 4/5] IB/nes: Delete unnecessary braces
Date: Mon, 6 Mar 2017 21:56:48 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1703062155550.2172@hadrien>
References: <502a5a6f-ee91-dd2f-cdc7-63f396059529@users.sourceforge.net> <c1546de1-468e-12f9-b31d-e6cf9e38d148@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <c1546de1-468e-12f9-b31d-e6cf9e38d148@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Faisal Latif <faisal.latif@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On Mon, 6 Mar 2017, SF Markus Elfring wrote:

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 6 Mar 2017 17:55:43 +0100
>
> Do not use curly brackets at some source code places
> where a single statement should be sufficient.

The introduction of ? is not mentioned in the commit log.  I'm not sure
that it is suggested Linux kernel coding style either.  One could
furthermore wonder whether those 0s and 1s could be booleans.

julia

>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/infiniband/hw/nes/nes_verbs.c | 84 +++++++++++------------------------
>  1 file changed, 27 insertions(+), 57 deletions(-)
>
> diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
> index f79ea50e3ab5..7764ba423c1c 100644
> --- a/drivers/infiniband/hw/nes/nes_verbs.c
> +++ b/drivers/infiniband/hw/nes/nes_verbs.c
> @@ -87,9 +87,8 @@ static struct ib_mw *nes_alloc_mw(struct ib_pd *ibpd, enum ib_mw_type type,
>
>  	ret = nes_alloc_resource(nesadapter, nesadapter->allocated_mrs,
>  			nesadapter->max_mr, &stag_index, &next_stag_index, NES_RESOURCE_MW);
> -	if (ret) {
> +	if (ret)
>  		return ERR_PTR(ret);
> -	}
>
>  	nesmr = kzalloc(sizeof(*nesmr), GFP_KERNEL);
>  	if (!nesmr) {
> @@ -137,11 +136,7 @@ static struct ib_mw *nes_alloc_mw(struct ib_pd *ibpd, enum ib_mw_type type,
>  		nes_put_cqp_request(nesdev, cqp_request);
>  		kfree(nesmr);
>  		nes_free_resource(nesadapter, nesadapter->allocated_mrs, stag_index);
> -		if (!ret) {
> -			return ERR_PTR(-ETIME);
> -		} else {
> -			return ERR_PTR(-ENOMEM);
> -		}
> +		return ERR_PTR(ret ? -ENOMEM : -ETIME);
>  	}
>  	nes_put_cqp_request(nesdev, cqp_request);
>
> @@ -680,9 +675,8 @@ static struct ib_pd *nes_alloc_pd(struct ib_device *ibdev,
>
>  	err = nes_alloc_resource(nesadapter, nesadapter->allocated_pds,
>  			nesadapter->max_pd, &pd_num, &nesadapter->next_pd, NES_RESOURCE_PD);
> -	if (err) {
> +	if (err)
>  		return ERR_PTR(err);
> -	}
>
>  	nespd = kzalloc(sizeof (struct nes_pd), GFP_KERNEL);
>  	if (!nespd) {
> @@ -743,9 +737,8 @@ static int nes_dealloc_pd(struct ib_pd *ibpd)
>  				nespd->mmap_db_index);
>  		clear_bit(nespd->mmap_db_index, nesucontext->allocated_doorbells);
>  		nesucontext->mmap_db_index[nespd->mmap_db_index] = 0;
> -		if (nesucontext->first_free_db > nespd->mmap_db_index) {
> +		if (nesucontext->first_free_db > nespd->mmap_db_index)
>  			nesucontext->first_free_db = nespd->mmap_db_index;
> -		}
>  	}
>
>  	nes_debug(NES_DBG_PD, "Deallocating PD%u structure located @%p.\n",
> @@ -1034,11 +1027,11 @@ static struct ib_qp *nes_create_qp(struct ib_pd *ibpd,
>  	atomic_inc(&qps_created);
>  	switch (init_attr->qp_type) {
>  		case IB_QPT_RC:
> -			if (nes_drv_opt & NES_DRV_OPT_NO_INLINE_DATA) {
> +			if (nes_drv_opt & NES_DRV_OPT_NO_INLINE_DATA)
>  				init_attr->cap.max_inline_data = 0;
> -			} else {
> +			else
>  				init_attr->cap.max_inline_data = 64;
> -			}
> +
>  			sq_size = init_attr->cap.max_send_wr;
>  			rq_size = init_attr->cap.max_recv_wr;
>
> @@ -1058,9 +1051,8 @@ static struct ib_qp *nes_create_qp(struct ib_pd *ibpd,
>
>  			ret = nes_alloc_resource(nesadapter, nesadapter->allocated_qps,
>  					nesadapter->max_qp, &qp_num, &nesadapter->next_qp, NES_RESOURCE_QP);
> -			if (ret) {
> +			if (ret)
>  				return ERR_PTR(ret);
> -			}
>
>  			/* Need 512 (actually now 1024) byte alignment on this structure */
>  			mem = kzalloc(sizeof(*nesqp)+NES_SW_CONTEXT_ALIGN-1, GFP_KERNEL);
> @@ -1084,9 +1076,8 @@ static struct ib_qp *nes_create_qp(struct ib_pd *ibpd,
>  					nes_debug(NES_DBG_QP, "ib_copy_from_udata() Failed \n");
>  					return ERR_PTR(-EFAULT);
>  				}
> -				if (req.user_wqe_buffers) {
> +				if (req.user_wqe_buffers)
>  					virt_wqs = 1;
> -				}
>  				if (req.user_qp_buffer)
>  					nesqp->nesuqp_addr = req.user_qp_buffer;
>  				if ((ibpd->uobject) && (ibpd->uobject->context)) {
> @@ -1271,11 +1262,7 @@ static struct ib_qp *nes_create_qp(struct ib_pd *ibpd,
>  				nes_free_resource(nesadapter, nesadapter->allocated_qps, qp_num);
>  				nes_free_qp_mem(nesdev, nesqp,virt_wqs);
>  				kfree(nesqp->allocated_buffer);
> -				if (!ret) {
> -					return ERR_PTR(-ETIME);
> -				} else {
> -					return ERR_PTR(-EIO);
> -				}
> +				return ERR_PTR(ret ? -EIO : -ETIME);
>  			}
>
>  			nes_put_cqp_request(nesdev, cqp_request);
> @@ -1401,9 +1388,8 @@ static int nes_destroy_qp(struct ib_qp *ibqp)
>  			nes_ucontext = to_nesucontext(ibqp->uobject->context);
>  			clear_bit(nesqp->mmap_sq_db_index, nes_ucontext->allocated_wqs);
>  			nes_ucontext->mmap_nesqp[nesqp->mmap_sq_db_index] = NULL;
> -			if (nes_ucontext->first_free_wq > nesqp->mmap_sq_db_index) {
> +			if (nes_ucontext->first_free_wq > nesqp->mmap_sq_db_index)
>  				nes_ucontext->first_free_wq = nesqp->mmap_sq_db_index;
> -			}
>  		}
>  		if (nesqp->pbl_pbase && nesqp->sq_kmapped) {
>  			nesqp->sq_kmapped = 0;
> @@ -1458,9 +1444,8 @@ static struct ib_cq *nes_create_cq(struct ib_device *ibdev,
>
>  	err = nes_alloc_resource(nesadapter, nesadapter->allocated_cqs,
>  			nesadapter->max_cq, &cq_num, &nesadapter->next_cq, NES_RESOURCE_CQ);
> -	if (err) {
> +	if (err)
>  		return ERR_PTR(err);
> -	}
>
>  	nescq = kzalloc(sizeof(struct nes_cq), GFP_KERNEL);
>  	if (!nescq) {
> @@ -2031,9 +2016,8 @@ struct ib_mr *nes_reg_phys_mr(struct ib_pd *ib_pd, u64 addr, u64 size,
>
>  	err = nes_alloc_resource(nesadapter, nesadapter->allocated_mrs, nesadapter->max_mr,
>  			&stag_index, &next_stag_index, NES_RESOURCE_PHYS_MR);
> -	if (err) {
> +	if (err)
>  		return ERR_PTR(err);
> -	}
>
>  	nesmr = kzalloc(sizeof(*nesmr), GFP_KERNEL);
>  	if (!nesmr) {
> @@ -2079,11 +2063,7 @@ struct ib_mr *nes_reg_phys_mr(struct ib_pd *ib_pd, u64 addr, u64 size,
>  	/* Make the leaf PBL the root if only one PBL */
>  	root_vpbl.pbl_pbase = vpbl.pbl_pbase;
>
> -	if (single_page) {
> -		pbl_count = 0;
> -	} else {
> -		pbl_count = 1;
> -	}
> +	pbl_count = single_page ? 0 : 1;
>  	ret = nes_reg_mr(nesdev, nespd, stag, region_length, &root_vpbl,
>  			addr, pbl_count, 1, acc, iova_start,
>  			&nesmr->pbls_used, &nesmr->pbl_4k);
> @@ -2159,9 +2139,8 @@ static struct ib_mr *nes_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
>  	int first_page = 1;
>
>  	region = ib_umem_get(pd->uobject->context, start, length, acc, 0);
> -	if (IS_ERR(region)) {
> +	if (IS_ERR(region))
>  		return (struct ib_mr *)region;
> -	}
>
>  	nes_debug(NES_DBG_MR, "User base = 0x%lX, Virt base = 0x%lX, length = %u,"
>  			" offset = %u, page size = %u.\n",
> @@ -2337,9 +2316,8 @@ static struct ib_mr *nes_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
>
>  			iova_start = virt;
>  			/* Make the leaf PBL the root if only one PBL */
> -			if (root_pbl_index == 1) {
> +			if (root_pbl_index == 1)
>  				root_vpbl.pbl_pbase = vpbl.pbl_pbase;
> -			}
>
>  			if (single_page) {
>  				pbl_count = 0;
> @@ -2411,11 +2389,10 @@ static struct ib_mr *nes_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
>  			pbl_depth = region->length >> 12;
>  			pbl_depth += (region->length & (4096-1)) ? 1 : 0;
>  			nespbl->pbl_size = pbl_depth*sizeof(u64);
> -			if (req.reg_type == IWNES_MEMREG_TYPE_QP) {
> +			if (req.reg_type == IWNES_MEMREG_TYPE_QP)
>  				nes_debug(NES_DBG_MR, "Attempting to allocate QP PBL memory");
> -			} else {
> +			else
>  				nes_debug(NES_DBG_MR, "Attempting to allocate CP PBL memory");
> -			}
>
>  			nes_debug(NES_DBG_MR, " %u bytes, %u entries.\n",
>  					nespbl->pbl_size, pbl_depth);
> @@ -2458,11 +2435,11 @@ static struct ib_mr *nes_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
>  				}
>  			}
>
> -			if (req.reg_type == IWNES_MEMREG_TYPE_QP) {
> +			if (req.reg_type == IWNES_MEMREG_TYPE_QP)
>  				list_add_tail(&nespbl->list, &nes_ucontext->qp_reg_mem_list);
> -			} else {
> +			else
>  				list_add_tail(&nespbl->list, &nes_ucontext->cq_reg_mem_list);
> -			}
> +
>  			nesmr->ibmr.rkey = -1;
>  			nesmr->ibmr.lkey = -1;
>  			nesmr->mode = req.reg_type;
> @@ -2497,9 +2474,9 @@ static int nes_dereg_mr(struct ib_mr *ib_mr)
>  				    nesmr->pages,
>  				    nesmr->paddr);
>
> -	if (nesmr->region) {
> +	if (nesmr->region)
>  		ib_umem_release(nesmr->region);
> -	}
> +
>  	if (nesmr->mode != IWNES_MEMREG_TYPE_MEM) {
>  		kfree(nesmr);
>  		return 0;
> @@ -2676,11 +2653,7 @@ int nes_hw_modify_qp(struct nes_device *nesdev, struct nes_qp *nesqp,
>  		nes_debug(NES_DBG_MOD_QP, "Failed to get a cqp_request.\n");
>  		return -ENOMEM;
>  	}
> -	if (wait_completion) {
> -		cqp_request->waiting = 1;
> -	} else {
> -		cqp_request->waiting = 0;
> -	}
> +	cqp_request->waiting = wait_completion ? 1 : 0;
>  	cqp_wqe = &cqp_request->cqp_wqe;
>
>  	set_wqe_32bit_value(cqp_wqe->wqe_words, NES_CQP_WQE_OPCODE_IDX,
> @@ -3864,9 +3837,8 @@ int nes_register_ofa_device(struct nes_ib_device *nesibdev)
>  	int i, ret;
>
>  	ret = ib_register_device(&nesvnic->nesibdev->ibdev, NULL);
> -	if (ret) {
> +	if (ret)
>  		return ret;
> -	}
>
>  	/* Get the resources allocated to this device */
>  	nesibdev->max_cq = (nesadapter->max_cq-NES_FIRST_QPN) / nesadapter->port_count;
> @@ -3901,13 +3873,11 @@ static void nes_unregister_ofa_device(struct nes_ib_device *nesibdev)
>  	struct nes_vnic *nesvnic = nesibdev->nesvnic;
>  	int i;
>
> -	for (i = 0; i < ARRAY_SIZE(nes_dev_attributes); ++i) {
> +	for (i = 0; i < ARRAY_SIZE(nes_dev_attributes); ++i)
>  		device_remove_file(&nesibdev->ibdev.dev, nes_dev_attributes[i]);
> -	}
>
> -	if (nesvnic->of_device_registered) {
> +	if (nesvnic->of_device_registered)
>  		ib_unregister_device(&nesibdev->ibdev);
> -	}
>
>  	nesvnic->of_device_registered = 0;
>  }
> --
> 2.12.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
