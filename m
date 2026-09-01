Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1A622D7A1
	for <linux-rdma@vger.kernel.org>; Tue,  1 Sep 2026 13:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788271003; cv=none; b=nk060vBg+nHCGrgrTbW4FdaAskP0ZEIobOxS12c/WHXSN0WfDZTvlECHuPi/Vwo+vO0CZaJsoXdX/btUV/RWCUa9KDjr5sp2n7qg8nqO8g6meHGQmLcFEvR9zmKcNJ3q5hPTKCVaR0sJl7GexTZIWW+RbodtzkukVdInMDRyLkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788271003; c=relaxed/simple;
	bh=EZB/LI4ShOl1MXyEyxeKkED2cZGOw5uYQITrJ7ih3/w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TaL2Lk/19LCJk/P+QMCy3hccZYgmTF7o5EnPWlJF9RRgV9gnRsLIm9+E/MwR1FHLQ3Do6Hhu7+dPRMoEuc//AjPxQBjP3OmXOny4CkMQpO0f5MSeeCJLo3hv9DeaVB8EyiNkSEHUsmDjtJgSJ7SrQiBecNk1zHZ6Zh26N9XoAvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S63CuIl/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S63CuIl/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338F31F000E9;
	Tue,  1 Sep 2026 13:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788271001;
	bh=LVgq0+3jRPxlx/MdGMn/39oonw6+Ix5nq/alZcX0fQY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=S63CuIl/xi1SjrRcbzZ+4P6XIFsa0mB0GR2u1kRTL1cUC3gkyT66rK3D2z9SvTbFo
	 XR98tQ/AOo2jQucPHgRS0KQVPC7PV6CyD+5miG5ls1tuWgHVQUrMkrGkKyLI19NWTC
	 RbgfiW5+sXX9l3+oH5uUvr95HxpkLdftqrIk1rzwLmFZAgU+R3QkoageqEEt0SBg6m
	 QPlHSNnAlja4fAbk4R9RBj6eWMmEtn0WBz7lc04HyYjFJaCQCmjLwhf7zeSqzKQvKy
	 fdGqnyAvWjI+IqjruCpIp+ikOdlJ9hiXl29JY3V4x74oWB0uhDgrzy100/mXaoEFZC
	 G55n9rZ8qCwvg==
Date: Tue, 1 Sep 2026 16:56:38 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Yonatan Nachum <ynachum@amazon.com>
Cc: jgg@nvidia.com, linux-rdma@vger.kernel.org, mrgolin@amazon.com,
	sleybo@amazon.com, matua@amazon.com, gal.pressman@linux.dev
Subject: Re: [PATCH for-next v3 0/3] RDMA/efa: Add support for 128B admin v2
 SQ entry
Message-ID: <20260901135638.GM24140@unreal>
References: <20260812121718.2904349-1-ynachum@amazon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260812121718.2904349-1-ynachum@amazon.com>

On Wed, Aug 12, 2026 at 12:17:15PM +0000, Yonatan Nachum wrote:
> Changelog:
> v3:
>  * Ensure proper alignment of stack admin buffer to prevent unaligned memory
>    accesses.
> v2: https://lore.kernel.org/all/20260731075007.3878376-1-ynachum@amazon.com/
>  * Rebase on for-next branch instead of wip/leon-for-next.
> v1: https://lore.kernel.org/all/20260726123854.638687-1-ynachum@amazon.com/
> 
> -------------------------------------------------------------------------
> Add support for the new 128-byte admin v2 SQ entry format. The v2 entry
> extends the v1 header with checksum and payload version fields, and
> carries a larger inline payload.
> 
> The series first decouples admin command payloads from admin headers,
> then generalizes the SQ ring to use a configurable entry size, and
> finally adds the v2 entry format selection based on device API version.
> 
> Yonatan Nachum (3):
>   RDMA/efa: Decouple admin command payload from admin header
>   RDMA/efa: Generalize the admin SQ
>   RDMA/efa: Add support for 128B admin v2 SQ entry
> 
>  .../infiniband/hw/efa/efa_admin_cmds_defs.h   | 116 +++--------
>  drivers/infiniband/hw/efa/efa_admin_defs.h    |  33 ++-
>  drivers/infiniband/hw/efa/efa_com.c           | 194 +++++++++++-------
>  drivers/infiniband/hw/efa/efa_com.h           |  16 +-
>  drivers/infiniband/hw/efa/efa_com_cmd.c       | 170 +++++----------
>  5 files changed, 240 insertions(+), 289 deletions(-)

I tried to apply the series, but it resulted in a large number of merge
conflicts. Please rebase and resend it.

Thanks

> 
> -- 
> 2.50.1
> 
