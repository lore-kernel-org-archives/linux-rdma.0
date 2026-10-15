Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35F653F6AB;
	Thu, 15 Oct 2026 18:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792088246; cv=none; b=iHRT6dN+bF6UkMdLkW6NR2wLz0oIRSoABVVVpQCEFmL+nKsxrPUaQ237hZWY0t3jODO3yATfruX1uq7P0nw06FEmqnxU0hZTI0KnGDh8LHCj4Rjh5toYDOmWItE1srcPOuCfsU9y3X4d8Xvzw456sC8/kJR/mYFyJT+W8pgpZ6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792088246; c=relaxed/simple;
	bh=94SFc2frJuu5i6d3yDnz3QPDROVTJfLGJVj9IL65e50=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aFscnjPKXtpkTS0kTkKiOzZZFa2TGtIKVUHmPhHGv1LMNgZvC4x/yhQib3esOWjAWOd4KFgg3JbbZiKyDgZbVePkTGwUb0OMwTNmTak2G5SQNr3zmUo8UunPHf0K+IfR1PQKhO0HVTxt/GY2WnjOsx1XwwmVXUrbTWqj/MTqMOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NQVI2esR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NQVI2esR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092DB1F000C6;
	Thu, 15 Oct 2026 18:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792088237;
	bh=k67o3OR1qMtQp5c2QUj18xunQff2y1QX0dForzdNANY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NQVI2esRyplxegh7w+U/D07TXZY2j6qnYXn69NbdAFUsy239xoCHHhk851VjnBouq
	 5IwoTBraI20cuJmgUDklTmwcPBA6SD47bPkDvwHdO/FAPkQJYkRCk/pjW2NEApZce4
	 gLp2yc/RG7Yyt5YXdNHyS3JhSyxnBQpr7dVmDC3tgfT9e5sRvOvjT9rkK9/BGkyxIW
	 HJkVsUVPQBbkR8LTTqr69bTrYipE85fx16BVcsr7m3Iw7dKF/eek8llC4iO3Qaop7j
	 RecAYTD/3h553Bci0OEDOUN1YVRpO+57fkBO3hKDdim+JCKzZBmsHAipUhpYu4pcd6
	 qK7GJtm9QsfQA==
Date: Thu, 15 Oct 2026 21:17:13 +0300
From: Leon Romanovsky <leon@kernel.org>
To: David Hu <dhu@x6u.co>
Cc: Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, jmoroni@google.com,
	eagleshaw@google.com, xuehaohu@google.com
Subject: Re: [PATCH rdma-next v2 4/6] RDMA/irdma: Split CQ setup to umode and
 kmode
Message-ID: <20261015181713.GB219304@unreal>
References: <20261015011940.4122452-1-dhu@x6u.co>
 <20261015011940.4122452-5-dhu@x6u.co>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015011940.4122452-5-dhu@x6u.co>

