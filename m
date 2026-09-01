Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C8774756DC;
	Tue,  1 Sep 2026 13:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788268215; cv=none; b=qayejHbGtlvY//cLuq22RFjBRhQZigs5ZUGTx5oHwMFRxN485OkpkLa76qllhOKTx/WTynFpjqHewVATFY4GdNoXF1TR4mJfyIHbpqqQ8uckTP45GZSusOpxplGSQ+33OB8VyG0aK6/WVCN0q7nLWQQhrj2jmG26R80TBmrbJW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788268215; c=relaxed/simple;
	bh=D7Y0FiodKzTsin7aX0uocFDy1vIWFPMH2CTDpG3w450=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=aCKkTaWeNsJPUSjiAO+9aW9ZP3MKYnzBUjmAo/xXn2U9bXS5yP1D7iwizuIzK1dzeVzArnQFSaC2s0tgc/ZEJ5CdmvY8hIvM+O6W3HkD/eqQfhAlZpp8gPic61tqnEqH6JBU8hvKqJazGANcAPtcJzOSUclQdO/x8F4nEl47oJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MDeQIBnw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MDeQIBnw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E251F000E9;
	Tue,  1 Sep 2026 13:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788268213;
	bh=GUek49z5wqUuUMjedTlyCSq9I1Mv+lGUV4d0JU5GNzY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=MDeQIBnw/ys5Oa1LrW9+lGU8jCrnR0D7AAir6CqelY3g75Kv2VgQ0pM9kh0sjiKbc
	 KgKuD5mAClYFyazG1CRcg5+9uCyjlrV299YfvynYJd+cppGwdzwQq6EmfTzuCEhtLQ
	 VKabnNgTkD0NvRP0saqGw3T+ERiZOxAGhAcNx0aQOFThzz8Z/S1pwuadDv6iq2DRnD
	 ihlYpAKtPStF/eBm8Z8mLYQFU62fpSJjOoC7bumfy/azb5t7w1O0vtWjknvcEpieHv
	 c6zw/hXMZ4boeJIe12arT0N1Y0DkAni21W4Ghvy6r5BdjJIY8CFtgZTURXXP5JJAXW
	 n4XfNUAL9R3OA==
From: Leon Romanovsky <leon@kernel.org>
To: kotaranov@microsoft.com, snsanghvi@microsoft.com, longli@microsoft.com, 
 jgg@ziepe.ca, Konstantin Taranov <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260827143736.2013093-1-kotaranov@linux.microsoft.com>
References: <20260827143736.2013093-1-kotaranov@linux.microsoft.com>
Subject: Re: [PATCH rdma-next v2 0/3] RDMA/mana_ib: Extend MANA RC QP
 support for UAPI
Message-Id: <178826821084.1317752.17968593336700715052.b4-ty@kernel.org>
Date: Tue, 01 Sep 2026 09:10:10 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 27 Aug 2026 07:37:33 -0700, Konstantin Taranov wrote:
> From: Konstantin Taranov <kotaranov@microsoft.com>
> 
> Extend MANA RC QP support with an updated userspace ABI and optional MMQ
> and fixed-size send WQE features.
> 
> The series first extends the RC QP creation request and response while
> preserving compatibility with existing userspace. It then allows
> userspace to create an MMQ and receive its queue ID. Finally, it adds
> fixed-size send WQE support, including MSN-in-WQE when supported by the
> adapter.
> 
> [...]

Applied, thanks!

[1/3] RDMA/mana_ib: Extend RC QP udata request and response
      https://git.kernel.org/rdma/rdma/c/71fc2d52047e79
[2/3] RDMA/mana_ib: MMQ creation for RC QPs
      https://git.kernel.org/rdma/rdma/c/4309bec53b2496
[3/3] RDMA/mana_ib: fixed send wqe size support for RC QPs
      https://git.kernel.org/rdma/rdma/c/23d5ff8fd62f27

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

