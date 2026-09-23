Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AEC444236B;
	Wed, 23 Sep 2026 06:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790144954; cv=none; b=lh2369hNR3Vzfls2x4YCxJMMa31qiInsZ6Ea0Hv+QuF8qBkexnCy8q8I8TYl9cSVPI5r1sAZlhbnHRKMMcgnK/2oJj1rfKSYuwh66lPIM7hJAIi62ziIF3sWFid2sRbXundvZeVyAh7tQcyNbSnnqvgjfVZMGCV8efGR8segerU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790144954; c=relaxed/simple;
	bh=IuttnzsKaQS8CV5aj/IjdcQ2CL0lhB357AN+0Js1XA8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=S52/tssP2OcW/j0J0YWahGKaByYZ1O7zYO9E35amdb8nlgDubGJNS5jNVeUFvNp4ugIAO1UrmVhwOmFr38SRkuwwrLB8eEZBlyWjOaP6kUv6sqE3jT+1pByVkK3mWn5e36d0DovascBeyw96bkx3jSmRClXLByN9oo/ot7BBxvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=drDpY/xY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="drDpY/xY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64BE31F000FF;
	Wed, 23 Sep 2026 06:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790144945;
	bh=40LYtqqV1Jk1rI/YmG0Vu0bWZqiu5pHds9xDq9NkaJk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=drDpY/xYpTLhKfxLHtDCRE1aJG/ND7XasChhF+rPZThS6Qbj9RwBsz6hdcs7KImOa
	 rqKsAYbS82qK+ZEz+iu1Sk910UJHgwy6wGw3mM8v78sCPstYdtUwrhVF4nY3L0hcGn
	 Y+v3+2Oiv7VhBLnPtdV3KUJbPiw/68o0aGqKbDcW0vwUzE6yxOwezVX3GNztuaCbsu
	 rgw8KHNE7WgDwskAax29dJ/s0Q92fo1oDrm1TLpOecgxeS9o34N90rbCOCCUJ1IZLf
	 HhHyldUo5RehEr6Hy/HdTnlozXwuxmCrFrA2E79HrNWEa5wJ9EajChTswkvpGAi01Y
	 Wcl5ljkWjcxNg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v5] net/smc: fix lgr/lnk lifetime vs diag reader
 race
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mahanta Jambigi" <mjambigi@linux.ibm.com>
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20260923061716.1970059-1-mjambigi@linux.ibm.com>
References: <20260923061716.1970059-1-mjambigi@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 06:29:04 +0000
Message-Id: <20260923062905.64BE31F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The diag dump walks the socket hash table under a read_lock and dereferen=
ces
> conn->lgr and conn->lnk. Two terminal teardown paths drop those reference=
s via
> smc_conn_free() while the socket is still hashed:
>=20
>   - smc_conn_kill() -> smc_close_active_abort() -> smc_conn_free()
>   - smc_close_passive_work() -> smc_conn_free()
>=20
> This allows the diag reader to dereference a freed lgr or lnk.
>=20
> Fix it by unhashing the socket before smc_conn_free() is called at the two
> terminal teardown sites in smc_close.c.
>=20
> Additionally, smc_conn_abort() calls smc_conn_free() during early handsha=
ke
> aborts while the socket remains hashed in SMC_INIT state. The
> smc_listen_out_err() path leaves the socket hashed in SMC_CLOSED state af=
ter
> smc_conn_abort() returns. Guard the conn/lgr/lnk inspection blocks in
> __smc_diag_dump() by skipping them when the socket is in SMC_INIT or SMC_=
CLOSED
> state.
>=20
> Fixes: f16a7dd5cf27 ("smc: netlink interface for SMC sockets")
> Fixes: 9dbe086c69b8 ("net/smc: fix invalid link access in dumping SMC-R c=
onnections")
> Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260923061716.1970=
059-1-mjambigi@linux.ibm.com?part=3D1

