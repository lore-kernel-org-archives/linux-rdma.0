Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14875342177
	for <linux-rdma@vger.kernel.org>; Fri,  6 Mar 2026 14:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772806396; cv=none; b=FM+swOw1Vk1QIBOZNT7ljS4+qNUtu0NQlqZn8trqDzKJkisn3DNPFogpDArhuhL2HExtxkL0adQuCBTtloC3/IYzY9Q33XD7kD7rNRSb4qT8NflXESjdBqkBiazNT70GkfRkt4P8YnrdOP7q7QK76PUa9PO0wd7nLWl+0Z5myMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772806396; c=relaxed/simple;
	bh=YU0nCZB5g0/WFCrlPQAuqSrwJGmSQYF2jN6VbohiKP8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d8WtF/BT/h/L71cRx2QmN3N345HSIFNLv7+FYj+eqSTh7EEfkf4GjyPzwIaPG0jGbXqAmEi6Cj/+m07A7eOXuib1SpW5gQPYxY6TrUVy5iD5zCNtx/204ybV8d9lwwyrECqIBVWOs5CRi41NdVUoLjcuLNb2JW9/kc4xcbaquHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Vj+kQW73; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Vj+kQW73"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8c6f21c2d81so874102985a.2
        for <linux-rdma@vger.kernel.org>; Fri, 06 Mar 2026 06:13:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1772806394; x=1773411194; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qbnMy2ZvQKv7XexDfnSiXXigerbMB6pNDzD5OW8JzmI=;
        b=Vj+kQW73d5KK2AQ/5vahdGMNtCxhMLJftbLYVC0rX3wb9e8nXC+fky566C2cafz3pu
         lyylxXabKEUAAgoNjCXXA1CIVkwooHIRpRsBVvoPiBjRUHQlsIckP8lZrmATgBfT2xdB
         1Kbgzx55wb6nXUt9SmFKVC7RrXvtlEzTt/nkppKlgQclrQe2jLtG81V3sC8zt3UMhVj5
         3bMizCerW+ejfzsByqgGkPlN27nLMbXUeThgUO38I8v3QHzLyf3RmUJiI4CjDaQGurrG
         y94LhDNq4fV/wSTRAMa2fQRdfrRNhYtMi6I5G6gDKiYQLLN2Y0ICXytam+e3U6VT2vj5
         HTSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772806394; x=1773411194;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qbnMy2ZvQKv7XexDfnSiXXigerbMB6pNDzD5OW8JzmI=;
        b=K7iFRM5ac6IBEzRhbqhv/Faa7DHSOjx7MZQ6HCKZHw8/FVQh3WqoB/boRpfzm3p7Hj
         o9Z3JbbYdHe12nxcuGtjASj6ac75XyaDaV+fFUUZ4WOY4Nlx2twhpTXGcV1Xir9sy7uY
         IEDfuz9gs/jogngYbjgs9eIlTO/oRRf+QYESMlOZz3OM70/WnGcFw/L4biqT5h8bCKkv
         gmvFhqAP/6USNHuDAF7HHVmdgrULzEHOPbENXCXAmU/4SNdXMVlGxuzBfe9CoCcvM1fo
         IFA00QQESRo6Lonqh6k3M31ToyW/RJBTZ8EEgwTTWShNugMal1uylUqRdOdHFraukwxd
         XzCA==
X-Forwarded-Encrypted: i=1; AJvYcCWKXEuts9t5DpAKi0kyeXuIk9jK5NPPifftRM1E0FXuKEAHo0vFzAeUURfMrix7jXLjRtKoH1QhVRrt@vger.kernel.org
X-Gm-Message-State: AOJu0YwUvr58528hGBnSn3foBhqkAGZO/iK6DZSVftgt68iCIOezBf+L
	YQ40r21cqssFFjxBsnNkjfads3k/WCkZ3SK9QWbT2SauCBrlqiwh/5fY8/4gEAzEjfU=
X-Gm-Gg: ATEYQzxxnZa7xX8NvwcstrbgFja0cdND/Bf0kgu1N8WdQUCS+AeHGqvETGruRwlVaII
	MDGrtubBiORBOwS+5p9PFufjGuOqYcTLbL2dEAa2Tnw1sqakHeFKmGu6614VAcc6WAEyBtB3mlX
	/CpHkRt5AOPfbiVinE0Er41u94/oYxzxNoDJimZs3Y1nPAwSuYxr73H68AE/mWn+/g+5gpRjUBj
	APPrZGv4HXeLMmRHh/IZ0bnsi1hYIVhxi+cUgtxaRf6pHcThKRKqL6a7COEPK8OwajonoUtMu0C
	jsc90TUXri5+3jQUxkJoHNglGYKAkrrfePcsAkg7X4tNCgB8wDQcq7HR8aG3CaPN8fSdXo8TGFD
	4rd2B87jl3VobX+tfNPvsAWEkIZ/NhYlMoToNYhSE7raXdvXVqxkMwcNMrXX/VU6mcQHumX/yyK
	JXOypgb0+VR+qKVIWKSr6U5GrN8FMx9n2yCR9ciDvU9wB+aJCp6AnQiV+cRBBUelZXxIrbAbecr
	dquzYAJCce4ETJxtlA=
X-Received: by 2002:a05:620a:470b:b0:8a1:b5ab:bbd6 with SMTP id af79cd13be357-8cd6d4fb49fmr279334085a.71.1772806393751;
        Fri, 06 Mar 2026 06:13:13 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cd6f53bd51sm136666685a.27.2026.03.06.06.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2026 06:13:13 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vyVvT-0000000Cx0p-4162;
	Fri, 06 Mar 2026 10:13:11 -0400
Date: Fri, 6 Mar 2026 10:13:11 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: kernel test robot <lkp@intel.com>
Cc: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
	oe-kbuild-all@lists.linux.dev, Doug Ledford <dledford@redhat.com>,
	Jason Gunthorpe <jgg+lists@ziepe.ca>, linux-rdma@vger.kernel.org,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: Re: [rdma:wip/jgg-for-next 18/19]
 drivers/infiniband/hw/bnxt_re/ib_verbs.c:3478:37: warning: variable 'cctx'
 set but not used
Message-ID: <20260306141311.GE1687929@ziepe.ca>
References: <202603060549.g4df8HXz-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202603060549.g4df8HXz-lkp@intel.com>

On Fri, Mar 06, 2026 at 05:52:07AM +0100, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git wip/jgg-for-next
> head:   7f022cadde7e1fa6e5f7abac05e01bdcff5e19a3
> commit: 387f31e96d46cd6ba0cf6b2439c367440f60255f [18/19] RDMA/bnxt_re: Separate kernel and user CQ creation paths
> config: x86_64-rhel-9.4-ltp (https://download.01.org/0day-ci/archive/20260306/202603060549.g4df8HXz-lkp@intel.com/config)
> compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260306/202603060549.g4df8HXz-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202603060549.g4df8HXz-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
>    drivers/infiniband/hw/bnxt_re/ib_verbs.c: In function 'bnxt_re_create_cq':
> >> drivers/infiniband/hw/bnxt_re/ib_verbs.c:3478:37: warning: variable 'cctx' set but not used [-Wunused-but-set-variable]
>     3478 |         struct bnxt_qplib_chip_ctx *cctx;
>          |                                     ^~~~

I fixed it

Jason
