Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB10E38C40E;
	Thu, 16 Jul 2026 09:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784193564; cv=none; b=Lf+fsXiv1X2TJoYiW2EGpL3UncetxJK3NnI2ZpW8i8Ev0XRyuQGdMYOvr1+a4OJ9jvschrP3YsdlxAr2MbOjGqb1vI+2oD/SwO9cztXmQuwjcG4HOVlngV/jN19oJMaZwjMztm1HF8MCyLDZlpR2OV5elo/LqbkNdPY4RNtEHUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784193564; c=relaxed/simple;
	bh=7hM35br6HtICzkAqAj9MjZkQWaP2xLwxcfpqwL7oI4E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dGI8Z7JbrgaXRpHyHmh3w7p0UKgqpQ5SS4p1VArQMqNQl4uMaTVcTUEZ5lt4NKJ9jE2O8DNz0YzWqsS7SKha9H1S6eAoJ6GGrJ+KnEMGEOIu4QG45g/o4L9KvCHHJ7FKqXjmGqOLELjoqpnLUXtf9Nj7h8JfmaStmVxayCO0XTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VIon6jat; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VIon6jat"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E2FA1F000E9;
	Thu, 16 Jul 2026 09:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784193562;
	bh=/Mz+kdlqEOGvVMYDCuZiJbAp0mTFr2/gm6t0R06rrdE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VIon6jat+8GjU7kXwTDMEbVuB3ABUUjfrkE0z9mcFF6PRS5zsLx6XRKnUPHsHChj3
	 qw0PTXIKN3+j1kk5J3xlw6agzmWEEOsoF+dgtXI4G0fJAoaTlnP1kZQOoQN3Z/cioC
	 mkAe+r29t3C0qZU7+rCm6FJciduT6Unf+iNriDhY/OrspJGKNV9GE2LoguZlgacJsW
	 odHTZEi8EHGiLb/B8Q/5JF26RNA7DR4/nVwb87uj+CEq0jWs5SzU4aNYuzzy1FOrHY
	 jpQppAzgmKeRSRdiKroJa/6CIS9mK2bseQDyVC5T+mY9B7ZdJNVByd28L0OE9Nlz+r
	 x7JF8MY/ZblqQ==
Date: Thu, 16 Jul 2026 12:19:16 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Abhijit Gangurde <abhijit.gangurde@amd.com>
Cc: jgg@ziepe.ca, kuba@kernel.org, davem@davemloft.net, allen.hubbe@amd.com,
	andrew+netdev@lunn.ch, brett.creeley@amd.com, edumazet@google.com,
	pabeni@redhat.com, nikhil.agarwal@amd.com,
	linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [for-next v4 0/5] ionic: RDMA completion timestamping support
Message-ID: <20260716091916.GC357857@unreal>
References: <20260610154216.712374-1-abhijit.gangurde@amd.com>
 <7c9dea7d-a551-6f6a-3c3a-e0b55497c645@amd.com>
 <20260716080110.GA70906@unreal>
 <7b5f02bb-26db-175e-34cc-40318b0752b2@amd.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b5f02bb-26db-175e-34cc-40318b0752b2@amd.com>

On Thu, Jul 16, 2026 at 02:26:22PM +0530, Abhijit Gangurde wrote:
> Thanks Leon. This is already addressed in https://patchwork.kernel.org/project/linux-rdma/patch/20260617132605.1888205-3-abhijit.gangurde@amd.com/
> which was sent after this series. Happy to rebase if needed.

You need to rebase this, as we moved ib_respond_empty_udata()
from the end of the function to the beginning.

Also, please send this as a separate patch or series.

Thanks.

