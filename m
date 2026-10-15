Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6261A3F1043
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 17:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792085363; cv=none; b=UIHK/sdNRkrwEZE7wLH1lT14+iByNGtUYY2UXvtz91sVoK/Ytw0i25+41gLHnho+eVr2qt137ejtXJd6iPIAPn9iH2HK0oitggAH9cQyIDo9rFHTcngt2gmAb5adRg+Z0TYf4k3SDj2PWrb08+w2NXNpQTqc49gZXhsIDFLQjfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792085363; c=relaxed/simple;
	bh=amXZaAZdJYc2A2RpLeFEs6m5SpFPOdXyChqVqpnoVEM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uvqsVf8A3FouPA9dWOIjeA7Y9HS77TmWVe3CkIcqSJtZGGSR89ECgQVoxtcVcMKulEOoY6l3NW2R3WlbRLwprio7sKKX0ftaNJS6YcTIigVuW1bTLhzJL7VEG981FLeHvXVatDW+w2AUjkxTROF+Ek4qVueZXB5MZiiAFfvob6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=bzu5VQ76; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="bzu5VQ76"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-917c04630c2so67913256d6.3
        for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 10:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1792085353; x=1792690153; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CHoGzVuQLAsPz2pRCMbpyEq22Gtbipe1ICxFRy4plm0=;
        b=bzu5VQ76ylAKWRnh/lYE1nndaio8bVwnwbDtflzuBjHXZgQnzwoBruJSDNJ7tMIWk8
         B2/I3FGe9YAd63QITiu7SM3pyYHDGQ+u3xWY0cHKaVLjjXs25pX5lAYh/KR/oZPfP8Kw
         mTB9CN4rIaD37J0kYUtLDlML5jKBccQJ//uG9/rmNEMumvaPLG/E8nKd6BulKELdROFD
         AoOUmHqkC5atQstzP5SlliDgUes0JwknRYcy6FEdm1VBqbiAYLfk36zzy/x1+b/fzETC
         xLNiaHJe7EjFnY1lJ3bAmXxR35Ingrmpc0lIGw/svLNatibsUuqQskUPWd15BFwqK30n
         TgFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792085353; x=1792690153;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CHoGzVuQLAsPz2pRCMbpyEq22Gtbipe1ICxFRy4plm0=;
        b=Cw6UP1g1byWuSN3ZML4r04GEAMCXtgP//ng7HVpM8zM2nexcKDaN+vfJkBYaqW9nPy
         gjveSfFlO6T44rhe8X6LEhCYWfQF1DCLL66xmt2e+LVnDxEPNKedmAkINskEv6kibjZb
         9x0ABKNyqasCf+Yw5UGBAGChzMbO6/mJlEQuF25UzMCMVgOEMKPW7sbvRaF29k1pfrhd
         HkqYz31WhQJKa3Ip63G5L316dgrCXnkufgBwR1uTN2QMXyXxwxgWNrc/gcX9L6gH18uA
         NZ0HKQjVcBvoIMTJtjQjTKA3FuP5aT40qVtvM68YUfTxte5yLI1/xIsWK+kwxv0DZ5It
         MV2Q==
X-Forwarded-Encrypted: i=1; AKwUvBwRPNFqpnShiuvDuyU6GE7FhVLDy9ORW248xMTRfI6KPiGxJ0NYFYw6pXGsGmtXFm0z7fIlFOre8Lm6@vger.kernel.org
X-Gm-Message-State: AFq9FYKNzZmxuFqK/5jV9uqIeYHfMuhToduRRvfue+dhs4e4AOjpQFiG
	y5uKejl0CNLSLLaQCi9ctY8rQ7q1OopqzacipLMzGpz7WNcXpW+0a5sjDX5K5m3Vpl8=
X-Gm-Gg: AYBFou0gNgC5WoOhnyI39HMkttdsw7aMxQAIhAe9PPaNBJwTlyBbYfyhh1pg1vccPDM
	Jkab3wIMB9kNZZ20+5O/xBP4DpwetQBzUpyDlOi9QQXrDO3qkiYfL+QPwzzSt4RvbAXDLSfni1z
	pSE69KLwsVeCY04MSzHT+I7RAT6xcjr5gV4/Il16wK3bHt++l9dY6+353i4ikHs1CLa56PVOHMM
	b7n05ekkSO5r+qjJJrWX8GuNlM2ezDUaa9gMemxAobuIplHW7DTTIqZs4ZT1zKXDO04hoJCdpVM
	G96OBJwyMzjYmLwsVB5mPQ6baTWeskSGnSoC603J5SgrdRfQw8blU/odM8+EIW9EY5UhHVGqOaS
	KbhqFAkg0LyoJgULIqLoFXVjZjCULT9Q6yoPMEDrsL9vmSEX9QLsuUP/j9ntSLrmgyAIY3qeuyc
	d5hPBjElj4THtt85gMB5F8cZrhtsCeRdIA8YRUYaSlyg61KSPVKbjED/ZgBQKg3fRabwqvuSsN3
	osC1nrSG6ZiSWxqQGHc7EPCUPQSJoYvtgumnypfxMNxm+cyxCl/8jwJ
X-Received: by 2002:a05:6214:240d:b0:91b:9136:d30a with SMTP id 6a1803df08f44-91b9136d6dbmr174939356d6.10.1792085352839;
        Thu, 15 Oct 2026 10:29:12 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91bcb8b6323sm1081556d6.6.2026.10.15.10.29.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 10:29:12 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xHPGR-0000000H5F2-1XQA;
	Thu, 15 Oct 2026 14:29:11 -0300
Date: Thu, 15 Oct 2026 14:29:11 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Doug Ledford <doug.ledford@hpe.com>
Cc: eric.davis@broadcom.com, Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH rdma-next 00/13] RDMA/core: Ultra Ethernet transport verbs
Message-ID: <20261015172911.GR14213@ziepe.ca>
References: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
 <2bfb4db7-c9e2-4aa4-91c4-7991ee858089@hpe.com>
 <20261015000834.GQ14213@ziepe.ca>
 <733df751-5e7a-4004-84d8-627320734c30@hpe.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <733df751-5e7a-4004-84d8-627320734c30@hpe.com>

On Wed, Oct 14, 2026 at 06:02:38PM -0700, Doug Ledford wrote:

> > You are running sashiko locally and fixing the bugs it finds?
> 
> Yes, but with one caveat here at HPE anyway: We have very limited AI
> resources we are allowed to use for data exfiltration reasons 

Ah, that will be hard for you. You need several runs through sashiko
before you post anything so big. That needs a real AI license. Gemini
or GPT are good choices.

> However, also keep in mind that this is adding a new QP type with
> semantics much closer to Portals 4 API than verbs, and that does create
> some friction not just with the rest of the stack, but with the AI
> reviews judging by what I've already seen from the Sashiko reviews to
> this series.

Lovely. It is a great sign when AI can't even understand the code :\

AI reads the comments, humans read the comments. Same with commit
messages. Try describing a little more what is going on and why
things are OK. It does actually help get better results.

> Probably wouldn't hurt.  But, our driver is many more lines over in the
> drivers/net/ethernet space than it is in the RDMA space.

Well, you need to get the netdev driver merged first, with a core
device and aux bus scheme. That means I don't have to look at that for
about 6 months probably.. Yay.

Jason
