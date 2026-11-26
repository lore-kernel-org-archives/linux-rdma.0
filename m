Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795702349;
	b=eYIAHi005nS2gW0t5x4gYQ0zWU+8CjyDuSIHo5D0QocUgyRRL6fNxdSL/pFNPXagNLbC
	 frkFuiku84uTdzacJD0OmjuIXBHo5PEr0VZ46vQCdu2ZUYFxfDtg8ZedXwsPINUcRzDIb
	 /RCNWKaoM71bH8CYkpNt4rYXDCOMiyHmvuE0fQLqTR1aYSdAvPt5HWNVkbu5ECLA1kMG9
	 UP6jtIe/YNrvsftmqaweEYABbJ757BSdbH2qv/8TGESxA+z43q1z268Ue+vjfJJ9tHWCj
	 /aDzLIkRvs2G8tE0CwVmdnZH4nkSMkFFnqFHR9p0Fs8qos54jenlsUpMWyvD38419nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795702349;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=LwGYC1cwRnzG2Zd7sG4qSIqL9ktnNq6xWYxuTA0fJ4s=;
	b=5Yi4iOzi8D66toN88s9ENX9N1YrjGiSC8nXok79sEqTxQK7jiy9pMDSjcqmCUDU5j6mh
	 uFU1QLCKawIaUrxJZ9mhj4Br7PM4A7/U1Zj98nNNLUt/fRIBiAZ3Q5Rz5gu2XmBUteYqR
	 ZXz6fFPN2UF1ZkjYxkabrl11Pssfi0KEGj2GtrYIv9JWN1+FkqKUSMzIHWfFn+IWU7nOr
	 7FJgL4Ba0n7FdoylWDmv9TPu17zApICJtY4X1md1Y+SlMl+AgkKSNje2APlXp573beW1E
	 bHIVn4QU2dGFnn4F5y2mWO15Yxarv+hguipOHvaSvQ6eWtk/AAg//CXCXZqeAOT3J6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NqyUcnLn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265C6606A31C;
	Thu, 26 Nov 2026 14:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NqyUcnLn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E20B1F000C0;
	Thu, 26 Nov 2026 14:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795702349;
	bh=LwGYC1cwRnzG2Zd7sG4qSIqL9ktnNq6xWYxuTA0fJ4s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NqyUcnLnyrUle2omJKy3Ilfuid64A31cWNo8VfcJA3mANApch6Bb3SuLiQESKvzR2
	 egcC46zs1cTNLJ33y5FMMb+P3YF8WGZImHo2xOCgbn3OJMdFUIAzMJceYNTczshTYW
	 qhjPf2kTzPtKluJNThXSz2FjAxPKuC0BnzvJtTZEjm4234Oeoiirad4pcz6I+4ZIZx
	 7lYy27fLZUcQU08KUM37Wbl+xdXX0T5Kywn+U7cyr45oqd6VZzEL1e6EvDwXrS8D8T
	 0QWRyoc67Q066koXqa/oqdfCebswuuxME9oVf+tFf7D33ojHl2HdmzEX2IZzT5zF9k
	 2lfO9N+PTmzng==
Date: Thu, 26 Nov 2026 16:12:24 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org, saeedm@nvidia.com, tariqt@nvidia.com,
	mbloch@nvidia.com, kuba@kernel.org, pabeni@redhat.com,
	edumazet@kernel.org, davem@davemloft.net, andrew+netdev@lunn.ch,
	dtatulea@nvidia.com, moshe@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V2 rdma-next 21/21] RDMA/core: Report and enforce
 adversarial mode via GET_CONTEXT
Message-ID: <20261126141224.GQ774860@unreal>
References: <20261122073156.GA12665@unreal>
 <761ca80e-a772-41f3-b8e9-cc332e4ba5d9@nvidia.com>
 <20261124125327.GR14811@unreal>
 <20261124125950.GC9566@ziepe.ca>
 <20261124133353.GT14811@unreal>
 <20261124134751.GJ9566@ziepe.ca>
 <20261124140906.GU14811@unreal>
 <20261124143024.GO9566@ziepe.ca>
 <20261125090309.GY14811@unreal>
 <e8eaaaa7-545e-4019-9d7f-d2aab00c3217@nvidia.com>
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
In-Reply-To: <e8eaaaa7-545e-4019-9d7f-d2aab00c3217@nvidia.com>

