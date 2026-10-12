Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F5F3BE64B;
	Mon, 12 Oct 2026 08:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791792512; cv=none; b=M0NjcUftNMn+hwvD5C3bm64vSdoNm8PBRPrPq1vVsGt89CTKNpZ1IdUzq27moX3bLpf3INGrgJl9V3apZv3UwIRVj3AvgSlyXkmVMg8c9YugmYKggMk4uUNWRSCSvvVEAY+J4Fx2p+NXJGDs33ql6dTC2yL1noRpfc2jHiMVaaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791792512; c=relaxed/simple;
	bh=fUijr6glsKt344ZeX0t8NLHts2AIyJb84PRQM+5wZUg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EvIoZF8l1QRg5h8OFSggs8JeZ/ovy8cjIBTP6eJWaLu5iPjYjZSW2R+MVn1UwUObxD05B48yinP+hbKi1hAyics17K6P6qC0IAol8y4X30A0luQHMStSwZ+JSoZ/Ag5RXWVJuIn8Lt2qEWcE0IHPnCr2hYDfpg5fcYv9wmxv9Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OGFk++kX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OGFk++kX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D9511F0089B;
	Mon, 12 Oct 2026 08:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791792511;
	bh=/OOFRPtAFbJXcIK6VVyzE8pqPO2I1iDm9oy3p173wXE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OGFk++kXIhxBrfTe2V9f3UvsG2tBK64VmQUTgBOjaCfCExzgcEp77/JdDoe+AkGcj
	 u0QHm+gdBoIRUkB1e8Vcr3CCHggl13NF4Qg4S6qwLkiWuoQLY246XKjGGhFV4gwidt
	 zTKZ+c1QJblStzll5vmQKh+Vua2yrfdT4rpzoiesnHUrHHcsUBk1LnxphAlL+E+Fu8
	 BCcKsXNkb10GfdA27ni21tsHHy0QVRo56NnRsD4tW/J31sV4pCG1LihqYgO74DQWBX
	 7QJqbEkJnoxgJdM1MZ+LJEqcR8WR/MAPYsZPB6EJ+Pq0o7R7xMZxEUSfEHauweNkzd
	 JqZLwnhsl/5Mg==
Date: Mon, 12 Oct 2026 11:08:26 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Serhat Kumral <serhatkumral1@gmail.com>, haris.iqbal@ionos.com,
	jinpu.wang@ionos.com
Cc: jgg@ziepe.ca, danil.kipnis@cloud.ionos.com, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/rtrs: Use strscpy() to cache the HCA name
Message-ID: <20261012080826.GB219304@unreal>
References: <20261009131715.39217-1-serhatkumral1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261009131715.39217-1-serhatkumral1@gmail.com>

On Fri, Oct 09, 2026 at 04:17:15PM +0300, Serhat Kumral wrote:
> As the comment states, the HCA name is cached for sysfs. Use
> strscpy() to copy it directly without unnecessary formatting and
> avoid interpreting format specifiers in the name.
> 
> Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
> Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
> ---
> found by smatch:
> - drivers/infiniband/ulp/rtrs/rtrs-clt.c:1906 rtrs_rdma_conn_established() warn: call of 'scnprintf' with non-constant format argument
> 
>  drivers/infiniband/ulp/rtrs/rtrs-clt.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> index 927e3f30483c..c85e22f670ba 100644
> --- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> +++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> @@ -1918,8 +1918,8 @@ static int rtrs_rdma_conn_established(struct rtrs_clt_con *con,
>  		 * Cache the hca_port and hca_name for sysfs
>  		 */
>  		clt_path->hca_port = con->c.cm_id->port_num;
> -		scnprintf(clt_path->hca_name, sizeof(clt_path->hca_name),
> -			  clt_path->s.dev->ib_dev->name);
> +		strscpy(clt_path->hca_name, clt_path->s.dev->ib_dev->name,
> +			sizeof(clt_path->hca_name));

Haris, Jinpu

These names shouldn't be cached.

Thanks

>  		clt_path->s.src_addr = con->c.cm_id->route.addr.src_addr;
>  		/* set for_new_clt, to allow future reconnect on any path */
>  		clt_path->for_new_clt = 1;
> -- 
> 2.53.0
> 
