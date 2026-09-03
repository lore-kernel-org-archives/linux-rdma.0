Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32639408035;
	Thu,  3 Sep 2026 09:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788429176; cv=none; b=jhTCLWehmo00HZ7ioSu2Pq+EH6ep+kOUUxCdneRZ/8muLTAasrWNsGiy6w82Y+09J8+wLJvRQVs4TzA2rpGpqJcIs6jAXhAKRKCUD1cpju0YwMt8bU3/ivlfLbRB6Oth5NhCDJ9IL7dx9XvJSOxDuPV8xctAZ2khDRRzyEglG88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788429176; c=relaxed/simple;
	bh=IkjVeJlu2GyIRqgnlO9/fmTMTZy0l1j2IVaaUQyZ7/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AR0Aaw5vLQn7mouetcBvM/CaKUQbz5ZNVYwaI/rTQAFO1Cnm1TYuavPubj5LjweU5vHUL1XGKGgcfrc5gJzERdJOr0l0dNBnATGmLCT7o1fNrumizxVGPA2YhoTnc0uZN0qhI0qSiTusw+kyisWP6RDTrRn8greDviXNsHA5Y/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WLcgma3n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WLcgma3n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E051F000E9;
	Thu,  3 Sep 2026 09:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788429175;
	bh=auxsqhZdib4fhY1vUwbGflRaYABo5XW0dke60z6sCNU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WLcgma3ncAtJp+7GHQHq7NBsEfK76PvoL5c4PwPEbNcoq+VBrg2gUfXSOdxJtv5wA
	 +vF8Azgy8y1BovDRfBj3Ccz0Ok9BDz4GbbBSPE3ENWyRIb2drfg/OfICtIXJlJLz5F
	 0EMBdgsviXXhdJbdIAnjfbJD4G+RdTlcTfY/WezavokKEINixTeCi86CQoNW0DWVbw
	 FxaPy5J7VgYYEIhfO8V9mt2+pM1NiFiJO5/xVzhkUSNHqFtOhhi5SCAi02Yh7xHkv/
	 NWG/cAt5BnbTdLknaDMAZW5JxXggnDATeiMR2DaeFhVwtSx23MBgAHx1HEHhAHnbHT
	 icSSaeEgIpUMA==
Date: Thu, 3 Sep 2026 12:52:51 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jeffin Philip <jeffinphilip14@gmail.com>
Cc: jgg@ziepe.ca, kees@kernel.org, Tatyana.E.Nikolova@intel.com,
	roland@purestorage.com, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, larrystevenwise@gmail.com,
	pj.waskiewicz@solidfire.com,
	syzbot+bd317784d628820741b5@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] RDMA/core: fix refcount bug in iwpm_get_nlmsg_request()
Message-ID: <20260903095251.GB24140@unreal>
References: <20260902085213.145312-1-jeffinphilip14@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902085213.145312-1-jeffinphilip14@gmail.com>

On Wed, Sep 02, 2026 at 02:22:13PM +0530, Jeffin Philip wrote:
> iwpm_get_nlmsg_request() initializes refcount _after_ list_add_tail()
> making it accessible to global list where another CPU can kref_get()
> on nlmsg_request causing a refcount "addition on 0" bug. Fix this
> by initializing kref _before_ list_add_tail() so refcount for
> nlmsg_request can be incremented/decremented normally.
> 
> Reported-by: syzbot+bd317784d628820741b5@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=bd317784d628820741b5
> Fixes: 30dc5e63d6a5 ("RDMA/core: Add support for iWARP Port Mapper user space service")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jeffin Philip <jeffinphilip14@gmail.com>
> ---
>  drivers/infiniband/core/iwpm_util.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/core/iwpm_util.c b/drivers/infiniband/core/iwpm_util.c
> index 990cf928b32a..5d07c5756987 100644
> --- a/drivers/infiniband/core/iwpm_util.c
> +++ b/drivers/infiniband/core/iwpm_util.c
> @@ -313,13 +313,13 @@ struct iwpm_nlmsg_request *iwpm_get_nlmsg_request(__u32 nlmsg_seq,
>  	nlmsg_request = kzalloc_obj(struct iwpm_nlmsg_request, gfp);
>  	if (!nlmsg_request)
>  		return NULL;
> +	kref_init(&nlmsg_request->kref);
> +	kref_get(&nlmsg_request->kref);
>  
>  	spin_lock_irqsave(&iwpm_nlmsg_req_lock, flags);
>  	list_add_tail(&nlmsg_request->inprocess_list, &iwpm_nlmsg_req_list);
>  	spin_unlock_irqrestore(&iwpm_nlmsg_req_lock, flags);

These three lines need to be the last in the function, i.e. all fields must
be initialized, not just the refcount.

Thanks

>  
> -	kref_init(&nlmsg_request->kref);
> -	kref_get(&nlmsg_request->kref);
>  	nlmsg_request->nlmsg_seq = nlmsg_seq;
>  	nlmsg_request->nl_client = nl_client;
>  	nlmsg_request->request_done = 0;
> -- 
> 2.55.0
> 