> 
> 
> On 7/16/26 13:31, Leon Romanovsky wrote:
> > On Wed, Jul 15, 2026 at 06:38:06PM +0530, Abhijit Gangurde wrote:
> > > Hi Jason, Jakub,
> > > 
> > > Gentle ping — if there are no further concerns, could this series be merged
> > > through the rdma tree?
> > Jason requested converting any driver that extends udata to
> > use uverbs_robust_udata.
> > 
> > https://lore.kernel.org/linux-rdma/13-v3-bd56dd443069+49-bnxt_re_uapi_jgg@nvidia.com/
> > 
> > Thanks
> > 
> > > Thanks,
> > > Abhijit
> > > 
> > > On 6/10/26 21:12, Abhijit Gangurde wrote:
> > > > Hi,
> > > > 
> > > > This series adds RDMA completion timestamp support for ionic.
> > > > 
> > > > It enables PHC registration for RDMA timestamp capability, exposes a PHC
> > > > state page for safe user-space reads, maps that PHC state through RDMA
> > > > ucontext mmap, and extends the RDMA CQE format to carry completion
> > > > timestamps.
> > > > 
> > > > With this, user space can read completion timestamps and convert them to
> > > > wall time with low overhead.
> > > > 
> > > > Provider's PR: https://github.com/linux-rdma/rdma-core/pull/1724
> > > > 
> > > > v4:
> > > >     - Added alias mapping of mlx5_ib_clock_info to ib_uverbs_clock_info
> > > > v3:
> > > >     - Renamed ib_uverbs_phc_state to ib_uverbs_clock_info
> > > >     - Moved mlx5 to use the common clock info structure
> > > >     - Addressed review feedback from Sashiko
> > > >     - https://lore.kernel.org/linux-rdma/20260606050003.3648306-1-abhijit.gangurde@amd.com/
> > > > v2:
> > > >     - changed ionic_phc_state to ib_uverbs_phc_state and moved it under
> > > >       ib_user_verbs.h
> > > >     - https://lore.kernel.org/linux-rdma/20260512092623.1157199-1-abhijit.gangurde@amd.com/
> > > > v1:
> > > >     - https://lore.kernel.org/all/20260401102501.3395305-1-abhijit.gangurde@amd.com/
> > > > 
> > > > Abhijit Gangurde (5):
> > > >     net: ionic: register PHC for rdma timestamping
> > > >     net: ionic: Add PHC state page for user space access
> > > >     RDMA/ionic: map PHC state into user space
> > > >     RDMA/ionic: add completion timestamp to CQE format
> > > >     RDMA/mlx5: move mlx5 clock info to common struct ib_uverbs_clock_info
> > > > 
> > > >    .../infiniband/hw/ionic/ionic_controlpath.c   | 34 ++++++++++
> > > >    drivers/infiniband/hw/ionic/ionic_datapath.c  | 43 ++++++-------
> > > >    drivers/infiniband/hw/ionic/ionic_fw.h        | 12 +++-
> > > >    drivers/infiniband/hw/ionic/ionic_ibdev.h     |  2 +
> > > >    drivers/infiniband/hw/ionic/ionic_lif_cfg.c   |  2 +
> > > >    drivers/infiniband/hw/ionic/ionic_lif_cfg.h   |  1 +
> > > >    .../ethernet/pensando/ionic/ionic_ethtool.c   | 12 ++--
> > > >    .../net/ethernet/pensando/ionic/ionic_if.h    |  1 +
> > > >    .../net/ethernet/pensando/ionic/ionic_lif.c   |  5 +-
> > > >    .../net/ethernet/pensando/ionic/ionic_lif.h   |  3 +-
> > > >    .../net/ethernet/pensando/ionic/ionic_phc.c   | 63 ++++++++++++++++---
> > > >    include/uapi/rdma/ib_user_verbs.h             | 33 ++++++++++
> > > >    include/uapi/rdma/ionic-abi.h                 |  1 +
> > > >    include/uapi/rdma/mlx5-abi.h                  | 15 ++---
> > > >    14 files changed, 179 insertions(+), 48 deletions(-)
> > > > 
