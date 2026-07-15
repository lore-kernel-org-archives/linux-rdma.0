Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012C63ECBE4;
	Wed, 15 Jul 2026 09:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784106554; cv=none; b=qQZU1ylwyS+LgUDmPAWPzO0hGIu1eOjbpIffeuZcFONoGDvsxsZjuvMNhbczZDwMXX0Bbq+6vrQLsrooulsgQC67rI9Lelgx0JKhN7oqtaDC+4R5xsA0fgPJvrVLa6v8PH2dY7ggUq0YTVkMjAOzavGRZ6yiNtpZcrWzUmtg/8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784106554; c=relaxed/simple;
	bh=C4ds2dwo7aAopJsQrkQ6CF1f5gifEvebxz0K5F5vpKQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=RnMpnO2DFl4Sc5BjcmNZsZELeCzpaoDmLHgoxoV9wG0NHphBnDOyOtCX244nmxuNuSCJaHMOcKhVUHwX3LPtHViFYYBJFXJKOF4OWjUKnPttDbwwZhelL9DFRw/OMGBf6YlM6zqH827MGvUJSyp6sWp064tLPfV+IsuK0xoF900=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OUPJIIP1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OUPJIIP1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C99511F000E9;
	Wed, 15 Jul 2026 09:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784106552;
	bh=uOCR1yy5iLzEWniBpGr7tczquehQf0MC1zjdD9A0VJ4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=OUPJIIP1rMLsaoBmsS70m6iKMWO+9Vqm0zLiPQtsJiRN9FI7IoyzlQf5rmgA5hS+l
	 MAjJvtWDUj7nTgFNhzmEPb81H1enYPUMfji5xh9jBDGg7YsbZYOQt4sG+LSZHmKjet
	 5kV0hevPxK/tBytZe84SqFRS3OQM5gh/DzquRbxmanAk5AuaVkqJtk4PX6ZdZQAT2J
	 8Fwo7vxcqi7Dy5TmVIGAwPT/rH9GcaDrdopgjIohn7iZObI4MbYdafE3AZYTBb7dpu
	 ctLw17j9rkBM7neaRDROStzDDNEO52rPYX9ZiMnxHnL1WAmwKFewSr70Ot3BM7Dh2S
	 uL8FtQ/CxYGog==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, 
 Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, 
 linux-rdma@vger.kernel.org
In-Reply-To: <22f2263c04cc94e242cee712e6e6d82b86ac353d.1784017128.git.christophe.jaillet@wanadoo.fr>
References: <22f2263c04cc94e242cee712e6e6d82b86ac353d.1784017128.git.christophe.jaillet@wanadoo.fr>
Subject: Re: [PATCH] RDMA/mlx5: Constify struct ib_frmr_pool_ops and
 dma_buf_attach_ops
Message-Id: <178410654947.143159.2274183881280364069.b4-ty@kernel.org>
Date: Wed, 15 Jul 2026 05:09:09 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Tue, 14 Jul 2026 10:19:06 +0200, Christophe JAILLET wrote:
> 'struct ib_frmr_pool_ops' and 'struct dma_buf_attach_ops' are not modified
> in this driver.
> 
> Constifying these structures moves some data to a read-only section, so
> increases overall security, especially when the structure holds some
> function pointers.
> 
> [...]

Applied, thanks!

[1/1] RDMA/mlx5: Constify struct ib_frmr_pool_ops and dma_buf_attach_ops
      https://git.kernel.org/rdma/rdma/c/dcae56cfecc6e1

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

