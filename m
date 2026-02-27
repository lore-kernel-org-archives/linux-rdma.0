Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A477721ADA4;
	Fri, 27 Feb 2026 01:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772156076; cv=none; b=HOU8iaxWsbnFEd47eCQogokOtklyiQ/jWJ9pgSMmC36tuae8RBuZ0Dmn6lKLvEmTfSE0xBi8JMtNS3sFADNJ9CQWxH0VesJXaaSXLdJ9C+lb18lZbpMvrI3H4Phltf4nCNd4jrWHyZvRcMKgBGwL3eCiBFaVpYCKASRl2QZTvqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772156076; c=relaxed/simple;
	bh=cDmw7CPcHRz9hHC50EPfLUgDjj4B/4/F4o8OPLPDaPQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FkoVMoGygqlzUmK09uSpT33/F4VWAQ32hebB6AYACFdcxe2Rk7PAyHSXUa8LDtkDgRtxTyTN1Na35uDeR9TxuHHg1f6vKFqKey8F4yov064crZVSY3QgDj8PTc1gQtzItW31DylePqj5p2cBh1e/LRnWvJPHGEYRnCxiFe54GpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=taFXSFaB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="taFXSFaB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E18C116C6;
	Fri, 27 Feb 2026 01:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772156076;
	bh=cDmw7CPcHRz9hHC50EPfLUgDjj4B/4/F4o8OPLPDaPQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=taFXSFaBbPDDT+dEMs7jw9UJyhWPKtG9uQZ2m9XVT88B8qMLAof7EHwF6tz36GxU+
	 TMESLQQNyqL2VFif6e5Yzh6ijiPvju2MOwbBKM9rVCz5QbbAZDbD4FT5TD8s8ClQL6
	 k72lFe7oSt+XdtyBzHKHW+Ox4FIpLs9K1MY1ynsON2P9Leh4+Xb8KkWBXy1tqffXg6
	 OCsIPjdwdBoDu+PPqE7z+GXPqBTi1JydvzvYQKolzJQVqmd5NgO7DjK/eLCYzY7see
	 E/NHKSQdB5RZTEu8Scq5JA24yY6gew5RNyhfJy7OdL4UuqeThLf4iBv4///JMdAVjS
	 ojUyj64pgKrHA==
Date: Thu, 26 Feb 2026 17:34:34 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>, "David
 S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo
 Abeni <pabeni@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, Maher Sanalla <msanalla@nvidia.com>
Subject: Re: [PATCH rdma-next 0/6] Add support for TLP emulation
Message-ID: <20260226173434.62c82688@kernel.org>
In-Reply-To: <20260225-var-tlp-v1-0-fe14a7ac7731@nvidia.com>
References: <20260225-var-tlp-v1-0-fe14a7ac7731@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 25 Feb 2026 16:19:30 +0200 Leon Romanovsky wrote:
> This series adds support for Transaction Layer Packet (TLP) emulation
> response gateway regions, enabling userspace device emulation software
> to write TLP responses directly to lower layers without kernel driver
> involvement.
> 
> Currently, the mlx5 driver exposes VirtIO emulation access regions via
> the MLX5_IB_METHOD_VAR_OBJ_ALLOC ioctl. This series extends that
> ioctl to also support allocating TLP response gateway channels for
> PCI device emulation use cases.

Why is this an RDMA thing if it's a PCIe feature indented for VirtIO?
