Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792929425;
	b=FXEXi40gxCCpPc5k/tIZhgajZkZbq57YGLrUw4TabB3mtpIy8bwwWO9RKotKBmyXO/V/
	 Ngy/iFzKWs8fvoTBl8N/gfshseFoXZtU1EQUrZqQExzcl0njmFy1axdZfuekeDT/8JSOr
	 XfU4E2khUwFrhmifZSV8tzphald1KImPxprNeQ8bWYdlG0C2UfTjC60dY3EOMbSAYfPBV
	 ipmmumSFE1mt+FD6dWF3gYwluhwQo86s7C9lP05HRGofmruWDAhqSkwy/w2BxgfiXNves
	 pzPe1MRikc3lCLNdy+XheCFDMQirrlbfRcVPdEhQ2F8COJ5K4ArxYcce4lkPP6NZBfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792929425;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=skWADfsGhEkhmSfF4DFrePkAr4mtDMESyqaoVeOwa5g=;
	b=Fxugpc9abLOBF4f5UgqUXqmQNfTAw3PWoCKBVOmwIIzhpPTnwUEDeIMAnu8uKj8Vu4et
	 KZYQ6qwH6g849h5tWRX3/JzPn7xXRbqnBF5sKjXzpjmGo8kwsc/zOskEgxQL/55r4aqwC
	 xPuIE0CsUEP+Rlq7cWcycG0ji7bNc+gQVfHXGGqs9yaHGaTleT+oty/nS/miUc0sCIpgw
	 8t9gl5qX4mjhJKiiFzHskJ5LSBy7LFGxL6BIij3ASAy59nl7CzCvm3jnyq3E7B0AHESp3
	 60ePDAzIdwuXQQbQwfOtGLkJe37zX747v+TvUu+wEP8r9skSO/DXAwN95EZCzPFNZ6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=naYBV3ad;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028E0606A31A
	for <linux-rdma@vger.kernel.org>; Sun, 25 Oct 2026 11:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=naYBV3ad
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813651F01825;
	Sun, 25 Oct 2026 11:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792929424;
	bh=skWADfsGhEkhmSfF4DFrePkAr4mtDMESyqaoVeOwa5g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=naYBV3adCLK1Doflxtfpk5N2ng5jR+GB3v5vF1ZKrFmZrVg+tKvv5I8P6J6Yxwfx2
	 MIq96lbby5VbLu6eoNc1rDWLEHMT6X55hImcf2rN5MASpH3EioghA45trY7PD1BfoL
	 S+/opDLNcw53huWA60krxAeWzstwEm0PsROoEH3fBJXPFecvlx1tkaO2cbnycoEA7i
	 duClTACwqUu3ADqikf7XVhFnQ4z3lZWz5BUJW+hr6/b2jin6KxPO68PYE3u4eU/Zr9
	 Arm5cRRtZC5H3Bq/kE1XbQ2mvsZLal2aXFvrxm2dAdIUyyOj5cGl43lFyP/NDjxATB
	 x90anKXfsA6Jw==
Message-ID: <sashiko-outbox-184199@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] RDMA/srp: drop a truncated SRP_RSP
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261025114155.4007867-3-yhlee@isslab.korea.ac.kr>
References: <20261025114155.4007867-1-yhlee@isslab.korea.ac.kr>
 <20261025114155.4007867-3-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 25 Oct 2026 11:57:04 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> srp_process_rsp() reads the whole 36 byte SRP_RSP header, the tag, the
> credit delta, the flags, the status, the residual counts and the two data
> lengths, without ever checking how many bytes the target actually sent.
> Its two siblings, srp_process_cred_req() and srp_process_aer_req(), both
> refuse a message shorter than their header.
>=20
> A short response therefore makes the initiator parse whatever the receive
> IU happened to hold from an earlier response, since the IUs are reused, a=
nd
> act on a stale tag, status and residual count.
>=20
> Refuse it the same way the siblings do. A conforming target always sends =
at
> least the header, because a response shorter than that carries no tag to
> complete a command with.
>=20
> Fixes: aef9ec39c47f ("IB: Add SCSI RDMA Protocol (SRP) initiator")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261025114155.4007=
867-1-yhlee@isslab.korea.ac.kr?part=3D2

