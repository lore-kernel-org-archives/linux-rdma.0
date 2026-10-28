Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793172081;
	b=HAavG2p2P1Ci96VAR+Gi6KiH7I1QBUUFtd6F/UAm/PP6pX4U4G/0nvwWFHIQ1KmD2i+j
	 qdzr+Zj+O3JNrGr21T0bpzknmpnjuKYZ9VjoYoqbkLLmhr2XI+BsbfeqzYvrqSdFqZoBJ
	 k1VH5ZYEzKsrIiCizMQ1dD6vAUpFbGr4W4Ux+w2k/ARoOzljNWxRsHCgoqttsbhnxdYNp
	 B0aPMYfzF5bm98HSoUNc4uR/L3QNPmYb1mHphHoDf2kiThxQRM3y6gW6ZC5yVg5oVG7GS
	 PcU2xF+PAFi/V/3SqwMSSGLZxRsZx1hF+g6d8Z1dsUw9zR5zgmoD95K5v7fguqYUa2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793172081;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=qd9kn0TUz3ScHa8C2ONZDnL0z3Cv/bz1zoYGOXY7NMk=;
	b=LZVFqhiOKvcuxb6U/dce9DInApY0wNbh1g59xe/kDiP+GSRHhc5jOI9004SRMByWS9wX
	 b2uq6IODPkuUlfkjqRz3tydreI9jeXyKwwjBRBj29qF2qqTmijP7B1I5K8MCosW39tT1N
	 xBbt9hMOggR1V4bFpPSWmQ/k8E+2XvxMQY2Amc2hdFdJvhLCCwZwb2NAtT0QcupJHs/VS
	 0bZQeQ01jkAeq3XGyvTFV2Z4J2Ll9N4+yoe+jZ4DRuZ3giCDhDh6HSM5cmz8EXmLMm98/
	 RBBp44lHWLCy9odQqMhb/0+/Bllid/2VUEM5eX1XDemoe6PR/G/qRK+iJKIfe+JN1Iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dzEniKu5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481F4606A31A;
	Wed, 28 Oct 2026 07:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dzEniKu5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 902481F01825;
	Wed, 28 Oct 2026 07:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793172080;
	bh=qd9kn0TUz3ScHa8C2ONZDnL0z3Cv/bz1zoYGOXY7NMk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dzEniKu5NzA4a+iPWbmu0v1nWstrl5xGOGs6b2Fhfn0t5tYzoMZ5uMYV5PJ6CQU2V
	 2+KVfwC7rBsZuZ2m6lyG2oxPcL0nRW6gS8WfHMvmxQAkN55+IqgXo6CQeo+xkkR6JW
	 Gfst33IYpu2zVc4qgh7vTO2K8/9dYjGxHXxVURogpK8uUN+gPNtiZTXQQWG/gjIiEt
	 CR66MaI1yBupXS+b12MYq7QILJ406D+SO7FT9bGwVqeQ4Amsj73tFsjdHz8LnfNNiv
	 yuCTvJDG4b0r68pUeD8b5XjkLsz9l8sJ79aNQBWYiUUxcGkyM4AC8l2Hg5H39JWQaJ
	 6hSYW2D5zBtMQ==
Message-ID: <sashiko-outbox-187575@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v14] net/smc: fix lgr/lnk lifetime vs diag reader
 race
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mahanta Jambigi" <mjambigi@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261028070210.1685136-1-mjambigi@linux.ibm.com>
References: <20261028070210.1685136-1-mjambigi@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 07:21:20 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> The diag dump walks the socket hash table under a read_lock and
> dereferences conn->lgr and conn->lnk. Four paths expose a window where a
> hashed socket has freed or partially freed conn/lgr/lnk state.
>=20
> First, smc_conn_abort() calls smc_conn_free() during early handshake
> aborts while the socket is still hashed in SMC_INIT, synchronously
> freeing the lgr on the smc_lgr_cleanup_early() path without holding the
> hash write_lock. A concurrent diag reader can load a non-NULL conn->lgr
> and dereference lgr->is_smcd after the kfree. Skip the connection, link
> group and DMB attributes in __smc_diag_dump() for sockets in SMC_INIT or
> SMC_CLOSED, and for sockets that have fallen back to TCP, and do not
> look at conn->lgr to determine diag_mode in SMC_INIT or SMC_CLOSED.
>=20
> This changes the sock_diag output for such sockets. SMC_DIAG_CONNINFO,
> SMC_DIAG_LGRINFO and SMC_DIAG_DMBINFO are not read while a socket is in
> [ ... ]
> Fixes: f16a7dd5cf27 ("smc: netlink interface for SMC sockets")
> Fixes: 9dbe086c69b8 ("net/smc: fix invalid link access in dumping SMC-R c=
onnections")
> Fixes: ae2be35cbed2 ("net/smc: {at|de}tach sndbuf to peer DMB if supporte=
d")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028070210.1685=
136-1-mjambigi@linux.ibm.com?part=3D1

