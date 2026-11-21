Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795251915;
	b=JPADfFH5q8s3eyNXQHbvKvC05j2Dif9nEMh7GdTrsYUr18Q8gIsALN2Vwqu6MOeP4VTa
	 h77xfth8U2bhh6Zd+jboXvwQxRJRCQoCqCOymxg+Qcrs9Fv5ndnCiogUCbWo8G9wIK4a2
	 5mvftSFL0PNZ0Ys4YuZ4aPAkgWJuIdXwgZlpnAJz7WNx6ZBEe8hha1QSevlJWVQW0VV84
	 WbV+YNanHUqBIiUYRQhyCtSnHBHtOpRcYW3mA4eLFElpHeSuo/cSbkt7+5WwP5uNtr6bI
	 5oTYu/Fe+6gTnlTeB7byCKeu9Gknxkmk6wgiBTKrFoTXEzKHdEv3+mZbBcyOHo7eeNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795251915;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=LRTC8vLfPKKB+daofLKm1CRWwkoOBm9o22966vQmmWo=;
	b=2Oiklf2u9V6UkUSMSQ5RPCu/1AQugaRQ6xIQS9dwqIdo6sNLjnJeOBBkCUNZewHyjlJB
	 NpfF4Hp53N/p0sMeKvhKoDIt+v3bz8zk6atT8I+5kaSh6lYMmpmJct/lO4gx7tR+Jd2Lj
	 w9OsgyM/4GXPmGdexNDr2IVe2dzSUyr62N/Wf2UMfHT/28445Tj0j6YRqfWwxkm0FtSRj
	 qMwCA2jmi8cyqFrUV7ZBkr33oQysyURj+l25BhjVaM+IZ3gtr0RY62pGNP6RFIf5AnT4i
	 zo5/+CH/8fQTqr13q3fnBfw80N/8opc6aontA/+Z4st6uexJLuYqjEDxJKyQdLzyDkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PZzkVnl+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44033606A320
	for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 09:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PZzkVnl+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD84A1F000C0;
	Sat, 21 Nov 2026 09:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795251914;
	bh=LRTC8vLfPKKB+daofLKm1CRWwkoOBm9o22966vQmmWo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PZzkVnl+XZDi0hjkAwXrdnsSRdyMc39ULNqJ55kRGmoqkln4LUSnqP994MkR3jGD8
	 JKvtKWHF7tTaVGARAAJdRHRgCPpscfaPChyAyjXzGnNPsMJsD+3S2X0ffgvL7bgptw
	 vRrI398JK6Sn/2bR4Jbm9IT4HWV2qxHf+UULr63rg0xHP4Cjxbpb+zpUkOnaWRWQRJ
	 GbgX+Gzib7srb63IkHTywm9wWjVDGjYSd+ZiDMokJc8Yjl9I6gtBMi0UVIpnJgcXdA
	 LuiRfLSClfR3EB6B1fI3piBOytcBQbFL/3NzT5Ox42GAKmBTb/MQcvWPHnj1Fr4RzC
	 gbYxrwBIJ2wIg==
Message-ID: <sashiko-outbox-226854@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] infiniband: cxgb4: Add cleanup on failure path in
 c4iw_init_module()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wanhui Fu" <fuwh1120@163.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261121090058.400020-1-fuwh1120@163.com>
References: <20261121090058.400020-1-fuwh1120@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 09:05:14 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] RDMA/cxgb4: missing Fixes: trailer on c4iw_init_module() leak
  fix
--

commit a9076097e24c29502aab3a6c3bfee7c36d52d50c
Author: Wanhui Fu <fuwh1120@163.com>

> infiniband: cxgb4: Add cleanup on failure path in c4iw_init_module()
>
> Add c4iw_cm_term() and debugfs_remove_recursive() if reg_workq is
> not allocated successfully to release memory.
>
> Signed-off-by: Wanhui Fu <fuwh1120@163.com>

[Severity: Low]
This fixes a resource leak introduced when reg_workq allocation was added
to c4iw_init_module().  Should this include:

  Fixes: 1c8f1da5d851 ("iw_cxgb4: Fix possible circular dependency locking =
warning")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261121090058.4000=
20-1-fuwh1120@163.com?part=3D1
