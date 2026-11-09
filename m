Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794212341;
	b=ClAkFQ3+LnQHrUOFuJ+9aRS2BVWJVWujRIXlGrcdCtpqE/azbgXqCnVG2ApJ0WwHEKZc
	 xfIOYb7dtZ1eWPjsojy9P4xgOxMeVOi5OARPXG5QiN4btirGYbx5R+VUtppl8Tc+gjWoj
	 u5wDYbUaMkNVVYgFB92shGDcsF06GpHKuWhPNvcp1fq2d+GrBRXfHj7bSyNI0BGoxqNjN
	 fP38DVS7VKOPm90LNfEn/v5FNEgIs4A9DbYcbFg2/WhuFLh2+tmuzwjTvetXvDXzqQORs
	 XLKe7TyM2RWdbWbAHeagDCSTLTFsByopd6+d/TUinmsrANE6z5+J764j5Lif1ggWWiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794212341;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=aRzcpliqlj1KkBSuIYQ0msQiLTUuZuUMZHG3GhCxNi0=;
	b=JAp1UF0elIntfn1715NXy64CbRulzfZ6mdt0XSAMhVlbKLa/egFAr1rqk/4rTKun1ZTP
	 KxklastL28Ln06pX3dDLeeyvNyEyVYCvdPoDULFxOqCH6GyN1ppLh3Tt4FT9BwkFlykP3
	 dD/2OCq/wp7IBW4DL3bCDS9HolgR5NuHnfsYheE5KdIRRzSejhrq6zFlQw9aH4Jq90P5f
	 wdBxzRh4lpFJj77CSL1sjSKZMbObp1DpQRuggsRnLvHazWlprK+lsvolUsDBFjX3PKWju
	 4m1dWTEHXdb0nBiL7gPd2RPHh9AdvGscpd0ImSNuvuTkuB/awXHLpTd4WFq5pnfCN+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="ZvpNe/FI";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2BD606A336
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 08:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZvpNe/FI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0152C1F008A7;
	Mon,  9 Nov 2026 08:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794212341;
	bh=aRzcpliqlj1KkBSuIYQ0msQiLTUuZuUMZHG3GhCxNi0=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=ZvpNe/FI+S0UaOkUJDTx19ZI2ZF962KJX6gM+xDWDjjInYBPQZh0HzVyu1iYdlzz1
	 jN3ORLxaWTpOk+T5mjs9qGIiHC8qNupZCLpDkw33Un8uSZj+RLNI8ebfQ+Gyo7yDja
	 3J19/Op5X3vEz3l0D2akUAM554MukEAIWbcXowCyS/xsPwwPecdrfOCxzi0U8TT5Dn
	 5ivehvQr0cxuGHVGEoUqft41YVvQ+r8KdoRcvpduw/tR7HjzJkNnITSLMkEBequz6G
	 5X3sUZ6UIMeXSS+53DJdSsJP3xBPYyjJE62eSkW7fJrV+FtiKIQt2Of8ourf+YC7z1
	 aHL+HcoH617FQ==
Message-ID: <sashiko-outbox-204583@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-next 2/3] RDMA/efa: Report the admin RESOURCE_BUSY
 status as EBUSY
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ilia Kolominsky" <ikolomin@amazon.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261109081349.27316-3-ikolomin@amazon.com>
References: <20261109081349.27316-1-ikolomin@amazon.com>
 <20261109081349.27316-3-ikolomin@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 08:19:00 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> The device completes a command with RESOURCE_BUSY when the object it
> targets is still in use, for example a destroy of an object that other
> objects still reference. Map that status to EBUSY instead of the generic
> EINVAL so that callers can tell the two apart.
>=20
> Reviewed-by: Michael Margolin <mrgolin@amazon.com>
> Reviewed-by: Yonatan Nachum <ynachum@amazon.com>
> Signed-off-by: Ilia Kolominsky <ikolomin@amazon.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109081349.2731=
6-1-ikolomin@amazon.com?part=3D2

