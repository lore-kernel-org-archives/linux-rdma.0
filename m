Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792861016;
	b=bldmhaDNqLPBaltaZsFYu49EjiPhFbSMxxXoJjbjnVpF2mLSyencuJlCQTyOWwGfL6ll
	 skPo89M7YhMFtJbjN8DvoMpisjua/e4dSfgvPFsTzrWHh4/mQc+KqvMfFnIXOBdN4P5zG
	 RTynPqPks929FVadecPEDstcwVncvj5kBqCowPnwSf3EDZrXxSGAlJDvTBLc0rIdE6vWN
	 yD3lhbimRiBIww+nrQi/1POJSxV/BIxUDix+Ln9Ptwf8s3xkZFvOYwKvxczw6k+vLEM/a
	 ARxQwX8ng/5SU2rZpBrPbkTxxPFMGG/YQtHn/zzHd62XUPgqPyEJPyGHIakPBPAZGhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792861016;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=23+8+DGgUhyfM88PorNgs8cZQoSX3G9gw183fORiYXo=;
	b=24fi6E83H0GG0aIa8LIvVfFVv5lFwElC90Kjr+p+cQItjXGOI0g/Gf4Ry5QEckJ+SVXc
	 lS4gBZAeca+F0R1O3fAjIfhvt4n3mJvz7Kvkd2Em6dCWZu/oS9LkYo6Yvd21GXvZV47g7
	 yPgDierz2GV70oxmnPWvV0h1vL4eQ44mocWRUZJUZajMSLu6BlknWjacuq9Bj0KOB2/PI
	 H12d55Ex3swYP89F60iIVeAdNE5eJuUHvY13zGPCQlnESomcOksbIdirmedcB7EDL9H1G
	 hEwfnnelDK7UNTef39OloOJz8bsmbum35FhmQJVCmBnd4wlDlsm8A4cwID4cOL6jxRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M5JZPA4e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09991606A31A
	for <linux-rdma@vger.kernel.org>; Sat, 24 Oct 2026 16:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M5JZPA4e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8781F01825;
	Sat, 24 Oct 2026 16:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792861015;
	bh=23+8+DGgUhyfM88PorNgs8cZQoSX3G9gw183fORiYXo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M5JZPA4eH6O9heXCOdgipBbG0UxZXv6Jcf6yvg9Cw21ijNAXN1O7lI4KSdc/goddJ
	 c29HbTUc40wyot2vPuJPFEA4mbvXLSsUdC3+lbZxzTKCgncT/wIr33zb2vtId8ZpeG
	 AnIaBaxBuWUuTb95uQXFzGGZDEnfW7N7cZStlLJJcXrpTkJ+l/HuKn8VPtODmMExZ/
	 MF2Maidi9Uf2YuqiPN3VLYsc/G9fiShB4bB8CmLsu/w1p85wFxTMJ6YIEoe4wtXqS9
	 r7XO5eUmeFk1+tcbG5+Z8i1JW1KWf6f5GleB60IxU01wG/+U4V9x5GhIr5mg7UI0AD
	 weYduH+tXabgA==
Message-ID: <sashiko-outbox-183807@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 2/2] RDMA/srpt: widen the indirect RDMA context
 counters
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261024162852.3528224-3-yhlee@isslab.korea.ac.kr>
References: <20261024162852.3528224-1-yhlee@isslab.korea.ac.kr>
 <20261024162852.3528224-3-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 24 Oct 2026 16:56:55 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> srpt_send_ioctx::n_rdma and ::n_rw_ctx are u8, and neither of the values
> stored in them is bounded by 255.
>=20
> n_rw_ctx counts the INDIRECT descriptors a command carries, and the count
> guard in srpt_get_desc_tbl() admits data_out_desc_cnt plus
> data_in_desc_cnt, so up to 510. At 256 descriptors n_rw_ctx wraps to
> zero, and srpt_release_cmd() frees the contexts only when it is non-zero,
> so every scatterlist and RDMA context the command allocated leaks.
>=20
> n_rdma is not a descriptor count at all. It is the sum of the
> rdma_rw_ctx_init() return values, which is the number of work requests
> each context needs, accumulated by ioctx->n_rdma +=3D ret. A handful of
> descriptors for large transfers can pass 255 on their own, with no
> unusual descriptor count involved. A wrapped n_rdma is then handed to
> atomic_sub_return(ioctx->n_rdma, &ch->sq_wr_avail) and tested by
> WARN_ON(ioctx->n_rdma <=3D 0), so the send queue work request accounting
> drifts too.
>=20
> Make both counters int, the type the values they accumulate already have.
>=20
> Fixes: b99f8e4d7bcd ("IB/srpt: convert to the generic RDMA READ/WRITE API=
")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261024162852.3528=
224-1-yhlee@isslab.korea.ac.kr?part=3D2

