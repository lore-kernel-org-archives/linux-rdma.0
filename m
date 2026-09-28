Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A952D8DC4
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 16:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790611583; cv=none; b=BmzHTlUSkzkea4k5+yulEpm1uPRK+yqNj0/W7l9SsP77cCnU2nZpMenHI+g0H2rfXbYozhhFGC3q65JJRP1Z3Q+AXiCrTxxtqvdsG9RQfD8N6lKgNB6weyxM5fWxnMLp/faRrz52MMWPWlPRdBwa4VkW0ZvCD6QK2c0+wE/cZCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790611583; c=relaxed/simple;
	bh=pfViWgFXuwSH4myZ2gSv/CWn9UQZODiiVjoez3Kn54Y=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GBt7APNMqa4UjVLMmTkCLZZkqN78YqvJ/xEGcmGPQ8JkwCu/OEGjw4D75/+lyhOKASzIZ7LprLBLZG2pnGXrgSRsxIzpA3V/qYJwFKL4ol1a9CzY7/wYuqDcsvFn6rw3D+v1ffa6UppXLBIunY9fB8ifMfMFaiWAYBWGQ93F/xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YBwOQARq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YBwOQARq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A0D1F000FF;
	Mon, 28 Sep 2026 16:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790611575;
	bh=pfViWgFXuwSH4myZ2gSv/CWn9UQZODiiVjoez3Kn54Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YBwOQARq9e48LogmUEWNvGSKSUL79YwCqY12KO2J89EBfyRaUk+9eHgk+PQV5L4YS
	 efYq1k5Q8HnaEK/yL3Ifk9020gKrL5tYG7xxnhg39U8Kbiz/EDbqvkcQgWwSDcttQG
	 55JKKB2CTXzQJdCOU8E00PNQ7NU6EtQhwfQnG0StGdWWGU9y7RiRvPDCADz7wYPmIB
	 YlrZr1nRCgtdqW4KmXmCuKKGgzRnuyl5yl+TfVFDn2eLMjTJNmAQkowHgXdbDpv3X5
	 dkvT6zppYmUiSCwZhHYIGdCDuIZDftq8gklFW/iQlhBPIPzhctZJKePXNAoFAi3sbq
	 ZKGLvQNWXm1SA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/4] RDMA/rxe: Do not force cleanup on pool timeout
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dongliang Qin" <cccccccccccc777777@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260928155351.3222978-5-cccccccccccc777777@gmail.com>
References: <20260928155351.3222978-1-cccccccccccc777777@gmail.com>
 <20260928155351.3222978-5-cccccccccccc777777@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 16:06:14 +0000
Message-Id: <20260928160615.72A0D1F000FF@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928155351.3222=
978-1-cccccccccccc777777@gmail.com?part=3D4

