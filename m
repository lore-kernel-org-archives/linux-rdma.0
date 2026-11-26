Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795694387;
	b=t6jW46paP3nvpeMtOlEd9sy3VHPdYffFkjKOUpCj1ztT3SPwIA5DwatPrdxi1GBXMUvo
	 WNdpUWBQsE+ybkGSyxYGV5C1iX93EuGY6BgBaEM7AmiEYV7mz4H0EhM1odE+E6E9Si2QG
	 qTeipxVA6cbRI5suNe05vxpLhNlMIFIANL3oelCFRk6MlxUU/b2rmrTNjriGI+99t3ce4
	 PETE6Gxnhycsm62OHJHWhMNDJdEfSPFMVYUy0/uSjjgSusv+tAe36SxC/RuqPaJ3aYTAz
	 bDkuqfVlArVo8gQ5Hk5WlvkXQOfvcYO7TNEnbiHU0l7wJjNv5x5YcDbEsH/b4RxZtjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795694387;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=HCxBhw+LiN6Ju6EckKIzv3MS9RO6KjYpZeDXCLfLS/0=;
	b=qO+ASNjuZkC93ox2gJcG1QYqYHzYGau7LYlBrelIFRRiCkSAHkg4ud1XdgwuLAAVGqxN
	 VW+/pVWRtZlmGaaW7y+84TKmNSnDWwpQZVTMMveU2Q+R6XjnuTnHEaocRRY5nMay2Pf8n
	 x/ltjZ/KzlEUGPOWE08qxXeHNm+f7bgfLeFsDONWWG+y9RFrcjdOeOmOyDs1hQV/kxjjP
	 KOpvc9YIgvOw1T4Ob1EynNdLdegGN4C3L1CmnRNaUTNuzbjZ5hXlLmnh2Bh/QlVt7o5n+
	 SXuG6eLD4G9PqTubA0vfeVmo3RlIwnKPDPA0va3udfdT6jHtBs9T4M15xGuj9U2DeSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VHJuvVVd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F69606A31C
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 11:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VHJuvVVd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44BA1F000CF;
	Thu, 26 Nov 2026 11:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795694387;
	bh=HCxBhw+LiN6Ju6EckKIzv3MS9RO6KjYpZeDXCLfLS/0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VHJuvVVd1DsHMUVrTqeZTc7b5bOUcEsjt5LhoqmczfXZiwrOWxcxmdPhoP6Olh4pO
	 K6NRI0Kci8CwwUwWV4uJDNjcnA6t32jjPQjZqIm0BLB0OgyL+6Q9GMcb9UHLFshzf0
	 8nqqZCuKGughWXiDwI6MKXQVMnlerItu+XWdNHqqV5qS9NhyvytpD8IlyByrpBqyJn
	 LMAVd/kyEYNQOAv2Ogi+JI05MBGEEk7ZXGPFx7lg0hU+edJbwpGIUpgYLTSxKaTdoT
	 93NtxDd7l9sZpMufg2ZnFoKJFpdr73Z+dAwi8xBKuLPcbAaThjUJnkJQqOXkRvxnZu
	 83x+nhah3yKlw==
Date: Thu, 26 Nov 2026 13:59:41 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Md Haris Iqbal <haris.iqbal@ionos.com>
Cc: linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
	Danil Kipnis <danil.kipnis1@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>
Subject: Re: [PATCH 1/9] RDMA/rtrs-clt: Add mpath_policy module parameter
Message-ID: <20261126115941.GH774860@unreal>
References: <20261123143719.938876-1-haris.iqbal@ionos.com>
 <20261123143719.938876-2-haris.iqbal@ionos.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261123143719.938876-2-haris.iqbal@ionos.com>

On Mon, Nov 23, 2026 at 03:37:11PM +0100, Md Haris Iqbal wrote:
> From: Danil Kipnis <danil.kipnis1@ionos.com>
> 
> Add a module parameter to set the default multipath policy for newly
> created sessions. This simplifies configuration when all sessions should
> use the same policy, allowing administrators to set the default at module
> load time or boot time via kernel parameters.
> 
> The parameter accepts numeric values 0-2:
> - 0: Round-robin (MP_POLICY_RR)
> - 1: Minimum inflight requests (MP_POLICY_MIN_INFLIGHT) - default
> - 2: Minimum latency (MP_POLICY_MIN_LATENCY)
> 
> Invalid values are clamped to the valid range. The parameter is runtime
> adjustable via /sys/module/rtrs_client/parameters/mpath_policy, affecting
> only newly created sessions. Existing sessions retain their current policy.
> 
> The per-session sysfs interface remains fully functional for session-
> specific overrides, maintaining backward compatibility.

Your AI tool merely restated what this patch implements and provided
general information about module parameters.

It does not explain why this parameter is needed, especially given that
IONOS is the only user of RTRS.

Thanks

> 
> Signed-off-by: Danil Kipnis <danil.kipnis1@ionos.com>
> Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
> Signed-off-by: Md Haris Iqbal <haris.iqbal@ionos.com>
> ---
>  drivers/infiniband/ulp/rtrs/rtrs-clt.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> index bf3a0377da3f..573beb5ccdf0 100644
> --- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> +++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> @@ -39,6 +39,13 @@
>  MODULE_DESCRIPTION("RDMA Transport Client");
>  MODULE_LICENSE("GPL");
>  
> +static int mpath_policy = MP_POLICY_MIN_INFLIGHT;
> +module_param_named(mpath_policy, mpath_policy, int, 0644);
> +MODULE_PARM_DESC(mpath_policy,
> +		 "Default multipath policy for new sessions (default: "
> +		 __stringify(MP_POLICY_MIN_INFLIGHT)
> +		 " (min-inflight), 0: round-robin, 1: min-inflight, 2: min-latency)");
> +
>  static const struct rtrs_rdma_dev_pd_ops dev_pd_ops;
>  static struct rtrs_rdma_dev_pd dev_pd = {
>  	.ops = &dev_pd_ops
> @@ -2758,7 +2765,7 @@ static struct rtrs_clt_sess *alloc_clt(const char *sessname, size_t paths_num,
>  	clt->max_reconnect_attempts = max_reconnect_attempts;
>  	clt->priv = priv;
>  	clt->link_ev = link_ev;
> -	clt->mp_policy = MP_POLICY_MIN_INFLIGHT;
> +	clt->mp_policy = mpath_policy;
>  	strscpy(clt->sessname, sessname, sizeof(clt->sessname));
>  	init_waitqueue_head(&clt->permits_wait);
>  	mutex_init(&clt->paths_ev_mutex);
> @@ -3220,6 +3227,10 @@ static int __init rtrs_client_init(void)
>  	int ret = 0;
>  
>  	rtrs_rdma_dev_pd_init(0, &dev_pd);
> +
> +	/* Validate and clamp mpath_policy to valid range */
> +	mpath_policy = clamp(mpath_policy, MP_POLICY_RR, MP_POLICY_MIN_LATENCY);
> +
>  	ret = class_register(&rtrs_clt_dev_class);
>  	if (ret) {
>  		pr_err("Failed to create rtrs-client dev class\n");
> -- 
> 2.43.0
> 
> 
