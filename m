Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795728092;
	b=DzEcPOQiGZN0SQ/iBFKJg8+irl08AzB4lrBTEzy3sWLaWfgA3YWeM1FskDGufpQuEmvt
	 WoncHmGI+Xim6r+ppWF8bYC/rcM2tImqpU34bA9owtg0o2t/0pemckMME7rgbXMQAewqb
	 ZCedCSLG+FIfFMaDhW1oPLnx3Dpr/FAXaGrEIr/5IyQzum9friz4PZqaHqJHDOyNLYpTu
	 8uwLEq8vnouu+UYvZDVMiHNlcmCcTb6CI3im+2jqcvF5Nq6lF7mOiAOVkO4XGdFwMxlhu
	 MF4sz91STsrI88yOd7Pg+4f+yIZ5lx6qmYAaVskpg3CBEVIh3oN0LwQm6zfff6LSjuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795728092;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=fdrni9Q7MVcGVnGqiWW4iN764WBp1fbLEJOpLdKbg7I=;
	b=H5YWFuVzlBvESn5ivCc2j7BDurJD0Oe1tHsD8fujbl9qwR573vhrJvKUFVnTwq7vQ48G
	 UlgqF12aFViWomS6joRDKaO+Zie9SgqJNluPihDHviyqM0RtDcUTp4Q5zsEYFUjhQmG2U
	 j663k7ePm631EQSWv5hPvTy1lI1tGl0OqVIy/5AM3EfceY1pn6BkIifqkpvD2kZPDxEzt
	 lsdmzYaMIhHnh0La0vLpRm/rbpN3aTZGrbf0moTOHYNlmJzGI47ek8JApwchHwQlMKgis
	 nis45JPzNOgyR7nszXl+HV7zjKuXItAB4GQbQXn6blxBXmgp6cQfwpZuSN2glOU+dKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kIEW+AtX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB786606A31C
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 21:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kIEW+AtX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C281F00896;
	Thu, 26 Nov 2026 21:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795728091;
	bh=fdrni9Q7MVcGVnGqiWW4iN764WBp1fbLEJOpLdKbg7I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kIEW+AtXy3uACrfcgs9fS6PJdMuHhMclGq8m0ZLc/3kTiZ5uEVvLZT3s6DN70T0cL
	 jfhaqjPdtREL/def4w3fJdb3oR7OQcNPj+Ykknak0wR9TlfMNOfaFm9iRKiox9R5Qs
	 l2jD8jx4zRjlnq3r4HBMagE9F7p/OrZw56EEIB6iuvoob2wjDC/7YQlCOkaIYcuuLo
	 +xul7jseS4S8d4nmwEO+7y0cCDuQpx828aaNCaaK3ny+mergvzxPPR7ViPqKVuwMkc
	 a0Vwqw4Fa1VVTK9XooBR34gTOgoE72ggehmfEvjcN1jHziwLI3YBiM+SXUkWiXi2Td
	 3eg6YdWDOkUfg==
Message-ID: <sashiko-outbox-236229@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 0/2] net/mlx5: Add controller number to SF and
 VF phys_port_name
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261125212032.243064-1-tariqt@nvidia.com>
References: <20261125212032.243064-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 21:21:31 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Sashiko has finished reviewing this 2-patch series:

- Patch 1: no issues found.
- Patch 2 ("net/mlx5: Add controller number for SF and ECVF phys..."): 5
  potential issues (5 Medium) and 1 related pre-existing bug

A detailed review has been sent as a separate reply to patch 2.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125212032.2430=
64-1-tariqt@nvidia.com
