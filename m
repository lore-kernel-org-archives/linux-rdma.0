Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037011;
	b=cAGl+lSwTavgFLz0dX8oa/zqI+MVFGM/UMipShnfjUlwic2oLdH7qFDNdezdG6KCknQa
	 Qg0Tv+AzKwsPNzHv58XRWaZ3Elgw8yKWZhPRJR47UbSeuYTxZbERSobMtGU5hK8HP74nh
	 g0nhPCOVaF+k8O49y/dQrRHfqTd5cXxsMyzUvQ3Uej1rV3IJYYiaCtLjKYDg0zpZp8RYX
	 HcTUNu1tL8uWX9Xr1Chc2Q+Pfc2sSQc3LiuXYrtJDJwXbmHMah8M5sC4CoVE/Cs+688IE
	 T1McmyZXTme3cylWdlS42zPrSnwhwtv/oQsG60Jl798mWKLx9qkFS6yG/9O8vk7lBNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037011;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=uEjXQ89Bg0272bIZVhZrdaYATf93HZP86cl2KFYwYHw=;
	b=L+Vrkf9bOHZ+4sscUKsNm70iDoHzdYdEwc1CNuD/BHRSQvsQrpEwgu8mjLl/Epnuc5YJ
	 5g1gFaKFhb6v0wnWt65Sp3z/tyObtvoE9JXIl5K7dIYoBvwCpVdkUiGH6+8ear8ap7Bzj
	 J6O/WgX/RhWtNhoHvVRyOuAmRk5TLsSqXs6Pu/6E5Z2yuMYIpBXi7tYMeIT1ytxbUsZ3a
	 5OjAF6A30H8mgiZ+nGyzRG697HRIiysOypLusxqCtNAHav1Q0H7NXt1uZRC18kjnei03w
	 SzZahEMveF8zA9ZN3lYckUx6kVoiEJkFNDcj/MEcQUSEr8VTiqr/AzJW9hf2FwwTMJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nvakCHYr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009EC606A325
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 21:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nvakCHYr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D12C1F000C5;
	Wed, 18 Nov 2026 21:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795037010;
	bh=uEjXQ89Bg0272bIZVhZrdaYATf93HZP86cl2KFYwYHw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nvakCHYrVuKmriReM/P/Nifcop3zvOy0FyyCr2oV5AeF+jFVxw3vTQ9Cuz8swImQj
	 /yPaiwYb7PplHcW0pvsYic+zvT/3dHgzfJj1Wa54FmZ3Nq44b74XOrYQPSZu1qF6/K
	 bx5359Qwhh0QXhAYl0UnJ868awNFEFaIGeTI03MsrFArQdHgcn34Tnea8Dkkxb27RF
	 O1WlXJ6iItfW+qB31LZWBoWwvGXB3LtzfTXCpagN39ndOj5ALECPtngdQwCE2aGdU7
	 N07Ndx63CNaeWoJvRCu64qbuOjdvTJ36dv2RdY6hcvgwIvVfsmweVhoEKYqVVrL6YK
	 JPYJcR0G7vfag==
Message-ID: <sashiko-outbox-221990@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 3/4] IB/isert: finish a Reject the target core
 allocated itself
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261118211503.2526705-4-yhlee@isslab.korea.ac.kr>
References: <20261118211503.2526705-1-yhlee@isslab.korea.ac.kr>
 <20261118211503.2526705-4-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 21:23:30 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> iscsit_add_reject() builds the Reject from a command of its own, with
> iscsit_allocate_cmd(), and iscsit_allocate_cmd() zeroes sizeof(struct
> iscsit_cmd) plus the transport's priv_size.  For iSER that zeroes struct
> isert_cmd too, so conn, iscsit_cmd and rx_desc are all NULL where
> isert_allocate_cmd() would have filled them in.  The command then reaches
> the tx thread like any other, and two things go wrong with it.
>=20
> isert_put_reject() hands the NULL descriptor to isert_post_recv(), which
> dereferences it.  One PDU after login is enough:
> iscsit_check_dataout_hdr() answers a Data-Out whose DataSegmentLength
> exceeds conn_ops->MaxXmitDataSegmentLength that way, and it does so
> before it looks the ITT up, so there is no SCSI command involved.  With
> TargetRecvDataSegmentLength negotiated down to 512 and one Data-Out
> declaring and carrying 1024 bytes, 5 boots out of 5:
>=20
> [ ... ]
>=20
> Link: https://lore.kernel.org/all/20220311175713.2344960-2-djeffery@redha=
t.com/
> Fixes: 4366b19ca5eb ("iser-target: Change the recv buffers posting logic")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118211503.2526=
705-1-yhlee@isslab.korea.ac.kr?part=3D3

