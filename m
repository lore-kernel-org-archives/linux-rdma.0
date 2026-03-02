Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3ACD3FD13F;
	Mon,  2 Mar 2026 14:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772460416; cv=none; b=Bs2X/q/ROe73Z44UaI3IaC6avkAOvEWbo+NpyZ9u/X/gikD6gAnGpeq2MErhGmpYgMFqto42n+JmegYP9NslAsCQ9EIfWEhXX7vDjKFKgps6GZsD9voqjFaojJSu0Ku6yEs+7/aOZne4F2dQhb+C+m07wmLGajmb+z/DgVEkXvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772460416; c=relaxed/simple;
	bh=qQvKyY355WiiUZ5PDr+CWS9ETxDQZyTIWeRmwyfhO5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NVi139C0dLrQCNBazZ7FzSN0BLtJSiWkMmYvpQnRwCyaDsqZuzDAAXGFtx3S5vUAKABosVC7cvZfvtZXrQBb25vUSTrrZ4ql9lFMd5gzXhmeFXAa37HVHmSOGzryYPGmsWlcuKkIQzoyzZgydq1mBtAg/Y5Pb2AioR9/+5YmFSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A7y2s0JM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A7y2s0JM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E99C2BC87;
	Mon,  2 Mar 2026 14:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772460416;
	bh=qQvKyY355WiiUZ5PDr+CWS9ETxDQZyTIWeRmwyfhO5A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A7y2s0JMNbE3IzW0gV/VicaMP+jY2VZhuMzDEyqCe/clINZ6iRrjF1r3yX/h38EuD
	 HKhtfnrO1+7BGOZRtuBKJCrgrH7M1/BsjR2bwkkFJt+2Y0cfsVuHeOr1O0ySwcI+Pu
	 QcG6UI53+tTQJ/EXpboNu+rUSSftw9E5JG2cklNoeOULTdkAW3+s2hpp5KPi3evdz3
	 ci/ARygrF0ZVyegNUtNqXWkw0GX/lAYwDv9pxrlwJVrK2rzV4xkaamOaLk0YfObQPV
	 +iy+E/A5R1kmhEVdN/AV5XpkjhGfipTzxb70+tHTWGGtFZ2qtFiJgdeMFrqDtKZPd4
	 5wvrQhI+g7Udg==
Date: Mon, 2 Mar 2026 16:06:52 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Maher Sanalla <msanalla@nvidia.com>
Subject: Re: [PATCH rdma-next 0/6] Add support for TLP emulation
Message-ID: <20260302140652.GQ12611@unreal>
References: <20260225-var-tlp-v1-0-fe14a7ac7731@nvidia.com>
 <20260226173434.62c82688@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226173434.62c82688@kernel.org>

On Thu, Feb 26, 2026 at 05:34:34PM -0800, Jakub Kicinski wrote:
> On Wed, 25 Feb 2026 16:19:30 +0200 Leon Romanovsky wrote:
> > This series adds support for Transaction Layer Packet (TLP) emulation
> > response gateway regions, enabling userspace device emulation software
> > to write TLP responses directly to lower layers without kernel driver
> > involvement.
> > 
> > Currently, the mlx5 driver exposes VirtIO emulation access regions via
> > the MLX5_IB_METHOD_VAR_OBJ_ALLOC ioctl. This series extends that
> > ioctl to also support allocating TLP response gateway channels for
> > PCI device emulation use cases.
> 
> Why is this an RDMA thing if it's a PCIe feature indented for VirtIO?

This is the result of a long path of evolution.

Early on, we had VDPA emulation implemented entirely within the RDMA
stack. The idea was to build something similar to a tun/tap pair, where
a native RDMA QP could be connected to RDMA QPs carrying WQEs formatted
in the VirtIO layout. With some QEMU-side handling, this produced a
virtio-net device.

Later, this model was adapted for a DPU configuration. In that setup,
the DPU's RDMA block held the native QPs, while the x86 host exposed the
VirtIO-formatted QPs, still with QEMU involved. The DPU controlled the
x86-side "tun/tap" through RDMA-linked operations on the associated
objects.

Next, the DPU evolved to instantiate a full VirtIO PCI function on its
own, removing the need for x86 to run QEMU. The DPU continued to manage
the tun/tap via RDMA operations, with some extensions to cover PCI-
related details.

Eventually, the DPU gained general-purpose programmable co-processors
capable of executing various RDMA and non-RDMA operations. As a result,
the RDMA subsystem also became responsible for loading programs onto
these co-processors and managing them within RDMA context and PD
security constraints.

Now we have reached a stage where these co-processors can manage a much
larger portion of the PCI-side behavior, including delegating some
responsibilities back to the host CPU. This produces an odd situation
where a privileged RDMA user can:

- Claim an "emulation" PCI function
- Load a co-processor program associated with that PCI function
- Use RDMA-mediated queues and security controls to interact with the
  co-processor program
- Use the co-processor and related mechanisms to capture and respond to
  TLPs directed to that PCI function

There are many tightly coupled components in this design, but the TLP
handling cannot be separated from the RDMA-related logic that enables
it.

Thanks
