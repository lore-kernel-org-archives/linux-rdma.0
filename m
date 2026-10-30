Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336066;
	b=Nboi+UzpaMh2WCApI4fWtUeww8EJ/XYZuOawbrbNT/zoOooVgxFMRG8CH/CcYXkPS16f
	 3bfNnjqj7l8A51E9bftMKs4zU/hkK82PP8ZN28Ax/F/2JbV5UShguI2CP+AZ1uc5ipb/G
	 m4FURtgPS3uMVjfM5R7L7Uw5UqtiKWeSnp9DDVdYwXEGo+0wfLQaKLkPedmMPoH0zI2KI
	 bOXgspnQdpNFZbudeJ+rONdaxKn7CQSK9xAKtyh1392E3gS9dUUdc8LYqPnh31Db4gKW0
	 ezyPd2C/K4ilLeTHLN1X1T44bY1mE9LAsyFZqv9TFnuGyqN7syE2LBymCr357G1KDEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336066;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=g1c6IcQQPGQFSwPJgucRRTLERkNpdaUioNqDYXsNS1U=;
	b=tohsoUvL1OBBNOVAqbqdpGXDcElpVfBAQVESb46gl81/bVLS2hBPLmreXncHYrX8vmgb
	 DysyUiJGThaSIToID9rapkCu37L2oaN4Ql9n19ZB5JiLWnAhG+S4EsN/GSjY3wxXCNjHB
	 FCyznL9cRkgfwVFrLDjlVNPSq1zjF3znau1Dc54H0106CCj3FaHyjhKzKy3qWawuyeTQ2
	 F0IKRPyX4O8IQy2rZeeYPojQWlmuUpaS8Rdj/tKc70QUrH/nw0B51Xuj+bWtEb88oWoBN
	 6cMwVnTM9kL9p4LPX7bwXui0UjvWbC2A1isX0Bb+5aq6JKrVJyA43I5bZRquG0+okaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="ekII7z/L";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B80F606A32C
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 04:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ekII7z/L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 208C81F00A02;
	Fri, 30 Oct 2026 04:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336066;
	bh=g1c6IcQQPGQFSwPJgucRRTLERkNpdaUioNqDYXsNS1U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ekII7z/LcfZWio6P8aPbAQ/L/kamRN+ZqsRFjKmVnxjdf86XbIgtdRW+tBMOBQEkN
	 Uhi0AA4iMYKFEmOshL62y9DjHTLbrAvW/aqADqYoCMnCiXp6ANYYAMTFH+1nPNmUtA
	 +4x4HmAuIk5OtKBqhL/Zffn9PCM53OxbzHroU1alY8bGtfTVbRl5rasbrap3Zz5amT
	 qSMi30CsY6KT1qNw2GXTZkdu0rG2j0fdNUYLntIBql0tmsW7RIrYpY8HGDVHh+kTMx
	 8Xubjz4IGg5Q9kBxDNTIT2Rz6EzY0FXqMsrfhdhlqDgyWQxgnVKhEwfFeTDtYz675+
	 Hch1ZL/V5HIAg==
Message-ID: <sashiko-outbox-190464@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [for-next v4 2/5] net: ionic: Add PHC state page for user space
 access
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abhijit Gangurde" <abhijit.gangurde@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260610154216.712374-3-abhijit.gangurde@amd.com>
References: <20260610154216.712374-3-abhijit.gangurde@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:54:25 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Add a page associated with the PHC that can be mapped to user space,
> allowing applications to access hardware timestamp information.
>=20
> In order to synchronize between kernel and user space, a sequence
> number is incremented at the beginning and end of each update.
> An odd number means the data is being updated while an even number
> means the update is complete. To guarantee that the data structure
> was accessed atomically, user space will:
>=20
> repeat:
>         seq1 =3D <read sequence>
>         goto <repeat> if odd
>         <read PHC state>
>         seq2 =3D <read sequence>
>         if seq1 !=3D seq2 goto repeat
>=20
> This mechanism acts as a guard against reading invalid state during
> concurrent updates.
>=20
> Co-developed-by: Allen Hubbe <allen.hubbe@amd.com>
> Signed-off-by: Allen Hubbe <allen.hubbe@amd.com>
> Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260610154216.7123=
74-1-abhijit.gangurde@amd.com?part=3D2

