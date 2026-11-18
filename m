Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795002854;
	b=ebqwLaOuIbDoNVbfsjGI5/4jioMAWDStnHimT3xmeQqbg1ER0Sjl8sjFUbk/FDmWYIwF
	 VERpOmzrAmMFet6NYVmz6KvQYzW2STkZzId6rwNWgGJtek120MRKgthjAW41Gb4DzuRZs
	 OlEnJ+JnoLCRpidCcAWrtSZHkTKXlwhyiengszHxpsJmr4LkZ4IycqdbJpnFMgEN9dXhE
	 YFZAA2IkrviTKOJ6yyBaSvlrWk4BbZxJpXUGBsXz5fD6rFFR302BXcNWKjRiE7hvsL0At
	 7Zxar7i4AMGfmpc4NHFGaf3p3CA9iRHus1YEJPK4z0Z0/YdtHIkCJLg6NDSw+XQVBDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795002854;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=R7DWN5o1amXSL8aixU5UpeY45Z+myo+BkWnFHQbXsBY=;
	b=Ibemr1J7U0OaE5fLndzq7NE4Lhr/H47P31BvWsPKZ2bta1/cWU8oyyHIMRVBKLg87rBN
	 gD5ARj7QJEW3p1mU53MQaYLR3nY2dOPaiyOX7thZHDgv0It3whIMkh6GsXauCsshy/CwB
	 Taf1tK/5nePSFcXAUZKseRnQR1ho7U6LQnFgUr7cLeju0HKxPctPfV3m88xTO8KDXZWne
	 w7/WMBm4GvLJTxCgfi9y0hZl/YqEVDF1gu52qkX7F1VTHEqRj6M0nuWpI89YpmqaYF3bb
	 yqGkrVFRf1QJ5JWNwpfE5pjYcx/H4CP34oJ1qL8of9K1NwvqcTyJ3OYvZ9PhyJOKuBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DP8ynbj7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE06606A320
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 11:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DP8ynbj7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88B61F000C4;
	Wed, 18 Nov 2026 11:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795002854;
	bh=R7DWN5o1amXSL8aixU5UpeY45Z+myo+BkWnFHQbXsBY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DP8ynbj7aiUqPN9dxFg/nqPVpYpdJtrJ8f7Zhk9S+5JQKAXB6+i6YlOvfjNCg00NP
	 6jOuWpsRy31uIqhEHKe6DUwhCjsOaDP3orBfmDwcrO2nmC7SbHyuEn1LiPTX9m2pRA
	 sOJHkfQmm3mYaJFc09YcHuMgzddnH69wvNIFcdpAf2Hc/uze+3FArLjDq22xYIRAjT
	 zfWuH0uudcCbsallmaEbW1rrN41I7woETSsVrdO9OM8QdO/XqfKlGhOtLNijRWpmjc
	 wlgccxxnIdIHvKUiCf2hl5rannLtvj47z34/AORk28gSp3WZ8iCWBSGURKbMxXLNk7
	 5Srg4X9WtmVHw==
Message-ID: <sashiko-outbox-220849@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/4] IB/isert: finish a Reject the target core
 allocated itself
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261118113905.2361969-4-yhlee@isslab.korea.ac.kr>
References: <20261118113905.2361969-1-yhlee@isslab.korea.ac.kr>
 <20261118113905.2361969-4-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 11:54:13 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118113905.2361=
969-1-yhlee@isslab.korea.ac.kr?part=3D3

