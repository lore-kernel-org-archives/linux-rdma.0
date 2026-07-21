Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B897A3D3CE4
	for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 07:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.13.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784620795; cv=none; b=rouSdr6xjbE4R894rzkPi+TZWNZHyK/WDQ2Ue0RuKE7wNaa5rRzSsUSZswj5xYiToYt/2N+AqnhwYriAZ699+Z74/tr21nGqAJAOOeXd+ytoB89QKiHcWA80YjI6WlQRO2mw7841pOFIXZbrSCh8IFOJK1f9qgeIMCvN2WJCp1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784620795; c=relaxed/simple;
	bh=txkJ31LwnHaR/Q9HLAlOCffz6QfFekXES17bTSxBcGQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TGbUXwdnrhF+GI8x0+pAYi3egABLdvQZ2toTNJnz6zjuREz8JvlsjgQK5fGzUHhICOCFMa11bDTnSiA/dUUeGpFu1iOiMpwmLUzlc9ivwc/t/eKyx4P+mtcfNY8gRzGw9uXRn5IlfqVM9MISylF7ReXjbLyYKI+n915qzetwKLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=tYZEN1bP; arc=none smtp.client-ip=52.13.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="tYZEN1bP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1784620793; x=1816156793;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MgiD3gFi6n2DWZGyKOzXtpdRlkIGNHfoEGFjKi4s6gE=;
  b=tYZEN1bP68i/jTjZaMpHWmFLnr4iIynetQf6uNGmPZKm5bW8V4xJkK3v
   eQFwo11w0RQJVca7W/KVEEM5KDkRCG75WDsX5AI7UQ0c3do8/0Ge1UL/K
   W0xPqrQ+QfGh6AgH4OkFgI8b/oEXFOVpUGHAC4AeElOkpGljLqGXR7f3m
   xOoitESp//jvcwht/Ek6uswU5xZuk23M8GliUYYLOX/A2u0fwL/Fb2gIJ
   IhbfTPhbSp/xkzGFkhFQHIDgi6LvwKGhUCXIJoMwNhQ3qSPF0Wku5Fy00
   GOoeYvzH6CmzAbwwg14HSHOBQCuioxvp1Xa9Xd6ng7VI32y7vU5ebX3Fs
   g==;
X-CSE-ConnectionGUID: OpzI/lgPRomd2OikBsBKCQ==
X-CSE-MsgGUID: uodAFWpXS9C+K6nHSo5ICA==
X-IronPort-AV: E=Sophos;i="6.25,176,1779148800"; 
   d="scan'208";a="24041183"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 07:59:50 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.48:18644]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.48.250:2525] with esmtp (Farcaster)
 id d4701d73-2dca-492e-91e8-215baff33398; Tue, 21 Jul 2026 07:59:50 +0000 (UTC)
X-Farcaster-Flow-ID: d4701d73-2dca-492e-91e8-215baff33398
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Tue, 21 Jul 2026 07:59:50 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Tue, 21 Jul 2026
 07:59:48 +0000
Date: Tue, 21 Jul 2026 07:59:41 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <sleybo@amazon.com>, <matua@amazon.com>, <gal.pressman@linux.dev>
Subject: Re: [PATCH for-next v10 0/6] Introduce Completion Counters
Message-ID: <20260721075941.GA1973@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
References: <20260720132221.2551-1-mrgolin@amazon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20260720132221.2551-1-mrgolin@amazon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: EX19D045UWA001.ant.amazon.com (10.13.139.83) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Mon, Jul 20, 2026 at 01:22:15PM +0000, Michael Margolin wrote:
> Add core infrastructure for Completion Counters, a light-weight
> alternative to polling CQ for tracking operation completions. The
> related rdma-core support is linked in [1].
> 
> Define the UVERBS_OBJECT_COMP_CNTR ioctl object with create, destroy,
> modify and read methods for both success and error counters. Add a QP
> attach method on the QP object to associate a completion counter with a
> queue pair.
> 
> Add EFA Completion Counters support as first implementer.
> 
> [1] https://github.com/linux-rdma/rdma-core/pull/1701
> 

I just want to make sure that nothing blocks this series:

1. Sashiko's comments on the first patch regarding usecnt, resource
tracking and multiple attaches to same (QP,op) are fully handled in
the following patches in the series. The few remaining comments doesn't
look like something we should handle.
https://sashiko.dev/#/patchset/20260720132221.2551-1-mrgolin%40amazon.com

