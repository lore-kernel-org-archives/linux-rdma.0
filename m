Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D23944D00D;
	Wed, 23 Sep 2026 08:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790150887; cv=none; b=L5QSM2p3foZkUXwedU7packCPImUGpXXs8b113musezXuHTemG7bU0b71h643tHX3qypr4C4N2M9vie+ipPLGQLGz56yV+RG9+81baB4tBtnOATuzC7Qiq2+/txxOVjNZCyX0VK7QV4yHkj4mYtj/ZUh2+HqMzhV4k1916tvEQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790150887; c=relaxed/simple;
	bh=pE7hGxoqiZhaMUIGWTU8GAMu4tnk84JHbDsxbTdyLW4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EIGZTYcijZMFo1GrYEXWy/157AlIJKXvw4a/78GsQeR/vVRPiuDzK8q2pbibNmGkYRK4N6ZzCIzL/6Mf0eieKS1voyYLY59O8tkOQYfdzjLs3/7PcOgak4UOnbUOFY3XfEtp0skC+WTM2o7tmP9OC+0UjK/1DY7f5WZ1sNFG5QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XRhmKRjd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XRhmKRjd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915C91F000FF;
	Wed, 23 Sep 2026 08:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790150886;
	bh=BzpMu0dx+dVmBD8yn9ceUD4I08Fx7LbGLoIrX5Dk1RM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XRhmKRjd++52c+zan+3dy9LokPl+dLBV5LotXz2AGLSxEn/8o0eINO0a6uAKsVYb/
	 gr5ZavkTVPGiRascSzqaPd7LWpYyzbKzdCfET8RwXzJGm+3ER8GcH/tqSTxF207iYW
	 aZAAk/Vblug6Oi96iWKnwIoI8zjfuTRrQXviAU3iqlOBDYjcLMPOa+YaOxMMtKY3qA
	 /z0I/3OjYV/SDDcyhahROLujVfKFaeXHJ6End0dLqSSCZ99PsUR6au074mMzW1oZ45
	 V9573F1xtAFdyftOIabgu2hblEIIegRZon+lpVlxXT+EuB/GSgeU2zehhiIteVjb2R
	 LaogQ+tCfElSA==
Date: Wed, 23 Sep 2026 11:08:01 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: bernard.metzler@linux.dev, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 6/7] RDMA/siw: Fix new_cep use-after-free in
 siw_accept_newconn()
Message-ID: <20260923080801.GL563127@unreal>
References: <20260916184109.2092928-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916184109.2092928-1-vulab@iscas.ac.cn>

On Wed, Sep 16, 2026 at 06:41:09PM +0000, Wentao Liang wrote:
> On the error path the listening endpoint reference of new_cep is
> dropped before the accepted socket is disassociated.  When only the
> socket's reference remains, siw_socket_disassoc() drops that last
> reference and frees the endpoint, leaving the subsequent
> 'new_cep->sock = NULL' writing into freed memory.
> 
> Tear the accepted socket down first and put the endpoint last.
> 
> Fixes: 6c52fdc244b5 ("rdma/siw: connection management")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  drivers/infiniband/sw/siw/siw_cm.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)

I think this patch is supposed to fix it:
https://patch.msgid.link/r/20260604160808.30948-1-bernard.metzler@linux.dev

Thanks


> 
> diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
> index f7ac81c0f267..1b93963cb191 100644
> --- a/drivers/infiniband/sw/siw/siw_cm.c
> +++ b/drivers/infiniband/sw/siw/siw_cm.c
> @@ -1044,14 +1044,16 @@ static void siw_accept_newconn(struct siw_cep *cep)
>  	return;
>  
>  error:
> -	if (new_cep)
> -		siw_cep_put(new_cep);
> -
>  	if (new_s) {
>  		siw_socket_disassoc(new_s);
>  		sock_release(new_s);
> -		new_cep->sock = NULL;
> +		if (new_cep)
> +			new_cep->sock = NULL;
>  	}
> +
> +	if (new_cep)
> +		siw_cep_put(new_cep);
> +
>  	siw_dbg_cep(cep, "error %d\n", rv);
>  }
>  
> -- 
> 2.34.1
> 
