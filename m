Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C123831813A;
	Fri, 11 Sep 2026 09:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789119021; cv=none; b=k/4nG+396TFIldnIZv2EInF0ZKgiSmrEtZYOiv/FDkJZIh/5MOWlt4i5Mt0QNGZAdKhgSYZG8hSDmDKI691FcgvsMOhmt9niL3cK9B8SJ9Di6FSPdb8Df5hNTJyeX0kPd5t8Rl1bTWnkfikRw/1CNLsHWwiqI04bI3b164b5mwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789119021; c=relaxed/simple;
	bh=A4jHQyG+J5MNMZAQ+kcZeJlChlaoUikTEw/M8iWLf04=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LJtQYA0NCRhZtP0Y6nJ6ua3tUdXh8d8mvcBCID/MYzF2axhQbWTXt3PcnjB6Xeow58eQaESCaOtHugbd9BLdea8vPLKSIg4OJeyOKd/7wHXbqJsx03sVYpb6DdZc2O2+7ovHHHgA6w/OSqkPQz04mWzF4WI3UVeVwwZLQ6RhYCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=auET5Cph; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="auET5Cph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF0DD1F000FF;
	Fri, 11 Sep 2026 09:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789119020;
	bh=257SyGpWSl86iSkOsMsalhTeekXSon4AlW4qmeMth+U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=auET5CphIGflFGWOv0x1PwOrIbhJUYwjHbW264VdC3Op1rpfYDYjHRNjJ+Y5SwMjJ
	 PcXc30BG692ov85E0okEDaXrqPMId3tcEkDmfpEWIndXGQKjlW1oYC34GciA5cXQN0
	 CL6B+SUSuoAA0OoYpeoM9R1Wnj1GKBAs4+dk0gEbcBoSBiLlfSuwtnDGUBZc+yc0+1
	 xcwKc0VFNMEja/Gf0c15SmRiah+Qg/68LRTca14IZQf35rTtQ0ru/ZpNvEOcjTt6mB
	 QqOtD6l33LPrY461kc1t7CFju9ii1hFC1yw7VVdI0QvuUgROf2ZD8v0maSv+4Z76Uo
	 Tcuktgm2N85jQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v4] net/smc: fix lgr/lnk lifetime vs diag reader
 race
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mahanta Jambigi" <mjambigi@linux.ibm.com>
Cc: "Heiko Carstens" <hca@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20260911090906.1949163-1-mjambigi@linux.ibm.com>
References: <20260911090906.1949163-1-mjambigi@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 09:30:19 +0000
Message-Id: <20260911093019.EF0DD1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The diag dump walks the socket hash table under a read_lock and dereferen=
ces
> conn->lgr and conn->lnk.  Two terminal teardown paths drop those referenc=
es via
> smc_conn_free() while the socket is still hashed:
>=20
>   - smc_conn_kill() -> smc_close_active_abort() -> smc_conn_free()
>   - smc_close_passive_work() -> smc_conn_free()
>=20
> This allows the diag reader to dereference a freed lgr or lnk.
>=20
> Fix it by unhashing the socket before smc_conn_free() is called at each o=
f these
> two sites.  Any socket visible to the diag reader under the hash read_loc=
k then
> has valid conn->lgr and conn->lnk pointers.
>=20
> Fixes: f16a7dd5cf27 ("smc: netlink interface for SMC sockets")
> Fixes: 9dbe086c69b8 ("net/smc: fix invalid link access in dumping SMC-R c=
onnections")
> Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260911090906.1949=
163-1-mjambigi@linux.ibm.com?part=3D1

