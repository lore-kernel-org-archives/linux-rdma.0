Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B455654705E;
	Tue, 29 Sep 2026 19:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790708668; cv=none; b=SnOFS4PeteCkkf/ABDmoPXPfk4ghbkLxMPLDb98kCqu3iwslB/9bkdNMbFkjOCzXczIE1PLSt9MuC5pGzbg8EizNqnw8mFXiRJPZ8DLCjIKwVL9T95tZFeKHt9GxkNKUgd3OZMXZnSpSGms9vSF36uEcwEI5lzzaq7v5J9TUOgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790708668; c=relaxed/simple;
	bh=MuP+tIYUMeVPLcPK6CE2aYyu20CcexZHYWfCI/3F/DI=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=L3RKvS4EkUyB1DFbmCcLVnbXgnlwd0RyWOp/J2xv3alMoTJ/OpCWkykxTJKaafBKy5/xqjeD1wXMhpEP4E987LlleuI/VYIFsTQYnhDGMMezaVUAmrKDtXFqyw0XOwuQnz9ewasRf2UCowfkqiUZ/DYOv4OB00glH3RoHq5QRb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HQLLkqvk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HQLLkqvk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FBAD1F000FF;
	Tue, 29 Sep 2026 19:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790708667;
	bh=AG7c/aiBDU43ZMrhw4dcw9HYFgrZIHm/Yc1yzrp8uaY=;
	h=From:To:In-Reply-To:References:Subject:Date;
	b=HQLLkqvk+PmYw9nI1nzHgMLQRZIUQWHzam3kYQjgBcON7m5y/f7qG59KdJFFIYDAy
	 GNNlT14uMh9zQBIzTPiAifT2yi01M+31dJDJL6cl6ou+Ds7ychMgm7KDK+vDlyC32i
	 3mZDQLrN4N2IaOwtBltz9ncxRoE0SFz5xUkGn1b8WFWMl5LdcwHbS+sIvzChc07h3e
	 R9iENBaqBDcX5mB0P4Z09Lqp1F3Civutg1XuPLxnC5jXKRDdH0R2Il1UgCHRWp2l80
	 LgDX4OEELxR10n3tLjXW+e+G+b33Jh5DrT+u5ohLTo963+eTXowXeADMItXUuInKxj
	 JMDA8bjtTDjAA==
From: Leon Romanovsky <leon@kernel.org>
To: Yishai Hadas <yishaih@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Matan Barak <matanb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, 
 Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Jiale Yao <yaojiale02@163.com>
In-Reply-To: <20260926111150.3197004-1-yaojiale02@163.com>
References: <20260926111150.3197004-1-yaojiale02@163.com>
Subject: Re: [PATCH] RDMA/mlx4: Do not allow the user to write to the clock
 page
Message-Id: <179070866486.3979066.10577666620017337297.b4-ty@kernel.org>
Date: Tue, 29 Sep 2026 15:04:24 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Sat, 26 Sep 2026 19:11:50 +0800, Jiale Yao wrote:
> mlx4_ib_mmap() maps the internal clock page to userspace through
> rdma_user_mmap_io(), which does not restrict write access. Userspace can
> request PROT_WRITE directly, or upgrade a read-only mapping later with
> mprotect() because VM_MAYWRITE remains set.
> 
> Reject VM_WRITE and clear VM_MAYWRITE, applying the same read-only policy
> as commit c660133c339f ("RDMA/mlx5: Do not allow the user to write to the
> clock page"). The rdma-core mlx4 provider requests this mapping with
> PROT_READ, so its existing behavior is unchanged.
> 
> [...]

Applied, thanks!

[1/1] RDMA/mlx4: Do not allow the user to write to the clock page
      https://git.kernel.org/rdma/rdma/c/33db1d9683b8fb

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

