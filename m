Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795610870;
	b=BQEpAciLqI0omlFnSsnW770o+SMx3NGbG/C4OfFO/Kov9RLrhqzknbCLnbP7J5UOuGWR
	 8ip+W76LvfvbtQ3hzPV9Cbwl93NuFMTUgVnjPIRedJWktE0MxXXj0F/68cHdb8UfQ19cg
	 l9uy2f4FDxzP0KMULWOXGHq3JV9CQ0oUu1V9GvjHpc0KxJ3qMvcs5/3oOMmZ5xXxpMQrK
	 U7+JCsNtbcd/gMRrYMQkR2ML52MuoEBDXnsSALbppe0JA1cgtCfO0JdXyClv66tyRrwmh
	 IhvAialxnLNRyhZBdPwBgBPcRemGXa3xHgvff0QI+AoWkj2ZHxnf702ZsXnKg5LD3Cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795610870;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=qmmNsGHx5swsZXrbHcd6p0xEwZ8Dh7RJPPdxqIjGjGo=;
	b=llfhATs1KR2gbJT737ah79sie252T6tXgyDtU6/oaRzofLkGHi5EV+VN6uAA1myH4Eq4
	 zFNp0J6vUgrsvMp/OcfJ1Yl8dMavnT3/PP2TiR/fopevKkhthk1DSKpC7q7ex0LIjgJAT
	 Qt9HVLeHZabDqR+zOg1zYxNvOliTz61zTGGKZrGC3fiL6fz6ylkIRq+JSLlSw4aQ+W90a
	 sev5SHk7Jy37RZENgaMFiH8J1uTaWSjk0u2s3OktECzrVJGQ1/cbg9w/nZjot0rgixLbz
	 3pID4yriRfIfJz1KqlLaAQblTVh3E2/BWP5LkKxGFGWKCDsVXj7hYA31gtybJvrP39w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A5B+nm0g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999E1606A31E
	for <linux-rdma@vger.kernel.org>; Wed, 25 Nov 2026 12:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A5B+nm0g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0FB11F000C4;
	Wed, 25 Nov 2026 12:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795610870;
	bh=qmmNsGHx5swsZXrbHcd6p0xEwZ8Dh7RJPPdxqIjGjGo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=A5B+nm0gLGTZXsQ0QTPdBUBji5230f6k6lhnhDtPeZVwLym9oPNkLYQZbjJhTDEwY
	 A09x39Z+0xP0QsnzVFSpfrKREdbPd9qZ12RE8MW5NTeSotIu5eL2cs7mh3L3Gu5UxW
	 5M4vlSBGV15zY3Xr8/20Gv+sj+U2HuD2R/8yNl0VQr93d63KTJS0m5MAZj7CV3wR0c
	 yuu9enUQS0cusVr+BvQ7FJr4fOcaNhkXMg20+2ZTOCWysg8zFIROJ6Eoctbfse5Faw
	 9ymcJZZd/SirtMgYxpAIN61Mr9Dh98YJgZMd9jLEN4gbmXaUniFqco0oJi8jh14qCT
	 1Wj0UcuaQdyfg==
From: Leon Romanovsky <leon@kernel.org>
To: jgg@ziepe.ca, haggaie@mellanox.com, dledford@redhat.com, 
 Wanhui Fu <fuwh1120@163.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261121095902.442960-1-fuwh1120@163.com>
References: <20261121095902.442960-1-fuwh1120@163.com>
Subject: Re: [PATCH] IB/mlx5: Fix a potential memory leak in setup_qp()
Message-Id: <179561086727.1213625.7685046838604300896.b4-ty@kernel.org>
Date: Wed, 25 Nov 2026 07:47:47 -0500
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


On Sat, 21 Nov 2026 17:59:02 +0800, Wanhui Fu wrote:
> create_gsi_ud_qp() creates a QP but the QP is not
> released if modify_to_rts() fails. Free the QP by
> calling ib_destroy_qp().

Applied, thanks!

[1/1] IB/mlx5: Fix a potential memory leak in setup_qp()
      https://git.kernel.org/rdma/rdma/c/274daf227ed929

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

