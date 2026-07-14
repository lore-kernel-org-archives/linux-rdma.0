Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CE23D3CE6
	for <linux-rdma@vger.kernel.org>; Tue, 14 Jul 2026 12:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784031590; cv=none; b=n9ewZwMCopew5LDhIs27h71L1A3iroP0JY6BidIJuigikejIzwTpFTjOt7m60Cf/QRcJ0Dsk42Vumx0Qd6tHJn/9RlC+szF4kWDzgHWDQQ0ST/VG5soJyFNwtkksDy5sxt+AGYB/RYmVtr+i6EZ/GzwPvfcIPJt2bJuslJThOBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784031590; c=relaxed/simple;
	bh=y/ZoBo4jqjK2u7yyV2dT274h6pS6jqasM0Sj/X/gQhg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q0qOI+A9u/W7HCeZ6POVBzU5FHrCvDnoU6GucEFL4fvRKkQdiOiXMBs6M3885hAAmYWUzurSKp/CyazV8yUo334JdZr4nMeuPpGHebX+5KTzD64z5R4KsFeNaiPlEjDCmZZR2kfozplqqi6WHfY/Dhx43o+z7s9tlxgT6OYfFdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O3Au0MbC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O3Au0MbC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5F01F000E9;
	Tue, 14 Jul 2026 12:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784031588;
	bh=GgFwEpsrkGWUXnPMSVT43eFMaUI7iGaM+J9DQYQo1+Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=O3Au0MbCU/nnR8V2fW1QvrEMU1cLEx8exzNHorTVbOc9seIOk4nNnvlAdSIh7kj8N
	 I48E9pxMn+21J8szg39kYmBrMJLVkAo+mmlFG1HUYeh56nqyEECA4PnstCjnXkF/oq
	 vBq6fEyH5+KuDLvzGkzBp6WuJ0IkbG4K1ogjQtvsx40Tb4ONb+DsCQmSKSuYc7ZFKJ
	 wRWeG/bf4XVdYt1IdmBUhxuxtjKrUP52JAlVQDfvVMi6q+S3CBTjDtYmLZtCrNExJN
	 u2oTc8CuAL7BaHPSfvWdc8zxZkMVtp4RnCcEHP1bKYrD1bzsO4Gmtd94SYhRS0Nq5Y
	 G3JOXiF1RCsmw==
Date: Tue, 14 Jul 2026 15:19:44 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Selvin Xavier <selvin.xavier@broadcom.com>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com, kalesh-anakkur.purayil@broadcom.com,
	sriharsha.basavapatna@broadcom.com, alhouseenyousef@gmail.com
Subject: Re: [PATCH for-next v3 1/4] RDMA/bnxt_re: Replace per-device hash
 tables with per-context XArrays
Message-ID: <20260714121944.GC19233@unreal>
References: <20260713135830.1934471-1-selvin.xavier@broadcom.com>
 <20260713135830.1934471-2-selvin.xavier@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713135830.1934471-2-selvin.xavier@broadcom.com>

On Mon, Jul 13, 2026 at 06:58:27AM -0700, Selvin Xavier wrote:
> The CQ and SRQ hash tables (cq_hash, srq_hash) on struct bnxt_re_dev
> were used exclusively to look up a toggle-page pointer from a
> user-space-supplied hardware queue ID in the GET_TOGGLE_MEM
> ioctl handler. This approach has couple of problems. First,
> because the tables are per-device, any user can look up another
> user's CQ or SRQ by guessing the hardware queue ID. Second,
> concurrent add and remove operations on the hash table are not
> protected by any lock, leaving a race window.
> 
> The correct fix is to retrieve the CQ and SRQ objects via the uverbs
> object handle, which gives built-in ownership verification and reference
> pinning for the duration of the ioctl. That is added in the next patch of
> this series.
> 
> To maintain backward compatibility with older rdma-core versions that
> do not send a uverbs object handle, the driver must continue to support
> the existing TYPE + RES_ID lookup path. This patch replaces the per-device
> hash tables with per-ucontext XArrays (cq_xa and srq_xa on struct
> bnxt_re_ucontext), which narrows the lookup scope to the calling context,
> eliminating the cross-user visibility. Also adds Xarray locking mechanism
> for synchronization.
> 
> The GET_TOGGLE_MEM ioctl handler is updated to call xa_load()
> in place of the now-removed bnxt_re_search_for_cq()/
> bnxt_re_search_for_srq() helpers. No ABI changes are required.
> 
> Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
> ---
>  drivers/infiniband/hw/bnxt_re/bnxt_re.h  |  5 --
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c | 76 ++++++++++++++++++------
>  drivers/infiniband/hw/bnxt_re/ib_verbs.h |  6 +-
>  drivers/infiniband/hw/bnxt_re/main.c     |  4 --
>  drivers/infiniband/hw/bnxt_re/uapi.c     | 75 ++++++++---------------
>  5 files changed, 87 insertions(+), 79 deletions(-)

<...>

> +		if (uctx) {
> +			xa_lock(&uctx->srq_xa);
> +			__xa_erase(&uctx->srq_xa, srq->qplib_srq.id);
> +			xa_unlock(&uctx->srq_xa);

Something very minor, there is no need in this lock->__erase->unlock
pattern, use xa_erase() directly as it will perform locking internally.

> +			free_page((unsigned long)srq->uctx_srq_page);

It is worth to get rid of get_zeroed_page/free_page too.
https://lore.kernel.org/linux-rdma/20260713-b4-rdma-v2-0-65d2a1a5180c@kernel.org/T/#t

Thanks
