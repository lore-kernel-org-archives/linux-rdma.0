Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795254173;
	b=AuUYQKQCEcUCPJ69E1d8d8zTLkpj67tK2Sk8e+p/BQgtZUdBcd7LfJsEhUr3lTiRgZ9t
	 QbQtPsXF+4JCiuFlWjYpPfKeVCrM3ZFCyTxUFoHLMo61VoRp0KMOyuMcdIMBgE2NareE+
	 8SXpCFQsZCBbrwOmcU87hEcKBDn8UDKKIldffHkqRl6x6rtNCJRdRaX+Lol6hTVgIX55a
	 7zwdoZiZpTSoCF9QqPe6tlrkHH0riMub6MtmDBs9S09+RFxn7QOs90l6jqbwdwDkNQeu5
	 baccZfJp2QJDVmBQp2hOU1d/qjh5cjK3D2oXTKRhpI2rMZDZo6JaLjNjfakzJCsafYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795254173;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=N5RJE5HkmyHFjUDTmkjuFdGukz1STmLW2GdRp/VuXfU=;
	b=xFk66Ib37yM5rZtsFATOf+dTc93DeXuaXm8NWRLcUTs6ir/IGLbj5PKamyMbNyJ6JIzf
	 8HpITTC9vkFLko/Vorr/GGEAmLLbqJ8f7pRepQYt/Ud7Cg5/bP78awAWyTQ2cL6OUJIM2
	 jEsyxxJlBeJIg4ntZE9tY9+WlDw48DTgAGi1YhvLk7tVQzyrb3Gf9T9Ewan7VBFLV8JQW
	 dj/S3hbpDHHQSN4qAraxz8IQEUDRXV4/7FQbz0mQXNvOHXdZZ6W0B1apDh48xpZJsf9Co
	 M6i62L33IHJBeeSzCzr7RgIalrBomVaqrjyS2tcJQpc/jpcpkz+WG6QGHrna0fkYCiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mOmVXe6b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE253606A320
	for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 09:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mOmVXe6b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79901F000E0;
	Sat, 21 Nov 2026 09:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795254173;
	bh=N5RJE5HkmyHFjUDTmkjuFdGukz1STmLW2GdRp/VuXfU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mOmVXe6bbxLK5/7Gt3UnpCTw8/WUZ/csXQdjO1m0xme2ojbsZjRhcp/OVxL2DuTzI
	 T/NTXos3Zym7sjp/LbWfjJ+UhOdSdimSaUaT+PigAiwGfEY8tK8tNgV4n4UceNCIHz
	 l7C5bP0hN1hfb/t/jyAIFmUVjRRCXDpwkVXjezePKA7F/crqblzhBfSuAYTWfqJsnJ
	 AIeW09ki9+J0sQQwhewhDayvLvHo3nMuzggwjqFmHsTpsdkrX2VEJgjlzi67jecjhl
	 I75yRiu9UxK4V8j9F2t/5Q94FO8UZpkktdEHTkwd6k74wQ+Lv1PDGU8C9RM5/4TJCo
	 AJ5jF6j7/+lFg==
Message-ID: <sashiko-outbox-226867@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] IB/hfi1: fix error paths in hfi1_mod_init()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wanhui Fu" <fuwh1120@163.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261121093901.427880-1-fuwh1120@163.com>
References: <20261121093901.427880-1-fuwh1120@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 09:42:53 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] IB/hfi1: missing Fixes: trailers on hfi1_mod_init() error-path
  leak fix
--

commit 02fcb0aee43546fd5e57fb0f21507c7ab7cce12f
Author: Wanhui Fu <fuwh1120@163.com>

> IB/hfi1: fix error paths in hfi1_mod_init()
>
> The error path in hfi1_mod_init() is not completed.
> Fix this by add some goto label.
>
> Signed-off-by: Wanhui Fu <fuwh1120@163.com>

[Severity: Low]
Since this fixes module-init error-path leaks introduced by d63730192f59
("IB/hfi1: Reserve and collapse CPU cores for contexts") and 48a615dc00ae
("IB/hfi1: Integrate OPFN into RC transactions"), should this include:

  Fixes: d63730192f59 ("IB/hfi1: Reserve and collapse CPU cores for context=
s")
  Fixes: 48a615dc00ae ("IB/hfi1: Integrate OPFN into RC transactions")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261121093901.4278=
80-1-fuwh1120@163.com?part=3D1
