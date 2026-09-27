Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219BC2D3727;
	Sun, 27 Sep 2026 07:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790495870; cv=none; b=sxHADPjs4B2W82Mt5olu+G3FMFqPhvPWwtK3NrJg6+GYZ0VKxL0wsCmURLp1YognTt1r2Q4d/pJWb//TfcN0ylxAYfydB1XTiiFGDmDHga/lQJRYnijd4ToQbasDFJNoxMtHXlT/pZ1a4vtP3DV8qeItVVbKwS0GrIfx6hSr8ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790495870; c=relaxed/simple;
	bh=6kAZ+9zYEtvs5BvBa0p5umHoI/jIXwLDLZNR0v52dCs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GKrgGxo8I4E4kZtX/djAM//LXMdLdiFhxPfc0Xr9Pb1p/RwSZSpE1CBFtQtitf5IljDotKTbXpYyab5yyULg8C/vEufrqpsbjUrfHfIZ8pBuQAZ59UARjRU8IYcYIlPLLWoC3sORZRwCbfAqt4ZWHk8/hMUaxwcjTcAmlpUCY3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z39RpOLB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z39RpOLB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C52E1F000FF;
	Sun, 27 Sep 2026 07:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790495868;
	bh=KG2puzlrFcatqAXqVzbEBzYpRp5kOKlSTAi5mZGnJbI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Z39RpOLB59+5FtPss+DnxOXm3YA/aadsuZfAlI4quOWIo1XgFpBq1UjbuxdKeQ/Ox
	 de32+NBQroPNevkcShemNKaG4A/QouCeVfV3G3aSn3s0KkpWeQyt10dQFC0zL8cBaV
	 cvrUOhHj+6YaLoYqsLrcxPxUXfWl+YOlQ+qS7T+Ywh3ZRm8J1cWNdmTTYe7ZKSgc/x
	 hL10GZRph8C82mls8ZbyR2Tcstk9C2H43RXD6PvGox743a78IKiGobQBDwqiOtWV3V
	 BBm9gKt6QSvjRfGfUdBa9trZXRGxB4fa/tsnUD/Y22NOkrWZwSF2SzU4yYNqcRLX2Y
	 1IZYh/yAQpN4g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/smc: Serialize link activation with teardown
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chengfeng Ye" <nicoyip.dev@gmail.com>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20260927074547.3694742-1-nicoyip.dev@gmail.com>
References: <20260927074547.3694742-1-nicoyip.dev@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 27 Sep 2026 07:57:47 +0000
Message-Id: <20260927075748.5C52E1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> smc_llc_link_active() marks a link active before scheduling its testlink
> work. The first-link confirmation paths call it without llc_conf_mutex,
> allowing link-down processing to clear the link between these operations:
>=20
>   Connection setup                    Link-down worker
>   smc_llc_link_active()
>     link->state =3D SMC_LNK_ACTIVE
>                                       smcr_link_clear()
>                                         link->clearing =3D 1
>                                         smc_llc_link_clear()
>                                           cancel_delayed_work_sync()
>     schedule_delayed_work()
>=20
> The connection reference keeps the link alive during activation, but the
> newly queued work outlives that reference. Later cleanup skips clearing
> [ ... ]
> without changing the handshake sequence or error handling.
>=20
> Fixes: 877ae5be421d ("net/smc: periodic testlink support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260927074547.3694=
742-1-nicoyip.dev@gmail.com?part=3D1

