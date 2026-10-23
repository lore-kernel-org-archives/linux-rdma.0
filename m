Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774599;
	b=We/rRTx2dJaDyF/6rZSZs2k4LscCOR5YV5F2NHKPFVb/v3/UM9QJM8iXbPBoN4SneCnD
	 WyfROPTRmC+VTjpDt0TflkIXazLuTGyYi2Esx2UIk2exPAYd32Q8CiWUuwrOLL1qNFGbC
	 DLabcAwaTCvkW+vz/m9rrT5WsSJk7IgZiUmtBIfT8XmD5N+WCF8W1DJf7yauCv/MOT7nd
	 tXD59Y5lEEdLmBLTIaIWzo+yMVzYhHpiyB2uhMSjv9G3YQ95eWg79F3kz03c78vTvrRtb
	 /1Ka7oF23f14wvNfUQ8r3vQiWcMe1cgyIyScn2AhOLN0gyUF0UFOGlukj69FgmmHaUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774599;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=DkY0yffP/TSTVVFtKZfn1AXeb2RPVc818IaAsv/BfEs=;
	b=1A6a7Bb+H1ddt8VTXGfRV63KATFBUot50BpDqn1Hyjh/tktR2cevP3GFR3umfDeRcMCu
	 dbIgw9t8YLhmWsMDMt8e3dDLXGgUE1degLg0zwXqCAibtoArTaxOjbcNm0bpoXcGatN+J
	 03pwZn195CVQV0vtHyfx3b+eOlqRiiU605DRzhrylTpL4YeX5nI5scTIBTlW5Mntg5Xu6
	 k4SzPcgjPsvOljGRUCAXJQzmZ+JHUG84brCyDgwFH6OmH44++jzk2yr3nbM3WYu1fe46l
	 8q2aTX16u8HfPQcGz776kJSmCdKx9WmNXiSVtr6hSVyjwH0ZhvegO0Udo+PMq195CiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LNna1yQH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FBB1606A31A;
	Fri, 23 Oct 2026 16:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LNna1yQH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C02DF1F01825;
	Fri, 23 Oct 2026 16:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792774599;
	bh=DkY0yffP/TSTVVFtKZfn1AXeb2RPVc818IaAsv/BfEs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LNna1yQHt4VZX8cxTfQj8ZaOWEXdZp0vQ+cbohnGbonBduOWUn65kqoCJR5bp919d
	 pDvKZPnbiXdXFs93JzXv9LAVVBTkXOQy1PHOObyZfKztlnuWVEw8qTeU3caa9gVnJl
	 h6st0qqbBRxKMg3yB1FIeahXtYQhVIOJ4AtAi6XFHHthbBfLcLEwIkW1pL7uNUv75Q
	 kMr6pYpYPx1yMEfR7dPlAHS1q7xQQ4ByEty+XUkUfOW1HHeUorhisw4cFbBme9v9OK
	 T43yZMr5Ct2uU0QeOoOizatpKYAa8lp/YTZrIU3Kb9SJYat2zB+TIRSITQ3+Abb7Pj
	 zwmoUmraOolyw==
Date: Fri, 23 Oct 2026 17:56:34 +0100
From: Simon Horman <horms@kernel.org>
To: Peter Morrow <pdmorrow@gmail.com>
Cc: Tariq Toukan <tariqt@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>, Yishai Hadas <yishaih@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: [PATCH net] net/mlx4: always create the eth and ib auxiliary
 devices
Message-ID: <20261023165634.GA888721@horms.kernel.org>
References: <20261020164239.3808903-1-pdmorrow@gmail.com>
 <20261022101915.GD708417@horms.kernel.org>
 <CAFcZKTyrRKS+A1cb4ZrjgbEwJpEHMVNCW=Bx+emzrBdC8H-mug@mail.gmail.com>
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
In-Reply-To: <CAFcZKTyrRKS+A1cb4ZrjgbEwJpEHMVNCW=Bx+emzrBdC8H-mug@mail.gmail.com>

On Fri, Oct 23, 2026 at 03:08:23PM +0100, Peter Morrow wrote:
> On Thu, 22 Oct 2026 at 11:19, Simon Horman <horms@kernel.org> wrote:
> >
> > Thanks, this looks good to me.
> > And I think the minimal approach taken here is appropriate for net.
> >
> > Reviewed-by: Simon Horman <horms@kernel.org>
> >
> > I do, however, wonder if a follow-up is warranted.
> > It seems to me that the is_supported callback could
> > be removed entirely. Leaving either:
> > 1. struct mlx4_adev_device with a single member, .suffix
> > 2. mlx4_adev_devices as an array of of strings
> >
> > To explore this idea a little further I tried coding-up approach 2.
> > Which lead to the following (compile tested only):
> [...]
> 
> Thanks Simon. Agreed, a cleanup here would be nice. I'm happy to test
> and send your suggested patch to net-next once/if the reviewed change is
> merged, unless you'd like to send it yourself.

Thanks Peter,

If you could handle preparing and posting a formal patch I'd be most grateful.
