Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24443B71A1;
	Mon, 28 Sep 2026 06:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790577464; cv=none; b=hW+DSoj89tTuyZwYraGbUbFlzXuujyi28cCC/DYTMmsQ9NKpgZ4h8Fys/V1gC992d0N8eTAoyJrfDhIkGdmvSMoDdHtyJnfTp6l5lciNVFHIFGVA+BUJ6RowFUuIsklZeq5U+UscEHT0DHS5dcYJSBpjBM2hnyyXy1xPym+wnhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790577464; c=relaxed/simple;
	bh=QOD8mxL7DyzRF5uiE6/b+pA7F8DuntngZZY3ZhgQsQc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=W16YTFrO5wcb9TRd8Qm54aGw5jaNtriJ9VWhFeIVp7APaWSRV0Kfgt4B1Xs88HFVG6Pn9Kb2sUfMd0a88RLfeI0P1KzrUdZ2FpzsOcubttnEMYeU/RuO2+y7r2zkbZY/ZaUu3s8vjS8vynNzSaKQ03GLbBh8jTRD3Xzwa49I46o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N8cKlex6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N8cKlex6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CAED1F000FF;
	Mon, 28 Sep 2026 06:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790577462;
	bh=TwLqhAdic8fJ12E+xK0RgeZoGc+FonzD5KkNglfWuH8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=N8cKlex6TYI6YZCkwLmqwVEiLtaaUnAmy9wrTjmWwzqvCb2GKZUh1QRWqX3rd6A+j
	 6z7XFAIwZSx260XPhXvC6YSEnC15OlaZIp017orsSWtPSgREL8Vv6ThH88mJ2zXXXU
	 FyFJDQbtoPTOuTVuO6bmopBiRWUQEAyuiwC5TYwiOgcIPPhN6Wt3GVlBfDugoqAsBE
	 K1BppnBYiMZID1OukdD7C63JiNPwCVQadoELhV1vPrKqGwH+mabwWfApZwAxs08YcN
	 IGnnUJQSeV98zKfHBE0S0wXA5Po1+ftoeWC9HYeR6kqks2xrcpZ5yAiY0SfpUE6ELD
	 llQDer8kKEezA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] net/smc: hold a reference on net_device returned by
 pnet_find_base_ndev()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Atharva Vartak" <atharva.a.vartak@gmail.com>
Cc: "Heiko Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <6aba080c.b933486d.297b72.5042@mx.google.com>
References: <arn3qTu_SeM8Yrjj@1wt.eu>
 <6aba080c.b933486d.297b72.5042@mx.google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 06:37:41 +0000
Message-Id: <20260928063742.6CAED1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> pnet_find_base_ndev() resolves the base net_device for stacked devices
> under RTNL, then drops the lock and returns the raw pointer without
> taking a reference.  All three callers dereference the pointer after
> RTNL has been released, creating a use-after-free window if the device
> is concurrently unregistered.
>=20
> Take dev_hold() before dropping RTNL and add the matching dev_put() in
> every return path of the three callers:
>=20
>   - smc_pnet_add_eth()
>   - smc_pnet_find_roce_by_pnetid()
>   - smc_pnet_find_ism_by_pnetid()
>=20
> Fixes: 0afff91c6f5e ("net/smc: add pnetid support")
> Fixes: 1619f770589a ("net/smc: add pnetid support for SMC-D and ISM")
> Cc: "D. Wythe" <alibuda@linux.alibaba.com>
> Cc: Dust Li <dust.li@linux.alibaba.com>
> Cc: Sidraya Jayagond <sidraya@linux.ibm.com>
> Cc: Mahanta Jambigi <mjambigi@linux.ibm.com>
> Cc: Tony Lu <tonylu@linux.alibaba.com>
> Cc: Wen Gu <guwen@linux.alibaba.com>
> Cc: Willy Tarreau <w@1wt.eu>
> Cc: linux-rdma@vger.kernel.org
> Cc: linux-s390@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Atharva Vartak <atharva.a.vartak@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/6aba080c.b933486d.2=
97b72.5042@mx.google.com?part=3D1

