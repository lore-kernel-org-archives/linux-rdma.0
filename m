Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2938F35F16C;
	Tue, 15 Sep 2026 11:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789470795; cv=none; b=piiB7WImGlh89/5EJ42cHcGUXX4Xon4QCHJt8zarDwianXjeXSoAoGScSXS3hxjxUG7q5Cf8DdZ7kzCX8QLg2AW/F9nmvKnaceMyBTlmV5WepTOyn1rLLEnsNIpUIqGJfONgiID6G+usb8VbOqtUECZxHgeue+PKqUPUr3n92rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789470795; c=relaxed/simple;
	bh=BouqRODq3BY6jePjH1HB3d3dpYU74va5tpn4l0ocGF8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=krijX7Nbq5AOyWkmjeHkC3VEdYvCQd5Gk2QvfE46w33C0igvKEUanNUEFcgkrJoX2jvP5+MYpkLZwJLLUALOMp/5Wv9RwjTb9pGf8oIGhLHD1ZJLnZjJw9l2q4EMK+lLY6YXwqaaHtPxS/pXd4HFUwe+BqRsDeT2Mzx5brVbbUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M1a+ZPtS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M1a+ZPtS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E386F1F000FF;
	Tue, 15 Sep 2026 11:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789470793;
	bh=3Fo8O4YY20PaL/Cb8vHGwZWBXhFY9u139ruY8Ue0eHg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=M1a+ZPtSAZLewr5vayVBk+/q5i2b5T9uJB0NNQ+7fFamBUIs/VEH/Z1prBkCNg4R+
	 GtW0agBVy9REzaAD4gZjs/7wQo0zKbfqk6ogTdonlEIZOwzktQ3c4P34aWu66aBlGQ
	 boF0ehxz7ZVllzBu71wz6lXn1QF5QI81eApX7mriSEIPRoeQ/EVLvUkzSEjGlWGVsV
	 +UkBnuGE5tkdWTQ/56iLH9kmR07LYsSzCU4dJbs7AQP7IMJRf1GWcmJn7Sz5VePRcq
	 HLlQkP77ZTLCcyJPohE+PJ2qA2+BAXJV9gwDxxkzUjJY0Tw9rktlD9Srznhy7IU0pr
	 V+YB9v8R8B2IQ==
Date: Tue, 15 Sep 2026 14:13:09 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Jakub Kicinski <kuba@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>, Alex Vesker <valex@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>
Subject: Re: [PATCH net RESEND] net/mlx5: Use unique names for software
 steering caches
Message-ID: <20260915111309.GJ13683@unreal>
References: <20260730210200.2590115-1-tariqt@nvidia.com>
 <20260803182614.23f26c91@kernel.org>
 <20260804080455.GB326170@unreal>
 <20260804145756.331951b7@kernel.org>
 <20260806111739.GF23431@unreal>
 <28c6b0e5-eff3-4556-802d-be6ed3f16615@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28c6b0e5-eff3-4556-802d-be6ed3f16615@linux.ibm.com>

On Mon, Sep 14, 2026 at 10:58:43AM +0200, Christian Borntraeger wrote:
> Am 06.08.26 um 13:17 schrieb Leon Romanovsky:
> > On Tue, Aug 04, 2026 at 02:57:56PM -0700, Jakub Kicinski wrote:
> > > On Tue, 4 Aug 2026 11:04:55 +0300 Leon Romanovsky wrote:
> > > > On Mon, Aug 03, 2026 at 06:26:14PM -0700, Jakub Kicinski wrote:
> > > > > On Fri, 31 Jul 2026 00:02:00 +0300 Tariq Toukan wrote:
> > > > > > Prefix each cache name with the device name to make it unique.
> > > > > 
> > > > > Why do we need a per-device kmem_cache?
> > > > > Isn't the right fix to make this driver-level state?
> > > > 
> > > > This kmem_cache is required only for software managed steering mode, which is
> > > > configured per device by mlx5_fs_mode_set(). In general, resources
> > > > should be allocated only when they are actually needed.
> > > 
> > > Of course you have to wrap the init in a lock and count users.
> > > Trivial stuff.
> > 
> > I don't see why we should abandon the simple, architecturally
> > correct approach of allocating and managing resources where they
> > belong in favor of a more complex global scheme involving locking
> > and reference counting.
> > 
> Any updates on this?

No, we are waiting for Jakub to explain why should we complicate simple
and working solution.

Thanks
