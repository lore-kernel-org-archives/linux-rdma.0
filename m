Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC74E44685E;
	Tue, 14 Jul 2026 12:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784031999; cv=none; b=sDAAzjvUhY9sW0XLpKzhYutpufFqcN4cnOiD2vh12g9gdQuqnFbLZ7RIp78Dz2kIKhaHbPpbrzqpMOWRtCt1+wxD0TDIA7Qtg2dP64kzXu0bdduhTQOjzYOzkx28IYHFK58er6GWIjAHqm+1REYD5frh6meLkEV7AANVq2A2/Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784031999; c=relaxed/simple;
	bh=wPZSCJhtGUoXlNBBAla7atgM4zbSiPxjslbWi3eDo28=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=sGCCh25ILsSnfQ+KcBnI2yD79xoSm4LhLvDvrutL9IC5GcM1IHC+W2oyJ1NM+1yeL8zrqSx0ddt2WzBP4Rh3Fp9TPeizyiM5Khu5XpY+S5lEFMqg98f9sJkFRpKq0Tw/osN7UK1rAPh+SEnu2dX+zC1MGq1Ixu4q/q+a1B1uTlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d/43HVnA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d/43HVnA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19F21F000E9;
	Tue, 14 Jul 2026 12:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784031986;
	bh=mGk1WxQeIjy8TXxnkr72i3ixVNdguqRlqFJcS5wfXts=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=d/43HVnAk7/FJSfqTj5xPz9u7OIgJtrLN5hKMCb2FWagDN2HMlJti7jLHQXFwtYFY
	 UInW9HOmx+m5UEb3lc4W8EUlLakzhEfewyYo3bWFc+aqt0RWPbjQwVnsPZgO14nvka
	 Pka70MqwZmt6lszXW0R534MSEcoD7NE38iOKc7wCJoeq5Qwil2yxBJwwGigzAaKrhj
	 qN0kPwPnAxhKpEs5HYpFBfUbjd3t3H7RAu4SrH55t291VHsYv45Yhauf7Lgk38OoUN
	 DmHtVL++ue2LbRreljwCMORN2W/HyIPvdEQcMj7dIEmHuO3S9noT1f0yg0OxJbPX8/
	 2tpQJRrjVJO+A==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-rdma@vger.kernel.org
In-Reply-To: <20260713-b4-rdma-v2-0-65d2a1a5180c@kernel.org>
References: <20260713-b4-rdma-v2-0-65d2a1a5180c@kernel.org>
Subject: Re: [PATCH v2 0/5] RDMA, IB: replace __get_free_pages() with
 kmalloc()
Message-Id: <178403198364.107074.8884062475078285923.b4-ty@kernel.org>
Date: Tue, 14 Jul 2026 08:26:23 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 13 Jul 2026 10:17:21 +0300, Mike Rapoport (Microsoft) wrote:
> This is a (small) part of larger work of replacing page allocator calls
> with kmalloc.
> 
> My initial intention a few month ago was to remove ugly casts [1], but then
> willy pointed out that Linus objected to something like this [2] and it
> looks like more than a decade old technical debt.
> 
> [...]

Applied, thanks!

[1/5] RDMA/umem: ib_umem_get(): use kmalloc() to allocate page array
      https://git.kernel.org/rdma/rdma/c/66073100a7b857
[2/5] RDMA/mlx5: replace __get_free_page() with kmalloc()
      https://git.kernel.org/rdma/rdma/c/e3d8c413e2e9e8
[3/5] IB/mthca: mthca_reg_user_mr(): use kmalloc() to allocate addresses array
      https://git.kernel.org/rdma/rdma/c/5036553f0e39e2
[4/5] IB/mthca: allocate mthca_array memory with kzalloc()
      https://git.kernel.org/rdma/rdma/c/45bf0b3da47d75
[5/5] IB/rdmavt: use kzalloc() to allocate QPN-map pages
      https://git.kernel.org/rdma/rdma/c/f8d04b0c74e989

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