2. There are no open comments on rdma-core side.

Something else that I'm missing?

Michael

> ---
> Changes in v10:
> - No changes, v9 email thread got corrupted
> Changes in v9:
> - Moved counter max value report from per counter create response to a
>   new device level command that aggregates completion counter
>   capabilities
> - Exposed supported ops in QP attach as part of the above command
>   response
> - Link to v8: https://lore.kernel.org/all/20260707203427.6923-1-mrgolin@amazon.com/
> Changes in v8:
> - Added device event counter detach support and its use in attach error
>   handling
> - Prevented completion counters attach to wrapper QPs
> - Added max completion counters report in nldev
> - Link to v7: https://lore.kernel.org/all/20260701103448.17895-1-mrgolin@amazon.com/
> Changes in v7:
> - Rebased on latest rdma for-next
> - Link to v6: https://lore.kernel.org/all/20260604114627.6086-1-mrgolin@amazon.com/
> Changes in v6:
> - Moved to using ib_umem_get_attr util
> - Resolved additional Sashiko comments
> - Link to v5: https://lore.kernel.org/all/20260526090712.17575-1-mrgolin@amazon.com/
> Changes in v5:
> - Fixed Sashiko findings
> - Minor naming improvements
> - Link to v4: https://lore.kernel.org/all/20260511223721.18365-1-mrgolin@amazon.com/
> Changes in v4:
> - Replaced inc and set commands by a single modify command
> - Changed to passing buffers as EFA specific attributes using desc
>   struct aligned with the suggested common method of passing and
>   consuming umem in RDMA drivers
> - Link to v2: https://lore.kernel.org/all/20260416212327.18191-1-mrgolin@amazon.com/
> Changes in v3:
> - Skipped this version because of a wrong patch list
> Changes in v2:
> - United set, inc and read flows for successful and error completions
>   counters
> - Added comp_cntr usage count
> - Minor cleanups
> - Link to v1: https://lore.kernel.org/all/20260407115424.13359-1-mrgolin@amazon.com/
> 
> Michael Margolin (6):
>   RDMA/core: Add Completion Counters support
>   RDMA/core: Prevent destroying in-use completion counters
>   RDMA/core: Expose Completion Counter capabilities to userspace
>   RDMA/core: Add Completion Counters to resource tracking
>   RDMA/efa: Update device interface
>   RDMA/efa: Add Completion Counters support
> 
>  drivers/infiniband/core/Makefile              |   1 +
>  drivers/infiniband/core/device.c              |   7 +
>  drivers/infiniband/core/nldev.c               |   8 +
>  drivers/infiniband/core/rdma_core.h           |   1 +
>  drivers/infiniband/core/restrack.c            |   2 +
>  .../core/uverbs_std_types_comp_cntr.c         | 168 +++++++++++++
>  .../infiniband/core/uverbs_std_types_device.c |  51 +++-
>  drivers/infiniband/core/uverbs_std_types_qp.c |  67 ++++-
>  drivers/infiniband/core/uverbs_uapi.c         |   1 +
>  drivers/infiniband/core/verbs.c               |   8 +
>  drivers/infiniband/hw/efa/efa.h               |  20 +-
>  .../infiniband/hw/efa/efa_admin_cmds_defs.h   | 186 +++++++++++++-
>  drivers/infiniband/hw/efa/efa_com_cmd.c       | 136 ++++++++++
>  drivers/infiniband/hw/efa/efa_com_cmd.h       |  45 ++++
>  drivers/infiniband/hw/efa/efa_io_defs.h       |  20 +-
>  drivers/infiniband/hw/efa/efa_main.c          |   8 +-
>  drivers/infiniband/hw/efa/efa_verbs.c         | 237 ++++++++++++++++++
>  include/rdma/ib_verbs.h                       |  50 ++++
>  include/rdma/restrack.h                       |   4 +
>  include/uapi/rdma/efa-abi.h                   |   6 +
>  include/uapi/rdma/ib_user_ioctl_cmds.h        |  43 ++++
>  include/uapi/rdma/ib_user_ioctl_verbs.h       |  19 ++
>  22 files changed, 1080 insertions(+), 8 deletions(-)
>  create mode 100644 drivers/infiniband/core/uverbs_std_types_comp_cntr.c
> 
> -- 
> 2.47.3
> 
