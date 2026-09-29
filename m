Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDEB525A6D;
	Tue, 29 Sep 2026 18:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790708343; cv=none; b=e7w3nXu98Xjex+b0zET53YCiv7VIpnGdm1eU/2lFmrbhI1vZr6zbWYKWJ1RKSxwzKbqsdgpG2e0S4BGRs540GY3HdexcOC+hHF59cNZpQKKylCzaNtkrkvyMZrWuf7+bQkLHwdHxF1MvAJty5/+fR4wvMRyuqn9BbtMMGnCSFPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790708343; c=relaxed/simple;
	bh=cWonhJRalJLXnftzu+LfAVdePNoCPDblhVgV1xxh8WY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qbu2ktmc7Qtli4TwfOUHvLzcFLecXS5kxng6Nr3SN2IkDMZSA3w6kaOj4R5HFAmMWuFJ7y8CTzsSv4yhvDobdZwCUxu2C/yTiqUZeq5tMSzFX6sIgdER1uyW4RkYmM08ZgSM0gXWFNDYk6nhxplYw+0sCdCGZ+74/o+jy7sSIoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BCDJBic1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BCDJBic1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 364AF1F000FF;
	Tue, 29 Sep 2026 18:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790708341;
	bh=bKQYBufBAkZxK6CAUH1qqCMHbW6LuXVauQVyjo0TnxI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BCDJBic1ZhkD7SM3a504pnODCrzuKUrlwxH3wTvEOi3lAs1DVLCt/5+cG9s/igsRf
	 G/3HaojKnw0pbuRqbDKdKcCLwtivrizuVc2+6g0XqhHHSGuCCW+0f4qcyBN+zXGtnx
	 TG2vRwMPpTsnpX9+BUhUhB7nDRb7ixSK1TuTC0+6ivMQKyv/2PxvXytDSk1iKJHBgu
	 YUQv3SFyS5DcUUfW7Kw3pifICWyamJ9fFb9jzRdaASy/EK/1AfXQCuoV/s+4zzJGh6
	 ZSIXLOhhjj8GxfzD98AaQTasKHt8EvXmhSV+B24ImbM6g/OlZLbVXKMLMDot04NshC
	 hzwToBHiDL/+w==
Date: Tue, 29 Sep 2026 21:58:57 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Abhijit Gangurde <abhijit.gangurde@amd.com>
Cc: jgg@ziepe.ca, brett.creeley@amd.com, andrew+netdev@lunn.ch,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, allen.hubbe@amd.com, a.k@amd.com,
	nikhil.agarwal@amd.com, linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [for-next v3 0/5] RDMA/ionic: add SRQ support and firmware
 assigned CQ and SRQ IDs
Message-ID: <20260929185857.GL563127@unreal>
References: <20260925082802.2675902-1-abhijit.gangurde@amd.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925082802.2675902-1-abhijit.gangurde@amd.com>

On Fri, Sep 25, 2026 at 01:57:57PM +0530, Abhijit Gangurde wrote:
> This series adds ionic Shared Receive Queue support and lets firmware assign
> CQ/SRQ IDs when the LIF advertises qid-allocation capability.
> 
> Patch 1: extends the RDMA LIF identity with SRQ qtype and alloc_qid_cap.
> Patch 2: uses that for firmware-assigned CQ IDs and splits CQ create/destroy
> so cq_tbl is updated only after the ID is known, and removed before the ID
> is returned to firmware.
> Patches 3: Refactor RQ state into ionic_rq so QP RQ and SRQ share init/destroy.
> Patches 4-5: add SRQ verbs and EQ events. Userspace ABI field srqid is new
> with this series;
> 
> rdma-core PR: https://github.com/linux-rdma/rdma-core/pull/1799
> Net changes pull request:
> The following changes since commit 93f51579e7df248780214094418f205253383cc5:
> 
>   Linux 7.3-rc4 (2026-09-20 13:48:15 -0700)
> 
> are available in the Git repository at:
> 
>   https://github.com/abhijitG-xlnx/linux.git ionic-shared
> 
> for you to fetch changes up to c73a5f20bc786df0be484af29aa5956e909dc862:
> 
>   net: ionic: Fetch qid allocation and SRQ capability from firmware (2026-09-25 11:48:12 +0530)
> 
> v3:
>   - Addressed more sashiko review comments
>   - https://lore.kernel.org/linux-rdma/20260922095724.3683011-1-abhijit.gangurde@amd.com/T/
> v2:
>   - Addressed sashiko review comments
>   - https://lore.kernel.org/linux-rdma/20260908090802.152142-1-abhijit.gangurde@amd.com/T/
> 
> Abhijit Gangurde (2):
>   net: ionic: Fetch qid allocation and SRQ capability from firmware
>   RDMA/ionic: support firmware-assigned CQ IDs
> 
> Amit Kumar (3):
>   RDMA/ionic: segregate rq related fields from ionic_qp into a new
>     ionic_rq struct
>   RDMA/ionic: add Shared receive queue (SRQ) support
>   RDMA/ionic: implement SRQ event handling support
> 
>  drivers/infiniband/hw/ionic/ionic_admin.c     | 117 ++-
>  .../infiniband/hw/ionic/ionic_controlpath.c   | 785 +++++++++++++-----
>  drivers/infiniband/hw/ionic/ionic_datapath.c  |  98 ++-
>  drivers/infiniband/hw/ionic/ionic_fw.h        |  74 +-
>  drivers/infiniband/hw/ionic/ionic_ibdev.c     |  20 +
>  drivers/infiniband/hw/ionic/ionic_ibdev.h     |  85 +-
>  drivers/infiniband/hw/ionic/ionic_lif_cfg.c   |   2 +
>  drivers/infiniband/hw/ionic/ionic_lif_cfg.h   |   2 +
>  .../net/ethernet/pensando/ionic/ionic_if.h    |  31 +-
>  include/uapi/rdma/ionic-abi.h                 |   2 +-
>  10 files changed, 925 insertions(+), 291 deletions(-)

It doesn't apply, please rebase and resend.

Thanks

> 
> -- 
> 2.43.0
> 
