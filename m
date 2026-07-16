Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DADD7348C7D;
	Thu, 16 Jul 2026 08:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784188878; cv=none; b=G8HtZ83TJha7u1DIs926ff0j4YyOiDevlU/tq2TX0vawtIQZfEAdV/Vz7/w4BfXfLfDTLy4YzKO1TCsNbCeSkuvSdAmgMOIbQBbEwKuNtzC0Ws3YwPHfKqV4+61/I/UQwwqouNYPWL17RMeXi1FKxFffM8gXoG6smWnCEkOuN+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784188878; c=relaxed/simple;
	bh=5NUKSF+3ziXsrHkaOz8cg7W8bNV+FxbN/Kw4pImOsIg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FgADUWHwbDY01tHOfVNlHYBgAtjAeGUtjmDkg8EQqsxLpn9Petyj51zBcYCB/PsMZ5mDCPFJu3/tTJWkL73Af6DZ7oHmKhzL0iT56M5Yg6jzMMF8QF5WHNWTt4L9hSzXDHng7YX7e9ySYG36EYXLifm3HYjsOSmwDzj1tXmXn/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LO70z5mg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LO70z5mg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF931F000E9;
	Thu, 16 Jul 2026 08:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784188876;
	bh=yKztRyeQzLRt8X/OrCjjwbJIBJH99esVB1d4pT24fdY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LO70z5mg/8IKjr+XYBL4vjIV3YEmLkeWB89X39y/s/9sf5pYMc3IN/Odlxdks/JVg
	 WM0+auOCpbj4SwVfABzgh/pWpC/WmQtrshoayHJb126LL8MkFOZUg36HMY6AVU8zZc
	 brRQDVA8H9sMoTZkAHB3CmvApP8YV6gx2Mg22re799oNua0SZxOY3n4UKjsfvJIhXg
	 nOSDcxbwueehPTDINSfc5+SNVcBfUiQV3WZy6XU0jFoBgNs3z9Z6kLB7a815CVmKTu
	 usaIIlqMG2I/2q/TJLpYMxCsO3lg8Xu6S++5Gq2Hnn19j4JWLDCIBRk/6Vp+Ec3jcz
	 NDYDYRrfd9uAg==
Date: Thu, 16 Jul 2026 11:01:10 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Abhijit Gangurde <abhijit.gangurde@amd.com>
Cc: jgg@ziepe.ca, kuba@kernel.org, davem@davemloft.net, allen.hubbe@amd.com,
	andrew+netdev@lunn.ch, brett.creeley@amd.com, edumazet@google.com,
	pabeni@redhat.com, nikhil.agarwal@amd.com,
	linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [for-next v4 0/5] ionic: RDMA completion timestamping support
Message-ID: <20260716080110.GA70906@unreal>
References: <20260610154216.712374-1-abhijit.gangurde@amd.com>
 <7c9dea7d-a551-6f6a-3c3a-e0b55497c645@amd.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7c9dea7d-a551-6f6a-3c3a-e0b55497c645@amd.com>

On Wed, Jul 15, 2026 at 06:38:06PM +0530, Abhijit Gangurde wrote:
> Hi Jason, Jakub,
> 
> Gentle ping — if there are no further concerns, could this series be merged
> through the rdma tree?

Jason requested converting any driver that extends udata to
use uverbs_robust_udata.

https://lore.kernel.org/linux-rdma/13-v3-bd56dd443069+49-bnxt_re_uapi_jgg@nvidia.com/

Thanks

> 
> Thanks,
> Abhijit
> 
> On 6/10/26 21:12, Abhijit Gangurde wrote:
> > Hi,
> > 
> > This series adds RDMA completion timestamp support for ionic.
> > 
> > It enables PHC registration for RDMA timestamp capability, exposes a PHC
> > state page for safe user-space reads, maps that PHC state through RDMA
> > ucontext mmap, and extends the RDMA CQE format to carry completion
> > timestamps.
> > 
> > With this, user space can read completion timestamps and convert them to
> > wall time with low overhead.
> > 
> > Provider's PR: https://github.com/linux-rdma/rdma-core/pull/1724
> > 
> > v4:
> >    - Added alias mapping of mlx5_ib_clock_info to ib_uverbs_clock_info
> > v3:
> >    - Renamed ib_uverbs_phc_state to ib_uverbs_clock_info
> >    - Moved mlx5 to use the common clock info structure
> >    - Addressed review feedback from Sashiko
> >    - https://lore.kernel.org/linux-rdma/20260606050003.3648306-1-abhijit.gangurde@amd.com/
> > v2:
> >    - changed ionic_phc_state to ib_uverbs_phc_state and moved it under
> >      ib_user_verbs.h
> >    - https://lore.kernel.org/linux-rdma/20260512092623.1157199-1-abhijit.gangurde@amd.com/
> > v1:
> >    - https://lore.kernel.org/all/20260401102501.3395305-1-abhijit.gangurde@amd.com/
> > 
> > Abhijit Gangurde (5):
> >    net: ionic: register PHC for rdma timestamping
> >    net: ionic: Add PHC state page for user space access
> >    RDMA/ionic: map PHC state into user space
> >    RDMA/ionic: add completion timestamp to CQE format
> >    RDMA/mlx5: move mlx5 clock info to common struct ib_uverbs_clock_info
> > 
> >   .../infiniband/hw/ionic/ionic_controlpath.c   | 34 ++++++++++
> >   drivers/infiniband/hw/ionic/ionic_datapath.c  | 43 ++++++-------
> >   drivers/infiniband/hw/ionic/ionic_fw.h        | 12 +++-
> >   drivers/infiniband/hw/ionic/ionic_ibdev.h     |  2 +
> >   drivers/infiniband/hw/ionic/ionic_lif_cfg.c   |  2 +
> >   drivers/infiniband/hw/ionic/ionic_lif_cfg.h   |  1 +
> >   .../ethernet/pensando/ionic/ionic_ethtool.c   | 12 ++--
> >   .../net/ethernet/pensando/ionic/ionic_if.h    |  1 +
> >   .../net/ethernet/pensando/ionic/ionic_lif.c   |  5 +-
> >   .../net/ethernet/pensando/ionic/ionic_lif.h   |  3 +-
> >   .../net/ethernet/pensando/ionic/ionic_phc.c   | 63 ++++++++++++++++---
> >   include/uapi/rdma/ib_user_verbs.h             | 33 ++++++++++
> >   include/uapi/rdma/ionic-abi.h                 |  1 +
> >   include/uapi/rdma/mlx5-abi.h                  | 15 ++---
> >   14 files changed, 179 insertions(+), 48 deletions(-)
> > 
