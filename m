Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793705903;
	b=0DmX61CwV4dDrRsbU9sk0YASsDk7MfUQhsg8tyUucTaLA+L0R+DYh2QuYR/Sp9ZKZ9BL
	 LlvjNfAH1dFVYHhzsJoSFH2YhW7xFEDQpPSsBHRbNHq7G2IuguOaf6qCApzDN5YRGIQIg
	 VI6m+Xrht1srzSndANc5aOrnuXeMs1wcEo3rbbDiCWnsDxYV9smNe9ih+P1pmzW8Z1Bq+
	 Wvdv0To1kh2r8a9vpDQ037uqhsKMD6Zb95DDWyKGlXxjkciqgLBqosp+Bp2FU7fpepINu
	 R6h+NAKydKNH1vSm+v9B/Hhm71BBHNlIouT7VS1CDcw1aelxBVEXLoERtSERFHM+c8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793705903;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Bc0wE0yNhYor1EoqyYYtCgSzXL0i4s1aSAwhuXBQ+zE=;
	b=B4JU14LBjYMz4f7CcdaLKK9XC2QXZ0pEP2QHIXtt7VDuFCu4N/d9L7y7L2SJKcZ86ZWf
	 8Iy7DwqutH1SnCYqmo3XI0YU69+glQglLUMQoFXank6jxiTc3r4aWiZyRmX+yeXnGaoZf
	 TYH+KX4oSfn0/nbFXfW2CTLJm33sTO/Q7ochmP6Ir/5Z3xySnVfQWLEakZuf2+vXerclL
	 GiEeidfbALHzMsf/RUAJzKxdbpYwhxB0reJy4fKg5uNUgFT1de+oO7pbnxzsOVQSaFnNm
	 W1V/nRLAOUl3MPsK1ZCNy6JOSNgqByF0d8A+x9xr11xDwN6QZ7DQEU7CpHe+SEsAoUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KUXeYPNY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09784606A32D
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 11:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KUXeYPNY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 790CA1F000C1;
	Tue,  3 Nov 2026 11:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793705902;
	bh=Bc0wE0yNhYor1EoqyYYtCgSzXL0i4s1aSAwhuXBQ+zE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KUXeYPNYKX/rcZMlre5uJnoFF+u6LJ+KVNOmbqawBy//9fTph029On6vw3Fqb42VD
	 kl5aP1OEXQkNZJR5BI86ibhRXi58S4m4sovMJj3uovHvVGMW7a0K+r2L+6AtBahUNN
	 ecmrW8MKDMQaYMVkA90TPmNFqX2WQs4x5Ue0mP1j4MROq6LqRWV7p9ICc/ND0zjU+c
	 tFAYWWYHkq5CDn5pK4Uw14ey4gpfMu2AFbKUkK4bLpkOMEKITuPKQQlYLTfdK/vsUY
	 XXMPqmyUIgsR0RjTloPaCy3cm4oIqKws+qE9V5ghwRySAPfMIVLYTsTHQlKh1V5/I5
	 He4i+QCxQcc0g==
Message-ID: <sashiko-outbox-195164@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v8 9/9] RDMA/mana_ib: Handle error CQEs for
 kernel QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103111729.729886-10-kotaranov@linux.microsoft.com>
References: <20261103111729.729886-1-kotaranov@linux.microsoft.com>
 <20261103111729.729886-10-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 11:38:17 +0000
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
> Decode hardware error CQEs and process them on the corresponding work
> queue. Complete the failing shadow entry with the vendor status from
> the CQE.
>=20
> Defer transitioning QPs to the ERR state so that the other work
> queues can be flushed. Complete software-flush setup even if the deferred
> ERR request fails, since the error CQE already guarantees whole QP
> shutdown.
>=20
> Clear pending CQEs for a kernel QP after a hardware RESET by setting
> their QIDs to zero. Discard CQEs with a zero QID.
>=20
> Mark deferred errors as pending when scheduling work to prevent stale
> work from moving a reset and reused QP to ERR.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103111729.7298=
86-1-kotaranov@linux.microsoft.com?part=3D9

