Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795094801;
	b=5hBJ8ckJ6EBN0L0YXs0XD+MH8tGwfKWVymm883dOjgZJmw4hDw1f4zmrKMKl0hn9O3BN
	 w+KgDK2OCJJs3E1DK0cCZvPagSNH0iQ2WADILs+ydIRmk9/8w0h4+6HE292lt3JF9D3FF
	 Otomko8QUJ9BY0qlZDk4axFJfOV0N3dBw0sbC2SLGFhYRHbDpknLlu6w8+W/UOhOijum5
	 93vw6YOMcO34ZYt6BF6sQERksmMJCdGivKsR9UDNndnsxD+gyDK+3QdRdlhkK6OZfrxZ+
	 dFFDXMg3HsfQ5eEgLarssg86K26XScrVSAajVqrZsUWi3dK2gKluGmvNIXOPqcJV5nA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795094801;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=wtSoffIMLiTVsnz72g0JyIfkR3tG8kVimkrJAVZPoJA=;
	b=gdTf7QHxhIYDwBC4ovnjCmn+ntuPszCWmi2zqK6sx3g1AVS4oGyu7nsyrLGB1NKPRtIj
	 iPi6Kes2nZzQVXRYm8eMTwohYtckT4HYnEqbx2SEHXxtxO1sQy67CxCThYqZmPV9blJzB
	 po3JaFFc1yT8BRFhTl2S/rAtS/3cXQ9KwhGv8v23/apZEXyJBMIJdralisfAHNsh3GL70
	 trvdVcxjQAqENxUAfSPKfa/V70H/ePztsVW/TqM1YmCUGcgc3JlrZLsvTHGoS0vuU3UD4
	 Odc4mYQkHa8hYAz6x23sIp6kBlxx41JmVojZ2v8wu3hlkGjhcpX4zEXlsZPukWsljSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OAx1Bq1u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0921606A320
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 13:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OAx1Bq1u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 580571F000C5;
	Thu, 19 Nov 2026 13:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795094800;
	bh=wtSoffIMLiTVsnz72g0JyIfkR3tG8kVimkrJAVZPoJA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OAx1Bq1uT1uc2DDfXoITbq6pnuo6uJ3zfnOnzWhsJ0iG3O6n6QnLsDKTTrrrjJDpI
	 HusYwvyANB6Mju+M+RtnVVieTaAiFWKQZ6W9eMkuQ07+baLqiOptje5nVqPH7BHjQq
	 mMqWMx6ZBEb46UsSjwxUmccN66dQIEjfnr83yJ+cBXDAe1S/3ZbBy4E4Guo6Veksyv
	 /2rcSGWrCptRQdz0j+K+rmxFqXIlY7E8yp+KW03tXyAkE1NawTXVys1DvKCtASmg5b
	 uFqGYAcneGmpJ0T+n1k9zNZ8lO1wtnksY6+AaoNk2kSaZ4fOvyi2Fb9FrPRd+NYoi2
	 Dr0PxIOwVjY3w==
Message-ID: <sashiko-outbox-223173@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 3/4] IB/isert: finish a Reject the target core
 allocated itself
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261119131700.2722108-4-yhlee@isslab.korea.ac.kr>
References: <20261119131700.2722108-1-yhlee@isslab.korea.ac.kr>
 <20261119131700.2722108-4-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 13:26:39 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119131700.2722=
108-1-yhlee@isslab.korea.ac.kr?part=3D3

