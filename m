Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34EE3E7633;
	Mon, 10 Aug 2026 13:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786367118; cv=none; b=bmJBH2M+/zjKCzAfostitRO2mXji/vIZbUrhBY+tVMu8AVYMQzk3GCl6qnnKCWQJA/9xIAN6XcTgm8xvTEEvLBssJhPStXW4ocvn1tLzZUmxZTT2h1LZ0VU1SiREgblDV+mlKMFP/B2/mBSup6RH+mlmw0/mu4BrowUEZKWR80w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786367118; c=relaxed/simple;
	bh=SI7rS+wrO8NrHX2bjLVDJfhdPM6X2tKBj6YpYYkVG5E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J6ZtNJtKxQSZBSIgFcFkd9wmAXEDYi6NK8WmLaP5pI6E1eyQlYJQ1PGNcG9Bz4P/SvgNoQKUK9g5ud8GkGywalZ91TopWsiFznmuWnzWDH+NPj3jSfbzDkHLnU9FZiuu5/ySknxd0aK9fRYQLU3Ygg8NSwhXU3G9oCG38/6H0AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mJU7pMki; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mJU7pMki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9131F000E9;
	Mon, 10 Aug 2026 13:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786367116;
	bh=TBvVqD6xlWW1BUcQzsSV2rAh8UoSNAz3Lc8JWdfBxWI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mJU7pMkixuMQCh/QnrFaVT86aaOBeP22kN4iKrW6CbrOh4ktiiXfcyObr/qPRJrY3
	 4jrIkNGps/VPH1FyJ6+Pq/F/XJcVHfoyhm8JLNvsBEJRr5dFHGkKmRqybe2DsRBuA9
	 n4VrottPLAmqlzWZ1lrW22NCxz18ZIyIGmRBb3aDWhQzGiJJbTJGLOovqQN07WjHIX
	 +3lHL7ckJ91tYMHs3sQYFubDlzEydueRb655LL4ZWe2XCoRXWl2UXb522HzJAwcJWr
	 L6wlRMLfnLKHZssK3mBmp8Nap4FpAoVK4vAYibScJV8PvWWMRHPQNpjV59afjylN3Y
	 dedkDuCEQ/9TA==
Date: Mon, 10 Aug 2026 16:05:10 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Michael Gur <michaelgur@nvidia.com>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
	Edward Srouji <edwards@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH rdma-next 00/15] RDMA: Support HW requiring relaxed
 ordering and add Unordered access flag
Message-ID: <20260810130510.GA90355@unreal>
References: <20260726092943.2880176-1-michaelgur@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260726092943.2880176-1-michaelgur@nvidia.com>

On Sun, Jul 26, 2026 at 12:29:14PM +0300, Michael Gur wrote:
> This series prepares the mlx5 stack for hardware that restricts strong-
> ordered memory accesses, i.e. HW whose fabric doesn't guarantee memory
> operation ordering. The HW may choose to reject creation of an mkey that
> doesn't request relaxed ordering, so every mkey the driver creates -
> internal and user-facing - has to be handled accordingly.
> 
> The previously added 'ConnectX-10 NVLink-C2C' PCI device is such a device,
> as will be any future PCIe Gen7 UIO devices. 
> 
> The series does four things:
> 
> 1. Allow optional access flags on all memory registration
>    The uverbs ABI defines the optional access flags range as best-effort:
>    drivers must accept any flag in this range and treat support as
>    opportunistic, never failing registration. Several registration paths
>    (DM, DEVX UMEM, dmabuf ioctl, reg_mr ioctl) did not allow this range
>    and would reject such requests. These are fixed to allow newly added
>    optional access flag added later in the series and any future optional
>    access flag.
> 
> 2. Groundwork and internal mkeys
>    Rename the relaxed-ordering IFC fields to the new naming, add the new
>    ordering capability and mkey-context bits, and consolidate RO-setting
>    to a single helper in mlx5_core so all consumers share one cap-gated
>    implementation. Then enable relaxed ordering on the internal mkeys that
>    don't require strong ordering (resource dump, vfio live-migration data,
>    ODP null mkey, memory window mkey), so they keep working on strict-RO
>    HW.
> 
> 3. New Unordered access flag and enforcement
>    Add IB_ACCESS_UNORDERED, an optional access flag that additionally
>    allows read-after-write reordering, and wire up mlx5 support for it.
> 
> 4. Enforce no-strong-ordering in user MR registration on HW that requires
>    it.
> 
> Michael Gur (15):
>   RDMA/mlx5: Allow optional access flags in DM registration
>   RDMA/mlx5: Allow optional access flags in DEVX UMEM registration
>   RDMA/core: Allow optional access flags in dmabuf reg ioctl
>   RDMA/core: Allow optional access flags in reg mr ioctl
>   mlx5: Rename IFC bits of relaxed ordering fields
>   net/mlx5: Add IFC bits for new ordering caps
>   mlx5: Move RO setting helper to core and consolidate mlx5 consumers
>   net/mlx5: Enable relaxed ordering on resource dump mkey
>   vfio/mlx5: Enable relaxed ordering on the live migration data mkey
>   RDMA/mlx5: Enable relaxed ordering on ODP null mkey
>   RDMA/mlx5: Enable relaxed ordering on Memory Window mkey on strict-RO
>     HW
>   RDMA/mlx5: Converge UMR access-flag cap checks
>   RDMA/uverbs: Add new Unordered MR access flag
>   RDMA/mlx5: Support new Unordered access flag
>   RDMA/mlx5: Enforce relaxed ordering when HW requires it
> 
>  drivers/infiniband/core/umem.c                |  2 +-
>  drivers/infiniband/core/uverbs_std_types_mr.c |  4 +-
>  drivers/infiniband/hw/mlx5/devx.c             |  2 +-
>  drivers/infiniband/hw/mlx5/main.c             |  8 +-
>  drivers/infiniband/hw/mlx5/mlx5_ib.h          |  4 +-
>  drivers/infiniband/hw/mlx5/mr.c               | 79 ++++++++++---------
>  drivers/infiniband/hw/mlx5/odp.c              |  1 +
>  drivers/infiniband/hw/mlx5/umr.c              | 18 ++---
>  drivers/infiniband/hw/mlx5/umr.h              | 45 ++++++-----
>  .../mellanox/mlx5/core/diag/rsc_dump.c        |  1 +
>  drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 -
>  .../ethernet/mellanox/mlx5/core/en/params.c   |  2 +-
>  .../ethernet/mellanox/mlx5/core/en_common.c   | 13 +--
>  .../net/ethernet/mellanox/mlx5/core/en_main.c |  4 +-
>  drivers/net/ethernet/mellanox/mlx5/core/mr.c  | 21 +++++
>  drivers/vfio/pci/mlx5/cmd.c                   |  7 +-
>  include/linux/mlx5/driver.h                   |  1 +
>  include/linux/mlx5/mlx5_ifc.h                 | 24 ++++--
>  include/rdma/ib_verbs.h                       |  1 +
>  include/uapi/rdma/ib_user_ioctl_verbs.h       |  1 +
>  20 files changed, 134 insertions(+), 105 deletions(-)

Sashiko is not happy about this series.

Thanks

> 
> -- 
> 2.52.0
> 
