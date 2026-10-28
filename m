Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793228261;
	b=GgottF6BQG6pRfqm4ye1iJeS+x59l+8yICWFJ+baki2V0KCpoB3FtSXI68xmBorE14gm
	 mypXod+V/ZPFImBnmnYgJgQl7sZH0LM8by7kn8QvdBJXimN0OH3zAyCbkAQ+3sxF8PgwJ
	 zJKouLKPh+avTmzLH3otqFWfY+uQ4GbBu8p/g1Lpj5rIwQSD2Jcn4SDY2D5KqSIFWpE8d
	 pyoPK96tOkTXZvQnK23YD1LtiHRVb1denDteIC9fWbGMlPaBaYn6lEdCatJnL/AXeHE3H
	 W2+eK08JnNtqkhZxtlSSxB1eFsUhgz8ppJt0kRni45oxOGNo0XjSzzT6h5MMRmGNcOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793228261;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=4VWNpwR37uhQq3f6cJYqlxMwxDhgPV2ouIP5BZGW4UA=;
	b=idQRG/y5c2Diq58GuFkCIj9ABmUsHo9jm8K3QtxwJC6z58UQabEMh/JCUrIao0zUS42F
	 ns3ys/xhRSe6tAFnjMu5YDYt0OO/sWKFtMzBiTMIKBR/hRxVSfdFeDa/HkOMce2TJ8SSS
	 vwA+G7f89H+MU1Dq5Q2kHImqsdaT3hTl/7PDVex5h9TtSnLOIz/m1+jH3B6an+lOF9EtG
	 /1jE8oAonGR16vx4Ki2bHkAiEde8zMgQQCW3ZBtVJ1kBsvBHPtDwSMNRSS3jnzBEsKJJZ
	 UyttBoySuzqjdD+NUGQVTZuONq0emE0w6dwlSDiql8N92IPaoMMhumQYP9yQNy74MVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NnuPstmT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E02E606A31A;
	Wed, 28 Oct 2026 22:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NnuPstmT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50CA71F01825;
	Wed, 28 Oct 2026 22:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793228260;
	bh=4VWNpwR37uhQq3f6cJYqlxMwxDhgPV2ouIP5BZGW4UA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NnuPstmT6IcbtPZyZWKmmt5+U/tHVFSqsN8x6rkL2kuRD7el0ISiuIanCbqNPI03p
	 AJPHflNTwSkD06MIEdGN10PeSRv2PWkSHlVRu9H0EdHu/FwQ4PfJzTaX8//A9+cgYq
	 S3WVyVMH6YdtSeUx+idu1wYA/DMbEcmb6R7lpsMSKrmx2eGPNQFQ8Rh1duXSMnC/Q0
	 eCAlwp0GfoJRxaf4NNRE1DGaGI1mHGsinK5RgOg1KQi1T8+v6fcLEx1OURnNNF3odf
	 HRyvxWxx07SRUxY1Q17TIn7/gWJn8GuO3EjO+Wio75isR744wNFccdDEu6QH3R1MGB
	 Ga2tVOaD45w8A==
Message-ID: <sashiko-outbox-188536@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/smc: fix limit_smc_hs sysctl on big-endian
 architecture
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fernando Fernandez Mancera" <fmancera@suse.de>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261028225350.3753-1-fmancera@suse.de>
References: <20261028225350.3753-1-fmancera@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 22:57:39 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> net->smc.limit_smc_hs is a bool, but its sysctl entry uses
> proc_dointvec_minmax() with .maxlen =3D sizeof(int), so the handler
> accesses four bytes at the address of a one-byte field.
>=20
> On little-endian this works with the extra bytes being written in struct
> padding. On big-endian (tested on s390x) the bool sits at the most
> significant byte of the int therefore the bool stays false and the "1"
> goes into padding. The sysctl reads back 1 but SMC sockets created
> afterwards see limit_smc_hs as disabled.
>=20
> Fix this by using proc_dobool() handler and adjust the maxlen to the
> right value.
>=20
> Fixes: f8406a2fd279 ("net/smc: add sysctl for smc_limit_hs")
> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028225350.3753=
-1-fmancera@suse.de?part=3D1

