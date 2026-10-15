Received: from vtj.irix.systems (vtj.irix.systems [82.76.27.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E58B542EEC;
	Thu, 15 Oct 2026 18:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.76.27.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792088553; cv=none; b=YTW8GN4R2AQAT8j/641SwJqYAd3J6VUJYgKaalb2eb/t39Hc/UX0cS/WtXNYsY55f0PlNrt0vpQlESd29UGXwKZCb+4i0EhZQbbSpjZjVDqgsT3i7dwDkGKmtazt/4ubVsaS4FilUOcwaKiXg6qCaUFUvlzwWzfxSTfXthouJ/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792088553; c=relaxed/simple;
	bh=xNpEhYZcq6qVSUBvPyydPbPL4dYdr3MofZpFtCsCi+o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WEflBsuEJcrDAnCYgmFkE0vc4lHaIsY5eVXWi2OUeKTT3ONPHrInShqdDh8fP06EbEFqxUMu/rDqEJr1AGZXbME5mlCJeuab+cruAyndf2RNsfaP2hX6mV/t7Lt8glz0J5RxXbp5quhUjfHP7wXRJuto69uE1w9UpoqcCVvQL7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com; spf=pass smtp.mailfrom=andrei-z.com; dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b=S/GS98DG; arc=none smtp.client-ip=82.76.27.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b="S/GS98DG"
Received: from MAILGW-BIG.big.vtj.corp.irix.systems (localhost [127.0.0.1])
	by vtj.irix.systems (Proxmox) with ESMTP id 88BA812301;
	Thu, 15 Oct 2026 21:22:28 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=andrei-z.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=sig1; bh=xNpEhYZcq6qVSUBvPyyd
	PbPL4dYdr3MofZpFtCsCi+o=; b=S/GS98DGCW1dxwnvTcBT/UzF6t/3JvbXcTWV
	OfoD22QgCES3sp1x0dipC1WVgMOTfYA3+wNunZ/XKpn3tetnTudwmtuRkYZOSHIP
	ynXVx2yR5SJLthOJDJv/2fWXezxuD25TRQL5/1ppOurRgcewKyxwlAyRZM0GmXPH
	33CV67Z4piQvoK61IaVvAfrkzo0Y5+mPHqyVNaFeZIfFcVBYVGusBQcvosusY6IS
	o2iioOxF9s0t11nqh8lurfEP3CGxciUAoF+iqdcJGYLVDBryZYIprsAluA6QOOFt
	nilIUcUBe0wheFiMIvV3baSboUHynD5qXihEuAuo5VLHVVtC/A==
Received: from VTJ-MX.corp.irix.systems (unknown [10.57.36.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by vtj.irix.systems (Proxmox) with ESMTPS id 0F8AB12300;
	Thu, 15 Oct 2026 21:22:28 +0300 (EEST)
Received: from [10.89.11.73] (10.57.8.14) by VTJ-MX.corp.irix.systems
 (2a02:2f04:1:9c24::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 15 Oct
 2026 21:22:27 +0300
From: Andrei-Alexandru Bleortu <me@andrei-z.com>
To: Bart Van Assche <bvanassche@acm.org>
CC: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Sagi
 Grimberg <sagi@grimberg.me>, Max Gurtovoy <mgurtovoy@nvidia.com>, "Md. Haris
 Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 2/3] RDMA/srp: Post command IUs inline
Date: Thu, 15 Oct 2026 21:22:27 +0300
Message-ID: <20261015212227.3338582-1-me@andrei-z.com>
In-Reply-To: <fa01c872-9d1d-4b60-b994-08ba86a5ebaa@acm.org>
References: <20261015125118.2966247-1-me@andrei-z.com>
 <20261015125118.2966247-3-me@andrei-z.com>
 <fa01c872-9d1d-4b60-b994-08ba86a5ebaa@acm.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) To
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6)

On 10/15/26 Bart Van Assche wrote:
> A table like the above makes maintenance of the RDMA subsystem harder
> than necessary. Shouldn't a mechanism be added for querying this
> information from the RDMA adapter?

Yes, the table should go. But a single value per device would not work
for mlx5. There the limit depends on the QP: the send WQE must fit in
max_wqe_sz_sq, and part of it is taken by segments whose size depends
on the QP type and create flags. Only QP creation knows the real limit.

> What changes in the RDMA core would be needed to eliminate this loop?

A new QP create flag. With it, the ULP asks for up to N bytes of inline
data, and the driver gives as much as it can, up to N, instead of
failing. The driver reports the amount in cap.max_inline_data, as mlx5,
bnxt_re and rxe already do.

The ULP still names N because inline data is not free on mlx5: it sets
the size of every send queue slot, and so the send queue's memory.

On a driver without the flag, creation can fail. The ULP then creates
the QP once more without inline data. No table or loop is left, and it
works for any QP type.

If you, Jason and Leon are fine with this, I will send the core flag
and the driver changes first, then a new version of the three ULP
patches on top.

