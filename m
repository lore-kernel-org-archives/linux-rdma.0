Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793778659;
	b=rUPwkln0ChTgib+0AEBL0Z9kgUPMvm8+tkz6/pE9UZRDGEA5c94f3Tszu1NXj438P+l5
	 0drwwqT6bVMNL6noIUxzHt+//vRJHmCWi8LKsA2URqMX8UCnc1rGShvBpPLxxivvYarZh
	 d7uRXa8j8vYDl3GS7HP+uH0vP5/oAjvbvtXEBExqQWSLTK+A5Fl8IhJMryEE9RSg78kEl
	 OklLuXu42Lk+Yn5XV5EAny/9BaSHmxKl1TYMJ2GPnhFUv4Oowat4tNB7hAhYWkYI50NNN
	 +hPeKf6zNSxodb6QK+Eh3OUtIEvzbWAFb2zQ4WCJqRknYxnIs9XBLFXEyJIp8RglRZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793778659;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=+x0caZ0pC+EFyWhDfl1gmIN09MGJqKHTRPG88Kl6DZ4=;
	b=3rDhPEb6dg5CaxpUVz8D86TGq3KOZ21huNN9iOQjZjbPx4hwRfiLY5MKjeSVQ3C/yKpv
	 lL9BEm6Nx3nqkCYgt2PMg818c41SiWtEjp376b3QB5v7yKT+lSTslydA6+YW1ih1Cqi9f
	 aNbZxWmWWKFtWHcyw1WQGtPtdryUvPNxidshXBj+wbYwuZcpM2jY0EpdO4+tENpGPPrxL
	 44NQ5kgbSzW5Nn4Rcl+aWYaqaaCl8DswMpTNqU/u+0maxCK3H/j+oYsZFs/gnBSZ8swP3
	 +yR10DLW0PUzuK+kOR3tZ7YK0d4klXQtmc1R1W8vNT3nbKP3NC2bQBjzABF63WQuOpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=me4p4b5G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A079606A328;
	Wed,  4 Nov 2026 07:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=me4p4b5G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DBD1F00919;
	Wed,  4 Nov 2026 07:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793778659;
	bh=+x0caZ0pC+EFyWhDfl1gmIN09MGJqKHTRPG88Kl6DZ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=me4p4b5GiB/BbaLFQXgar5GxXH6vWVN4hC6duaEOq4LD6uI5ioz0Tw31jQev5ByJK
	 cMXVyvv5tnfWAcP4bp6XIy2rg4rHW2UCGpnG8pdzsFa0B2XXz7lHAI0xdEfXk9Kzc1
	 kHzKcdOVeOvwbqr2S9wSTFITUn/8wJuu284URItSC6scrOgb2//2/Q4N9Yg+pHr2d8
	 cte33u8ZdCddF9selZfGEHrE5Cw/IKdoGe1fFA46tpOdgUi6mHQlVvWyETygWKeRyd
	 5WcbdTs5MiGCmkoZ+UjUQMAWM2FjoWTnGh4Lo7lwsQF8ezaApzh5zYX+lGLofpy+Aw
	 gSqn/thmWw1lg==
Date: Wed, 4 Nov 2026 09:50:55 +0200
From: Leon Romanovsky <leon@kernel.org>
To: David Hu <dhu@x6u.co>
Cc: Mustafa Ismail <mustafa.ismail@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Jacob Moroni <jmoroni@google.com>,
	intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, David Hu <xuehaohu@google.com>
Subject: Re: [PATCH rdma-next v4 0/6] RDMA/irdma: Add support for ioctl
Message-ID: <20261104075055.GL264423@unreal>
References: <20261030181512.2056056-1-dhu@x6u.co>
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
In-Reply-To: <20261030181512.2056056-1-dhu@x6u.co>

On Fri, Oct 30, 2026 at 06:15:06PM +0000, David Hu wrote:
> From: David Hu <xuehaohu@google.com>
> 
> Hello,
> 
> This patch series introduces support for uverbs ioctl queue creation
> (QP, CQ, and SRQ) in the irdma driver. This series makes progress towards
> modernizing irdma. This enables 1-step queue creation from pinned UMEMs
> and shared dma-buf heaps (system_cc_shared), providing RDMA support for
> Confidential Computing (CoCo) guest environments where memory encryption
> otherwise prevents standard host-VA-based queues from operating.
> 
> Historically, irdma relied on legacy write() commands for queue setup.
> This series modernizes irdma's queue creation path by adopting the ioctl
> infrastructure:
> 
> 1. Plumbs uverbs_attr_bundle into the irdma QP and SRQ creation routines.
> 2. Registers irdma's UVERBS ioctl namespace definition for QP, CQ, and SRQ.
> 3. Implements 1-step queue buffer creation for QP, CQ, and SRQ using
>    UVERBS_ATTR_CREATE_*_BUF_UMEM attributes and ib_umem_get_attr(),
>    configuring hardware Page Buffer Lists (PBLs) directly from pinned umems.
> 4. Split CQ creation setup logic by umode and kmode into separate
>    routines to be consistent with other queue creation logic.
> 5. Adds support for driver-specific shadow area UMEM attributes during CQ
>    creation with CQ resize capability.
> 6. Preserves backward compatibility with legacy 2-step write() path
>    registrations when UMEM attributes are not provided.
> 
> User space rdma-core PR: https://github.com/linux-rdma/rdma-core/pull/1766
> 
> Testing:
> Verified with rc_pingpong, srq_pingpong, and dmabuf_pingpong over irdma
> devices in Confidential VM environments.
> 
> Changes in v4:
> - Reject dma-buf queue creation in iWARP mode and enforce page-offset
>   alignment unconditionally in irdma_setup_q_pbl_from_umem() (Jacob)
> - Bound attr->cqe in irdma_create_user_cq() to prevent cq_pages overflow (Sashiko)
> - Fix to irdma_cq_free_rsrc() was sent separately (Sashiko)
> - Link to v3: https://lore.kernel.org/all/20261016202909.1289496-1-dhu@x6u.co/

I applied the series, but I have a concern: the commit messages are
not useful.

Thanks
