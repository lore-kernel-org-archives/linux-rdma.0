Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0350478E57;
	Tue, 18 Aug 2026 16:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787070061; cv=none; b=B/RM+Wg6q/3jq4Nfq4uRD1mQK8xIGsbm11SrnWCIOEcKC56jc8mvGhnbr6SyrICBIzE5wJvfBt2pQ5kwih5cgBzlAR8V1KtvNk3UUZraz4FsybG5RRanOBeNOLW1lfNArp+f3tun2kuuomKYHt7bDWrmcQi8adEZGS06za0KnOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787070061; c=relaxed/simple;
	bh=XVkiqEzmR8LlmHZj/orPfn9pbzTjaNByvc1R7R8haLo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T2gfpnrTEGlUBdkQ2w7xP2qFgQdSo1FeP2IArQyAL510M7AEeti9CKftJuOwAn26qdIQbW4jngZIhC3P/81UY6UwHRkrwK5+gj9Q1iYe5hQkBE+poOkujsDVvOz6U27RIaU+A2WjrXv8JPnrcoSe9xnG8fy3VeGBxNJrOm1UCtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MZdEzQLJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MZdEzQLJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 643781F000E9;
	Tue, 18 Aug 2026 16:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787070060;
	bh=o1Rc4UcWATfkuiiyIovbnQ/+G+6Oq09fG28yqi1Cnzk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=MZdEzQLJzwcyb9kJtmLO0+JkFJrXWOkPKU4MY7V91s02HQcUeVVHDOho4ELGu7RJq
	 gqsJ/g9iECrT6nUZwio1b5NxuTrNvmBnV4shEoBg+Pbn3A4wHWiwTPeHG7k5N2qYgT
	 KwQglj14EDfITJuqbyDqmdpx9kmvCYaU3q59f3oZHzjvHjxIzGrxFwNROjexZtyN6b
	 jgrRLVXgNdXfzRKjXiUXT0GRwj0ScNT4/AwgtBMTe9ryAuPKZkgybCX6nIYJbMtJ6u
	 DbRLlmSvzLSKRZhzikieK4KvkUKC5E8lFEgI9e6CVF5rOWr3HBI3xGJd6OmhMT8NCH
	 ruiPJXQn1vK9w==
Date: Tue, 18 Aug 2026 09:20:58 -0700
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
Message-ID: <20260818092058.5da26ce6@kernel.org>
In-Reply-To: <20260818092005.25dfbc17@kernel.org>
References: <20260813174243.3044348-1-longli@microsoft.com>
	<20260813174243.3044348-2-longli@microsoft.com>
	<20260818092005.25dfbc17@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 18 Aug 2026 09:20:05 -0700 Jakub Kicinski wrote:
> On Thu, 13 Aug 2026 10:42:33 -0700 Long Li wrote:
> >  }
> >  
> > +static struct gdma_queue *mana_gd_get_cq(struct gdma_context *gc, u32 cq_id);
> > +static void mana_gd_put_cq(struct gdma_queue *cq);  
> 
> Forward declarations are considered a bad smell in the kernel.
> Please add these functions here, I don't see a reason for this
> they are purely calling kernel APIs.
> 
> >  static void mana_gd_process_eqe(struct gdma_queue *eq)  

Well, prolly not gonna have time to review the rest this week
due to the merge window, so pls TAL at the AI review as well 
before you respin:
https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260813174243.3044348-2-longli@microsoft.com
