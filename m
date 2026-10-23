Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792786533;
	b=dijCsOSWaPlp4yPZbm9TNPLCK+qeOlD6FYRNrB8UBKKPh8HigyF6xol5evLE7PlV1CdU
	 jFpPesIW9flvzR9VT/j09EIaQhh30b3+bOtBteGqTxXZZ6r5Fgp9X5SSbCQUtTlJoCgyd
	 ZAGStnH93exryb9kH4wu49NcEV89wfn9WcJZWa7K0q14CW8EAGtNTlQBLT4sZvEFt0MeE
	 9jXWwt1C/PA54S9O/MEvheeAGHyj2EqIl1O1J+J4+OBtTQ1T6qQwwUzTXAut3sJwkgMEq
	 19/UD4cbeOy3VmwDBQ336WqqT5iCWr1W9PhNXctbXsy88V+R3lsFsY8wsbg7EisyO4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792786533;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=LjMfVQmjefsgN7ZWT6/c86G+DCQ8WdW7PyuBbuO1hbY=;
	b=Fdzhj3D9cdWapTwNJYOmttfJomeTTrq4TbZwshpg9kcHZL4fhEy6EH4rU/ixFGkniJoF
	 uTEO5s7TiEX+iBTxQPaor2eiG03McqYS7cQz7chrYJ0AFXc5ta23Cm4LavvcKfNTY+c3m
	 qEjzQcnelKTPHy80BVwl+pfMCZQE4/H9Kd3kKRsiIPgknqQjVGQou78tyVU5Tqrgyevqp
	 kSv17bu+VmYnP7XkeGMt8Ju4o6mjnknr9DRiXr5JNVPlddDmSoX3xCewL4+5F+HqjIscc
	 1cw0KI9MZMq+mN6kvETIJ2pIdqm1/dyXO1KTGVFLCaZrv+18HmSYVmOW6vAGCrto6vQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mPO7YXrP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CEB606A31A;
	Fri, 23 Oct 2026 20:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mPO7YXrP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA2D1F01828;
	Fri, 23 Oct 2026 20:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792786533;
	bh=LjMfVQmjefsgN7ZWT6/c86G+DCQ8WdW7PyuBbuO1hbY=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=mPO7YXrPQDax1DVJaIP2e9sYo+5L9AvZwUjLGajvf2GIofMt70yNG+v4okfljv1m+
	 mQ9t3fBfOxUy8XokMjCiZulcdMVqZJMkhN17KgAijggXLyAIzt2txfyoOorFbhdgZY
	 M0HH0Zmg7aUpHB/dkniCeAZp3RCvD+NJgX4bVibtYuZymGAuzK3eknt1GeciJerA5h
	 eoghJrtkv7LPEJeH462xdL+BTE6aAyt4oGHbjx7ZcpQ7YQlnZEa1MqgrbouO93JlWs
	 PKNt0QIxbyhUD8AXe8WL90pp+qKtrhdJeg8fT8gzu9fGb7T3oe1c4G44BzKTLGEoCx
	 Bap59M59hWzRQ==
Date: Fri, 23 Oct 2026 15:15:31 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, iommu@lists.linux.dev,
	Tushar Dave <tdave@nvidia.com>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-rdma@vger.kernel.org, kvm@vger.kernel.org,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jens Axboe <axboe@kernel.dk>, Alex Williamson <alex@shazbot.org>,
	Ankit Agrawal <ankita@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCH v9 02/18] PCI/P2PDMA: Derive routing from directional ACS
 controls
Message-ID: <20261023201531.GA2805244@bhelgaas>
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
In-Reply-To: <20261023190036.GL3977851@ziepe.ca>

On Fri, Oct 23, 2026 at 04:00:36PM -0300, Jason Gunthorpe wrote:
> On Fri, Oct 23, 2026 at 01:27:15PM -0500, Bjorn Helgaas wrote:
> 
> > > Yes, the ACS combination is selected to avoid ordering issues
> > 
> > Does a user have any way to know whether the configuration is safe?
> 
> No, unfortunately in PCIe so much is really difficult when it comes to
> deployment :(
> 
> > I'm wondering whether users might use "pci=config_acs=" to configure
> > ACS so things appear to work as they prefer but may not provide the
> > ordering guarantees drivers depend on.
> 
> I imagine that could happen, but on most practical systems the root
> complex will blow up if you do asymmetric routing so there is an early
> indication.
> 
> I know this because I've help debug such configurations at
> customers. Some servers helpfully MCE if you do this. Lovely.

I'm still confused about this because earlier in this thread, I
thought Leon said you do asymmetric routing:

  Bjorn> And I guess asymmetric fabrics must mean fabrics where
  Bjorn> Request Redirect and Completion Redirect are not set the same
  Bjorn> way?

  Leon> Yes, in some of our systems, deviceA to deviceB is going
  Leon> through different route than deviceB to deviceA.

> > If that's a possibility, do we have any notes in dmesg that we are
> > depending on fabric behavior that the OS can't discover and verify?
> 
> Maybe, it could be interesting if the P2P logic found asymetric paths
> it refuses to permit it.

It seems like P2PDMA *could* check for asymmetric paths and at least
warn about it.  If it's practical to do so, it would make me feel a
lot better about this.
