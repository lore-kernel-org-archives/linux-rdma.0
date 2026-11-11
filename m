Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794405543;
	b=VOHEveMeQBA+zHDz893HY22/Ea500Pyfr5THbwQ52qEJxHdth9PUw0NsCaP87Zbha7oP
	 //dElK4VuPLkVgK8+Kv5Ipm2AmtGHXVcIk/9F5FBqoTxtzvy8qpNzhzbQ0P6cdpV+DMOb
	 vNuuL4OJUhb3GBFDBIeE2/eeQXha77zjOqxw5YWTW5z5kyKDGQ9gqXqK9QMfRir6WJ4b0
	 xJ2U+YWgJlZb+AIfhU36Ij8DGjqp0dIEIzJ+V3CsRz32ctQBgbYdk9IJx+wQGppvqhyof
	 yI3UzKvk28rRCJdkESA3roz2xpdqOCBKif8t+EUAjSglr8096O1torQ9gdf96rtZEgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794405543;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=Xnkn3qGs1fsK1Jbk4oAGn/q/RWKnHPNQC/oOAD9dVvs=;
	b=J0EHKAUNYZes2VAAN15s8JkoE2rKa0dH+RaVbMa6UDKJ/hZeF/CVfbZvlRdVwNZl4ja9
	 KW2ALwJkK5mLZz68dwSPtddcD5YjO58FArA4S40CgT8FfCV42ZOSAYqQb8lZzJU2VBYWL
	 SPZKnYNtVTosjRBXqkeYD6q7+1BEMOXCOrvxjyQyi+atxnSicEaYpuKP4xc27SO85UAIH
	 tX7Qd0/ApKvg17dJWM+04SvdIsnXhHvy2SIh/KjSszkpLvsZIeKCYZVvrtE2Xw8IseTVr
	 s9llloXvdofVqubJnb7MCTj2F6rlP8TtNRrEbPW48IlC7pW7oI5dTYpUgkYv8afD4Lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OSkwj9l9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7A7606A321;
	Wed, 11 Nov 2026 13:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OSkwj9l9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54411F00A05;
	Wed, 11 Nov 2026 13:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794405543;
	bh=Xnkn3qGs1fsK1Jbk4oAGn/q/RWKnHPNQC/oOAD9dVvs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=OSkwj9l9IMm57wGjjV7p+Z87300v79/UTtnE3FdU6bM74hMsnfHhG7P/jAkCdJ4Hk
	 ZI7A0lY90kc211b+tTqA9HgyLxSVdxJecqiKsdTI9xXU/ZNPX6+nAfuVr5xYpIOGMc
	 lMneCR3oxowd9r/EDx+edw4JoNU1Dz+Hn6w2PX3w4yhY4lTEjfVIxZSt55SJpmvCSA
	 nzhHgpTut+0DT03zXe9H8jyWeW3hO2aZYE8k1YyL1kGl8g/siv3wWiD5JYozgaHh1i
	 iErH0DjW8VflvjHgqozhfg+IJHlmHVysfbCIuH7Rc17c5A92OYQrTVrVT5PekuTE9H
	 bI+/k5jyLZ44Q==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Tariq Toukan <tariqt@nvidia.com>, 
 Mark Bloch <mbloch@nvidia.com>, Shay Drory <shayd@nvidia.com>, 
 Chiara Meiohas <cmeiohas@nvidia.com>, 
 Michael Guralnik <michaelgur@nvidia.com>, 
 Edward Srouji <edwards@nvidia.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261109-rep-netdev-leak-v2-1-9a6d164142e5@nvidia.com>
References: <20261109-rep-netdev-leak-v2-1-9a6d164142e5@nvidia.com>
Subject: Re: [PATCH rdma-next v2] RDMA/mlx5: Add missing error flow in
 mlx5_ib_set_vport_rep
Message-Id: <179440554049.585435.15743124528960715774.b4-ty@kernel.org>
Date: Wed, 11 Nov 2026 08:59:00 -0500
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 09 Nov 2026 14:28:45 +0200, Edward Srouji wrote:
> mlx5_ib_set_vport_rep() attaches the representor netdev to the IB
> device, which takes a netdev reference, and then adds the LAG demux
> rule. If mlx5_lag_demux_rule_add() fails, the error is returned
> without detaching the netdev. The eswitch does not call unload() for a
> representor whose load() failed, so the reference is never dropped and
> a later unregister_netdevice() of the representor waits forever while
> holding the eswitch representors lock.
> 
> [...]

Applied, thanks!

[1/1] RDMA/mlx5: Add missing error flow in mlx5_ib_set_vport_rep
      https://git.kernel.org/rdma/rdma/c/da0c7b9ba5e91b

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