On Thu, Oct 15, 2026 at 01:19:38AM +0000, David Hu wrote:
> From: David Hu <xuehaohu@google.com>
> 
> This split is similar to QP, and SRQ that is already present in existing
> irdma driver. Only variable plumbing was done, while umode and kmode setup
> logic is identical as before.
> 
> Signed-off-by: David Hu <xuehaohu@google.com>
> ---
>  drivers/infiniband/hw/irdma/verbs.c | 232 +++++++++++++++-------------
>  1 file changed, 126 insertions(+), 106 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
> index ab25445f3828..7162b37fa6ff 100644
> --- a/drivers/infiniband/hw/irdma/verbs.c
> +++ b/drivers/infiniband/hw/irdma/verbs.c
> @@ -2624,6 +2624,126 @@ static inline int cq_validate_flags(u32 flags, u8 hw_rev)
>  	return flags & ~IB_UVERBS_CQ_FLAGS_TIMESTAMP_COMPLETION ? -EOPNOTSUPP : 0;
>  }
>  
> +static int irdma_setup_kmode_cq(struct irdma_device *iwdev,
> +				struct irdma_cq *iwcq,
> +				struct irdma_cq_init_info *info,
> +				const struct ib_cq_init_attr *attr)
> +{
> +	struct irdma_cq_uk_init_info *ukinfo = &info->cq_uk_init_info;
> +	struct irdma_pci_f *rf = iwdev->rf;
> +	struct irdma_sc_dev *dev = &rf->sc_dev;
> +	int entries = attr->cqe;
> +	bool cqe_64byte_ena;
> +	u8 cqe_size;
> +	int rsize;
> +
> +	if (entries < 1 || entries > rf->max_cqe)
> +		return -EINVAL;

This if() is impossible.

> +
> +	cqe_64byte_ena = dev->hw_attrs.uk_attrs.feature_flags & IRDMA_FEATURE_64_BYTE_CQE ?
> +			 true : false;
> +	cqe_size = cqe_64byte_ena ? 64 : 32;
> +
> +	entries += 2;
> +	if (!cqe_64byte_ena && dev->hw_attrs.uk_attrs.hw_rev >= IRDMA_GEN_2)
> +		entries *= 2;
> +
> +	if (entries & 1)
> +		entries += 1; /* cq size must be an even number */
> +
> +	if (entries * cqe_size == IRDMA_HW_PAGE_SIZE)
> +		entries += 2;
> +
> +	ukinfo->cq_size = entries;
> +
> +	if (cqe_64byte_ena)
> +		rsize = ukinfo->cq_size * sizeof(struct irdma_extended_cqe);
> +	else
> +		rsize = ukinfo->cq_size * sizeof(struct irdma_cqe);
> +	iwcq->kmem.size = ALIGN(round_up(rsize, 256), 256);
> +	iwcq->kmem.va = dma_alloc_coherent(dev->hw->device,
> +					   iwcq->kmem.size,
> +					   &iwcq->kmem.pa, GFP_KERNEL);
> +	if (!iwcq->kmem.va)
> +		return -ENOMEM;
> +
> +	iwcq->kmem_shadow.size = ALIGN(IRDMA_SHADOW_AREA_SIZE << 3, 64);
> +	iwcq->kmem_shadow.va = dma_alloc_coherent(dev->hw->device,
> +						  iwcq->kmem_shadow.size,
> +						  &iwcq->kmem_shadow.pa,
> +						  GFP_KERNEL);
> +	if (!iwcq->kmem_shadow.va)
> +		return -ENOMEM;
> +
> +	info->shadow_area_pa = iwcq->kmem_shadow.pa;
> +	ukinfo->shadow_area = iwcq->kmem_shadow.va;
> +	ukinfo->cq_base = iwcq->kmem.va;
> +	info->cq_base_pa = iwcq->kmem.pa;
> +
> +	return 0;
> +}
> +
> +static int irdma_setup_umode_cq(struct irdma_device *iwdev,
> +				struct irdma_cq *iwcq,
> +				struct irdma_cq_init_info *info,
> +				struct ib_udata *udata)
> +{
> +	struct irdma_create_cq_req req = {};
> +	struct irdma_pci_f *rf = iwdev->rf;
> +	struct irdma_ucontext *ucontext;
> +	struct irdma_cq_mr *cqmr_shadow;
> +	struct irdma_cq_mr *cqmr;
> +	unsigned long flags;
> +	int err_code;
> +
> +	iwcq->user_mode = true;
> +	ucontext = rdma_udata_to_drv_context(udata, struct irdma_ucontext,
> +					     ibucontext);
> +	/* Even though the last member of struct irdma_create_cq_req
> +	 * was always user_shadow_area, we need backwards compat with
> +	 * the legacy i40iw struct i40iw_ucreate_cq which stopped
> +	 * at user_cq_buffer.
> +	 */
> +	err_code = ib_copy_validate_udata_in(udata, req, user_cq_buf);
> +	if (err_code)
> +		return err_code;
> +
> +	spin_lock_irqsave(&ucontext->cq_reg_mem_list_lock, flags);
> +	iwcq->iwpbl = irdma_get_pbl((unsigned long)req.user_cq_buf,
> +				    &ucontext->cq_reg_mem_list);
> +	spin_unlock_irqrestore(&ucontext->cq_reg_mem_list_lock, flags);
> +	if (!iwcq->iwpbl)
> +		return -EPROTO;
> +
> +	cqmr = &iwcq->iwpbl->cq_mr;
> +
> +	if (rf->sc_dev.hw_attrs.uk_attrs.feature_flags &
> +	    IRDMA_FEATURE_CQ_RESIZE) {
> +		spin_lock_irqsave(&ucontext->cq_reg_mem_list_lock, flags);
> +		iwcq->iwpbl_shadow =
> +			irdma_get_pbl((unsigned long)req.user_shadow_area,
> +				      &ucontext->cq_reg_mem_list);
> +		spin_unlock_irqrestore(&ucontext->cq_reg_mem_list_lock, flags);
> +
> +		if (!iwcq->iwpbl_shadow)
> +			return -EPROTO;
> +
> +		cqmr_shadow = &iwcq->iwpbl_shadow->cq_mr;
> +		info->shadow_area_pa = cqmr_shadow->cq_pbl.addr;
> +	} else {
> +		info->shadow_area_pa = cqmr->shadow;
> +	}
> +	if (iwcq->iwpbl->pbl_allocated) {
> +		info->virtual_map = true;
> +		info->pbl_chunk_size = 1;
> +		info->first_pm_pbl_idx = cqmr->cq_pbl.idx;
> +	} else {
> +		info->cq_base_pa = cqmr->cq_pbl.addr;
> +	}
> +
> +	return 0;
> +}
> +
>  /**
>   * irdma_create_cq - create cq
>   * @ibcq: CQ allocated
> @@ -2647,11 +2767,9 @@ static int irdma_create_cq(struct ib_cq *ibcq,
>  	struct irdma_cqp_request *cqp_request;
>  	struct cqp_cmds_info *cqp_info;
>  	struct irdma_cq_uk_init_info *ukinfo = &info.cq_uk_init_info;
> -	unsigned long flags;
>  	int err_code;
>  	int entries = attr->cqe;
>  	bool cqe_64byte_ena;
> -	u8 cqe_size;
>  
>  	err_code = cq_validate_flags(attr->flags, dev->hw_attrs.uk_attrs.hw_rev);
>  	if (err_code)
> @@ -2679,7 +2797,6 @@ static int irdma_create_cq(struct ib_cq *ibcq,
>  	ukinfo->cq_id = cq_num;
>  	cqe_64byte_ena = dev->hw_attrs.uk_attrs.feature_flags & IRDMA_FEATURE_64_BYTE_CQE ?
>  			 true : false;
> -	cqe_size = cqe_64byte_ena ? 64 : 32;
>  	ukinfo->avoid_mem_cflct = cqe_64byte_ena;
>  	iwcq->ibcq.cqe = info.cq_uk_init_info.cq_size;
>  	if (attr->comp_vector < rf->ceqs_count)
> @@ -2689,109 +2806,12 @@ static int irdma_create_cq(struct ib_cq *ibcq,
>  	info.type = IRDMA_CQ_TYPE_IWARP;
>  	info.vsi = &iwdev->vsi;
>  
> -	if (udata) {
> -		struct irdma_ucontext *ucontext;
> -		struct irdma_create_cq_req req = {};
> -		struct irdma_cq_mr *cqmr;
> -		struct irdma_cq_mr *cqmr_shadow;
> -
> -		iwcq->user_mode = true;
> -		ucontext =
> -			rdma_udata_to_drv_context(udata, struct irdma_ucontext,
> -						  ibucontext);
> -		/* Even though the last member of struct irdma_create_cq_req
> -		 * was always user_shadow_area, we need backwards compat with
> -		 * the legacy i40iw struct i40iw_ucreate_cq which stopped
> -		 * at user_cq_buffer.
> -		 */
> -		err_code = ib_copy_validate_udata_in(udata, req, user_cq_buf);
> -		if (err_code)
> -			goto cq_free_rsrc;
> -
> -		spin_lock_irqsave(&ucontext->cq_reg_mem_list_lock, flags);
> -		iwcq->iwpbl = irdma_get_pbl((unsigned long)req.user_cq_buf,
> -					    &ucontext->cq_reg_mem_list);
> -		spin_unlock_irqrestore(&ucontext->cq_reg_mem_list_lock, flags);
> -		if (!iwcq->iwpbl) {
> -			err_code = -EPROTO;
> -			goto cq_free_rsrc;
> -		}
> -
> -		cqmr = &iwcq->iwpbl->cq_mr;
> -
> -		if (rf->sc_dev.hw_attrs.uk_attrs.feature_flags &
> -		    IRDMA_FEATURE_CQ_RESIZE) {
> -			spin_lock_irqsave(&ucontext->cq_reg_mem_list_lock, flags);
> -			iwcq->iwpbl_shadow = irdma_get_pbl(
> -					(unsigned long)req.user_shadow_area,
> -					&ucontext->cq_reg_mem_list);
> -			spin_unlock_irqrestore(&ucontext->cq_reg_mem_list_lock, flags);
> -
> -			if (!iwcq->iwpbl_shadow) {
> -				err_code = -EPROTO;
> -				goto cq_free_rsrc;
> -			}
> -			cqmr_shadow = &iwcq->iwpbl_shadow->cq_mr;
> -			info.shadow_area_pa = cqmr_shadow->cq_pbl.addr;
> -		} else {
> -			info.shadow_area_pa = cqmr->shadow;
> -		}
> -		if (iwcq->iwpbl->pbl_allocated) {
> -			info.virtual_map = true;
> -			info.pbl_chunk_size = 1;
> -			info.first_pm_pbl_idx = cqmr->cq_pbl.idx;
> -		} else {
> -			info.cq_base_pa = cqmr->cq_pbl.addr;
> -		}
> -	} else {
> -		/* Kmode allocations */
> -		int rsize;
> -
> -		if (entries < 1 || entries > rf->max_cqe) {
> -			err_code = -EINVAL;
> -			goto cq_free_rsrc;
> -		}
> -
> -		entries += 2;
> -		if (!cqe_64byte_ena && dev->hw_attrs.uk_attrs.hw_rev >= IRDMA_GEN_2)
> -			entries *= 2;
> -
> -		if (entries & 1)
> -			entries += 1; /* cq size must be an even number */
> -
> -		if (entries * cqe_size == IRDMA_HW_PAGE_SIZE)
> -			entries += 2;
> -
> -		ukinfo->cq_size = entries;
> -
> -		if (cqe_64byte_ena)
> -			rsize = info.cq_uk_init_info.cq_size * sizeof(struct irdma_extended_cqe);
> -		else
> -			rsize = info.cq_uk_init_info.cq_size * sizeof(struct irdma_cqe);
> -		iwcq->kmem.size = ALIGN(round_up(rsize, 256), 256);
> -		iwcq->kmem.va = dma_alloc_coherent(dev->hw->device,
> -						   iwcq->kmem.size,
> -						   &iwcq->kmem.pa, GFP_KERNEL);
> -		if (!iwcq->kmem.va) {
> -			err_code = -ENOMEM;
> -			goto cq_free_rsrc;
> -		}
> -
> -		iwcq->kmem_shadow.size = ALIGN(IRDMA_SHADOW_AREA_SIZE << 3,
> -					       64);
> -		iwcq->kmem_shadow.va = dma_alloc_coherent(dev->hw->device,
> -							  iwcq->kmem_shadow.size,
> -							  &iwcq->kmem_shadow.pa,
> -							  GFP_KERNEL);
> -		if (!iwcq->kmem_shadow.va) {
> -			err_code = -ENOMEM;
> -			goto cq_free_rsrc;
> -		}
> -		info.shadow_area_pa = iwcq->kmem_shadow.pa;
> -		ukinfo->shadow_area = iwcq->kmem_shadow.va;
> -		ukinfo->cq_base = iwcq->kmem.va;
> -		info.cq_base_pa = iwcq->kmem.pa;
> -	}
> +	if (udata)
> +		err_code = irdma_setup_umode_cq(iwdev, iwcq, &info, udata);
> +	else
> +		err_code = irdma_setup_kmode_cq(iwdev, iwcq, &info, attr);

No, the idea was to actually implement and set ,crate_user_cq() callback
and clean as much as possible from existing .create_cq() callback.

Thanks

> +	if (err_code)
> +		goto cq_free_rsrc;
>  
>  	info.shadow_read_threshold = min(info.cq_uk_init_info.cq_size / 2,
>  					 (u32)IRDMA_MAX_CQ_READ_THRESH);
> -- 
> 2.56.0.385.gd3acb90ef8-goog
> 
> 
