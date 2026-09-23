Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0194946AA6E;
	Wed, 23 Sep 2026 08:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790150911; cv=none; b=ZVOit9PQs6gTJGnqKT9Te3MCOroYQYGOSAtTkoTJGpp+sx4bW+C8vwray2odXt12jKfWGJ2ClYpopPE3b+e1KGOBE671N5ATobi5Gwbg4gzFStwIY3G7ABOIym5Mbuz6A/QjAJrV2ifDhTbaOUR4eAA5lfC9/mAxiJXy18X1nh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790150911; c=relaxed/simple;
	bh=rMtbxzgSLKcRKb/AzjQvnk51C2p7ZQ5Pu0Ztyw1/zHo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=asAlpZG8LOOAbtphTDvY3oF2S+DL96HatBQUlZ9/2zp1FVxlWBeFVgPToPPpZdXqMtPa0WTe+zRwZK3P6JPAIhkL2+PzGiZNi3l6512JoQ3a2Yr+aHeHRBtDSHmdrTNPJXjsDxTpwOGBL0yaiFFXaFiJYfQmTOVDY/Mws1eGYcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LXwglY7O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LXwglY7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D561F00893;
	Wed, 23 Sep 2026 08:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790150907;
	bh=RpoZaXoO4vu9bytGfL2IV+XFq/qvaoHr7Ga9y5HB5kY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=LXwglY7ONFEJD//3e8Z5aFkO5K0WqxKXENxNxKEhz6OtkRvsVLnfO88e9rFZv7Z41
	 uCIjBjSG8RV7hr158U4uPx32H4y/ihVxi4ru/97XVyqsCY3vwW9cGmwAxpf6Hlc7KT
	 PS59gL+rgQnZnybAAvh7YgevRkdhbTJ8BfAAbG/ZZnxTr/1A4CI8RgPR20na0CKBvk
	 ZC+izTy+MstAOyX03Y3rV6a6FgQFPCXeTlROQqzmYRrQVvLn02CGDqIW64kjYeVsgo
	 Wbs2E9Yms0U/rMV4gyjzNjPlQ72Y40sTuHJshfa0Y/xE/W9ZRlGgbGDrLPOBO0WFLa
	 KhV446D4LUVPg==
From: Leon Romanovsky <leon@kernel.org>
To: bharat@chelsio.com, Wentao Liang <vulab@iscas.ac.cn>
Cc: jgg@ziepe.ca, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
 roland@purestorage.com, vipul@chelsio.com, stable@vger.kernel.org
In-Reply-To: <20260916183715.2092663-1-vulab@iscas.ac.cn>
References: <20260916183715.2092663-1-vulab@iscas.ac.cn>
Subject: Re: [PATCH 4/5] RDMA/cxgb4: Fix skb reference leak in rx_pkt()
Message-Id: <179015090419.3392134.10093981656053179310.b4-ty@kernel.org>
Date: Wed, 23 Sep 2026 04:08:24 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 16 Sep 2026 18:37:15 +0000, Wentao Liang wrote:
> rx_pkt() takes an extra reference on the received skb so it can be
> handed to the firmware completion path via req->cookie.  When the
> work request skb allocation in send_fw_pass_open_req() fails the
> function returns without releasing that extra reference, leaking
> one skb reference.
> 
> Free the packet skb before returning when the allocation fails,
> matching the cxgb4_ofld_send() failure path.
> 
> [...]

Applied, thanks!

[4/5] RDMA/cxgb4: Fix skb reference leak in rx_pkt()
      https://git.kernel.org/rdma/rdma/c/5eb6ecb6128419

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

