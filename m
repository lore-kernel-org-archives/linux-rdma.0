Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5EF4D17A0
	for <linux-rdma@vger.kernel.org>; Mon, 21 Sep 2026 22:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790028028; cv=none; b=QRmZofYHD1kPU4XQKu0iI6UaobUEhuk0LSVKdi8shSdLrk3AgdSbnErlpq9EmXO97V5RZxCKgCUPTMHItO4sdd6nuWNTDBCGw48DiI7KkCFOhKUUowY4LMdBBrH1IU2fOjwz+UbKxIknpcOQXP1y8zhl1YE9GTeTeFldyHtVELs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790028028; c=relaxed/simple;
	bh=oSEolsv5k1lDJHNqCVfhW58k54PYFKBhOJlziXd0XW8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=QD2/jQVgfPPf5tMVvPaHMvqKb/ieq+HS4V7SY2vUYnrUFds/sixqpIr7+vsXxVCLUbYz4KTmOxG/j/HLt55irFcaQuAKXLPBUdtXf3QBJeNNvTnzsKigpHR2HCXjBqJ4YvbyrTFE3rYd/+7px/g8JBOB1KaTMcjpM5tCoB9hmf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lD54f517; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lD54f517"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C151F000FF;
	Mon, 21 Sep 2026 22:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790028026;
	bh=eS5lHse8yaB2I0yYnINaEVbToZ1O9Rbb0i6M4GmetVg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lD54f517cUnYQdKFAb1HylK3i5edlntBCscgpfGsdbujfocKs3ao7mESzBvyFEguE
	 8HIoqXqKTBBSzpMPUbZQiIFloDdY2NTJ4hR2w1WRI+Va7rKp8iqkX+PE2mVGjeXOTh
	 3HjKtNDosmfLMedaHTfXfLZBFm7XlGlKZZMRd4Hs0/Q7Ss1Pq6zXuTlCb805Bu/JAw
	 7WSXHeNo5+xU8WGZCYODZwbY3AEqXdq7zKLdOFcf7/DIpbMAmmqUbxiiqcFuO97wmc
	 R4wmG4uAk/D3AW7vUMPAAl+C8MKQeN2XivgUqR9WbIeh/0mlWX5irXpDvxE0lvEqoo
	 UbzrTMAqUzIgA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/rds: include the scope id in the sendmsg
 connection cache check
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260921215046.174745-1-achender@kernel.org>
References: <20260921215046.174745-1-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 21 Sep 2026 22:00:26 +0000
Message-Id: <20260921220026.94C151F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> rds_sendmsg() reuses the connection cached in rs->rs_conn when its
> peer address and ToS match the request.  The interface index is part
> of a connection's identity as well: rds_conn_create_outgoing() passes
> the request's scope_id down as dev_if, and rds_conn_lookup() compares
> c_dev_if, so sends to the same link-local address through two
> interfaces are two different connections.  The cache-hit test never
> looked at it.
>=20
> A socket bound to a non-link-local address has rs_bound_scope_id 0,
> and the scope check at the top of rds_sendmsg() accepts any non-zero
> destination scope for such a socket.  So after a send to fe80::x%ifA,
> a send to fe80::x%ifB hits the cached ifA connection and the datagram
> leaves through ifA, to whichever peer answers to that address there.
>=20
> Compare c_dev_if with the request's scope_id in the cache test, so
> that such a send takes the lookup path and finds, or creates, the ifB
> connection.
>=20
> Fixes: 1e2b44e78eea ("rds: Enable RDS IPv6 support")
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260921215046.1747=
45-1-achender@kernel.org?part=3D1

