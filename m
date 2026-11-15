Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794751588;
	b=EyI0aXk3Zvel8EmqHnc1VkOC9Ddbc/4oO5w2xXHFq8Va8uhOmg7Dwr3lmX7oOkie+0ET
	 5ypTjW+lQnKypnKqLYOW+rx6QIZxD9dORlUQu311jGOLzgeh3MLAaQDxnG/LoFuUvaTC+
	 eYIHKLcQLzo2e1MpiaXy2mzYd+ZA4QsL9JpimQzo3rHzZyBiApoKDJq49sYlRrzjinTkC
	 gRnqpCCLYrUnJ8YN37ioeDTG9l1pX/2qCuD6xTO1VOqEkAHBvtyrsIHXZioMdI94F59gr
	 fOcV6nA1G31QGVzv70maCghbsOg5gokhoah9Zzz7flF2JdXqkkcJ/yVYIE3LKmfpKXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794751588;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Pw6ELLof8sXq1rGGaq/DDPI7LyWqO6k2g8iDxpoOW4k=;
	b=aiU0SPP/YHith1RP21CEEWy5K2EOUHgOPlOXuq+kMFo9ScCeF4pYu5q+H2j4Ar3jn8Xn
	 SHuNARDcoVXG8Gjfcr4/bc6W/g+DGj+CO5cu1JZT7DTEVUW4antPOjaHtRx9IuH5k9QeT
	 Z9XdokYjYeBCCrHMc3t1R6Djw1YRbtWnADTeCQD30KXhsc85IgBtNsWY6BucVku68JCj4
	 Yr3jii/EZ/nj0WEHQPreWvKmYHXHy7Zp3o9//RWOEnKCdCA+wCuVzUT9uEcPBY7Gn6gyE
	 HQB8VN5PLYH99Jw4+A/vbm7F8vQq8faNPZuEv3pWtyE57WcozJSHbu+IYtE37LbNqeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O+iT5rMc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8041606A32C;
	Sun, 15 Nov 2026 14:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O+iT5rMc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D331F000C4;
	Sun, 15 Nov 2026 14:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794751588;
	bh=Pw6ELLof8sXq1rGGaq/DDPI7LyWqO6k2g8iDxpoOW4k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=O+iT5rMcq8IDu1WnLz6Ns8IvESGfuXg4dLg0WX1nCCgR+TdO+YhE0wdkTQhZ04qAi
	 S1npAWF7syolLd+vdRJB0xkhK+efTUkGld+IO9zwCWA9WWMRHymT0NVtrqLKwutBOe
	 wcySn0Y5Cni2h5vQGfECL7XAsKmqyyjx3yxrGaFNbM7+aAt9ey4Kwvydre3rF0HWxc
	 8wGdhw3/8aYarFLuRJrIFQTRip/WaT05OG2ZJzg7j778/ZDORJt9eAP4Tiq173syb+
	 VvsWq3hmqkcobI4iKQB2riIpZvWKJma9vgU9rPoUeiUVXjBjZISFmvAJOEhk48RXMv
	 bPoGc2atEpP6A==
Date: Sun, 15 Nov 2026 16:06:24 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Edward Srouji <edwards@nvidia.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@mellanox.com>,
	linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Mark Bloch <markb@mellanox.com>,
	Michael Gur <michaelgur@nvidia.com>,
	Patrisious Haddad <phaddad@nvidia.com>
Subject: Re: [PATCH rdma-next 0/5] RDMA/mlx5: Add NIC_RX_CLASS steering
 domain for RDMA classification
Message-ID: <20261115140624.GF42525@unreal>
References: <20261103-rdma-rx-classifier-v1-0-1ad6c8cfe936@nvidia.com>
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
In-Reply-To: <20261103-rdma-rx-classifier-v1-0-1ad6c8cfe936@nvidia.com>

On Tue, Nov 03, 2026 at 08:12:48PM +0200, Edward Srouji wrote:
> mlx5 devices recognise RDMA traffic on receive with a fixed classifier: UDP
> destination port 4791. Packets that match are handed to the RDMA receive path
> (NIC_RX_RDMA); everything else continues down the normal NIC RX path.
> 
> RDMA transports that identify their packet differently don't reach the
> RDMA receive path as they use a different packet format entirely.
> 
> This series adds NIC_RX_CLASS, a new per-vport receive steering domain placed
> ahead of NIC_RX/NIC_RX_RDMA. It gives a privileged RDMA transport manager a
> programmable classification stage that supports matching on arbitrary header
> fields and marking the packet as RDMA.
> 
> NIC_RX_CLASS reuses the model used by RDMA_TRANSPORT_RX/TX domains:
> - one root namespace per vport, owned by the eswitch manager;
> - targeted from userspace by `ib_port`, as with the existing per-vport
>   domains;
> - gated by `rdma_transport_manager`, and by
>   `rdma_transport_manager_other_eswitch` for the cross-eswitch (LAG /
>   socket-direct) case;
> - restricted to callers holding the same UCAP that per-port matchers already
>   require, so an unprivileged process cannot program another vport's
>   classification.
> 
> A rule in this domain takes no destination: it matches, attaches a
> modify-header action to mark the packet as RDMA and explicitly allows it
> onward. ALLOW is the only terminal action the domain accepts; a flow counter
> may be attached alongside it.
> 
> Patch 1 adds the IFC bits, patch 2 fixes ALLOW handling in the FTE merge
> logic, patch 3 unifies the per-vport root namespace init/cleanup helpers,
> and patch 4 adds the NIC_RX_CLASS domain itself. Patch 5 exposes the new
> domain and the ALLOW action to userspace.
> 
> Patches 1-4 are mlx5_core changes and are targeted at the shared mlx5-next
> branch, prefixed accordingly; patch 5 depends on them and is targeted at
> rdma-next.
> 
> Signed-off-by: Edward Srouji <edwards@nvidia.com>
> ---
> Michael Gur (5):
>       net/mlx5: Add NIC_RX_CLASS IFC bits
>       net/mlx5: fs, treat ALLOW as a conflicting action upon merge
>       net/mlx5: fs, refactor RDMA transport manager root namespace init/cleanup
>       net/mlx5: fs, add NIC_RX_CLASS steering domain support
>       RDMA/mlx5: Expose NIC_RX_CLASS flow table type to userspace

I applied this to mlx5-next and rdma-next.

Thanks
