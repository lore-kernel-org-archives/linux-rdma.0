Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794279684;
	b=U7xvf2ydfLTu6oyWLh8Og87gbYxpcn3XBKnxU8J2qiWOVCsB9LoRKtIUtztB5jHpinK2
	 JPz+R8+dLMbDZfrRVvGG4qMOCZ7qUVXBDqNN1C+Dkia8qJFzsLZoda857p+xNPRBYNmHz
	 HsZNy0qAQgAxf5zbn45r9YvRuOJQyDoIPWJY8tY5QMEqjwh0zhFWTEE4yH/RYXAc7v4gx
	 SoQGZfWD4A9rjIXfO5STxRiJmie0RHGDJdn/K7o4gsTFln4MSrCWaF5FBfb1/EnyGU/yn
	 2lzuko6Fl0Jk+xlWdWJep4DrKuxC9zxnW4g3lDItTC2dUnRN6wPomYTcxm4HfdnnScw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794279684;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ysFIWYjxwHmUcfDEx/hnTIPWBUqFtCli440qKD4Ksfs=;
	b=yF6+/PwOXMMXl+AX+YjRR4WtviE97w/8MNpc3MNhuiCGo5Br+j13O2Qb/RSce3+XmsOA
	 BcGrwxXsGcG8FDEQr++XwKs5lbFCisJJ11PfxOyzfleSHQVwO5WvAnRhWAoBQEz0LrvZS
	 Go1z1gI1MpL5sVWdmyqf/FCFLk4VOvXpO6L7LxLEyoOQe5WPagiOgX0GON8dMNBrdzwYO
	 Nm+B7wYE81Zvs8nHYqEqJ3d3xFxoYJVVsU49O5tJ1DI/a+r3E3ymrmckeCbtoGhDrSb9f
	 uXHdva/8s4zbECi2zlKxyEk2nvQCi6pt/2m0WzphtSRF0kfV89CUnQ4JYJbEv4eEL9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T5l1EMAY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34F0606A331;
	Tue, 10 Nov 2026 03:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T5l1EMAY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4271F008A1;
	Tue, 10 Nov 2026 03:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794279683;
	bh=ysFIWYjxwHmUcfDEx/hnTIPWBUqFtCli440qKD4Ksfs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=T5l1EMAYfi2JDlRal4j5Iuyo6IF8L38uMpSaMYdWkQwgqCrv34Q3uP1+jC5b7Ny47
	 v9WVV1rKGdkeMSkxBFdAoYuXmPlPoAwGTNi3Ik03lkH0zT3DLQYhfKLzek3AMN3yfi
	 6PTKf7/pRbsGY0OIJ6d7TsMJbP+j9z/mN0jsnm0AZAFnDdUZPprmZR/gNb1HPco8LQ
	 /c6i/TWDFZY/I0XQ7O09TIb15fkDrxgoa1xfouc02NMcXSOpV0+OPjn0kHLHQNQSFF
	 NHC+MstSwMoqYSiaQpUOuImOjm6g1zKKSD0qiQY6/PXdrIKgCte/FaBRGzXQJLYcNX
	 sQzW6UOh6EQ5Q==
Message-ID: <sashiko-outbox-206075@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 02/14] inet: frags: annotate data-races around
 fqdir->timeout and fqdir->max_dist
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Cc: linux-security-module@vger.kernel.org, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261109025425.328445-3-jiayuan.chen@linux.dev>
References: <20261109025425.328445-1-jiayuan.chen@linux.dev>
 <20261109025425.328445-3-jiayuan.chen@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 03:01:22 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> fqdir->timeout and fqdir->max_dist are read without any lock while their
> sysctl handlers update them with WRITE_ONCE(). Add READ_ONCE() to the
> readers.
>=20
> Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109025425.3284=
45-1-jiayuan.chen@linux.dev?part=3D2

