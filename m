Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C5A3D9527;
	Tue,  1 Sep 2026 13:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788268346; cv=none; b=IPpvrkxbi/mClYB/inMrrHluO8XzKWkjoUMbCh/MO51RSF18Tt+wCZ54TKDfQi3BrGD6EjeynapmCV4XnNBdpDqV7Cnv5bVpJ1vKjhG6IL+JAbIVmv8WgkbSP/IexCKCKzreDjX4L/NaRXfbSvJJBroEwjZp7/G8arJzW/Q2DYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788268346; c=relaxed/simple;
	bh=CedOdvSOG1qs/fr4fZAERA8FtatbE4Oz2BpDqJjyMhg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ioEkbjR3pn71jJuK6dYRxAno1DcQVy7/K4eaAT35WYs+sb8T4rt8BscMUEXZF3R2TDh9NFeUgAmE1U214cfipO0E8DZgxWYJULKG8wMttKCu8j07dByfwJsUA5dXfpkuUaXzUVru60rGAAYKGWIRSAAk0YNIa1CmRx/b5D2OQTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UW4DYi6Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UW4DYi6Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7A11F000E9;
	Tue,  1 Sep 2026 13:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788268345;
	bh=9EAPkOHOqvHaZzL4LdXifTxKIBGcK0GSAxjVav7t4YY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=UW4DYi6Qx+LY1byXt2JgfdJzCXA2QfZJ5olu3Qlybqgpg4nA6ZkeMy6ZkG481tOnP
	 30+VJU3kx/iWtlOj+L68r0m4qIOMVsFN+8RI7upo4bkIOE5+uephcDJFOstOFKxJme
	 K1h12qgfG7FM0zND1qruI5q4oMl7vP5vJtAVgoAjGSipIUizJnjuSAJXheFRBA7f0q
	 Q+cnrAswKYetS2djekyTLWkRX9800vM2nLjBnSGZBwP6VFk0qWHd/nduagJ8NtitbU
	 GEPvt0MckWsj3cqtcxg9cMxaEYeVFKgsi/Ze3QPdF9AMZSY2N4OCVLRNUDYLA8vfRj
	 Vfqp1alDGDteg==
From: Leon Romanovsky <leon@kernel.org>
To: Zhu Yanjun <yanjun.zhu@linux.dev>, Zhu Yanjun <zyjzyj2000@gmail.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, 
 Michael Bommarito <michael.bommarito@gmail.com>
Cc: Bob Pearson <rpearsonhpe@gmail.com>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260617022728.2770116-1-michael.bommarito@gmail.com>
References: <20260617022728.2770116-1-michael.bommarito@gmail.com>
Subject: Re: [PATCH v2] RDMA/rxe: insert mcg into mcg_tree only after
 rxe_mcast_add() succeeds
Message-Id: <178826834210.1321433.17003076666385881025.b4-ty@kernel.org>
Date: Tue, 01 Sep 2026 09:12:22 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Tue, 16 Jun 2026 22:27:28 -0400, Michael Bommarito wrote:
> rxe_get_mcg() publishes a newly allocated multicast group in
> rxe->mcg_tree before programming the backing Ethernet multicast address
> with rxe_mcast_add(), which runs outside mcg_lock. A local userspace
> RDMA client reaches this path with ATTACH_MCAST on a UD QP; if
> rxe_mcast_add() then returns an error (for example -ENODEV when the
> backing netdev has been removed, or a propagated dev_mc_add() error),
> the unwind frees the published group without removing it from the tree.
> A later lookup of the same MGID dereferences the freed struct rxe_mcg
> from __rxe_lookup_mcg().
> 
> [...]

Applied, thanks!

[1/1] RDMA/rxe: insert mcg into mcg_tree only after rxe_mcast_add() succeeds
      https://git.kernel.org/rdma/rdma/c/1caceeb2d74bbe

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

