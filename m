Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7906D30FF36
	for <linux-rdma@vger.kernel.org>; Fri,  7 Aug 2026 17:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786124915; cv=none; b=dgTRdKDgDLermAb7/teJCr6xoVYPRsZc9pLI3q63Dg7tVvIhVE+icJxDfr33YLkArG4B0cdcXgBmLVro/+xR/e8Hdo8J2uom0EfPX0iI/FLZXIGNWUZOlPOfw5vxuJIlz+NSZbmiNsRcnnwCIASbUbJTOFQZ7WlZV2NefSDupog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786124915; c=relaxed/simple;
	bh=B2dhcUAy99nJ6Q8/2A/3L1wWVEyE/AbW7wE9iaKuQWk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hsB75Mo/BnUJV6zaNaq8PP8Xj3729Egnz0amtlU186ywjhnDK5Clz3I50KZXvkTRlfbPC1pyAPsdGRkXyGQBZaYTQ0CI99CTdKzU4VtUpEkoTt1mOQnqpLtbEkU66J4K31ZP7zL/r7rHfYs1X/3lrBmNWW82UdfZieuNf8L6XLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=RUNoTSIQ; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="RUNoTSIQ"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8eeadbc5e21so24620976d6.3
        for <linux-rdma@vger.kernel.org>; Fri, 07 Aug 2026 10:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1786124912; x=1786729712; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=a5IgWT1wGp6cqflJGNJAuwwfXTXvrfSYmZSZMvhYv0I=;
        b=RUNoTSIQOr7hxR2MvzQYz+TKhubjcVPdYCRIhq/p9n+anptqVMW96Z5V/aUxhOqZyn
         jqlL+lYkbpJRHRD8dReO6q+HVKtGOTbiCAuoygUs0QR7fvOI6XrUHbC2XSHopJ9FbNKK
         jyL+Vfnt3fc5nAV26iXex3Le4zf/gxiOhtu0dRsiDCuCrd6d6rJrbZDXw/ZJBBKRoHG9
         a+yCPFGdl9oyyxudCjgwNOU+ehf2tI+cLSeKOXk3Kt0tvK1PjdfUtSJGFB8WC9ZJFAmg
         xteMd/qhUx5ovrhmqZ9X3W83nMzKgSRnIkjNwTN3CnwL4mSuAo05MCQugHRCHc36mumz
         d3lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786124912; x=1786729712;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=a5IgWT1wGp6cqflJGNJAuwwfXTXvrfSYmZSZMvhYv0I=;
        b=oSGw2aTOQKDfo+1cpTJopMsDZKunPEyNUlol2F4AiHZR1OSUDxons7v6CvU1LC6Pm/
         VkUNvcDM9VVkujLR8RmdGPTwqEoGRkt/auoFMAhXfc/PSFcXe/pveHmpDfYpNK8XVYS9
         ddyFmccgqr49EqLPpy/qTV6pgGETjxRnBsm4oZAfDtenLCSRXO1F2L2I+KQ2v70sJ6Ou
         F1dyxN/gSuKgY9ZKKt7zA75J3+6KzsIUNAZ+IYSKG37PDr1hGjiPzKP3tOmi7dZ0QEkd
         p0iRL/4VdeFG58374ugnUDfKD6/k9FT5B9RBJdQ8aC6v5k1ayM/XUWpyXo2nVBjpArSN
         JSgw==
X-Forwarded-Encrypted: i=1; AHgh+Rp5Q+x/00Bvcg5meIXxTqoJLBmCv9L2tCXMymD3hzRlIDm0Fga93UjVPAIwdeYF+7EW+KNIaJr+Ex8L@vger.kernel.org
X-Gm-Message-State: AOJu0Ywk194TvLw4GVsFj65OI0qgVVi3i2Ae6huJDXBW9MXSQtuUHO6j
	u4ngA1IyN+D0LshaUlYXK1fOrSpUpS2zbg+hpcrsTaBzSlzP78Y98qYAX7Ufi/+HHiI=
X-Gm-Gg: AR+sD11/Kf95rdJLVie3itCAAcAZa4z2BpoaDMVjaM9lgCAJIuaGw98lPbQIfRygvgh
	6bx+7xeX9hrVyX9fhT3u9Rmq4/Mv0SuoZRjtNoY+82KwX9tAuOjm08/WGSaHvBLUDHivzHoGNvy
	/tXE0crS7TVoS3kRLDJ6vUwjTaygSUTwHbtvW0IrGzlQxZwTODl8LDrLmTuqUVKttTpPVkDii8M
	gqDgOVmKqshaP92DEJFYRPYN881TY9BzalGxhZY4JKV12xy/IZIeMIoqgiICxHyyXMlhQXvelII
	2aBvxR+KKtvf2ZbB2ysKzpnXqiykUMGDc9GSZW0gBExUu/5upfWekBnW910elcCzkVXF7M2ebUn
	7XmKpQ1CsLCbUkIFxYgMA3M1THAmtVsb8Evaeu5nHmws4VIrYdOubTEIv8+aAguPIJUHBWx6wsU
	Gzh+9RQOzAxTFX4H5UzhfwDjl5+VUKlFjk7tQVeQ==
X-Received: by 2002:a05:622a:c8c:b0:51c:2340:bbdb with SMTP id d75a77b69052e-52d18fd59d2mr61313441cf.26.1786124912297;
        Fri, 07 Aug 2026 10:48:32 -0700 (PDT)
Received: from ziepe.ca ([142.166.156.215])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52d166297b7sm17136451cf.26.2026.08.07.10.48.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 10:48:31 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wsOgI-00000001ArF-3vYh;
	Fri, 07 Aug 2026 14:48:30 -0300
Date: Fri, 7 Aug 2026 14:48:30 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: Chenguang Zhao <chenguang.zhao@linux.dev>, andrew+netdev@lunn.ch,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
	dtatulea@nvidia.com, shayd@nvidia.com, moshe@nvidia.com,
	Chenguang Zhao <zhaochenguang@kylinos.cn>
Subject: Re: [PATCH rdma-next v3] RDMA/mlx5: quiesce CQ polling before device
 shutdown on reboot
Message-ID: <20260807174830.GF200537@ziepe.ca>
References: <20260715082307.1593915-1-chenguang.zhao@linux.dev>
 <20260716084211.GC70906@unreal>
 <c2c5dda9-3228-44a3-a4c9-89e8cc4501bc@linux.dev>
 <20260716105008.GD357857@unreal>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260716105008.GD357857@unreal>

On Thu, Jul 16, 2026 at 01:50:08PM +0300, Leon Romanovsky wrote:
> On Thu, Jul 16, 2026 at 05:03:37PM +0800, Chenguang Zhao wrote:
> > Hi, Leon
> > reboot -f skips orderly shutdown and goes directly to:
> > 
> > kernel_restart_prepare() -> device_shutdown() -> mlx5 shutdown
> > Upper layers may still hold live CQs, while ib-comp-wq keeps
> > polling — a use-after-free race.
> 
> The point is that this flow is neither RDMA- nor mlx5-specific, and it
> works as expected. mlx5 shutdown() stops the FW/HW, while the kernel
> stops and tears down the running threads.

I'm pretty sure we are missing stuff in the driver to synchronize
everything while it is doing a tear down or health recovery.

Ripping a driver out from under a still-running subsystem is hard,
this does seem like a real bug, but I also don't think the shutdown
handler is the right place to fix it..

What was the actual UAF scenario, we should take a look at that more
directly?

Jason
