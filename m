Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794316263;
	b=phTSKAl62DteKhmZMxKE5y9/B4fR55fKM1KZQjFgEVBryIvTXkUHt7+m6rb6Z+rZRTSR
	 E3xeJMb7nX+uTjZw2Q1PNyy0zQp+aRTqOaj8WHPrsm0YshAH1LB/tecEpQnV6k/71EI1k
	 EoFJYdDgM8a0DvLBYYuZrRp2mhdFM3rP6BcmHR1fuxXSHiQEz1Yr06J8nHorBeOqT/lf5
	 jNZI9ZiA3pbR883jLLA/mUHPzKMi+j09o3fuLbGDVrSxspGAtSyEU2bkD5t1H9BjnDH2J
	 NoDHScv3Tb/+3mFylp6ZF/2bb8+VmdjdcG8FU3o4y62ctO5gu6hHJsrr398Xcbxks2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794316263;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=XPK6XZDKdlmoUng1lr7rfcFJroSBu0VuTuRFa347LDQ=;
	b=NalbaNnZuokMMne2r3u8CHWItYVfwwfPBcYZIMOddI0B0IQIDiHaUdwV3kUWTsru2jiI
	 lrXL6DTTHIG/RbNLBL/eQ4MM2cmI46Fp+0CTeaTTtQQvRs+yPd8XL/o9cf3+rnERTFG4t
	 v24AI3i6McrCK0Iu4QeSw1MIvVuOrBHgfMRuYi6n4J+RcYrJjI/fyw7inkbw9z2jS2x0X
	 I29ACy9uCVyZYDfB9xFvnmoTGa53Ml1r51jZSjsZ6blfAbvt6LaZGFfFl8pZu8wiAG2ve
	 YJcThLe6CtpN9STThdGAuWiiVeNpRDXw1LncMq2zzwgcsWyyzwPokSklbxbJ3y/Lz5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PhkeJbuy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89D4606A74C
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 13:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PhkeJbuy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797331F00902;
	Tue, 10 Nov 2026 13:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794316262;
	bh=XPK6XZDKdlmoUng1lr7rfcFJroSBu0VuTuRFa347LDQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PhkeJbuyqy/q2iRjZ/uV+gONqkyktRQA6YtxDxI0oQZDQLdS0yPlvEMpfURGAAo6d
	 /d91Slc1DqwLT35/SrfaQLqqELo+IRy7+O8bZeTTRAIYwsP4DXdbbkCGvDImFH/Tfe
	 vTrOZYA8BzQxnGvcU9eeFGec7iUeDheAJ8vg/B+vtE5k8u1pApFSrUDrwGuQFt+STP
	 B3TEl3t+arEyra0ioW4xuynGLLAKGpiPXWBl73FCxHxnp7qQgTFkcGIwI1Zyrs/Q73
	 nviZXMzJ8CHb/P6P9kLCptKAjmsaYQ3hnPeNH5hfFUDgTkmFDxQmok9OeEkYe4MEma
	 N7ywQVRr7PfDA==
Message-ID: <sashiko-outbox-207094@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 05/10] net/mlx5e: TC, reject a partial tunnel
 key with tunnel mapping
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandre Cassen" <acassen@corp.free.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261109131039.959438-6-acassen@corp.free.fr>
References: <20261109131039.959438-1-acassen@corp.free.fr>
 <20261109131039.959438-6-acassen@corp.free.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 13:11:02 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Tunnel mapping stores the matched tunnel key. The metadata of a packet
> missing in hardware after a goto chain or a sample is restored from it.
> A partial enc_key_id mask would restore a wrong tunnel id. Flower is about
> to accept such masks.
>=20
> Tunnel options with a partial class or type are already rejected here.
> Rules without tunnel mapping keep working.
>=20
> Found by an AI code review agent while auditing the users of enc_key_id.
> Tested on ConnectX-7 with firmware 28.48.1000 in switchdev mode.
>=20
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109131039.9594=
38-1-acassen@corp.free.fr?part=3D5

