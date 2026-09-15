Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B87445AE0
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 07:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789457753; cv=none; b=gP6iAK188sTYnbRjte7I0pyEwtIHUFXVbi9cgIqAmlqDyhZ6xct8o1GQ/SZ6S8WKno62AHtMIlOl/Lv9OS8HTPl/Co+EZoJPgxoTqbR6n6UHZZtCFaK17cNELxeCmoBeC4JaiUoI8D/vs6rRpacEkPrRoxJo/h5QIlZzCVGSeTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789457753; c=relaxed/simple;
	bh=dblEJcauHzLgVbR6U6FNOH9sBaE0Y2J1No1vrjWDYDU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ezN6HojLXZSjehxXxpYfE5CX+ALtJyGYO8S+qPt/KqmHAkWEeBlUXEalADDlJSc7QrpFoe7p/CM8RYjb1IhUtA0W0bgWfNAkit7cBeX46Up7lB61j2C4FhCddG5d/J9lZIK6QnI3uJEC+og7w6PRTD1BDxcId5hmqG1DE+NhwOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iWwR+1dL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iWwR+1dL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F61C1F000FF;
	Tue, 15 Sep 2026 07:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789457750;
	bh=o3XruCwfProvdvduN/1NZxWzdLvNC5Jv5HAch4vSvSQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iWwR+1dLWXDLtDj95QNfOQwgrQQjd6BDRAJpzbhsFmpQBENgGBgtmprz+h7fCJM2T
	 sYtc+hUtckvB9QqLkeeiSDChq4UoLlD+ekaGVLB8lYjUk2Aud+j50RLgsUjCOe5O8d
	 5mfAf/iqENmehU4nSzpmxM6fS6So6fv+upmmvHDovVWftnutVBhtIi66MdgYPy5lJW
	 ozm4lXOqe+tC/ed/IZc0X5P96pBC6U/dKB0/A0tcxW6ShogUuPMRQZkrnpwg5mxLDz
	 mXu1/kejcSljuV2nJcLoBC0biUNjSf7YNglF3b2eJvWrQkK9U3DZS7Jg2362f69/nb
	 JkFJkNAqUDEQQ==
Date: Tue, 15 Sep 2026 10:35:45 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, selvin.xavier@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com, chengyou@linux.alibaba.com,
	kaishen@linux.alibaba.com, tangchengchang@huawei.com,
	huangjunxian6@hisilicon.com, abhijit.gangurde@amd.com,
	allen.hubbe@amd.com, longli@microsoft.com, kotaranov@microsoft.com,
	mkalderon@marvell.com, bryan-bt.tan@broadcom.com,
	vishnu.dasa@broadcom.com, maorg@nvidia.com
Subject: Re: [PATCH rdma-next 07/15] RDMA/umem: Derive DMA direction from IB
 access flags
Message-ID: <20260915073545.GE13683@unreal>
References: <20260908152851.1307294-1-yishaih@nvidia.com>
 <20260908152851.1307294-8-yishaih@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908152851.1307294-8-yishaih@nvidia.com>

On Tue, Sep 08, 2026 at 06:28:43PM +0300, Yishai Hadas wrote:
> ib_umem_get_desc() / ib_umem_get_attr() / ib_umem_get_attr_or_va() can
> now derive the DMA direction from the IB access flags instead of always
> mapping DMA_BIDIRECTIONAL:
> 
>   - No write access granted (as determined by ib_access_writable():
>     IB_ACCESS_LOCAL_WRITE, IB_ACCESS_REMOTE_WRITE,
>     IB_ACCESS_REMOTE_ATOMIC, or IB_ACCESS_MW_BIND): the NIC may only
>     read the pages, so DMA_TO_DEVICE. This covers all callers that
>     pass access=0 (SRQ WQE rings, QP SQ/RQ WQE rings, doorbell
>     records) and MRs registered without write access
>     (IB_ACCESS_REMOTE_READ only).
> 
>   - Any such flag set: DMA_BIDIRECTIONAL, unchanged behaviour.
> 
> This is not just a theoretical default: it has been verified, driver by
> driver, against every QP SQ/RQ, SRQ, and doorbell-record buffer in the
> tree pinned this way -- mlx5, mlx4, bnxt_re, efa, ionic, qedr, mana,
> erdma, hns, and irdma all externalize their producer/consumer
> bookkeeping through a separate doorbell/UAR MMIO write or a distinct
> completion queue, never by the device writing back into the same buffer
> the CPU posts WQEs into. vmw_pvrdma is the sole exception, already
> pinning its QP/SRQ rings with IB_ACCESS_LOCAL_WRITE (see the earlier
> fix), so it continues to correctly derive DMA_BIDIRECTIONAL here without
> any special-casing.

Please read commit messages and remove the AI slop above. It is part of
claude/codex/... Intermediate prose which shouldn't be in the commit
message.

> 
> For dmabuf buffers the direction is managed by the dmabuf subsystem and
> ib_umem_get_desc() routes them unchanged, ignoring the derived
> direction. CQ buffers already get their own tighter, unconditional
> DMA_FROM_DEVICE mapping from the previous patch and are unaffected by
> this rule.

Same.

> 
> Security gain by platform:
>   - Platforms with a write-enforcing IOMMU (e.g. CoCo guests backed by
>     ARM SMMU or Intel VT-d in strict mode): a hostile device is
>     hardware-prevented from writing to read-only buffers (WQEs,
>     doorbell records), limiting corruption.
>   - Standard deployments without IOMMU direction enforcement: no
>     practical security effect today, but the correct semantic
>     declaration and zero runtime cost.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/infiniband/core/umem.c | 23 ++++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
> index f1da70c4e352..490ce660193e 100644
> --- a/drivers/infiniband/core/umem.c
> +++ b/drivers/infiniband/core/umem.c
> @@ -329,7 +329,20 @@ struct ib_umem *ib_umem_get_desc(struct ib_device *device,
>  				 const struct ib_uverbs_buffer_desc *desc,
>  				 int access)
>  {
> -	return __ib_umem_get_desc_dir(device, desc, access, DMA_BIDIRECTIONAL);
> +	/*
> +	 * Derive the DMA direction from the IB access flags.  If the caller
> +	 * grants no write access (local or remote), the NIC may only read the
> +	 * pages - use DMA_TO_DEVICE so that platforms with a write-enforcing
> +	 * IOMMU (e.g. CoCo / SMMU with SMMU_CB_ARC_FAULT_ENABLE) can enforce
> +	 * the restriction.
> +	 *
> +	 * Where the IOMMU does not enforce direction (most x86 bare-metal
> +	 * deployments today) this has no security effect, but is still the
> +	 * correct semantic declaration and costs nothing.
> +	 */

Please remove these useless comments.

> +	return __ib_umem_get_desc_dir(device, desc, access,
> +				      ib_access_writable(access) ?
> +				      DMA_BIDIRECTIONAL : DMA_TO_DEVICE);

Write some simple wrapper for this pattern.

Thanks
