Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33024E73C7
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 17:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790616841; cv=none; b=D+2n100Uokm7DAsV/y8VMNvynfjUP2r8IOgGWFBmkAwZgw/HJ4f3GMyGd5qBWwBrPOxYMwyEzc9iK/DlfW1WTAP7AADyFV3oKN6k1u/j6vJFOBwiAoeGEVJ5udtzm4TYpiBmVAm5KAvyrEfRm1LoESSJb3ESdGUiWcbMxsaFgCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790616841; c=relaxed/simple;
	bh=LwrQZLn3Wz32UB0FcaHuX+R7XdbtinYODI/JDvYP8dI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=V3dR4S0zaG36OBEbnF23tN6N5gV/Ty1zd0XrMiLBtiaRE2oZfstC35e49/TwEEM0OMSTwlGfSqt0C3NuB+Kta1M+yQV2RR/q0bIWxmb6cO3fZbU4xg8FpEHjaunL4dLmNN2EmhZs5deEbSR6HSzBLfwppfwsqQq1LR3bS2KGsTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ad2oTxh0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ad2oTxh0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E2611F00893;
	Mon, 28 Sep 2026 17:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790616840;
	bh=LwrQZLn3Wz32UB0FcaHuX+R7XdbtinYODI/JDvYP8dI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ad2oTxh0kIiTgQ7l5sUm2bP8MNE6B2Q4moLbLWQ87ZTRvcOfzFa/DcmGosS9BZ0IL
	 UBVH8g+yMmVb6h+H9MjCz+7SSqC5eXPo9CMDv82WnCmDV9vZ+vs3ClDQnqQ7wdA/Le
	 Exp58ZCYaVtLKHu//lIABhk8v2J3OFXJghp/mW+WMwThkjLg5HD6RQbHvo3z4zQojV
	 E6inYkVpS8y8ih0oBGEP1C+MUKr2Nc0OcK42I/fumQgzAvA5IcDlql3FP0RXhw7iOK
	 TEmDITfw8l7wkk73NreuyIT1Lrz262NlC03MT5ksljkE+OhFEHsunlILCN0/m60ou/
	 RGbgQosluwcbw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 4/4] RDMA/rxe: Do not force cleanup on pool timeout
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dongliang Qin" <cccccccccccc777777@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260928171756.3254016-5-cccccccccccc777777@gmail.com>
References: <20260928171756.3254016-1-cccccccccccc777777@gmail.com>
 <20260928171756.3254016-5-cccccccccccc777777@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 17:34:00 +0000
Message-Id: <20260928173400.6E2611F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The sleepable pool cleanup path waits up to 50 seconds for the last
> reference and then continues cleanup anyway. If a reference is still
> held, that turns a lifetime bug into a use-after-free.
>=20
> Wait for completion instead. A stuck object is easier to diagnose than
> a stale pointer; the existing non-sleepable path is unchanged.
>=20
> Fixes: 215d0a755e1b ("RDMA/rxe: Stop lookup of partially built objects")
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Dongliang Qin <cccccccccccc777777@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928171756.3254=
016-1-cccccccccccc777777@gmail.com?part=3D4

