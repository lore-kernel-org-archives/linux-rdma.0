Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E174E77F6
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 17:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790616389; cv=none; b=ToSlPSbMMxuqe1Y/UqtMVVDbiF2VoMyQcw2c+UT3qQadxB1ZKCig5EDRYsCptqMFKWc8UooOGhfP7K9vSRATfSLAFOVuuojAbtWyiQfI97af8FPlgl4MMfn4EOPbAWM4us0bqyLaj8w7eYKIYkQ3+iYlpn/uS9Bs/vdau6G5aHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790616389; c=relaxed/simple;
	bh=pjQsn1k2PHchM+nky08/2PXwZvmA+YAtdQJ9y6nmOjI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=nmXcSvXeOalRYXpF/9lRQrxFL7WRhb93Cp94HKc2zU9QW3VXOcz0tnJtvTbbrW8cQQv2XuSAK7Qsj8QgdKP1MHcyhVU60HKhXYRbTESG3wSCSkyGfbA7HxHiHB262CG+W3RRQCuZ5bJYCAShJu62xTkWUAoBgU+HN5qbsX/soAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LEF82GW1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LEF82GW1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DB71F000FF;
	Mon, 28 Sep 2026 17:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790616387;
	bh=pjQsn1k2PHchM+nky08/2PXwZvmA+YAtdQJ9y6nmOjI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LEF82GW1vtT6SGPm8dkigt8R+ZY4K0PWsqP35TQYQXOwiS0mvrKXkcRrSG+DwFJOJ
	 IuBBLWM8O07zDzR1lPx755o5oVeMXDGposJjzEyWC63dW5af3OhpKmDmrbcuFz94vU
	 SJroZGCUgfuozYygT80YsaUkCvZPywLCB9I3KWdcrl574cg3NOSKwUZgnrV92ejuhw
	 2zK06GbElVlA525Xp8x81z/nGtlQt+3fgZA8FxyTCYeSoIp1FYjPmHho8KVStqNcmS
	 vUbVjIDXTgrmTprEVQkKauQ++Q6MYvJCk/qdWm6BxkS5XZ3Yi9aUxZHdb3TYqFkbiw
	 nOEpGq2jhN5dw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/4] RDMA/rxe: Take MR reference under MW lock
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dongliang Qin" <cccccccccccc777777@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260928171756.3254016-2-cccccccccccc777777@gmail.com>
References: <20260928171756.3254016-1-cccccccccccc777777@gmail.com>
 <20260928171756.3254016-2-cccccccccccc777777@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 17:26:27 +0000
Message-Id: <20260928172627.B2DB71F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The responder validates an MW, drops it, then reads mw->mr and takes
> the MR reference. A bind or invalidate can swap the MR in this window,
> so the responder may acquire a zero reference or use an MR that has
> already been freed.
>=20
> Move the MW lookup, validation, and MR reference acquisition into
> rxe_mw_get_mr(), and perform all of them while holding mw->lock.
>=20
> Fixes: cdd0b85675ae ("RDMA/rxe: Implement memory access through MWs")
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Dongliang Qin <cccccccccccc777777@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928171756.3254=
016-1-cccccccccccc777777@gmail.com?part=3D1

