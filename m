Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268322C3268
	for <linux-rdma@vger.kernel.org>; Wed, 10 Jun 2026 08:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781078834; cv=none; b=j1OoulMPZVXIac9UNCcw5Jo4K2T3H0ICvyG183n4Q83+B83wT4b7jxePMwusNMQMK2WrR04ndHwR70srlD5XccQoR/NBqWxdOoHiT286uYowRD0h8DSkY2koxT+v8x5kNuD2nyvEbnKieDQQhMrfQn46UiscPuZpRCLv0SLIFG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781078834; c=relaxed/simple;
	bh=TCfULUsjrKi+F0tq2OH/oFlwx+nlWLADc01I55JLtKE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gUDDTfuMdagnOHCwS3lOIxAxYiOur0sw30T7N3GOe+PpCQlUyH3VcG9yJWAlyudnMlIWg866645wfSdTlDSvmL2PvYKrXDl4WGUP4Gxp41AoeQl2xKW/IA+Ezub9rNr66jT0W7TdGc1fvDjlMmIQWeFIOWMiWky5ox9B6YTwO/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TDZGJZkI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TDZGJZkI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BCAF1F00893;
	Wed, 10 Jun 2026 08:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781078832;
	bh=v8INSMCzVSF/sS8yOpLJchKXBRU4zBQUE1lDEA+/IKw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TDZGJZkIi0WAK+l4M79Yb21quQ+PR4gmG6szrCAvLytBAVV98g67uxBU+GmJESPKb
	 UDhu264laYaHuZcDQc+0myI6D5EQh21APavb2itZg+h0sN1xVHtwQ2Dw9Qet6daBTI
	 6NQbjBxzCLZ0jSprRMpQ5yHGjDVEzkbANerDcFUH9TDjnrnIcwyc9icc8Yl4BpDyEM
	 /vQgLYn1vrjoPt7w0WX5A89sFYvCChVr4tFaxNWlLS39qFbI6wrL4KJ5Z6dQrqONYs
	 FjtevMct4eC9X5kmR384oD0OJBUSLK64excYiIcmYWBn2USboV5xdu6/7FsOsJeC1P
	 pIKhIEmDs1Qmg==
Date: Wed, 10 Jun 2026 11:07:08 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Tao Cui <cuitao@kylinos.cn>
Cc: linux-rdma@vger.kernel.org
Subject: Re: [PATCH rdma-next v2] rdma: display resource limits in curr/max
 format
Message-ID: <20260610080708.GF327369@unreal>
References: <20260515074111.428882-1-cuitao@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260515074111.428882-1-cuitao@kylinos.cn>

On Fri, May 15, 2026 at 03:41:11PM +0800, Tao Cui wrote:
> Parse the new RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_MAX netlink attribute
> to show resource limits alongside current counts in curr/max format:
> 
>   Before: 0: mlx5_0: qp 123  cq 45  mr 200  pd 10
>   After:  0: mlx5_0: qp 123/131072  cq 45/65536  mr 200/1000000  pd 10/32768
> 
> JSON output provides both current and max fields per resource type
> (e.g. "qp": 123, "qp-max": 131072). Backward compatible: no output
> change when kernel lacks the new attribute.
> 
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> ---
>  rdma/include/uapi/rdma/rdma_netlink.h |  5 +++++
>  rdma/res.c                            | 22 +++++++++++++++++++++-
>  rdma/utils.c                          |  1 +
>  3 files changed, 27 insertions(+), 1 deletion(-)

This patch is intended for iproute2.  
The subject should reference iproute2-next, and the relevant maintainers  
need to be CCed.

https://lore.kernel.org/netdev/20260512193412.32019-1-dsahern@kernel.org/

Thanks.
