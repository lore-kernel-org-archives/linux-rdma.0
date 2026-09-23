Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF12469850;
	Wed, 23 Sep 2026 08:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790150907; cv=none; b=pI5p0jd8GBfM4PcIPwqKUxgXbhvHzyETC1GebOh6H12zQgHMcFfeR14I/MZmjLu/XOibnLkRpKptGcPkPG3rPaZwd//zce7ulog1UqUbnEA5M8kj1w0ULXx4xEhR/zo7HE1XhfRjMa0zTpwaGdjQhX11Je9204erYxf6RVCoXH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790150907; c=relaxed/simple;
	bh=MrHNra1+cZlsrbjdCOO6jQLqnf690T+1O3bUHSKziqo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=hQWZEeGn1VLPV3JskoCiz6104dD5G7Ea8YnY2eE8hIxBldRBGhKuNU0sSvEnsArL8WjTuFB64oRXZDdYdNZ/0pFBFJ+WQR++zZ11eG7EIaDkdf6VPdqANYf1Lq9hafyCoWaIW9dJFmHomobwQsJ0oLiA6wR+F1LYpruQkSv19c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eLYfP+Ir; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eLYfP+Ir"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 334091F000FF;
	Wed, 23 Sep 2026 08:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790150903;
	bh=k81LzKnxJRIBKheO+esgrTZZcMucxHl4ZCrLEs+YM84=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=eLYfP+Irc+vRJVGXxi9TrIy+ragqCKMpD2AfH24UApQXhEN8Z2pi/Y/AWTZDPmAOx
	 V9jOWLQ7aT2jgjGKcj50Iy4jhgRQQ3J1Iuha7j6Gw5IhPkzMQ/kQyEGlBLscW4RVnT
	 i1dzuw0aljwZQ1nVUXZJAsV1Jnpv3/Ryn6Vyp/FhYKHisD0LoGfT/Mmtel/Eic+PM0
	 Jy01OJeUrc4sdLXfGjt09L9Wd3G0AR/DIh6yIVo/c1yhuYeCnXk9zd8woujcH8JMdZ
	 fVDhlyFqyc1sA20EqinGnfMopJng0dBSbrzpqJVVu6apBzeIwelsdqgmVME0z+xoNL
	 OhTUOOe1lQpaw==
From: Leon Romanovsky <leon@kernel.org>
To: bharat@chelsio.com, Wentao Liang <vulab@iscas.ac.cn>
Cc: jgg@ziepe.ca, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
 n.zhandarovich@fintech.ru, stable@vger.kernel.org
In-Reply-To: <20260916183530.2092534-1-vulab@iscas.ac.cn>
References: <20260916183530.2092534-1-vulab@iscas.ac.cn>
Subject: Re: [PATCH 3/5] RDMA/cxgb4: Fix neigh reference leak in rx_pkt()
Message-Id: <179015090088.3392134.7347566713371144587.b4-ty@kernel.org>
Date: Wed, 23 Sep 2026 04:08:20 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 16 Sep 2026 18:35:30 +0000, Wentao Liang wrote:
> If ip_dev_find() fails on the loopback path the code jumps to
> free_dst without releasing the neighbour reference taken by
> dst_neigh_lookup_skb(), leaking one neigh reference.
> 
> Release the neighbour before jumping to free_dst.
> 
> 
> [...]

Applied, thanks!

[3/5] RDMA/cxgb4: Fix neigh reference leak in rx_pkt()
      https://git.kernel.org/rdma/rdma/c/5fb3051aa4611a

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

