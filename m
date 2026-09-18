Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F169B3E0C67;
	Fri, 18 Sep 2026 12:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789735798; cv=none; b=p4FmZ2rWaFBdYjeSXddvy/HuoImGh+IZcDKlp4oKt+UZfbaEjHhHXPD3CU4ITfP0IpBxmAxP3CF72NRheOVCZJwRw4ttq2HDfW3E1wdgmF3zjJ7konbqFQ1CVTebbK5gWEHuSkwv9IlCPq34rJ89LWLFnCGQ0BR8y6A6ws6q4eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789735798; c=relaxed/simple;
	bh=hvUY8o6KJPXfez2g801Zg3UlbgTGU83tkB83dQXfn9E=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=but+f0Mg7pa658IUUznTjCDZEOdUSsfVW5QYrN0frKvUh+/hlwftShWTDaIiMSvSpK9/8kAevolXhIdo8pCKepoZCSxyVXdU26Z/DXmKPQ0AcILHxkDyZ1ICZ8ewnjb/DBo/Bgp0/mD7mgLzv9VBKaoJLYiZ9bRXlz9mfL4GsNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XrO9st9S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XrO9st9S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE801F000FF;
	Fri, 18 Sep 2026 12:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789735796;
	bh=9j8aK1rSpoPY2KmrFcnUhi1lyHcLhcypUtlMDB2258o=;
	h=From:To:In-Reply-To:References:Subject:Date;
	b=XrO9st9S+jgfBdMeG4nZgTNeQBhppAot8TUQHPJGLyuHFHqaTQzPOZV3nz6TP4++b
	 cklVyR9oSQ56tArj1hW8mWAY6Foe/WxmEzL3caTPPX8nxeDDVrA41ypN0BrHi48nZ+
	 XnzMsHx/6FEamvh15smSUbgXjVaseV1XF+m9ZKvNnYRFi96cnHsBTp9yHjtielgP2Z
	 UCESIDdwqB90G1KDvackYCrIxrI65OnJ3/qDYj/gNdGpSVZ/xb/KYKXGVUkUhosvGE
	 p1LsumxiOE4PGDxHRPn3Mi0EJ1ty+LmRbwlejSA2dWK2P1Wxwz9KdARWruHp8VMST8
	 f7qJG3IY9iN0g==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Patrisious Haddad <phaddad@nvidia.com>, 
 Kees Cook <kees@kernel.org>, Yonatan Nachum <ynachum@amazon.com>, 
 Kalesh AP <kalesh-anakkur.purayil@broadcom.com>, 
 Chiara Meiohas <cmeiohas@nvidia.com>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, lirongqing <lirongqing@baidu.com>
In-Reply-To: <20260916073042.1746-1-lirongqing@baidu.com>
References: <20260916073042.1746-1-lirongqing@baidu.com>
Subject: Re: [PATCH] RDMA/restrack: Don't set RESTRACK_DD mark after a
 failed xa_insert()
Message-Id: <178973579386.2688475.13662660832887274389.b4-ty@kernel.org>
Date: Fri, 18 Sep 2026 08:49:53 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 16 Sep 2026 15:30:42 +0800, lirongqing wrote:
> When adding a QP to the restrack xarray, rdma_restrack_add() does:
> 
> 	ret = xa_insert(&rt->xa, res->id, res, GFP_KERNEL);
> 	if (ret)
> 		res->id = 0;
> 
> 	if (qp->qp_type >= IB_QPT_DRIVER)
> 		xa_set_mark(&rt->xa, res->id, RESTRACK_DD);
> 
> [...]

Applied, thanks!

[1/1] RDMA/restrack: Don't set RESTRACK_DD mark after a failed xa_insert()
      https://git.kernel.org/rdma/rdma/c/391c5d826fd0a5

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

