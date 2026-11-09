Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794223018;
	b=eJAdnviqlWTlt9qyOsGTS7Znvcj47FXXSiiTJ2jgbZIOuTUQ3tEcmvkNiRw6+8e2f+Pa
	 gT8K7ZuzP+C1hy5a7W9kgcMntx44z8fTgWxTn1WW/XqyjhSiI0XdS3s5OD0EUUtQkTZYl
	 wgrTTbDBXS9RtQN/oXzl3CZ/855PBBbm6WeEcDsdmvEvwORyj4cygB6yY08UXVZ3hWQVt
	 kqASnPREfKhC6NDaeVEyVvt/NeqDhe2GvdSc5QQu5lfwkuflflT2ME5cTiBs/GbQ0b/Ss
	 PzEL+qakWmzIznUKmzjnfbDyhP2w60uWC1W93VJG9Z5hRMWwP8Cs6JRFjrPLbAD5lwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794223018;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=g362BMKFIDzyzm9WbyAXbPrl9q0ZEKXU+FroiUmw4p8=;
	b=d454ngl7IyrZIpccZN8wfyQ5He3f3R70ITMCX4pthtwem/5Yu3yK/f9o1kOFECmak6CY
	 0MTwfbCTbhwDfml2V/CiqjNMGs9QwjWSHlkt5rZgG9dFUQuk57mXGQNJlJklOxO67iMUE
	 tZ0ysu+TXSV5yFJ0qZOrNnN+CoOV2vpFpw2m5bjPhP+TTCMA5gUzsMhIxTWnXvLaVicVW
	 hyZ+OuvFN4Ci+Dkc8bxNRJ/wM9t1tx8JqetwZz+ggQWiNDT8uuXqhIt9vAafCpk1HYIoM
	 OmRNNRw/2BSxvJUVJcnjiMphHmDKlmonxz351M5xxvYAmDnUTswAbDS5IJgbFqgC+mQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cka6mHrw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61EFC606A31C;
	Mon,  9 Nov 2026 11:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cka6mHrw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C281F0089F;
	Mon,  9 Nov 2026 11:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794223018;
	bh=g362BMKFIDzyzm9WbyAXbPrl9q0ZEKXU+FroiUmw4p8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Cka6mHrwsEa/HbWRWzj5RuHTVz/eGA6g2SdWVk4DVtIEXZbavyQxLOwBZySnvMqTr
	 HCL8EMwbFx15KKbdWrIH3LvogA0Fta6za0ZHK130DEiBMCrTP8HhdJoMpKZQMq7Z0a
	 ffCQbewQsNG1DGBgj6CdiRSA2LGf5FV27W267RsS+xEv0DogbCaNLF2TCWR/P8zsQ3
	 ZQGrSfM8lNQca3ZbfFIMZnq+rS0ovxlSfzIVRBk7P5w3BoBimAvs4DyUZRpWkPULqX
	 18NbPDVLzwP0ccJgyVGooRkY/Y2DIKoMn/9DqoxJBckroPJOd/2fIq7/Bv9HpwAl3Y
	 ETx1bIzdS72/g==
Date: Mon, 9 Nov 2026 13:16:52 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, stable@vger.kernel.org,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/rtrs: Fix potential use-after-free on client sysfs
 setup failure
Message-ID: <20261109111652.GD8635@unreal>
References: <ddd08640709b149408b616c3eec8fee847af757e.1793455791.git.liguangshuo@mail.sdu.edu.cn>
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
In-Reply-To: <ddd08640709b149408b616c3eec8fee847af757e.1793455791.git.liguangshuo@mail.sdu.edu.cn>

On Sat, Oct 31, 2026 at 10:14:46PM +0800, Guangshuo Li wrote:
> rtrs_clt_create_path_files() drops the path reference on failure, but
> its callers still close connections and free the path. This can access
> freed memory and free the path twice.

Sorry, but how?

> 
> Keep the caller's path reference until its cleanup completes. Move
> per-CPU stats cleanup to the path release callback and let the embedded
> stats kobject hold a path reference until its own release callback, so
> delayed kobject release cannot outlive the enclosing allocation. Keep
> direct cleanup for failures before the path kobject is initialized.
> 
> This issue was found by our static analysis tool under development.

It looks like false positive.

Thanks

