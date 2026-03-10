Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3281D3A9D99;
	Tue, 10 Mar 2026 18:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773168793; cv=none; b=KBFzhxXhTeTN3+5cKkSietRVuoYmHsFYqIPm0ufjKxSizMEEvl2sJ+2HPD1Jg5TnJygxFyC9NHC16qZUMyh2IAB4FMhwaW/PcdUBw1gTcb8O2iYG2EOPCQy3nYbpYSrwmINCUVHch/sMspfINKbWJt068y+YA6hBTBLJRdcRYjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773168793; c=relaxed/simple;
	bh=26NQ/+zuqLyS2+1Dg7C9SDI6PT0Xr1YPQ7ljpU16GZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f2YiQUVhusSUMf91KFU5cxaq1amA7KKy6q04iomn+NAYYtiyH9Bq78ttialdR6do0Xc/1a82j1FRCXV/Tm+dRcPE4hNnfmr+mUs+Yo+JaY/194Ud6IOjKC5qopZ4YQuImrKuvZu8zPhJ+1HGe9uLidy8pHgRuPYx6Rl2C9h8+Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SA2NDnNH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SA2NDnNH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16F1C19423;
	Tue, 10 Mar 2026 18:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773168792;
	bh=26NQ/+zuqLyS2+1Dg7C9SDI6PT0Xr1YPQ7ljpU16GZ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SA2NDnNH3GIaT2LZFKXW7SUj1Bgo6w5QLsp6wZqpBULawGZNnho14cQt0aq/la4Tq
	 fzjSkUfqgr0EhGu1VZyDy6oP6uLnGUbZ8JnYqvxYXvuQYNd/+aFMlRENWCrTouYKvT
	 nL1jbI09bfh9CCLWlWkstvH6oxNecyKkDMSWGZ+E/MLFZ/FrTsUuKfRgPsR7d1vAgA
	 WW/k80Cwr9dccGMopyvHTVow/qgVeHo50gE7YmZ2BrBtKyokn+LkBJ2zefHed/BgtT
	 bvsDZWSUzh5ei/Xy8oGdve5I+bfInka3y1J6LS2CR/YWG4sF5bUwfg/36puqoAMMpD
	 Hfa/b8HZL/Wsw==
Date: Tue, 10 Mar 2026 20:53:08 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: jgg@ziepe.ca, zyjzyj2000@gmail.com, shuah@kernel.org,
	linux-rdma@vger.kernel.org, linux-kselftest@vger.kernel.org,
	dsahern@kernel.org
Subject: Re: [PATCH v5 4/4] RDMA/rxe: Add testcase for net namespace rxe
Message-ID: <20260310185308.GJ12611@unreal>
References: <20260310020519.101415-1-yanjun.zhu@linux.dev>
 <20260310020519.101415-5-yanjun.zhu@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310020519.101415-5-yanjun.zhu@linux.dev>

On Tue, Mar 10, 2026 at 03:05:18AM +0100, Zhu Yanjun wrote:
> Add 4 testcases for rxe with net namespace.
> 
> Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
> ---
>  MAINTAINERS                                   |  1 +
>  tools/testing/selftests/Makefile              |  1 +
>  tools/testing/selftests/rdma/Makefile         |  7 ++
>  tools/testing/selftests/rdma/config           |  3 +
>  tools/testing/selftests/rdma/rxe_ipv6.sh      | 63 ++++++++++++++
>  .../selftests/rdma/rxe_rping_between_netns.sh | 85 +++++++++++++++++++
>  .../selftests/rdma/rxe_socket_with_netns.sh   | 76 +++++++++++++++++
>  .../rdma/rxe_test_NETDEV_UNREGISTER.sh        | 63 ++++++++++++++
>  8 files changed, 299 insertions(+)
>  create mode 100644 tools/testing/selftests/rdma/Makefile
>  create mode 100644 tools/testing/selftests/rdma/config
>  create mode 100755 tools/testing/selftests/rdma/rxe_ipv6.sh
>  create mode 100755 tools/testing/selftests/rdma/rxe_rping_between_netns.sh
>  create mode 100755 tools/testing/selftests/rdma/rxe_socket_with_netns.sh
>  create mode 100755 tools/testing/selftests/rdma/rxe_test_NETDEV_UNREGISTER.sh
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 77fdfcb55f06..bd33edf79150 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -24492,6 +24492,7 @@ L:	linux-rdma@vger.kernel.org
>  S:	Supported
>  F:	drivers/infiniband/sw/rxe/
>  F:	include/uapi/rdma/rdma_user_rxe.h
> +F:	tools/testing/selftests/rdma/

This is wrong place in MAINTAINERS file.
You need to add that line to "INFINIBAND SUBSYSTEM" and under RXE to add
tools/testing/selftests/rdma/rxe* entry.

Thanks
