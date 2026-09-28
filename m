Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775852F0C74
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 12:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790597841; cv=none; b=F9GGZd9Q4W62r+tzvNYUMU9yy1gLUnVQ8cqS3nJg7Lfq0sNBSiOp0OLCrz/RIKcP+oGvVk8OMiwAvqV4gqtlireKIPt+qkxp/nC8Etg9DMDsBQgDDpkGqcNUvbScWS/x/q404nrjNdpkQxs48j7ccIyL36nVKN5zIwxFZgFUkSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790597841; c=relaxed/simple;
	bh=bQPLkuX9oNYwtjJOO5IQ+BEGQDPuBscea5g57HN4ZLQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=c50CarDv4IE9T1dZnd644pYykkUknyLZFvf7aSOhmngcspIwcfPzpd+OVkOVYyWhf0K8se24dr64UQJBz0ZFWLWjBax80BLnLG8ehP44jM31UC8N+WMFGd6pZS8TQn61aSNf7F1S7qxh3zQUsjorVjieh6RJM1DTYo2MjI4wT+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M7QdsQGF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M7QdsQGF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4351F000FF;
	Mon, 28 Sep 2026 12:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790597840;
	bh=nirCKRATW6pckb2rxDd641IepW2QQItdXnj21AZWrsE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=M7QdsQGFsa3OMnt+zgNc5xdcdif1cf+/4piRmx6mmpXSOn50HDYGeslqHbEikprkf
	 kxP/dk+eeejNVYA4a98P1Zy2jNv0jQ0Y3Beop6jyAYomiYbwycrmddssdIxWVWsBmq
	 XroFKKu+ihjfQbUnJG5z0qvwPXNd+KGiipZXVOPev/myRWe0xGbRFQu0SxS1b/uDeR
	 vXY0XV8aA8deyP6lUT4hZCpDA022zN9tZb3wpYmrwiYdGxiJmjRPgMS+jITS3NYP9G
	 EYq+poFI8eDqroogrUQRfDzgP4P/BtlaxZRdlWyx17myyDJHYjb9Jj8x1fSRE73dBn
	 TuV3JI5S5IRUQ==
From: Leon Romanovsky <leon@kernel.org>
To: jgg@ziepe.ca, Yishai Hadas <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org, selvin.xavier@broadcom.com, 
 kalesh-anakkur.purayil@broadcom.com, chengyou@linux.alibaba.com, 
 kaishen@linux.alibaba.com, tangchengchang@huawei.com, 
 huangjunxian6@hisilicon.com, abhijit.gangurde@amd.com, allen.hubbe@amd.com, 
 longli@microsoft.com, kotaranov@microsoft.com, mkalderon@marvell.com, 
 bryan-bt.tan@broadcom.com, vishnu.dasa@broadcom.com, maorg@nvidia.com
In-Reply-To: <20260915140933.40580-1-yishaih@nvidia.com>
References: <20260915140933.40580-1-yishaih@nvidia.com>
Subject: Re: [PATCH V1 rdma-next 00/15] DMA direction and mlx5 driver
 correctness fixes
Message-Id: <179059783727.3916571.17336446430052997316.b4-ty@kernel.org>
Date: Mon, 28 Sep 2026 08:17:17 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Tue, 15 Sep 2026 17:09:18 +0300, Yishai Hadas wrote:
> This series contains two independent groups of fixes for the RDMA
> subsystem.
> 
> Group 1: DMA direction correctness (patches 1-7).
> 
> RDMA drivers have historically mapped all pinned user buffers
> DMA_BIDIRECTIONAL regardless of how the device actually accesses them.
> This group tightens the DMA mapping direction to match the real access
> pattern for each buffer type:
> 
> [...]

Applied, thanks!

[01/15] RDMA/erdma: Pin CQ buffer writable to match device DMA write access
        https://git.kernel.org/rdma/rdma/c/ba3472ed6718bf
[02/15] RDMA/hns: Pin CQ buffer writable to match device DMA write access
        https://git.kernel.org/rdma/rdma/c/ce29f6e741844a
[03/15] RDMA/vmw_pvrdma: Pin QP and SRQ rings writable to match device DMA write access
        https://git.kernel.org/rdma/rdma/c/89abac4b60b708
[04/15] RDMA/umem: Reuse ib_umem_get_cq_buf_or_va() for VA-only CQ pinning
        https://git.kernel.org/rdma/rdma/c/b577999f6f8dbf
[05/15] RDMA/umem: Support an explicit DMA direction other than DMA_BIDIRECTIONAL
        https://git.kernel.org/rdma/rdma/c/2445d74c465ac0
[06/15] RDMA/umem: Map CQ buffers DMA_FROM_DEVICE
        https://git.kernel.org/rdma/rdma/c/50b96c3e3feb61
[07/15] RDMA/umem: Derive DMA direction from IB access flags
        https://git.kernel.org/rdma/rdma/c/dfc5334af5667e
[08/15] RDMA/mlx5: Fix mlx5_ib_dev_res_init() failure when XRC cap is absent
        https://git.kernel.org/rdma/rdma/c/4354ab7a85d1dd
[09/15] RDMA/mlx5: Put resource reference in mlx5_ib_wq_event()
        (no commit info)
[10/15] RDMA/mlx5: Set WQ event handler before firmware RQ insertion
        https://git.kernel.org/rdma/rdma/c/28c559d1e25de4
[11/15] RDMA/mlx5: Set SRQ event handler before xarray insertion
        https://git.kernel.org/rdma/rdma/c/d2aa15620e98dc
[12/15] RDMA/mlx5: Set RQ event handler for raw-packet QP
        https://git.kernel.org/rdma/rdma/c/a4fa6497002c80
[13/15] RDMA/mlx5: Set QP event handler before firmware QPC insertion
        https://git.kernel.org/rdma/rdma/c/05a078c97eb0bb
[14/15] RDMA/mlx5: Initialize QP/RQ/SQ resource refcount before publishing it
        https://git.kernel.org/rdma/rdma/c/829a0e65deff3f
[15/15] RDMA/mlx5: Fix signed integer overflow in EQE qp_srq type shift
        https://git.kernel.org/rdma/rdma/c/86959c7d009f60

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

