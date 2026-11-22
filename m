Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795360161;
	b=5JfKXu6BiWc7Ms2ymVGZsrwrxxZO8WwNxfZBZSnAf4QUw/6AiKxoaOzIjvuRDDCidW6y
	 XGB+p6++ZpHdrLP/YJnw9K9ljcOgXtEb9T8lWVaBNViJt4u2AzABAtJRHYYWtjPk6J/C8
	 I9CPvpBAhmLbRg3m8OcZ9xA8neQA5Ioz+D6byRgZ2YYO0ULRoAON1P3CJ+oBW9UFHUtvm
	 5sjRFbKAbnSTemwi1DyhEau4oiGGAwyQwY3lDtgvm0rT+4ljhqaHvW9qunkvTLaw4VUTr
	 FnnKo5gFop3NXhTcqT8nsykft/uzsJfVLhQ+5mYiKgFTErYmdPyuNIBxKpDNGpsmj2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795360161;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=fGRP4ZEA/eMYONMqdp0IkhxFYkY1qGTHoTvubr2aiNo=;
	b=yyroXFvBtYVE5GSwguX1RS2K1NvNcZr8kQNKXQ4LIYDzTTOG6qc7omQwpa01UCe6joxs
	 XDs1fCy8mASfIy+Ps5cRP3NSfUlknZ5DLJPfLf4U8KAxKzJkZViK+fyLTsYqLXkSExGfZ
	 NUKirQLUT+l3o6gbVj8qm8u+4/gVqRNz64qorf3oGxIVHgvG5RMcasC713w3g8/Cum3Yk
	 fHI3kpFIUXwNPkLYKueZ8KHEPGfeaP6sGcv4NBj1azgRTlb1Qf1jvNsKK35KpFpWuJtLp
	 mp+hFde5UsM5sm3x1G7ADJDCcetjBP7bktzD83AlhtmoYxQa4RCbB1xoZrmGJQs53Zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="K09Hn/Yj";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361AD606A320;
	Sun, 22 Nov 2026 15:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K09Hn/Yj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D354E1F000CA;
	Sun, 22 Nov 2026 15:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795360160;
	bh=fGRP4ZEA/eMYONMqdp0IkhxFYkY1qGTHoTvubr2aiNo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=K09Hn/YjFtMdlXpCcvOb4HvgL8oX/6eq4SPRGvom64piUWUDll6poXRF9fyq1c6lM
	 YUFoWrtxBVZPmFkmHZ1nZZ7KMh5EbX5ZvMOV2EVZUBNwlxTuz8WYpahTsYgoy5ymNa
	 DBjoljrEHCg3QgnsiqByFXSmUDQW4JzOwMj5fJCBOY40jeRVinQax62Ox2IvajINje
	 ZZR+GIrhmG3SfS2Due4xP35eqw8i5GsP49iiLoH1vQ1VFlbWqTLsg6gQeAFq+tMQaQ
	 x3Qw3JVS/7Flym2EiZROzb1FfIUmYiQnp1LGm2M88E+m0RpgZ/jy4zl+GQT4iH+YMJ
	 wU/I6w7ni7hpQ==
From: Leon Romanovsky <leon@kernel.org>
To: Zhu Yanjun <zyjzyj2000@gmail.com>, 
 Andrew Stellman <astellman@stellman-greene.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261119151327.95446-1-astellman@stellman-greene.com>
References: <20261119151327.95446-1-astellman@stellman-greene.com>
Subject: Re: [PATCH rdma-next] RDMA/rxe: Fix NULL dereference when
 invalidating an unbound MW
Message-Id: <179536015761.284370.349418730536231669.b4-ty@kernel.org>
Date: Sun, 22 Nov 2026 10:09:17 -0500
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


On Thu, 19 Nov 2026 10:13:27 -0500, Andrew Stellman wrote:
> A type 2 memory window has no QP or MR attached while it is in
> RXE_MW_STATE_FREE, which is its state after it is allocated and again
> after it is invalidated. rxe_check_invalidate_mw() rejects
> RXE_MW_STATE_INVALID but not RXE_MW_STATE_FREE, so invalidating a FREE
> window reaches rxe_do_invalidate_mw(), which dereferences the NULL
> mw->qp and mw->mr.
> 
> [...]

Applied, thanks!

[1/1] RDMA/rxe: Fix NULL dereference when invalidating an unbound MW
      https://git.kernel.org/rdma/rdma/c/4075ceed67949f

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

