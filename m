Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711F838D419;
	Fri, 14 Aug 2026 19:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786735673; cv=none; b=bK8tF0t4QtFAAMPNO5RkwItuFNhDF0q4KCWqQp4K1TRYcz/9jL6jaD2TptturnHnBj4cDVmseMqOSj+4L5xMXda9FGrUkIPMa3TmNHCnAX+76PLeM+bbRrm0//f/TTMH2OBpfICxagg/Wajpxhw/pb7s/DpiKE8zFwZ0a0L1vis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786735673; c=relaxed/simple;
	bh=yg5KSiDUjZy2DhSTrjVKqXJekq7U4uTBRUUKDs1tvEU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OXwsAN0GplAj6GvbFi4PzdXdj/kmyZ3qr8wJwtCWmm86TxmKqRse7eFJfcaGmJSy1E0TWr/D6JewpU5GIuO1w+F+R4V5fy8bqHyw9vE1FHmvGASrtQx3FqPwwg9RxkLgH7JrgdQjBnJMbfcGxgx3JglHmL6CFaR6WdpH0W452nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jTy77A1d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jTy77A1d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A2A1F000E9;
	Fri, 14 Aug 2026 19:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786735672;
	bh=yg5KSiDUjZy2DhSTrjVKqXJekq7U4uTBRUUKDs1tvEU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=jTy77A1dqQJv9GxByT+AB1qXiGkbw7SG1TUmZYIRYp3c97vIGcm9MUvF9Qqde8MhM
	 dNfBwrGAi28DaTVjEN2Gv/lCcanIVTWE6r2QVxxu/a9BEqn2RRz1Op6hOyyUY4883i
	 ewBMvi2GSw9/gHUU3TUWCopYmopCoXNdcauFL8zV8IM9UN6QoVzd0gxdP26HoukLre
	 xZWqduSZpWmp1uOgUAUGrtxTc20N3BRiCBvIdJ0EX5e1r0WwmjidrumsFc4j4CIuze
	 ovCeuWdgWbZBq+MHDF71yc+XaZqcS4PR0yVhlgbI9cZ4zvr0hHKdHuVJHoQodl8O47
	 TLE6CphHbL4OQ==
Date: Fri, 14 Aug 2026 12:27:51 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>, Gal Pressman
 <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
 <mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Saeed Mahameed
 <saeedm@nvidia.com>, Shay Drory <shayd@nvidia.com>, Simon Horman
 <horms@kernel.org>
Subject: Re: [PATCH net-next] net/mlx5: SD, prefer sd_group_size from vport
 context
Message-ID: <20260814122751.7d1d7863@kernel.org>
In-Reply-To: <20260810093037.3138197-1-tariqt@nvidia.com>
References: <20260810093037.3138197-1-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 10 Aug 2026 12:30:37 +0300 Tariq Toukan wrote:
> issue: 4680618

Stripped when applying, please pay more attention.
