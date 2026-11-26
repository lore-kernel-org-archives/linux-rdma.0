Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795719889;
	b=e2MzqiH6LJgsu0dh9FdP5KHLO76nq1pRlZ1AKRpCxQlPiz9y4k4mJEuagoUURpjP5B08
	 Vq5ljsT3IQgzZFrktNbnSbuqdfw47Z85jKzjZmiV+rJ84FzapM3JDJGGMdPP0u+PzSLVS
	 qlIhGaABtvUMpYnoD58HuNodgjJuXD4g3192h1dZcckD69AUVGA2QlMMUHNFCArQexBtv
	 XWEkPhGyWf4FGFDlZvJly50qkyACNgY7uInafo54iYKchfWvn5x6s5XFooTJUag/DH8gx
	 Q6wLYgvzR4DpI+NXZ88GbUwj3LwxQ1BG6w2geUp77D0tA7v4t4h8SGoPsYjiJL4N6nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795719889;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=gF28vHrnh8ZwRND8/aIoTxqCgAhKnH2NDDLBNFP8OlQ=;
	b=v3NNp9ZmyCeM3g60vqVcPVUd0jbZq3530uLjkFx85/oMWGhRKhFeUy/0hlU0qD1amxLI
	 TBTxY9eKbyTSs0BhnKdID/1qBvJ7qgIVEDef7QMvvLaMoTn/N2sUnalDSNejmPGusaxYY
	 R56Tjzm4SZK47eCCEQYLlnizVDoqSBtUbP40JZ9KvKW093auOPYIVXKTUFtqeBUNBe6Vi
	 Eeeius+n9AADxGHlGz3gwLzOwC5muU+DLxXj1l7tIPvTRokmnscLLKEljMFS4+85Tx5pB
	 1fOWetJTSDorR7isNnirhiIuQrGbLZqoSVDxEmqFvmPK7q6Lk3PURCzm+uvawYsE4bA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Gjbe9RD3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27A4606A31C
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 19:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Gjbe9RD3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706061F000D8;
	Thu, 26 Nov 2026 19:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795719888;
	bh=gF28vHrnh8ZwRND8/aIoTxqCgAhKnH2NDDLBNFP8OlQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Gjbe9RD3cbd8qpKPGpZ15oxNgpv1hVfpfUs17rfRbRAjip8xnkkc8ALotflhH3GfO
	 FVuv9OZ7oplW7V+QXrb965V4CDKtV1kYOozA0d3wAPlp50yDZGIPEb5QrgYWXUVzNr
	 EJEyBbez97ZDOrOkSHAmMcGmtZUq1Ni0wub3yYHb6wAnAyqZiPgUO2y0Ddjw+HcZrD
	 wXKRTjMFsHCR0xWzdiW+rVBrZ6Zyn30GPKdMUFYDkp56zoWnrIl4L9Y3HcmLYObPgr
	 V9dCAFP36NZQhesIzmNH+EEw96CbyA9IzwRofgBB3OXpgKGGvlg3iWTBZiiSqz9q81
	 yGyXUsPuOgS1w==
Message-ID: <sashiko-outbox-236048@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 1/2] RDMA/irdma: Wait for all refs to drop
 when destroying RoCE QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jacob Moroni" <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261126185344.2784303-1-jmoroni@google.com>
References: <20261126185344.2784303-1-jmoroni@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 19:04:46 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Sashiko has finished reviewing this 2-patch series:

- Patch 2: no issues found.
- Patch 1 ("RDMA/irdma: Wait for all refs to drop when destroyin..."): 1
  related pre-existing bug noted

A detailed review has been sent as a separate reply to patch 1.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126185344.2784=
303-1-jmoroni@google.com
