Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795529353;
	b=FO90ESoDg+fx3BfPoggt65+266zq22zP+7pP3UsrBauAv2CO8FHNTQT5dH8mZjItcQRH
	 GhLRz3whOIk2T7ujZAE3W6lWvL9D2mAeiHypaB5fd7di+ECcjxxCyzJpTnvTSE6p0zBAB
	 hDZrz4y4oOVEY4OtrrriZ4QW2lNjhxjKgi6d+fEDoHTl+zBObjlYEBEFFpM7hyd7qkNqS
	 uLQ71oPDXGIrHwIRFjbchL3JUi99m8EST6EW4IisKZm6v8uIdrN4QSbjDTBcECf1wuoag
	 653LvbomN8/m+Bzpgi+2gh8GWlBh1bGfAuWpETTH7evSb/4ZHqCoiv3rdn8XwW9kI4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795529353;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=aEKRkCZACHzceBkoblP2azxF4A1wSUzhMP5SkMMBDpk=;
	b=0pdUsonUcwi7wbnKH+onmxU2YXtKtewWer5CGEz0Renr4sU/lim7nckutDBbSoCOhTYW
	 +ipNW5yB3o2rOtTkTME3RyuQQ+357bALNZfuMh0FIRAPJeMRV9oKwfguC5coWOoFluXa3
	 nx9PQ6tecoB6gdnta1bkPZRjHNEplUjvsBX0CiPrAy+3Grbpo5n0DTV2sc9J3pmGiLLio
	 Ie/HEeh3gurffUainqSUgPZvwM7nIgTXJMDxuFBzpwAof4NsRSjZ8Lzos6GebKmFi9VPw
	 y+e1C9HmDh5CqyrbkpMaOOXbMUiGLIq/QcoKb0FgOAS8mNQbFx8qHwC+tU5u5Nl576w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="A5wtGxY/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CAED606A330;
	Tue, 24 Nov 2026 14:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A5wtGxY/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77B31F000C4;
	Tue, 24 Nov 2026 14:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795529352;
	bh=aEKRkCZACHzceBkoblP2azxF4A1wSUzhMP5SkMMBDpk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=A5wtGxY/gzbCZyw2JK0u1Zz5AF3vUHKBczaHqF5pbM3N4gPSSXnCtILS1BQu36VtM
	 HsylVIwckeZi8EtgHQjG46i97HZzMPeimTD8V8Vn3Hx6xs7AG+VXKZntFhPSyPN9R4
	 AFwNrZJBRTUkz9k6msBF/RcfjCo0LFGhc/TUZvUwTS4xcxxUnCFi7wJ/EgSXIjSUPy
	 nFFlQbSfXf4xnMnF1zbKQERfZjWYX49LAjqevrGQe+66g+fdUA+wvDPzPm49rufPSI
	 Urq3cmUZKt0PkNqcEYZF/oYT12RNLfqBJPutypGDC1Dmorw7R1dkqd1NESpU2Jng32
	 JryMSsNSfo1ug==
Date: Tue, 24 Nov 2026 16:09:06 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Yishai Hadas <yishaih@nvidia.com>, linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org, saeedm@nvidia.com, tariqt@nvidia.com,
	mbloch@nvidia.com, kuba@kernel.org, pabeni@redhat.com,
	edumazet@kernel.org, davem@davemloft.net, andrew+netdev@lunn.ch,
	dtatulea@nvidia.com, moshe@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V2 rdma-next 21/21] RDMA/core: Report and enforce
 adversarial mode via GET_CONTEXT
Message-ID: <20261124140906.GU14811@unreal>
References: <20261117170914.27410-1-yishaih@nvidia.com>
 <20261117170914.27410-22-yishaih@nvidia.com>
 <20261122073156.GA12665@unreal>
 <761ca80e-a772-41f3-b8e9-cc332e4ba5d9@nvidia.com>
 <20261124125327.GR14811@unreal>
 <20261124125950.GC9566@ziepe.ca>
 <20261124133353.GT14811@unreal>
 <20261124134751.GJ9566@ziepe.ca>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261124134751.GJ9566@ziepe.ca>

On Tue, Nov 24, 2026 at 09:47:51AM -0400, Jason Gunthorpe wrote:
> On Tue, Nov 24, 2026 at 03:33:53PM +0200, Leon Romanovsky wrote:
> > On Tue, Nov 24, 2026 at 08:59:50AM -0400, Jason Gunthorpe wrote:
> > > > > RDMA/core: Report and enforce adversarial mode via GET_CONTEXT
> > > > > 
> > > > > In adversarial mode the NIC is not trusted. As the kernel protects its
> > > > > own code from it, user space has to protect its own area, e.g. the data
> > > > > path that polls CQEs directly from the HW.
> > > > > 
> > > > > Hardened user space might use a different data path, with extra checks,
> > > > > and support a smaller surface. This isn't needed for a trusted NIC, so user
> > > > > space must know when a device is in adversarial mode.
> > > > 
> > > > This information is part of trust level series. Why is this a “must” in RDMA UAPI? 
> > > 
> > > Userspace has to work differently if the kernel driver is in the
> > > adversarial mode, and the kernel should not permit an old non-supporting
> > > rdma-core from loading to prevent a security downgrade.
> > 
> > I understand the first part of the sentence above, but the second part is
> > unclear. Why should this prevent it? In adversarial mode, the kernel simply
> > isolates that device from the others.
> 
> Userspace needs to do it too or it is not a complete defense.
> 
> > Moreover, the kernel cannot determine whether rdma-core has actually been
> > adapted. A locally cloned version of rdma-core can set the new adversarial
> > flag without changing the old, legacy version.
> > 
> > Once that flag is set, the kernel allows the patched rdma-core to proceed.
> > Therefore, saying that it “should not permit” this makes no sense.
> 
> If someone makes a non-official version of rdma-core that doesn't work
> securely then I don't care one bit.
> 
> I care that the official versions are not improperly mismtached to
> give something insecure.

You explain why rdma-core needs to know about adversarial mode, which is
fine. However, you also say that rdma-core MUST send this new flag back
to justify the statement, “The kernel should not permit an old,
non-supporting ...”.

However, in your last reply, you said that the kernel does not actually care about
the rdma-core mode.

Thanks

> 
> Jason
> 
