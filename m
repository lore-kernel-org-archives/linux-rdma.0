Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71CA6424D6D
	for <linux-rdma@vger.kernel.org>; Tue,  6 Oct 2026 13:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791294514; cv=none; b=EyfT5hMr9Y83oGF6aFds5v4SPPQPrtLWko7JiZlcjEJN4zkIwbZ8GX86C1FrXRcwYKw6f+kvQu52Yc5gFYJmm6itVDWlI6GywlApqCg3sz24XOw2ukZUwkRDHlT4o7cI23V8VhG60iSa0CjTgGkdE2rfu3fcteOkYIbECQljP7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791294514; c=relaxed/simple;
	bh=kMtTkezz8RK0C6SIlG94IbvLyEEsxqh9OTzo4DlPCrU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JTcvVpN8KRKe9wH6saTMZQ/yDtbloYhqlnJwUtkFVxPNfXA0H8ANS7WjBYtik9NV386qgvbnup4iupnLvmVvEN7O6jw7ToQLtKARc5wRhXQn9rEKEEK7db/+pKUxf4MxG82+/RRI9peHkrHfCBGxp/29rvfKCIecE3jD2YDZytE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=snu.ac.kr; spf=pass smtp.mailfrom=snu.ac.kr; dkim=pass (1024-bit key) header.d=snu.ac.kr header.i=@snu.ac.kr header.b=zDL/YGnq; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=snu.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=snu.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=snu.ac.kr header.i=@snu.ac.kr header.b="zDL/YGnq"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cc4be0e5351so920866a12.0
        for <linux-rdma@vger.kernel.org>; Tue, 06 Oct 2026 06:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=snu.ac.kr; s=google; t=1791294508; x=1791899308; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Xd+YhTvmmDiJasiYfZDfV8qAggwrlgKHI8hk48pv8dg=;
        b=zDL/YGnqH8YvAHo0vE2booW3iNn8L9i59YIB/gJBLc2H4PWlGJZxGgX0P/sp5ndVsR
         UxPUwkcIoUbPUSkHdOoDB5MpQ15ma6dr3Ln6b6MSf5KpzEOk7+L2dfxb+YhLCiTlBr3l
         UCjWHsdQbc1biSstrrsCR/bO+gDkizBulxzxU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791294508; x=1791899308;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Xd+YhTvmmDiJasiYfZDfV8qAggwrlgKHI8hk48pv8dg=;
        b=EvbO+oh6VsOAwEFvtmi1v8jkofszsGmwvNPMBkY322EJmjagiZtI8QqiKsPF3fnDPP
         AdfcInf5Jaik1NuawcDd3YjO02nFmEUDcTFlcdCnkPckR3HZH2pTN095SEwrkgEDRdYJ
         Y8PkGi95SPwnOKuM2vy0T4YeMTXZlDgvNYupBqqiht4YwQjdTkGzAiohQ0CQoVAUgPQ2
         CVGGR6BAPo0Uk8etlARwKYFEpoi58JhREN2HbpDzQzsUad3vrIMGYXrSUE0o2XM6yvT5
         dBlmeQqYVN3ED/xplZs1RkvpYd88X1kuaYchUSxTChSfsDsPR2BZSdneIqb5Zn9MV4kC
         WrMw==
X-Forwarded-Encrypted: i=1; AKwUvBwe0KC6WG917vvdOO7peIZz43vEIhPVqG7cykykKLYgrR3k+9VjJLd+gr4q3iQUcRu08hEJLFS3NJoV@vger.kernel.org
X-Gm-Message-State: AFq9FYJ550zW0D727bAagnelvpcgK3JBJJJS1746JUW6GEInxdTup3Xn
	aKQoCQZibLrIYlCZ07/03vWvVCaK5hJ5RyJVlTa92Kgd51D1OPr/z6C03q92OyDvFYk=
X-Gm-Gg: AYBFou06pfRX8FTqH20g0RTzj5ElxM8CNfO79vBRgomXh/Rp6Gj96C6ejJJGD9pqtmg
	qbSzN8YD+IRtpTEdx/v2Q07M4dj750Xs/S7mao5f0XkCmshZJFM9wFkvTm7yEi2M7YBeHuRkQ6N
	8bVr21QhUaXzcUynThax8N8KrlHJO8Ys0qcxJnocpZpI77EN89kt9iUTxlHXW7UVQ5SzAbomwbv
	iaLxkhfBokuSPlgMtTyQtZTr8wUzRaTODrRnlCiyCXzX7cx7mEqpUNAckoKCxaQ9qw8hubyvSNU
	vLLIXof8zw7TPnGWtYQ6fTj4BrgP3RJNr9i2zQ+Xo7YXm+PVUocPIzwEz3BMbCBmsoRUZdcpmDa
	ySGApAaorBxnXSC7FBMxj7JhJZNiPTR+zUprIgydAc1vkBjlA/IQYgyKPklTLVGVG+4zF7zB/XA
	Kzf+6PEowZGkIFEBT4BZI5njgCpiTZfRUrOumoIwhr5s91pWqxJjR+6p6hcgFBte2fuQ==
X-Received: by 2002:a17:902:f78c:b0:2da:eb8f:b4e4 with SMTP id d9443c01a7336-2e4e9c29bdbmr98737285ad.7.1791294508455;
        Tue, 06 Oct 2026 06:48:28 -0700 (PDT)
Received: from 1c1aead48890 ([49.142.45.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e5a5eeca3dsm24227885ad.67.2026.10.06.06.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 06:48:27 -0700 (PDT)
Date: Tue, 6 Oct 2026 13:48:21 +0000
From: Seongjun Hong <hsj0512@snu.ac.kr>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, 
	Mark Bloch <mbloch@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org, 
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx5: allocate dma pool structs on the pool's NUMA
 node
Message-ID: <z42vlmle2feb67bdkt6oswrhytfuruznrfnfo7z7caad46sp3j@ms7c7rxs6vfc>
References: <20261005-net-mlx5-numa-allocate-pool-page-v1-1-01f4283932b4@snu.ac.kr>
 <dd8747e3-5502-44dd-a64b-8d2ad5fae1ea@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd8747e3-5502-44dd-a64b-8d2ad5fae1ea@nvidia.com>

On Tue, Oct 06, 2026 at 10:10:06AM +0300, Tariq Toukan wrote:
> 
> 
> On 05/10/2026 16:46, Seongjun Hong wrote:
> > The mlx5 DMA pool structs (mlx5_dma_pool, mlx5_dma_pool_page and its
> > block bitmap, and mlx5_frag_buf_node_pools) are allocated without a
> > node hint, so they land on the node of whichever CPU happens to create
> > or fill the pool, whiile
> 
> nit: typo
> 
> > the DMA pages they describe are allocated on
> > the pool's node.
> > 
> > The pool, page and bitmap are dereferenced on every block allocation
> > and free. Allocate them on the pool's NUMA node as well, so that all
> > of a pool's state lives on one node.
> > 
> 
> Thanks for the patch.
> 
> That is true, but these structs are only used from the control path.
> That is once per WQ/CQ/EQ or doorbell record at open/close, not per packet.
> 
> I doubt we can measure any benefit, so it's just a matter of consistency
> with the other fields access in data-path.
> 
> The API kzalloc_node falls back if node is offline, so it's safe.
> 
> No strong motivation, but we can accept it.
> Please fix the typo and emphasize that these are control-path objects.
> 

Will do, thanks! :)

Best regards,
-- 
Seongjun Hong
