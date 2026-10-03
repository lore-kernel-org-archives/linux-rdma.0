Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1580B3A1A23
	for <linux-rdma@vger.kernel.org>; Sat,  3 Oct 2026 17:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050186; cv=none; b=oAKZN7F6zTyUE1cKQlwLYazxAe4QDk2h7Q891bBJj6YPtRYtR2FaqE+P1NvhKb+ArTbGd9FVowVSpxn8aO0rASYbcuoYNGxlfJnYYg9SOkXYI+rgoi/eU8SgvBTV4f1YTPalTPnZM+J9Af3pPfK3Dhb0NVIzfE+yb7Ymy+RzQw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050186; c=relaxed/simple;
	bh=b4oF/idx65OlWpHajpetTuvfc3VvUfwehWiozmi46Gk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=IEknh7Hs4Ex+PNEb9y0GBf6ILo7AiyZIAKtcrbISn1DbkUajO6uvttzhE5sE1MyLTynXQQuDOpZomNuf13Di+A29PCeNvPbZHZft1ucG4YT+HL7bTBGlsji4rNpBZyAF/1T8odWXGOhtTNzx+2mH8AngDk2awZ6OdRG+d8wWWro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hWvt5fNP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hWvt5fNP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21781F0089E;
	Sat,  3 Oct 2026 17:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050185;
	bh=ZahGAUk5NLizcRLSE/C4pYXGqKwTo3ntRL+lDLacV2g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hWvt5fNPseXxtRy3PsI4jkAHf+h9xoC01V0o5e5t3hgU4579DgKKiyX4+tRlBehWF
	 c9zSGQlKvz8WmnGOJI2Zgi5kIXbOR+vRTFfZ2eEh2fiNtT2rNWDi1vwP1pc2wQygX9
	 DHSDjkYyltarPFqdYgTRUkdZgJdGsGmJPoqz4Q9qc30K/hVFIIMWkptz52Okhsta5y
	 HPI7tao0PjAk1hN+KF197qWTkVBG435eKsgqsFjPr9XYEEb7esQvf6oaRcd1leLlTq
	 Fyg2CM1uqzvDfVkNb3omPhkSUAZJ2oOj7g0D+HNOAz/x5MNtnfs3DMvYY10DpRgosP
	 E134vFo+Xxp0g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v8 07/13] net/rds: unlink transport nodes
 before a possibly deferred connection free
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261003163215.250253-8-achender@kernel.org>
References: <20261003163215.250253-1-achender@kernel.org>
 <20261003163215.250253-8-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:56:24 +0000
Message-Id: <20261003175624.D21781F0089E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The transport teardown helpers - rds_tcp_destroy_conns(),
> rds_tcp_kill_sock(), rds_ib_destroy_nodev_conns(), rds_loop_exit() and
> rds_loop_kill_conns() - gather the per-connection transport nodes onto
> a list head on their own stack and call rds_conn_destroy() for each.
> The node is unlinked much later, by the transport's conn_free():
> rds_tcp_conn_free() and rds_loop_conn_free() list_del() it, and
> rds_ib_conn_free() does so unconditionally.
>=20
> That is fine for as long as rds_conn_destroy() frees the connection
> before it returns, which is still the case at this point in the
> series: the initial reference is the only one.  The following patches
> hand out references that outlive the teardown loop - a socket's
> cached rs_conn, an inc parked on a receive queue - and with those, a
> conn_free() deferred until after the helper has returned would
> list_del() the node from a stack frame that no longer exists.  Make
> [ ... ]
> what keeps rds_conn_destroy() from being called with the transport
> lock held.
>=20
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003163215.2502=
53-1-achender@kernel.org?part=3D7

