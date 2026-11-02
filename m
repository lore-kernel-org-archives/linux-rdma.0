Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793602489;
	b=afQudqvcB3zSZ+lHZqQn7iPWqzNCfpVUS9jcng7VY5kJv9UBI8odiX+gnzVOyRK/tCJK
	 GWr2PerAhGOIDAOZ0cbBYxFBJRWsxjmf2H+Jf40qCcUtG4RAXYUsrI+CRDuuKN2VFpW53
	 nTnDsaMJYhSp/7W2WI55XFZdHpUpk+B6u7jvZoTjd9S2A5t8UB3a7r8wyiYBCQhJu8HEM
	 8rQIIas8UI+U96y7guX/HtOrobKIMAkKD9PxTI3MW9O2bAr4ga706aRrzGMK9CfseKTaa
	 sfiSyMAKNhUdnqJprPvRL/LZxYoFiuTgEb/MLv/khczILLSP6N+Fs+Ls9Ie9UxtJt4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793602489;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=DXRKa9hHXxYCEV78BOW7LDiEWAgpljiTjN2BeB215dg=;
	b=qxAaD1q+ywpZ2Exhw4/ZtHPI6i6226WJkLWnBtRI7ehYelM2gitZNDSJdarXEeRW8Thf
	 ze98W3HSZVQav1UnIWBTRH7Kx4KwBHieHHMVi4VNME6P/jCikJsB4wETOZTUwUe/aUCVN
	 LLjh0uwlzF4VojRJZScxyr/nflOsxBUeoRTH2W93ndJyP/wKFjWDy2S2HckHg3oO4vyox
	 YraNYT1VEH5jIrCuKScwV5PFJ1IZSmum91N2XZmz3/JNK/eZh7xfX/nlIuVOYLtbOViKJ
	 +471IJeh6hJoc8gerjj9WXdXxUo+FFF3pDaReAL2A59lRQtj/jqsmeIMZ0ktTyHhsdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YM6tagxl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A64F606A324
	for <linux-rdma@vger.kernel.org>; Mon,  2 Nov 2026 06:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YM6tagxl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56BDC1F000C1;
	Mon,  2 Nov 2026 06:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793602489;
	bh=DXRKa9hHXxYCEV78BOW7LDiEWAgpljiTjN2BeB215dg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YM6tagxltfP+U0/w4sjJgIRSZGxyUL1+7Ku5200U4JypmmXJm3BX42D7y/QWTHLIG
	 Vtwre6jE+SgpRSMgArZuyTMD5ddrJXdWky7cyU5LGxdtPXcRhpMPqvCz7WEkItcHFR
	 +Sew/lUyHMgrawa2pp9feeWVh8SG0mGMfcOIJ5h17RkOBApw4wa10YLwS8Lxy8nkeP
	 1w+jYwQ1gibDaCdwayvxr6Ezt1eLdaFu2K1OoyiK0h5layI2vgilYr2u3YQh7yo5f2
	 yQhnxecvvHtfoCvfXC8nvnXBJTW/BPdYLWIATcIuP2RaDAMhR4+1/DxqzrzBtiOIpG
	 iogXINYf4Kkvg==
Message-ID: <sashiko-outbox-192980@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-rc] RDMA/siw: Fix use-after-free in
 siw_mem_id2obj()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Deep Shah" <deepshah146@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261102064437.23976-1-deepshah146@gmail.com>
References: <20261102064437.23976-1-deepshah146@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 06:54:48 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> siw_mem_id2obj() finds a siw_mem with xa_load() under rcu_read_lock()
> and then takes a reference with kref_get_unless_zero(). This is only
> safe if the object stays allocated until RCU readers are done with it.
> siw_free_mem() frees it with kfree() as soon as the last reference is
> dropped, so a lookup that races with the final put reads freed memory.
>=20
> This happens when an MR is deregistered while an incoming RDMA WRITE
> looks up its STag:
>=20
>   BUG: KASAN: slab-use-after-free in siw_mem_id2obj+0xe5/0x310
>   Read of size 4 at addr ff110001042aed88 by task repro-rcu2/90
>   Call Trace:
>    <IRQ>
>    siw_mem_id2obj+0xe5/0x310
>    siw_proc_write+0x282/0x430
> [ ... ]
> last put, since a failed lookup never touches it.
>=20
> Fixes: 2251334dcac9 ("rdma/siw: application buffer management")
> Cc: stable@vger.kernel.org
> Signed-off-by: Deep Shah <deepshah146@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102064437.2397=
6-1-deepshah146@gmail.com?part=3D1

