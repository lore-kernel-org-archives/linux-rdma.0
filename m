Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794559932;
	b=WjaVnyJ+OmoSJ2/mzmIZRv4iL1TCZ1EmSmEkAwctm1hL24TcED96WjBt3H+Q2uwJvMpq
	 x31sliGWFJi6PcQkf/QXYxNygfLRr2KU4n1BEkdz8AWfLNAbmBIhylUMRVU0dgbPRUGBj
	 er/SmZB30LVSrzDTy96ZpDJ77McsI7Gqn1KTWXAAZKSpulrrLc23z7ghrCssHTZZ2spxj
	 RssUFIA8vqHum8EKMSQZCTOF89nM6rNEWFyO41rxbbDsYDtWb4na23BnwGfEFupuE8u66
	 sNaYr6uTPVpEow8MTngGz2whbw2iifCNkG9hbyjuHVRUgd8QaVas2fWFfUy16tCuEaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794559932;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=eWV7AqFdjeN7vgZtX3vJdebIwanws6YuFXv2PrHfO9w=;
	b=SmUYFCnvpEADIfb7tS9orRyVl9YnqQY0oQ1JrVZPEijjiEquIod269pfpa/pAhwTnwqd
	 fWNlTbAmoe6xhCCm1KLo6KRMb4tM6v9phw5ICnwAXP9hXv+sADV7AoLsSWEu92cXoKIO9
	 a9lSAz4X7IB5BVIJ9BDJQmyAHphSUDSqdlsXcKRrCaQmdCcj341T3FGfNpBh8HA9JPw62
	 1D0fb7gzUAhUuQIPghewxUB/bfEuMuC/X73FZ5NQRaHrI29drFOwAd7Edg3+TbeP5JVJF
	 ba9iBOCMn+ajjybRgLzgyexpTPUADlMtN8uAlQs1Bm6mu4ccP91cZwye24q6ekavDrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dRaSmo3g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E6D606A89E
	for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 08:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dRaSmo3g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F9C1F000C5;
	Fri, 13 Nov 2026 08:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794559932;
	bh=eWV7AqFdjeN7vgZtX3vJdebIwanws6YuFXv2PrHfO9w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dRaSmo3gZo5jhPd9wh3jMViUHovTZOnpSSCVO0hS4OwvnEt/0JFwGgOy/13M7F4dl
	 /rz4l1a67aumM6tNYyn36MMZRiFTVqnI3w+1ApweLekVrxDMYyI1iQ3FDS9huQUejK
	 ftBNs5Z+McWzpTGOW/6gn+abI6QHZT5K9VT6+92V2KY+dQleATjuLFqDr274yNhQrJ
	 k9eAsJlUNYpj7aYZN3My/xHFCt5N7ZTOQ4BzKNwP23fWZfF3sP+dhXvRQwWW2kOpvF
	 gCoR4bxytRX1MZTG8bRL4cJ8lXjUrGzlGUWK18bTDKtU+94BQvAHP1LVGwAWR6rX13
	 DdSqS4IAI3Org==
Message-ID: <sashiko-outbox-212471@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 1/3] RDMA/srpt: Initialize commands before returning
 BUSY
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yong Liu" <pkfxxxing@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261113083848.1517595-2-pkfxxxing@gmail.com>
References: <20261110030809.913063-1-pkfxxxing@gmail.com>
 <20261110030809.913063-2-pkfxxxing@gmail.com>
 <20261110052827.963143-1-pkfxxxing@gmail.com>
 <20261111065342.1282709-1-pkfxxxing@gmail.com>
 <20261112094138.1390409-1-pkfxxxing@gmail.com>
 <92a82300-a454-4ee5-a191-0ce5a2ee58c7@acm.org>
 <20261113083848.1517595-1-pkfxxxing@gmail.com>
 <20261113083848.1517595-2-pkfxxxing@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 08:52:11 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> srpt_get_send_ioctx() clears ioctx->cmd, but descriptor parsing can fail
> before target_init_cmd() is called. The error path then calls
> target_send_busy(), which dereferences the NULL cmd->se_tfo pointer.
> A remote initiator can trigger this by submitting a command with an
> invalid descriptor table.
>=20
> Initialize the command before sending BUSY on descriptor parsing errors.
> Do not request an acknowledgment reference since the command will not
> be submitted to target core.
>=20
> Fixes: 8b8807b9e982 ("scsi: RDMA/srpt: Fix handling of command / TMF subm=
ission failure")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yong Liu <pkfxxxing@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113083848.1517=
595-1-pkfxxxing@gmail.com?part=3D1

