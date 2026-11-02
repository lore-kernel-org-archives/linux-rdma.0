Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793637753;
	b=aptjojZOWETxC5Jg0TNtg+VhSHnnFUh/+7uIYsa6qzdkeFHeR4I67/BZBOQOBgGucRhw
	 PSjLRZu1vTqcDhxhfnCqofdc6csARp2gX+4Y6HahB2svYDAQv6UjVuc+VkAuVvGI92cl2
	 zwefRx3/YV7MSl16cdd3VQZ44l14Q2W3NBm2lWSMa0M2+5AKkP1HYLyZ9iGWTdeO+8LFn
	 zXibzgHqmAWgmtE8JyOTRsasnQNLZ3RVFZsPMqywrujRgAYa4gu38cky5+IR9bvpKlxx1
	 VTOgf/kjXspNv6ZOhG4Lw/0Ua7FqJGVvlmfhQvY4yxrwaqMk20RocVDSCWeaH/H6mJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793637753;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ZlPwyHJBJNSNAECzJ8wQOO7bwkobhigiKt6c7wU9X9w=;
	b=BibamsfFKsTwt/xKvqe8EhGdztClQtAZ4qy0ds5ddN6PnhrY8+1+gufcGL5yd9Ag1xwg
	 0j6Xh2/VBIL/slWA8dNqq09LvVhHUwj8fki8cxALGERx2UrtCPBq8QaH+c5yG+F6dtsQS
	 IpiqYkUY+eqYQ9Pl9ORsQAFI10AwHOXOLqFW5067FbtZiRXDEcjnCyHpz36WFl+rI13zl
	 lbCU55UhMn/Fneg+S5GPUd65lL683eRZeKDwKUWjlVxEknag/FkrYEUNxTCaUq1iZkdTG
	 JjXDT8JGNyRh6sbh+Wu6Y1mi6Wi5XYx3+mxmTnF6J17tKKGGNYLFPntxMF2w0oNuv3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ftlkDh0g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B434760A1DAA
	for <linux-rdma@vger.kernel.org>; Mon,  2 Nov 2026 16:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ftlkDh0g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24EE01F00A1F;
	Mon,  2 Nov 2026 16:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793637752;
	bh=ZlPwyHJBJNSNAECzJ8wQOO7bwkobhigiKt6c7wU9X9w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ftlkDh0gnIFhjlJ1pOMn5d7L0S4bzgca3aiUf7J1bMVnjkh6/v7VuS698enfjzAQO
	 jYAB3XFbLLCoDK8WbMb4LdrQXVKEmwb+WmSD6DrYtZcl5TKm2RR5y9TY5dtBEES+T4
	 0Dw0JpWjJpJt1fbi2RfvaU1tWSB0VOxseyEcSQ/vMO1fU4BhBDw3+8RUo2x6B0hlR0
	 q436v4nnk5U+HfdVk8JCbvXlUCx65UZJSVF/sj7M6EIV4YtfdyeBsjqD8FHaeguxQm
	 65T+4vSByscwtsacR3F9GQrItgM/8kGXv8zYWay7QHLYJpQWUElCDiQdCLZWcDbFYH
	 P7ajx7gztmaEw==
Message-ID: <sashiko-outbox-193763@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v7 7/9] RDMA/mana_ib: Poll RC completions
 using PSN and FSN progress
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261102162505.501853-8-kotaranov@linux.microsoft.com>
References: <20261102162505.501853-1-kotaranov@linux.microsoft.com>
 <20261102162505.501853-8-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 16:42:31 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Decode RC receive completions, armed-PSN notifications, and MMQ
> completions. Retire requester and MMQ shadow entries using their
> sequence numbers, honor cross-queue fence dependencies, and suppress
> successful WCs for unsignaled work requests.
>=20
> On an ARMED completion, rearm the next signal PSN to generate the next
> send CQE.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102162505.5018=
53-1-kotaranov@linux.microsoft.com?part=3D7

