Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795683430;
	b=Lj7/2sDuCY7KFkotVhe2KkUK8q3lS1csUDJyveHBsF5hu1CSykafCxTz2ylPde72EgIj
	 xjGkCQNJzsy9PuaFA/fxiAC8JQtokwOBdelv0drxGxuDP1ySyq7DZNhx6L8GaxdZMi1P/
	 zIEkg0dpLe+vN8vVOTHQmI52XWbrH9etLFyQXV/WjMYpzTN3/TvZsTyrPVE1oancQCYbC
	 AmH214MTSvQ/vXLa416/thnOsvZSC81CPp3S8aRK8cInij9gerMdXmAdrC73lo9qm28s4
	 s+adZukp6vrNTDXeOfyM306o9rn5aSXC9gYs8fTHL+UHM2TjloNJCDTzEb+LM9bTEyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795683430;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=c8eXb6MPyyPDuG7fWkku3VOTMsmdQ5zJqCf3p5BmCmA=;
	b=WDMfv/zNsXKov/AfQpcqfzJ+AtY3wGjVny5rIyZnmozxBD6aFQgXbsdJeLlfm/blwZO4
	 QlDXMGbG1P9fxiwvYGQiOG2w7srtQ7gyfmj3gcIkX+C1Vx6HabxHlFGgM3DgJh8Ck40f0
	 1CKT2z6LO6iu/0QHrK/MgQgrLydjqsd3N6XWDdmGeNx1ola8XDRxccrC1STsZ+Jn4ky+N
	 gOs8cYT1BSqtfX4cHGW4EcsTb8577tALd+7ranNK3XWd7XdPht7bdqEBUxWMy/OKOadFs
	 Ftc4JyxbAAGNn6+tVAo2JijzqLbHqvanCHZLIlHC81QreufL+N5SsiY9lKoyg4DjRbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="mu/Qtpfj";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C271B606A32D;
	Thu, 26 Nov 2026 08:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mu/Qtpfj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 668621F000C6;
	Thu, 26 Nov 2026 08:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795683430;
	bh=c8eXb6MPyyPDuG7fWkku3VOTMsmdQ5zJqCf3p5BmCmA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=mu/QtpfjGKXegsH13hhds3olZJA9A5aGEyvkzLIF1twPMK2FrrB2HstxUZJTclybe
	 Cz8rSYWwoboY6jGa1DjCj3x5OaObt8X3pIFj0CmK5a8/mHmKnOIV2G0ebRZYxe7/ZS
	 ClBisQ3u94UvfR/RXaIXO9H8AMGPNQdLSW9434Rjn89osAqFqI8vbp46Py6fwLzA3y
	 UXjVLnyY4IOm7F74DugQfMMCB1Z7fY0deneEZ4StOpbf1El/X0d6Nca+PZ7CmcNpss
	 5UHBir8hdb27yJ/+UVrQtX2UwVeBAs0d+GE7tsqZdhFyoxqTutl3Pyt2KuGfDmNkq1
	 UbayDbAWtbrbw==
From: Leon Romanovsky <leon@kernel.org>
To: Bernard Metzler <bernard.metzler@linux.dev>, 
 Andrew Stellman <astellman@stellman-greene.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261122191122.65240-1-astellman@stellman-greene.com>
References: <20261122191122.65240-1-astellman@stellman-greene.com>
Subject: Re: [PATCH rdma-rc] RDMA/siw: Don't send stale data for a queued
 zero length Read Request
Message-Id: <179568342728.1250831.15769582279657645593.b4-ty@kernel.org>
Date: Thu, 26 Nov 2026 03:57:07 -0500
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


On Sun, 22 Nov 2026 14:11:22 -0500, Andrew Stellman wrote:
> siw_init_rresp() queues an inbound RDMA Read Request in the inbound read
> queue (IRQ) when the TX work request is busy. For a zero length Read
> Request the IRQ entry has num_sge 0, and siw_activate_tx() then leaves
> wqe->sqe.sge[0] as the previous work request left it.
> siw_qp_sq_proc_tx() sets num_sge to 1 for every Read Response, so the
> Read Response is built from the previous work request's sge[0]. RFC
> 5040, section 5.2.1, requires a zero length Read Response.
> 
> [...]

Applied, thanks!

[1/1] RDMA/siw: Don't send stale data for a queued zero length Read Request
      https://git.kernel.org/rdma/rdma/c/da570e4488d197

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

