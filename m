Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B4D4A1E0F
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 07:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792050394; cv=none; b=GRbQK4Vcjr6OCTr04qC5XtmMudcAV8NvLk7Vz7ZHWodpUJXQurW86SVsuthIxmV4RQ6mtqHSQaHd/w/72MOAFH7rakhneHZT9YHg7t7zSzNOLU9jXXHRWyCgpFZYH2dfCYBUqXpJ/m+ZljKI1TNI5N43acaO4FX6w5jAORgya18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792050394; c=relaxed/simple;
	bh=HQrJpwYraOdhK5sBrUeyeQjVXFUlvY3ZY64dDJeu6Ko=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=TLfJu/DSNbsWWmYoUhYXMRnVN9ykh1QljGRtOwEhHvDtA72iW3WH3Jy8Z2lStLJkPXSMickt+IPiAXiHMA89HEimLcY5h34TUdUpnW/iN4N5UaOtIJnQts2drmTtL//m5dJ9hXPTP2y4QwBWN4xRV2mHjXL45+pWr1k9Mrtn/u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JsQFCYyS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JsQFCYyS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 799C51F000C4;
	Thu, 15 Oct 2026 07:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792050390;
	bh=HQrJpwYraOdhK5sBrUeyeQjVXFUlvY3ZY64dDJeu6Ko=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JsQFCYySqUEpbLaHRK7YypPyQgl7nQVDLvp/eMt6XZYLXdr7dc8TvyaumP5kKGaEW
	 pswxBsYoouLdFz+ljznmK27ApvKuPZDwmPprJarCilIEX8Xrvil541vzkzOEsa/vQj
	 KMrIXW5govaizyd+G8CE913RBAyJSJQRbVL9VgFyLeiz5zgHZkUyv3ur7Aic0fhjV7
	 Z6ZvOzNZmrqV4+vVsNNgksQzyJILsftcybH52TzhI4yW59/L3jRgco3pAmJJA2EWtA
	 jB8csSK1b42177RvzZPU9KnBK4EO8hvaxipQEld1bApWrluRxI5N/B7IcmZ/IVuj3o
	 E4XGCJWX1klPQ==
Message-ID: <sashiko-outbox-172430@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx5: DPLL, fix fractional frequency offset
 scaling
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261015074035.1092340-1-tariqt@nvidia.com>
References: <20261015074035.1092340-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 07:46:30 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Carolina Jubran <cjubran@nvidia.com>
>=20
> The frequency_diff is reported by firmware in parts-per-trillion, which
> is exactly what the DPLL core now expects from the ffo_get callback.
>=20
> Commit bc443c253fcd ("dpll: expose fractional frequency offset in ppt")
> switched the callback contract to ppt but assumed frequency_diff was in
> ppm and scaled it by 1000000 to "convert" it. Since the value was
> already ppt, this makes both exported attributes wrong.
>=20
> Report frequency_diff as is and let the core divide it down for the
> legacy ppm attribute.
>=20
> Fixes: f035dca34ede ("net/mlx5: DPLL, Implement fractional frequency offs=
et get pin op")
> Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015074035.1092=
340-1-tariqt@nvidia.com?part=3D1