> 
> Fixes: 215378b838df ("RDMA/rtrs: client: sysfs interface functions")
> Cc: stable@vger.kernel.org
> Assisted-by: OpenAI:gpt-6-astra
> Signed-off-by: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
> ---
> Build-tested the changed objects with x86_64 allmodconfig (W=1):
> GCC with CONFIG_DEBUG_KOBJECT_RELEASE=n/y, and Clang with it enabled.
> A host harness executing extracted cleanup functions passed 198
> failure/teardown cases, including delayed release (also under ASan/UBSan).
> No kernel runtime or RDMA hardware testing was performed.
> 
>  drivers/infiniband/ulp/rtrs/rtrs-clt-sysfs.c | 10 +++++++---
>  drivers/infiniband/ulp/rtrs/rtrs-clt.c       | 14 ++++++++++----
>  2 files changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt-sysfs.c b/drivers/infiniband/ulp/rtrs/rtrs-clt-sysfs.c
> index f8b833bd81ad..44edc405f400 100644
> --- a/drivers/infiniband/ulp/rtrs/rtrs-clt-sysfs.c
> +++ b/drivers/infiniband/ulp/rtrs/rtrs-clt-sysfs.c
> @@ -22,6 +22,7 @@ static void rtrs_clt_path_release(struct kobject *kobj)
>  
>  	clt_path = container_of(kobj, struct rtrs_clt_path, kobj);
>  
> +	free_percpu(clt_path->stats->pcpu_stats);
>  	free_path(clt_path);
>  }
>  
> @@ -32,11 +33,13 @@ static struct kobj_type ktype_sess = {
>  
>  static void rtrs_clt_path_stats_release(struct kobject *kobj)
>  {
> +	struct rtrs_clt_path *clt_path;
>  	struct rtrs_clt_stats *stats;
>  
>  	stats = container_of(kobj, struct rtrs_clt_stats, kobj_stats);
>  
> -	free_percpu(stats->pcpu_stats);
> +	clt_path = container_of_const(stats, struct rtrs_clt_path, stats[0]);
> +	kobject_put(&clt_path->kobj);
>  }
>  
>  static struct kobj_type ktype_stats = {
> @@ -422,6 +425,7 @@ static const struct attribute_group rtrs_clt_path_attr_group = {
>  	.attrs = rtrs_clt_path_attrs,
>  };
>  
> +/* The caller retains the initial path reference on all exits. */
>  int rtrs_clt_create_path_files(struct rtrs_clt_path *clt_path)
>  {
>  	struct rtrs_clt_sess *clt = clt_path->clt;
> @@ -438,7 +442,6 @@ int rtrs_clt_create_path_files(struct rtrs_clt_path *clt_path)
>  				   "%s", str);
>  	if (err) {
>  		pr_err("kobject_init_and_add: %pe\n", ERR_PTR(err));
> -		kobject_put(&clt_path->kobj);
>  		return err;
>  	}
>  	err = sysfs_create_group(&clt_path->kobj, &rtrs_clt_path_attr_group);
> @@ -446,6 +449,8 @@ int rtrs_clt_create_path_files(struct rtrs_clt_path *clt_path)
>  		pr_err("sysfs_create_group(): %pe\n", ERR_PTR(err));
>  		goto put_kobj;
>  	}
> +	/* Keep the path alive until its embedded stats kobject is released. */
> +	kobject_get(&clt_path->kobj);
>  	err = kobject_init_and_add(&clt_path->stats->kobj_stats, &ktype_stats,
>  				   &clt_path->kobj, "stats");
>  	if (err) {
> @@ -470,7 +475,6 @@ int rtrs_clt_create_path_files(struct rtrs_clt_path *clt_path)
>  	sysfs_remove_group(&clt_path->kobj, &rtrs_clt_path_attr_group);
>  put_kobj:
>  	kobject_del(&clt_path->kobj);
> -	kobject_put(&clt_path->kobj);
>  
>  	return err;
>  }
> diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> index bf3a0377da3f..547313136598 100644
> --- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> +++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> @@ -2880,8 +2880,7 @@ struct rtrs_clt_sess *rtrs_clt_open(struct rtrs_clt_ops *ops,
>  		if (err) {
>  			list_del_rcu(&clt_path->s.entry);
>  			rtrs_clt_close_conns(clt_path, true);
> -			free_percpu(clt_path->stats->pcpu_stats);
> -			free_path(clt_path);
> +			kobject_put(&clt_path->kobj);
>  			goto close_all_path;
>  		}
>  	}
> @@ -3161,7 +3160,7 @@ int rtrs_clt_create_path_from_sysfs(struct rtrs_clt_sess *clt,
>  
>  	err = init_path(clt_path);
>  	if (err)
> -		goto close_path;
> +		goto close_path_free;
>  
>  	err = rtrs_clt_create_path_files(clt_path);
>  	if (err)
> @@ -3169,12 +3168,19 @@ int rtrs_clt_create_path_from_sysfs(struct rtrs_clt_sess *clt,
>  
>  	return 0;
>  
> -close_path:
> +close_path_free:
>  	rtrs_clt_remove_path_from_arr(clt_path);
>  	rtrs_clt_close_conns(clt_path, true);
>  	free_percpu(clt_path->stats->pcpu_stats);
>  	free_path(clt_path);
>  
> +	return err;
> +
> +close_path:
> +	rtrs_clt_remove_path_from_arr(clt_path);
> +	rtrs_clt_close_conns(clt_path, true);
> +	kobject_put(&clt_path->kobj);
> +
>  	return err;
>  }
>  
> 
> base-commit: d89e1d186ec9271bf78e62771779e9fc03bf0fc3
