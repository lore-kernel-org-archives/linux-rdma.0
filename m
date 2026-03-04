Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A2F3BE154;
	Wed,  4 Mar 2026 14:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772636305; cv=none; b=P2rMp2GTelFbXo/EErVGELVLCoKprKuzEAS3z0xAAcKJuhVEyoiFdSprGd3BQ2Hm62y2cuk1d/Ia3fIPj3wC6jUW42rPo48v0MKmEquWM6Hgm+4R6fBvmEFchssnDtNKKRBPFpo06DikOQMpaTf2P3GdtabgkKPRhP0TRmAMvT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772636305; c=relaxed/simple;
	bh=rII9J+C8rL3DLwgthbPiKKXig5D44fsZZam2ZJybaOA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z9t2IBC74UnQW/BQhoY3djmm1fYeJ9J64XVA9y1ysHi/KGWX2xoBJJfOCmYe750MMiXcup0vzstirYPhJlNlzUqPkNP1/4VE2JDk56y6IwELOkBjPIGroSvyGlhkumvQVI955o0qsInd/QDXQOpeYYIDgwfndOa0LylD3aOu/0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dstx0aXq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dstx0aXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B3ABC4CEF7;
	Wed,  4 Mar 2026 14:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772636304;
	bh=rII9J+C8rL3DLwgthbPiKKXig5D44fsZZam2ZJybaOA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dstx0aXqu9NGQnL0nJbFa7c1p9wi3Mtlr+DAOueHLuCVtuoeJZXKTyoAXYohLsIsp
	 2D64T6qemce3FeQivq0zDzV7aOx77IM697VnYDEF9Yi5/HOC3Qc8jBkrkXskzQZp0z
	 atWvJ1ojTKdV846WmlQT8CcgD9i/kOrvXE/FH+7eAtrIpf51Pd1aKzC/fnmEIGcVqN
	 NPd7cs1Ldj5XcCRMHnuCMqlLO/019stL30rVoLq6mG6KjZCdv3Pnq8zDcFa1UO8Zxg
	 vciN2rMVada4X2ISPAHAEvGckrLW4GkFnIV+AVY1F56BVa+EfYq2YDOQwYiKvxi7SJ
	 Z7AXPfs8IAzAQ==
Date: Wed, 4 Mar 2026 16:58:20 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Long Li <longli@microsoft.com>
Cc: "K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Shradha Gupta <shradhagupta@linux.microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>,
	Erick Archer <erick.archer@outlook.com>,
	linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/6] net: mana: Create separate EQs for each
 vPort
Message-ID: <20260304145820.GD12611@unreal>
References: <20260304000017.333312-1-longli@microsoft.com>
 <20260304000017.333312-2-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304000017.333312-2-longli@microsoft.com>

On Tue, Mar 03, 2026 at 04:00:12PM -0800, Long Li wrote:
> To prepare for assigning vPorts to dedicated MSI-X vectors, remove EQ
> sharing among the vPorts and create dedicated EQs for each vPort.
> 
> Move the EQ definition from struct mana_context to struct mana_port_context
> and update related support functions. Export mana_create_eq() and
> mana_destroy_eq() for use by the MANA RDMA driver.
> 
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>  drivers/infiniband/hw/mana/main.c             |  14 ++-
>  drivers/infiniband/hw/mana/qp.c               |   4 +-
>  drivers/net/ethernet/microsoft/mana/mana_en.c | 109 ++++++++++--------
>  include/net/mana/mana.h                       |   7 +-
>  4 files changed, 82 insertions(+), 52 deletions(-)
> 

Thanks,
Acked-by: Leon Romanovsky <leon@kernel.org> # drivers/infiniband
