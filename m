Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6865143B6F3
	for <linux-rdma@vger.kernel.org>; Sun, 20 Sep 2026 12:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789907072; cv=none; b=BWHpUaUS930H2UCTj7DEuw0n+IXVhQ+8kWZ+dTmJrmMW4RXGnHBCFqFRjkOYS0EbuC8x+ct8KxyX+tw0zRbmDaryJoFVIwSM5knEiVrP475IcA6eVo8pbh/yM5El28KNec1+iEQKbq6VLnZk6suAoHl4gfpCqIveJVyeQ8Y0s3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789907072; c=relaxed/simple;
	bh=g2zNZTJPSMZ7ATgN4Epnv2BjRz5wDEK71Fw4mXtoj10=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ze8oQrHKwaV3csqSvnm/jGnEg7tE0utrgINDmMXvkjm+6+/HNZfY3+TNNib3vxA9AM7jrQ7vg0XnXL+u7TUxyMMscojF2IZ2zAaCexC/kWMgbV++64EhLtHAIfMSS0bNDAUobh3Jp0VMTdrrI5SMtUtPmMgFXcGjs0mXUAYGSIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eiQgoFUc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eiQgoFUc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739931F000FF;
	Sun, 20 Sep 2026 12:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789907055;
	bh=GwGrC56QiD376jAnsn2yCVmj/BV+yjDKQHUztzkBdeg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eiQgoFUclT0BWPo0Cepwe/aLqAX0PwfiQbuArfAveapDL0xh4z6tLfavS8pPwd8cx
	 wMuruXPSvN7CoI6XneZMJVkcyRH3Ms/QfFd8tbcQR5NNhuQzyYfAMEXUYRScpIAjSK
	 sNvCzFBUoL9YTLm+TmePaVxkBeDfM6PzKL4PcqjbdBRT2oF00UXjZPqwvPdfIY+MCN
	 ByTvi10mGrqaGGZOAcPoyBbFmmzAScvjwchz3viEaWddCV+rRuFDk1uJLnwrpR6doD
	 MXLqr/T7KxNfRRet3/AUxWNHEPJ0KGY7hqSbQuZLnXUI5YNtvFjhvntkdCHlGC0LrM
	 WX1NMSqrsTk4Q==
Date: Sun, 20 Sep 2026 15:24:11 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, selvin.xavier@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com, chengyou@linux.alibaba.com,
	kaishen@linux.alibaba.com, tangchengchang@huawei.com,
	huangjunxian6@hisilicon.com, abhijit.gangurde@amd.com,
	allen.hubbe@amd.com, longli@microsoft.com, kotaranov@microsoft.com,
	mkalderon@marvell.com, bryan-bt.tan@broadcom.com,
	vishnu.dasa@broadcom.com, maorg@nvidia.com
Subject: Re: [PATCH V1 rdma-next 04/15] RDMA/umem: Reuse
 ib_umem_get_cq_buf_or_va() for VA-only CQ pinning
Message-ID: <20260920122411.GB563127@unreal>
References: <20260915140933.40580-1-yishaih@nvidia.com>
 <20260915140933.40580-5-yishaih@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915140933.40580-5-yishaih@nvidia.com>