On Wed, Nov 25, 2026 at 01:41:50PM +0200, Yishai Hadas wrote:
> On 25/11/2026 11:03, Leon Romanovsky wrote:
> > On Tue, Nov 24, 2026 at 10:30:24AM -0400, Jason Gunthorpe wrote:
> > > On Tue, Nov 24, 2026 at 04:09:06PM +0200, Leon Romanovsky wrote:
> > > > On Tue, Nov 24, 2026 at 09:47:51AM -0400, Jason Gunthorpe wrote:
> > > > > On Tue, Nov 24, 2026 at 03:33:53PM +0200, Leon Romanovsky wrote:
> > > > > > On Tue, Nov 24, 2026 at 08:59:50AM -0400, Jason Gunthorpe wrote:
> > > > > > > > > RDMA/core: Report and enforce adversarial mode via GET_CONTEXT
> > > > > > > > > 
> > > > > > > > > In adversarial mode the NIC is not trusted. As the kernel protects its
> > > > > > > > > own code from it, user space has to protect its own area, e.g. the data
> > > > > > > > > path that polls CQEs directly from the HW.
> > > > > > > > > 
> > > > > > > > > Hardened user space might use a different data path, with extra checks,
> > > > > > > > > and support a smaller surface. This isn't needed for a trusted NIC, so user
> > > > > > > > > space must know when a device is in adversarial mode.
> > > > > > > > 
> > > > > > > > This information is part of trust level series. Why is this a “must” in RDMA UAPI?
> > > > > > > 
> > > > > > > Userspace has to work differently if the kernel driver is in the
> > > > > > > adversarial mode, and the kernel should not permit an old non-supporting
> > > > > > > rdma-core from loading to prevent a security downgrade.
> > > > > > 
> > > > > > I understand the first part of the sentence above, but the second part is
> > > > > > unclear. Why should this prevent it? In adversarial mode, the kernel simply
> > > > > > isolates that device from the others.
> > > > > 
> > > > > Userspace needs to do it too or it is not a complete defense.
> > > > > 
> > > > > > Moreover, the kernel cannot determine whether rdma-core has actually been
> > > > > > adapted. A locally cloned version of rdma-core can set the new adversarial
> > > > > > flag without changing the old, legacy version.
> > > > > > 
> > > > > > Once that flag is set, the kernel allows the patched rdma-core to proceed.
> > > > > > Therefore, saying that it “should not permit” this makes no sense.
> > > > > 
> > > > > If someone makes a non-official version of rdma-core that doesn't work
> > > > > securely then I don't care one bit.
> > > > > 
> > > > > I care that the official versions are not improperly mismtached to
> > > > > give something insecure.
> > > > 
> > > > You explain why rdma-core needs to know about adversarial mode, which is
> > > > fine. However, you also say that rdma-core MUST send this new flag back
> > > > to justify the statement, “The kernel should not permit an old,
> > > > non-supporting ...”.
> > > > 
> > > > However, in your last reply, you said that the kernel does not actually care about
> > > > the rdma-core mode.
> > > 
> > > What do you mean? This is a mechanism to help the user manage software
> > > versions by not accepting incompatible rdma-cores.
> > 
> > Please take a look at the patch.
> > User space provides that new adversarial flag.
> > 
> > +	ret = uverbs_get_flags32(&ctx_flags, attrs, UVERBS_ATTR_GET_CONTEXT_FLAGS,
> > +				 UVERBS_ATTR_GET_CONTEXT_FLAG_ADVERSARIAL_SUPPORTED);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (ib_dev->adversarial_mode &&
> > +	    !(ctx_flags & UVERBS_ATTR_GET_CONTEXT_FLAG_ADVERSARIAL_SUPPORTED))
> > +		return -EPERM;
> > 
> > ...
> > +	UVERBS_ATTR_FLAGS_IN(UVERBS_ATTR_GET_CONTEXT_FLAGS, u32,
> > +			     UA_OPTIONAL),
> > 
> > The kernel does not care whether rdma-core is up to date. It works either
> > way, so why should we prohibit older userspace on these systems?
> 
> Older userspace is prohibited only in adversarial mode.
> 
> The new attribute is optional on both sides. An older rdma-core doesn't
> pass it, and the kernel declares it as UA_OPTIONAL, so
> uverbs_get_flags32() returns 0 flags when it's not supplied.
> The -EPERM is hit only when ib_dev->adversarial_mode is set. In generic
> mode, nothing changes for older userspace.

I understand that. I am referring to adversarial_mode, which should allow
legacy applications to continue working. Applications that require protected
rdma-core can use it directly, without requiring the kernel to check this
unnecessary flag.

> 
> In adversarial mode, the kernel side works either way, but the process
> doesn't. The threat is the NIC, and rdma-core polls HW-written data
> (e.g. CQEs) directly, so an rdma-core that predates this support leaves
> the process unprotected.
> 
> The flag doesn't authenticate rdma-core, and isn't meant to. The process
> is the one at risk, so it has no reason to claim support it doesn't
> have. The check catches a mismatch between official versions, e.g. an
> adversarial-mode kernel with an older rdma-core, which would otherwise
> run unprotected without anyone noticing. With the check, it fails at
> GET_CONTEXT instead.
> 
> > 
> > > 
> > > It is not a security mechanism to hard guarantee that rdma-core has no
> > > bugs.
> > 
> > It is you who talked about "... security downgrade ...".
> 
> The downgrade is a silent mismatch, where an older rdma-core runs in
> adversarial mode without protecting the process from the NIC. Failing
> GET_CONTEXT turns this into a visible error.
> 
> Would the below commit message make it clearer ?

No, we're discussing the flag sent to the kernel. Once we clear it, I
would argue that the flag from the kernel to rdma-core is unnecessary too.

Thanks

> 
> RDMA/core: Report and enforce adversarial mode via GET_CONTEXT
> 
> In adversarial mode the NIC is not trusted. The kernel protects itself,
> but user space has to protect its own memory as well, since rdma-core
> parses HW-written data, such as CQEs, directly. Hardened user space
> might use a different data path with extra checks, so it has to know
> when a device is in adversarial mode.
> 
> An rdma-core without this support uses that data without validating
> it, so on a device in adversarial mode the process runs without
> protection from the NIC, a silent mismatch. Such versions are already
> released and can't detect this, so fail GET_CONTEXT in the kernel to
> turn the mismatch into a visible error.
> 
> The kernel reports adversarial mode in the GET_CONTEXT core_support,
> and user space declares its support with a new optional GET_CONTEXT
> flag. In adversarial mode, a GET_CONTEXT without that flag fails. In
> generic mode, nothing changes for older user space.
> 
> Yishai
> 
> 
