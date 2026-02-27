Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18E23E8C60;
	Fri, 27 Feb 2026 21:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772228229; cv=none; b=SDoXfGvyuRFatMVY1Vgyu1ksRxIsHgE9vCi3aNBozXd7KYOnacwxKn65iNvkIrOjpy5YtPdrdDByaMsHz1RlR+QhGpfy+DRw55JHU/7bVLMloW+IBjJV+ZP6VKRBeYUi3tmYLfYfaGJmks800YSUsMy7bXTGnSJZz5EeuP3k2ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772228229; c=relaxed/simple;
	bh=5tXnhuCv52KCUVGltNH02leOmDs6VgPWcF8wP7DmfYs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X35IXgLlso7mp0+/7/SogQ+afbxpQ9xRhqQJwEnaST+cJk8gGsCAeG5VYRPJSMLzDMX3jpdCMfCaTH5Ry87FYKxrSxVvVgNAetqUUZROw2dRprIcsZXZHqKrRbPWOmq304KrKSl6ZJpgCMaItuj0Me2Ocn5pukQkPm7TfGssHgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=brwnEVJF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="brwnEVJF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F60C19423;
	Fri, 27 Feb 2026 21:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772228229;
	bh=5tXnhuCv52KCUVGltNH02leOmDs6VgPWcF8wP7DmfYs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=brwnEVJFVllXBTc0ka5thA6S+i5EEMndcr/o6BMfob4vigY2t2NdfmuHLsnt8z9ja
	 oWJW3HFgJ8uHkdFuEnJ6Pd3HxuJ5pXitMdCR4RDXR3uKnZL6ePhRD1v/bSJEL8m5y+
	 JCvM7AwH2wn2FREnGBH4573AWc2I4yb8CbOLfu3cMDGuhbY1rMrwqM5KzDFVlIZqnC
	 B4LYNX5M91tqJOaPTR7fgzRpU8PSXET5nDueXto0aL6sBWZWVZ3+oDgD9kYau91r2y
	 duJzvMjZJc08/XqShFFucHfmJoBCI40D1Rntj7MQCINhKl4bcIm1AcW2QutFvwJEXD
	 BMeEm2JSoq5og==
Date: Fri, 27 Feb 2026 14:37:05 -0700
From: Keith Busch <kbusch@kernel.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Maher Sanalla <msanalla@nvidia.com>
Subject: Re: [PATCH rdma-next 0/6] Add support for TLP emulation
Message-ID: <aaIOgcfCbRIBlpUO@kbusch-mbp>
References: <20260225-var-tlp-v1-0-fe14a7ac7731@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225-var-tlp-v1-0-fe14a7ac7731@nvidia.com>

On Wed, Feb 25, 2026 at 04:19:30PM +0200, Leon Romanovsky wrote:
> This series adds support for Transaction Layer Packet (TLP) emulation
> response gateway regions, enabling userspace device emulation software
> to write TLP responses directly to lower layers without kernel driver
> involvement.
> 
> Currently, the mlx5 driver exposes VirtIO emulation access regions via
> the MLX5_IB_METHOD_VAR_OBJ_ALLOC ioctl. This series extends that
> ioctl to also support allocating TLP response gateway channels for
> PCI device emulation use cases.

Sorry if this is obvious to people in the know, but could you possibly
give a quick high level description of the use case behind this feature?
I'm just curious what emulation needs are enabled by having access to
this packet level. Thanks!
