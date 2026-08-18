Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D532123E325;
	Tue, 18 Aug 2026 16:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787070008; cv=none; b=YEXdAYARHDn1dzo9bKdVv5qLxXQyzIGJziqtWcDKqJKXJXtZt13JGPcYhbaJvdkNITNCgPEwtC+eqVWK1oAziPICtu1g24rOdDPOJtb3urX4pJoWAX/AuGWdhBh8sky1Fa4GXkyGGCedGLoJmPcdQ59UcYBCSfKRR0zFKqN5FqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787070008; c=relaxed/simple;
	bh=yxkliXWesWiCi3foBPl9p6T9SvA9nlVQHNj4rveIru0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OaSYd0J67RAxY9Eek1yyP62FC79Klg98bX91Ss8wEhCeK/9PCD5PKEgutck8SelcgqcQ7RazrpcEslIGfMSf4RSlw7UikoA8edIoat2j5WFGai9qsK7FYIC3dTz9g6tGCjlMNiarduMyrnyFm0zUZLDHIcrxdH8U0qM7NtXSNhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PKIHd+E1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PKIHd+E1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A821F00A3A;
	Tue, 18 Aug 2026 16:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787070007;
	bh=EoccZUmFZ1vWVHYL9ZYevW51B1dbZMK3ybbpx1KHxgg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=PKIHd+E1Mvfb6BrDcVdnVayOJ9LXfmTz8LhrV6+p5pYogvcFA6a93l3OLnx6HWvu9
	 4k3OEoW7LGP74fBqS85PyQJLiM7diZsbTQ12HznUBnWqZxkns5PJmxpTOZzAEXctN3
	 ZEa5yGmNKy2B+EumBZmL6LYCKpe2p0hIfRAFiQjgBA8JTDomwBvUZPlK8DpeYADXGt
	 dcwgAlFXAhm7opWRDD3enOGeCOyWFd83FYdpv+zrgujBwVWrQRtAzDR/WkmbR2OkwC
	 HlbO4gH1r5p9qUmnMHdYG6fqC87N3YULtMObur2upqj/5cQZVHOyFWWdwDdkJVHpHP
	 5jQAiWjcqAd+Q==
Date: Tue, 18 Aug 2026 09:20:05 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Long Li <longli@microsoft.com>
Cc: Konstantin Taranov <kotaranov@microsoft.com>, "David S . Miller"
 <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, Eric Dumazet
 <edumazet@google.com>, Andrew Lunn <andrew+netdev@lunn.ch>, Jason Gunthorpe
 <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Haiyang Zhang
 <haiyangz@microsoft.com>, "K . Y . Srinivasan" <kys@microsoft.com>, Wei Liu
 <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
 shradhagupta@linux.microsoft.com, Simon Horman <horms@kernel.org>,
 ernis@linux.microsoft.com, stephen@networkplumber.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v7 1/7] net: mana: reference-count CQs looked up
 from the EQ handler
Message-ID: <20260818092005.25dfbc17@kernel.org>
In-Reply-To: <20260813174243.3044348-2-longli@microsoft.com>
References: <20260813174243.3044348-1-longli@microsoft.com>
	<20260813174243.3044348-2-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 13 Aug 2026 10:42:33 -0700 Long Li wrote:
>  }
>  
> +static struct gdma_queue *mana_gd_get_cq(struct gdma_context *gc, u32 cq_id);
> +static void mana_gd_put_cq(struct gdma_queue *cq);

Forward declarations are considered a bad smell in the kernel.
Please add these functions here, I don't see a reason for this
they are purely calling kernel APIs.

>  static void mana_gd_process_eqe(struct gdma_queue *eq)
-- 
pw-bot: cr
