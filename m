Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794256243;
	b=i785F6ypltQJ92317avk34VoRcp47kV2qJMsWnYkn/0R5dO6xbduFMwexsVfjOnGBf1e
	 2kYeRd9CVWIsm7Ka+a+B6kj1XgEjAq4WU16riH8C/2kMLg0Se0Teh+0qHs+mvhmYCIxON
	 GsIf0FTnlcLmY+VHcYiHt7jKt00U8+yXev69CwrLFDro6w/F10n62XVnqJvVWW2W5rfkY
	 +9XmGeacDoFjdFbklYX5DUNaxMHg+Z8xKL1/rao+yfqCDhsMhbk/386LBLL6mHbmf9Z4g
	 N0EDauKIbtPwqCbxmGaVUDh2EyYXXo9GaTYj2Yf3DNCeuw5nmKC8KBJOuR55dwjEebA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794256243;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=wYtFFO6gDpiUjuLfnIwCHhE06a622gRrqJHr/ljdqes=;
	b=QS1IPzol34cpYo3HA2fvgTFh8BffKquVJXgrI0R4AB3ZrbIaci+Rqc4q+Avg496LfFvA
	 MCLV3Dq4rokbz9H9kJRU9x177WE7XJTGBpgMt7mTisaTwnEppo1ckRHIdoUNZa3SL32ir
	 JJY6BvwZDAMSjmvcuhKOh46SjAMNEBIUGU++rr/zoHb0MRpOgjcQHPXCykZPAylR/n8xg
	 cw6VyyQV94NKA67aKGuAJc7INnMIytiwFpkWIqwa1FXIEJJroOW6GDUyJkEAVmlFiZAcM
	 sutcuzEWgtOFh8cX/c2S4aXS2zyESII7QaQRY98QPAgmc10Hf7cgJnKMRcZH/jUFAXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FLZHvYQg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4EC7606A321
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 20:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FLZHvYQg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF051F0089F;
	Mon,  9 Nov 2026 20:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794256242;
	bh=wYtFFO6gDpiUjuLfnIwCHhE06a622gRrqJHr/ljdqes=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FLZHvYQgYtz+76z72UI2hDJsO3XOa6E2kX/Vh78GQ9Bcbe7ckCUnum3n7K6CqXCbg
	 MYCFMVb9Ktv8vg+bVrZr5Y9EC3eyqjFGDOUSthTWpZSI1u6QDGK6f496VUvGC9v4Oz
	 p/HUymFVrEsqDCUm7rdz3vLB27J0oJVgLgvjf/+Zhe8/FWf2xozVli/FMgH8U1XW2l
	 4cTgTPm/GuU3vKVzF1b8lJ1bDpXyX9gDAeiU7DULWojrhvCSWnDf/TyPUSS/S1sMVU
	 RlVRBgFKkN6A3q3XgEdHl4wUPXuFcSAH+GZJmGaIWIVNesdzNqmZnlKdUwpBZQjM5I
	 UbAFnqyevtVOg==
Message-ID: <sashiko-outbox-205584@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 2/2] RDMA/irdma: Drop unused SRQ table from
 resource memory
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jacob Moroni" <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261109202525.2937295-2-jmoroni@google.com>
References: <20261109202525.2937295-1-jmoroni@google.com>
 <20261109202525.2937295-2-jmoroni@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 20:30:42 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> irdma_calc_mem_rsrc_size() reserves room for max_srq SRQ pointers at
> the end of rf->mem_rsrc, but irdma_set_hw_rsrc() never sets up an SRQ
> table there and nothing uses that memory. SRQs are looked up through
> rf->srq_xa instead.
>=20
> Remove the reservation so the allocation only covers what
> irdma_set_hw_rsrc() actually carves out.
>=20
> Signed-off-by: Jacob Moroni <jmoroni@google.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109202525.2937=
295-1-jmoroni@google.com?part=3D2

