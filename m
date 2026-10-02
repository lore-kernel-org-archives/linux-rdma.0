Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA26B355F42
	for <linux-rdma@vger.kernel.org>; Fri,  2 Oct 2026 09:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790932381; cv=none; b=IZgAYZrD3nvNJX7e7I952x4JDtqnnYRPKvm4bx/Sxj2PQ8d2PxueWydjq0Ma8lB0hi6bhefDBmroDJ+mAW5a8PAcus21WXFHgEgSzyoabng6CgdX0K5x4WnOn3AavjDIAOrktr6dXlZJ8rNIgNAenVhoSeDg6dJUJHE/LOcOWYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790932381; c=relaxed/simple;
	bh=LenNC4HcOdx14J9Mpd7l98t0+KE6W29Z2fjn+Ar8oCk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HI/1t+8gxYTxwjDBDtFXvqLumT1um8KNo/wzqnyjRKQuzqtKs0fOCDTWLIz2JBPdu3nE5E7/5YYys5J2Ff45obklS3h0p8PHm41tD3rLcoC/ewbYLYzG+IUQn9VGOrxlVYy7IsWxe+MRR+V1yyY/APWZPYt07L6ZWfgi1D2wQ20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BnMtnJYk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BnMtnJYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB961F00898;
	Fri,  2 Oct 2026 09:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790932380;
	bh=LenNC4HcOdx14J9Mpd7l98t0+KE6W29Z2fjn+Ar8oCk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BnMtnJYkwtanVdDbj8e4sBpwM/wpwPpZ0mtBULE2zXr2B1j5jqvkHcGyu/WlQ99wI
	 6ngcigKUPql++wXHdkt9G5L0c4lG0L3YYu/ZQg48dh6rDQ9sE8vv8CtEzApEIKqGJy
	 gBxq/ah51HO7Ud1tffyPB1ZzTjgIFX3l/iTFx66llpEqCpyAv2t+5Ve76O2Lijbzfe
	 ozMnk1PhYuHA9H1xShLejF0/Bwv2RUVC7G1aUSm1zVLDgkwp2jRD9dhRqvrXnKi/wL
	 bSANGPTY5iVcVp4qh5UjEvw6Wn7pLa3QMmcL1Zd9/LJ1xrY8fpggyAuyAe9qbWpZTK
	 jJ/6zai0zuSyA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 08/10] RDMA/mana_ib: Flush and notify CQs when
 kernel QPs enter ERR
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261001182015.1757203-9-kotaranov@linux.microsoft.com>
References: <20261001182015.1757203-1-kotaranov@linux.microsoft.com>
 <20261001182015.1757203-9-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 02 Oct 2026 09:12:59 +0000
Message-Id: <20261002091300.4BB961F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Complete the RC software flush path by adding a kernel QP to the CQ
> error lists when it transitions to the ERR state.
>=20
> Invoke the CQ handlers after the transition to flush pending work
> requests.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001182015.1757=
203-1-kotaranov@linux.microsoft.com?part=3D8