On Tue, Sep 15, 2026 at 05:09:22PM +0300, Yishai Hadas wrote:
> Several drivers pin their CQ ring buffer via ib_umem_get_va() rather
> than the CQ-specific helper. Switch them to ib_umem_get_cq_buf_or_va()
> so the subsequent DMA_FROM_DEVICE change covers all CQ paths at once.
> 
> For shared helpers used by both CQ and non-CQ callers (qedr, mana,
> erdma, hns) a new is_cq parameter selects the appropriate pinning
> function; non-CQ callers pass false.
> 
> vmw_pvrdma's CQ is excluded: it embeds a ring-state header that the
> driver CPU-writes after polling, making it genuinely bidirectional.
> 
> This is a pure refactor with no functional change.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c      |  9 ++++----
>  drivers/infiniband/hw/erdma/erdma_verbs.c     | 17 +++++++++-----
>  drivers/infiniband/hw/hns/hns_roce_cq.c       |  2 +-
>  drivers/infiniband/hw/hns/hns_roce_device.h   |  2 +-
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c    |  2 +-
>  drivers/infiniband/hw/hns/hns_roce_mr.c       | 22 +++++++++++++-----
>  drivers/infiniband/hw/hns/hns_roce_qp.c       |  2 +-
>  drivers/infiniband/hw/hns/hns_roce_srq.c      |  4 ++--
>  .../infiniband/hw/ionic/ionic_controlpath.c   |  5 ++--
>  drivers/infiniband/hw/mana/cq.c               |  2 +-
>  drivers/infiniband/hw/mana/main.c             |  9 ++++++--
>  drivers/infiniband/hw/mana/mana_ib.h          |  2 +-
>  drivers/infiniband/hw/mana/qp.c               |  9 ++++----
>  drivers/infiniband/hw/mana/wq.c               |  3 ++-
>  drivers/infiniband/hw/mlx4/cq.c               | 14 ++++++-----
>  drivers/infiniband/hw/mlx5/cq.c               |  6 ++---
>  drivers/infiniband/hw/qedr/verbs.c            | 23 +++++++++++++------
>  17 files changed, 84 insertions(+), 49 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> index ef08d42f377e..7f9aa3620abb 100644
> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> @@ -3749,12 +3749,13 @@ int bnxt_re_resize_cq(struct ib_cq *ibcq, unsigned int cqe,
>  	if (rc)
>  		goto fail;
>  
> -	cq->resize_umem = ib_umem_get_va(&rdev->ibdev, req.cq_va,
> -					 entries * sizeof(struct cq_base),
> -					 IB_ACCESS_LOCAL_WRITE);
> +	cq->resize_umem = ib_umem_get_cq_buf_or_va(&rdev->ibdev, NULL,
> +						   req.cq_va,
> +						   entries * sizeof(struct cq_base),
> +						   IB_ACCESS_LOCAL_WRITE);


<...>

> index fca2553e47ad..3519b5044e8f 100644
> --- a/drivers/infiniband/hw/erdma/erdma_verbs.c
> +++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
> @@ -828,11 +828,16 @@ static void erdma_destroy_mtt(struct erdma_dev *dev, struct erdma_mtt *mtt)
>  
>  static int get_mtt_entries(struct erdma_dev *dev, struct erdma_mem *mem,
>  			   u64 start, u64 len, int access, u64 virt,
> -			   unsigned long req_page_size, bool force_continuous)
> +			   unsigned long req_page_size, bool force_continuous,
> +			   bool is_cq)
>  {
>  	int ret = 0;
>  
> -	mem->umem = ib_umem_get_va(&dev->ibdev, start, len, access);
> +	if (is_cq)
> +		mem->umem = ib_umem_get_cq_buf_or_va(&dev->ibdev, NULL, start,
> +						     len, access);
> +	else
> +		mem->umem = ib_umem_get_va(&dev->ibdev, start, len, access);

Sorry, but this patch doesn't look right to me.

In bnxt_re_resize_cq(), you chose to move away from the ib_umem_get_va()
API, but here you still keep that API because most of its callers are not
CQs. Why is it so important to specify the direction for CQs while QPs
and MRs are left without it?

Thanks

>  	if (IS_ERR(mem->umem)) {
>  		ret = PTR_ERR(mem->umem);
>  		mem->umem = NULL;
> @@ -951,7 +956,7 @@ static int init_user_qp(struct erdma_qp *qp, struct erdma_ucontext *uctx,
>  
>  	ret = get_mtt_entries(qp->dev, &qp->user_qp.sq_mem, va,
>  			      qp->attrs.sq_size << SQEBB_SHIFT, 0, va,
> -			      (SZ_1M - SZ_4K), true);
> +			      (SZ_1M - SZ_4K), true, false);
>  	if (ret)
>  		return ret;
>  
> @@ -960,7 +965,7 @@ static int init_user_qp(struct erdma_qp *qp, struct erdma_ucontext *uctx,
>  
>  	ret = get_mtt_entries(qp->dev, &qp->user_qp.rq_mem, va + rq_offset,
>  			      qp->attrs.rq_size << RQE_SHIFT, 0, va + rq_offset,
> -			      (SZ_1M - SZ_4K), true);
> +			      (SZ_1M - SZ_4K), true, false);
>  	if (ret)
>  		goto put_sq_mtt;
>  
> @@ -1250,7 +1255,7 @@ struct ib_mr *erdma_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 len,
>  		return ERR_PTR(-ENOMEM);
>  
>  	ret = get_mtt_entries(dev, &mr->mem, start, len, access, virt,
> -			      SZ_2G - SZ_4K, false);
> +			      SZ_2G - SZ_4K, false, false);
>  	if (ret)
>  		goto err_out_free;
>  
> @@ -1931,7 +1936,7 @@ static int erdma_init_user_cq(struct erdma_ucontext *ctx, struct erdma_cq *cq,
>  
>  	ret = get_mtt_entries(dev, &cq->user_cq.qbuf_mem, ureq->qbuf_va,
>  			      ureq->qbuf_len, IB_ACCESS_LOCAL_WRITE,
> -			      ureq->qbuf_va, SZ_64M - SZ_4K, true);
> +			      ureq->qbuf_va, SZ_64M - SZ_4K, true, true);
>  	if (ret)
>  		return ret;

Thanks
