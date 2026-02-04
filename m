Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21FF1261B96;
	Wed,  4 Feb 2026 02:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770172014; cv=none; b=WqLKk68YYwuoMwVTZXG2Q5uA782IL6f68TDkFBEDPJmyPaGYfqt3W1SFjemFksLyeEgBFx8yr0ISeuFKky2UbO0jQcmdifMJJavBGqlZDqJMlE8zSR/5cfD3d/HeHjWzfaRNGgF/69/+hiPA+4ndoi6tmDCGRl8bBq55fYK97Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770172014; c=relaxed/simple;
	bh=7iHhDhmroXilqUpiAl9DOqvbDNkQ3iGMApcbhd1avnY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iPqc000Sxl511uT4bjIvxMEq4ros+hA6S4PcDN1qfsK7t11Ct6y9MNwMn4q4DJ2fVWkqdHxHOyMoQcPeKZzgb1G93eIgxnC0I3IcYBnOmZDFNvKx9tvCHT0oH483bMc3P+2Q7yRRC5DIjteyAms3MmNEeL1pMW2TjvL9fdarSoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YKvYfzvz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YKvYfzvz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C50C116D0;
	Wed,  4 Feb 2026 02:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770172013;
	bh=7iHhDhmroXilqUpiAl9DOqvbDNkQ3iGMApcbhd1avnY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=YKvYfzvzIEOFw3H6Ta6HXVlrqr2uY2VY+MW3ygbDI4Bba9vW/wbnBccsDoPZ39fUq
	 WCg75jlFiVPoYxIxHKlbtb1oWy8qlUwMo0kF2tMVQNTXYx56vyvAbaPiXLYNUNKhcN
	 Qcl8kOj4B1s/fU74SB2YE870qep5V/cIEJQoIWG/5tvgrlfKu8kH9k5EQANbZZwGPb
	 MINbRdMXlh3PbV3iR5UyHaNYrMD+6erJRf1KxT12MvFdJzc2E8SfelZ7XKye44d5tF
	 vJG4maBSIqG2bBmYxSZmYkEbza+MXbnNzgiFsqY4baE+VIWC6X1s8yv97lV4Ah5ah/
	 d17UnfjAlX2qQ==
Date: Tue, 3 Feb 2026 18:26:52 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Donald Hunter <donald.hunter@gmail.com>, Jiri Pirko
 <jiri@resnulli.us>, Jonathan Corbet <corbet@lwn.net>, Saeed Mahameed
 <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Mark Bloch
 <mbloch@nvidia.com>, Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kselftest@vger.kernel.org, Gal Pressman
 <gal@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Shay Drori
 <shayd@nvidia.com>, Jiri Pirko <jiri@nvidia.com>, Or Har-Toov
 <ohartoov@nvidia.com>
Subject: Re: [PATCH net-next 4/5] selftest: netdevsim: Add devlink port
 resource test
Message-ID: <20260203182652.39a3620d@kernel.org>
In-Reply-To: <ce09e17d-2b74-4bda-a8ec-352c92659a6e@redhat.com>
References: <20260203071033.1709445-1-tariqt@nvidia.com>
	<20260203071033.1709445-5-tariqt@nvidia.com>
	<ce09e17d-2b74-4bda-a8ec-352c92659a6e@redhat.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 3 Feb 2026 11:16:45 +0100 Paolo Abeni wrote:
> # Error: netdevsim: Exceeded number of supported fib entries.
> # Error: netdevsim: Exceeded number of supported fib entries.
> # kernel answers: Operation not permitted
> # TEST: resource test                                                 [ OK ]
> # Command "resource" not found
> # Command "resource" not found
> # TEST: port resource test                                            [FAIL]
> # Failed to show port resource for netdevsim/netdevsim10/0
> # TEST: dev_info test                                                 [ OK ]
> # TEST: empty reporter test                                           [ OK ]
> # kernel answers: Success
> # kernel answers: Success
> # ./devlink.sh: line 614: echo: write error: Invalid argument
> # Error: netdevsim: User setup the recover to fail for testing purposes.

I suppose this is because iproute2 needs patching. Tariq, could you
post the user space bits or share a link where we can pull them from?
I'll revive this in PW once we have CLI updated..
