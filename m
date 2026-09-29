Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D097147A893
	for <linux-rdma@vger.kernel.org>; Tue, 29 Sep 2026 08:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790671016; cv=none; b=s8MlJNGwL3axi5HJF5cZyu/0moDqaO3+b7L9oIJJjCHj5HFsqZGWcW88nuFLkFXAMLIv766lAp1a00M87cYQ9HsKbteCi75WAm6jnenn7p0C336uNNdVyOiCKWBkmxEcqgHgoGMz9FLd6wW/U9YhseLoP4+fru5+1yJVI00GPFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790671016; c=relaxed/simple;
	bh=XhQo2jgTVO8edfRZ6DaAPE6BfGDyD2890I+HH311ccI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=syC/0IxDQ5tLWYYn80y2pd+/caxhxbJQ9wPpRKE1CVc8VDoOWXg6Br2U/K2+O/sRIrZThlJ0Gq1gFTVklTRBuN9jQ5qHF/aISthQZJPwWOIjUuQNBI1rfdrkAHYFoP4Rppnh1DxSamF6yD303Tw/jh0u/49IGwhyNt3lHfU78wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OlNFo2Xj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OlNFo2Xj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B321F000FF;
	Tue, 29 Sep 2026 08:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790671015;
	bh=iyVKh3GpDfnCf7QZCWFzjvtTY04OsrpnjXq/4EYrOIA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OlNFo2XjkPQChm5AZTqH1hj7rhgbSrIsffDK0gyrX6vtXVLRKnKwjJYinfY3Y24gv
	 l6w7gXjtxCK1v9ajii+qtY15jh8AWtuo0/Q2f01LZAZMQd3A+h12IGVOJpJ2vCXnA8
	 B4gTkteFqPJvXIX+EGj0Z+v5iFLyCSbViZI3tussnISx8DK9znLeFc79U7FkNos/t8
	 k/h98O7/yaBrp6+qWtuQaf167f6z2ujPW8gbVuGF55CgS8lAOAQzhNCyer2Geml1Gr
	 Fjuz/VZ/7ThsJ1btihU8mlAYVz599lHOVEKsKKcwwYlIGoU2nZToo7XFs0XOU5t/B0
	 WZv8RPg5Lir4g==
Date: Tue, 29 Sep 2026 11:36:51 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Selvin Xavier <selvin.xavier@broadcom.com>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com, kalesh-anakkur.purayil@broadcom.com
Subject: Re: [PATCH for-rc v3 0/8]  RDMA/bnxt_re: Fix input validation and
Message-ID: <20260929083651.GI563127@unreal>
References: <20260922061230.7909-1-selvin.xavier@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922061230.7909-1-selvin.xavier@broadcom.com>

On Mon, Sep 21, 2026 at 11:12:22PM -0700, Selvin Xavier wrote:
> This series fixes some of the bugs found while auditing bnxt_re's
> handling of user-supplied values and some generic bug fixes
> 
> Please review and apply the series.
> 
> Thanks,
> Selvin Xavier
> 
>  v2 -> v3:
>   - Drop the VM_MAYEXEC clearing patch from this series. Will work on a
>     core level series which implements this in other drivers also
>   - Dropped rdev lifetime race patch from v2 series as it is reporting
>     few more review comments to be handled
>   - New fix to serialize dcb_wq against async notifier
>   - Removed is_in_used flags related patch to be posted as a separate rcfw
>     series
>  v1 -> v2:
>    - Handle review comment about clearing VM_MAYEXEC vma flag
> 
> Selvin Xavier (8):
>   RDMA/bnxt_re: Fix integer overflow in send payload size computation
>   RDMA/bnxt_re: Detect wrong sge_len passed for inline
>   RDMA/bnxt_re: Validate SRQ max_sge at create time
>   RDMA/bnxt_re: Initialize wqe.flags in bnxt_re_post_srq_recv()
>   RDMA/bnxt_re: Serialize dcb_wq access against async notifier
>   RDMA/bnxt_re: Fix the PD and DPI table size
>   RDMA/bnxt_re: Use bnxt_ext_stats_supported for counter count selection

I have applied all the patches above.

>   RDMA/bnxt_re: Validate num_sge in bnxt_re_post_srq_recv()

This needs some more work. It can be improved commit message, or code to
make sashiko happy.

Thanks
