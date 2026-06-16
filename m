Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C65D3D5656;
	Tue, 16 Jun 2026 18:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633376; cv=none; b=MSt21zPIZVZV9z2eUkUU5qp5ESSf3hPq7h4MQsC4lKgJqlIqHEeZOtvS0/tG4ZFZ9YjpGjda/eXM+HUA9IsxoI2uVwMYXl/PrYWhUl4jd1Iytl2AAO8DLs1BCODIRfIfcLMUUyv0+k/sMHsS1x5ptxVzokl8KWVkD5rNHrzzbmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633376; c=relaxed/simple;
	bh=UJoJC+LPr5JtwIIYHRNLpKRTlx9rR3elzqKtpXIld5k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kQ+tbAsPDyzvcojmJuvLgkP6M7eSD7Bm3dkkE4tTRNU1OqXKBhIIGXZOBp9lWdKrx/Cu8KVz4rYN1xuzxDTPsLzFmn3Zp8EvBSXtMr6SJ36KtvlF72QHR9Ni07qqfxVZ05v6QJOWkHvATDFjmk4H9e1gihUXjHPj0LpI40UonOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y2a8nmRO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y2a8nmRO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235891F000E9;
	Tue, 16 Jun 2026 18:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781633375;
	bh=HFFkLIXvkP/vvJblAmle3/icgdr5AJDzURgkhmjKBSY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Y2a8nmROpyirnyxwIZC529IvpjKMUhgG/4qT7Ag8oXGSPdofoSPMMmLXViCU3KfOT
	 XHn97EYh/6IhRoLOUb8Pg9kA0VK0SbIoubG0dvaZ8E896HDP1Q1ynTW7eu0IPggdqM
	 kAnW9VTPnxAy/bfqqmlTeK8sAi9YnRZrIHAUu24FMCRoH1sLZJbkV0h9vQW4PrHOO0
	 NxevWZQw6upp/LnB2AhBOZ6kz+AVg7XDj+4x/hvzMaCCLoGI+gct23QInGMg8tnsiT
	 i6oLFM12ExSXV9qZMUdX3u60pHgyqC04Lt0ApxgevzP9+w31jX7jb4XyUIDm5fwntE
	 aIwJc+Y+p1YHw==
Date: Tue, 16 Jun 2026 21:09:29 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: jgg@ziepe.ca, fw@strlen.de, kees@kernel.org, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] RDMA/iwpm: fix kref bypass in
 iwpm_add_and_query_mapping() error path
Message-ID: <20260616180929.GR327369@unreal>
References: <20260608154208.158175-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608154208.158175-1-vulab@iscas.ac.cn>

On Mon, Jun 08, 2026 at 03:42:08PM +0000, Wentao Liang wrote:
> iwpm_get_nlmsg_request() returns with kref_init() + kref_get()
> (refcount=2). iwpm_add_and_query_mapping() calls
> iwpm_free_nlmsg_request() directly on the error path instead of
> using kref_put(), freeing the object while the refcount is still
> non-zero. The success path correctly uses kref_put() via
> iwpm_wait_complete_req().
> 
> Replace the direct iwpm_free_nlmsg_request() call with
> kref_put(&nlmsg_request->kref, iwpm_free_nlmsg_request).
> 
> Fixes: 30dc5e63d6a5 ("RDMA/core: Add support for iWARP Port Mapper user space service")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  drivers/infiniband/core/iwpm_msg.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/core/iwpm_msg.c b/drivers/infiniband/core/iwpm_msg.c
> index 854c974d6586..bac3d1f321ab 100644
> --- a/drivers/infiniband/core/iwpm_msg.c
> +++ b/drivers/infiniband/core/iwpm_msg.c
> @@ -296,7 +296,7 @@ int iwpm_add_and_query_mapping(struct iwpm_sa_data *pm_msg, u8 nl_client)
>  query_mapping_error_nowarn:
>  	dev_kfree_skb(skb);
>  	if (nlmsg_request)
> -		iwpm_free_nlmsg_request(&nlmsg_request->kref);
> +		kref_put(&nlmsg_request->kref, iwpm_free_nlmsg_request);

You should consolidate all related changes in iwpm_msg.c into a single patch.
You also overlooked updating iwpm_add_mapping().

Thanks

>  	return ret;
>  }
>  
> -- 
> 2.34.1
> 
