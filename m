Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794749565;
	b=wbNJx6QsxxBpt+GuVoFCoo5/qq93HE+Pnno51i1OO1Q1VRUt03CqNKPsc6VNWxRdXcov
	 DLt/eUFf2WYlNtzRQ3UoWl/gx8gnB8rcON+GtdL9ytb1h/kEccXiSVKRzYePd8dblyxaI
	 3UuPBuzbdSBFCUknhOfhweEDnq/tXCWfwPSFFZ7NC7WalmBirGVvZichijx6TIbplP+3B
	 i8sgicNNa4xiBCSKFEhkRqjcHSln8aafAWrCx/ACUZHqhm+fukxZm0Ny0RVnDpzjESbZR
	 BGW/mvoTWKxeTXxdiFgvTlgbFLo8zCInzzDfzkNgxv6JQ6Txufgd0yJj/boAUMa59ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794749565;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=EJQ4CZW6XmCq709SJmqKZLYHdqap7mstK/Uro8YWrmM=;
	b=m+1TstSVNEYWuJEbycx3i0SQ6evaHMAdLtVKB5phErYAwXCRLnqae5wM6F9sdr3QV94c
	 VVIC99YgOuOnrUQoBzowr4U7qaFrF0P7xPiYczaiFtmfd67lbhtp5eb7IynyryrtyY92o
	 K355Pj6eEIfWQmUeA872KAPJM/4eRrMmiv/rl7ljlPcPFhHgttIRlqxf8bDWV39Vq6VQY
	 h6MXyYz3lPkn9/psyY0w+jVrwBmAd+yusKgtjd8GxlE/dVUYr1vstK65RuCaFsN1ylw4y
	 glomjnWZWgB7A3q6kkmhLaLCyGSaQCy1B05unLsNOOWJnjAB0jAEPiUwoLe02zvhEBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oqxif4Qb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71CF606A886
	for <linux-rdma@vger.kernel.org>; Sun, 15 Nov 2026 13:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oqxif4Qb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BFF71F000CD;
	Sun, 15 Nov 2026 13:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794749565;
	bh=EJQ4CZW6XmCq709SJmqKZLYHdqap7mstK/Uro8YWrmM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oqxif4QbxsmBBQ8Z/0hK5RkLUhWB5DMpdUCmr84FK/CzyZ9SvWB+Ayjhh10WspQm+
	 emKE259WgTWVNukXbNFaLBSadcBhvzaG9OCuW3IiuHyY+KyCLVjuOQ8u73rJkdpH5n
	 z0VqcSKGCVFxO/5HYHuvEDLACUGoigYh4YhGcEatZasR7+bGMo4ovvDxciblm5ZGCk
	 DbjxltlmIPxvXVvfzuBZM/eLTA94H+HXp1ddNpK+Ttoa2iXwrigsnHg1CTvMD2TRU7
	 vVKzrM6hfm84Bk6Om6AEOI7Mkf57NjDsPmBmibm5CZwIkTTXiWalpvWvCY4VzM0LZL
	 66la9rsgqakTQ==
Message-ID: <sashiko-outbox-215533@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 net-next 5/5] net/rds: remove dead sysctl
 declarations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Oleg Nesterov" <oleg@redhat.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <avmyxTOuUkKnOaM5@redhat.com>
References: <avmyxTOuUkKnOaM5@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 13:32:45 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Several sysctl variables are declared in ib.h and rds.h but are never
> defined or used; git-grep finds nothing.
>=20
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/avmymGvelu00X5EH@re=
dhat.com?part=3D5

