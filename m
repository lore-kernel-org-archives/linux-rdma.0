Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792488347;
	b=O/BkkzXolmUckq36Hk4RW1Bt8FWL9p8RAbAhDU3huCTqjDXnRfg4Gzw/6YSCYYbyM/f7
	 PXFwRaig6SCgPNoM8A+lmEUZQkTX9CmKiWFtsET5ZyRoHEkdN3xVGD1IK3q9exilM19qU
	 E7FjVLo7/tpHzGGggjSigCgM32u9cZwQ3bbkh94qySFCglH7hPCSb+GX6FMbevXWuf50p
	 5Um7voTzoz2UALHGYBd3WeZFd0NNbSgoEWLpAIE2t1PFe1uqENHqXVceOB3JiTd+Gb6DV
	 3Z4sCjB6I2aGSy2goB3D3QUib6gg1dD0CMEGxOYh9HfuKmkzADEV26LtfiuDm208/xQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792488347;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=FtFHTOtmL02OIQYDt3W6QQE0oSKe5W4Nnilp2RgE0Gc=;
	b=DqQwWGozT8rCVS8o2WseIQkK8oAau/MMPS/s8/9ZRjF/rfrQQZ8hoHv7XKcoPPHDvrYo
	 UTUl9VrPhQXUcZNZNSsQ95brPUqDlMVKuz7tArOhj61j3w+Ssr3BU7JbJYI4edPFLqqFr
	 cfWft+LrLki1+6XXMFzshboNk/3J1ONoJtjl7Je+4nv2udo+J8ju9/a+yaOfuyOMFl0me
	 LAX0lFPu/QaMtGENiTA/jRVEtvw3kY08U80MMa6zthmRyk6bS6/LOEtyMq/Owzhr1JQsR
	 dOLOFVmeQqdG8CLXHxMO8tIMYw9klQEKpDkZcqUY4t1XWcbk7DjrX0PYdmYSWwyxeow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C8w0P9vd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF38606A319
	for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 09:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C8w0P9vd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE141F000C4;
	Tue, 20 Oct 2026 09:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792488346;
	bh=FtFHTOtmL02OIQYDt3W6QQE0oSKe5W4Nnilp2RgE0Gc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=C8w0P9vdM7N29+v0MWsFzXiMRKga9CY1w/cG3rFiGD1vshIDMqQFHCnfIxlqz2Svs
	 sGVI18NLEzNu2cI9HVWto3e59H+ooF3ck299ZEfBzbSXdCCjsB8S7/11jb4VyZ5xga
	 Xevtwk+q5k6IWKkSMvh4XB+Q6xElKXg1tKCMGTi37bYIuPMkTpVd41/ewJuWweAAog
	 UIkZ96HFyO7USie6VlWcH0agfOoarltvbU9ch8RwxisD57o+0pPHyL51yjY/4+3P6J
	 Vhjvp4UT3ZHn4GtquYoDCg3xmNlJ9TMP+wfewJ+Qh25GLNCnCqQTOqPlKhbu+3qM+S
	 Wjm4d13QltETw==
Message-ID: <sashiko-outbox-178727@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 09/13] RDMA/core: create a queue pair ready
 to send
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Davis" <eric.davis@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261019-uet-ib-core-v2-9-8bd654f25370@broadcom.com>
References: <20261019-uet-ib-core-v2-0-8bd654f25370@broadcom.com>
 <20261019-uet-ib-core-v2-9-8bd654f25370@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 09:25:46 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Eric Davis <eric.davis@broadcom.com>
>=20
> Some transports have nothing to negotiate, so a queue pair can be ready
> to send the moment it exists and the modify sequence carries no useful
> information. Let a reliable unconnected queue pair be created with the
> attributes that sequence would have supplied, in the same form the
> modify command uses, and apply them as that modify to RTS once the
> queue pair exists, so its checks run. A queue pair whose modify fails
> is destroyed.
>=20
> Note that the QP handle field is refused, since the create is what makes
> the handle.
>=20
> Signed-off-by: Eric Davis <eric.davis@broadcom.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019-uet-ib-cor=
e-v2-0-8bd654f25370@broadcom.com?part=3D9

