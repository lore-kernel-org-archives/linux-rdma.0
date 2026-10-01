Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA88352941D;
	Thu,  1 Oct 2026 15:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790869290; cv=none; b=gKpnRI5+Ouxr2grrQkjuUaGon/9HPOHl85pb8MhWNdzd/QKACRxIUWSaWtnvpl/7deHyN3a+07DMVoaVA46apQByOwO51bac/hKi49lMhbVCv0XJ5KUP2HwESO2B5oKMKoiLrFfKKkW3xz3P4/ioIT5V6W7jqNWJ9rd+DfVSUPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790869290; c=relaxed/simple;
	bh=upwG9Ajb7HiwDiz7s2DT2P4aDUU67N+8gTTyElgRGi8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=OaIspFpii3dT+URzG9EDpSvjGLf/X1wNpvK9kdNhVpmsSiapsaCLBsLgfHfsFHz4o2hEwJC1QNPjiHb5Wf5d76imHnHj3BEm4eucL1HoeJtmEsP2j7xIj6Uo7w8H7ufyx6RelcdO/tX2jqiy9YRlSFNYBzcmuOMYv/GaNph+wDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TQZYxOq1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TQZYxOq1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3D31F000FF;
	Thu,  1 Oct 2026 15:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790869288;
	bh=/4WbIgH97AoP+BHwk2QH+RwEoL7rad4fL8/FcXMQ58U=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=TQZYxOq1enRn0kLrEZobjY86WDij0EAsM0P17ASk7dENutZLrE9nQkP5v85NmWYKb
	 1+HWKTb2XYDtx/Z8Ish+jRdNPsDWhVmTcyTHf8QbeSh1bjEHoDPZvm5mDa0NeUK1cI
	 YgUnfYcOahXe+cFvGEfonuOEN2SFsO/t1OuKjcYF4SMP939K2haR/gCsvfcGLdHWRz
	 NUytH1A2ujT/XuuMySwF7qwz4BeRjDnxFz2FnAcmdXubBxcVaEI1NEVVUY5Zj8diql
	 irCiFL5WjZveCBw2jdcfJPsPSUaH1zjO1FWgeOw74Vrak5lleehc+jl2+TVLAa9om3
	 UlcyhkI6jUOFA==
From: Leon Romanovsky <leon@kernel.org>
To: linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>, 
 netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>, 
 Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, Cosmin Ratiu <cratiu@nvidia.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Dragos Tatulea <dtatulea@nvidia.com>, Eric Dumazet <edumazet@google.com>, 
 Gal Pressman <gal@nvidia.com>, Jakub Kicinski <kuba@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, open list <linux-kernel@vger.kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Leon Romanovsky <leon@kernel.org>
In-Reply-To: <20260930114227.139274-1-tariqt@nvidia.com>
References: <20260930114227.139274-1-tariqt@nvidia.com>
Subject: Re: [PATCH mlx5-next V2 00/10] mlx5: Move data direct
 infrastructure to mlx5_core
Message-Id: <179086928533.370711.525345553365862636.b4-ty@kernel.org>
Date: Thu, 01 Oct 2026 11:41:25 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 30 Sep 2026 14:42:17 +0300, Tariq Toukan wrote:
> Data direct support currently lives in mlx5_ib, which owns the data
> direct PCI driver, device matching and resource management. To prepare
> for data direct support in netdev, move this infrastructure to mlx5_core
> and provide a common interface for its consumers.
> 
> The series first replaces the direct IB unbind callback with a blocking
> notifier chain, allowing multiple consumers to receive unbind events.
> It then separates consumer registration from initialization,
> consolidates the per-device state and resources, and keeps IB-specific
> locking and MR teardown in mlx5_ib.
> 
> [...]

Applied, thanks!

[01/10] RDMA/mlx5: Notify data direct users via a notifier chain on unbind
        https://git.kernel.org/rdma/rdma/c/a727a424068b5d
[02/10] RDMA/mlx5: Add mlx5_data_direct_supported() helper
        https://git.kernel.org/rdma/rdma/c/2365f8d7f609cf
[03/10] RDMA/mlx5: Make the data direct VUID query self-contained
        https://git.kernel.org/rdma/rdma/c/ebbb9f87689998
[04/10] RDMA/mlx5: Give the data direct PCI driver a proper name
        https://git.kernel.org/rdma/rdma/c/0a4095faca722b
[05/10] RDMA/mlx5: Move and rename data direct resource functions
        https://git.kernel.org/rdma/rdma/c/47723d4febd62b
[06/10] RDMA/mlx5: Add new registration stage for data direct users
        https://git.kernel.org/rdma/rdma/c/1c879b1e9f2ed6
[07/10] RDMA/mlx5: Extract IB specific lock out of data direct
        https://git.kernel.org/rdma/rdma/c/26f27809b0034e
[08/10] RDMA/mlx5: Consolidate data direct state into one object
        https://git.kernel.org/rdma/rdma/c/f6c452b311f0e4
[09/10] RDMA/mlx5: Pull data_direct resource creation in init phase
        https://git.kernel.org/rdma/rdma/c/7611034dc86cfd
[10/10] mlx5: Move data direct implementation to mlx5_core
        https://git.kernel.org/rdma/rdma/c/00290b9ff59ef4

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

