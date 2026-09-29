Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F2640F721
	for <linux-rdma@vger.kernel.org>; Tue, 29 Sep 2026 03:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790652574; cv=none; b=Q37mmCvzXAS+IYAaf4TReVZjeEFs+vhYo3cExeWHt+3ToyCa9eBueMkkdIigyhxyCEe/740lyrPIptXMU1ceBzTGsdiwo4no2jE8ohP1bK3+6DvuD5FI31PdR5SRoz/2RSiaV+Aq8wm5Get/rAMSgV+j59lNpf9xaLaZb/pqByA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790652574; c=relaxed/simple;
	bh=pZ7/f5vt+Dn4QMHEFWiLdnTC3a7IrPx7el9nvhaBv0k=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=sA9R5oK/WyJT2TaDoLjA2X2RGZ4Gz8tLKRZxB/vEo+93Z/iwgCRprgjFwB3Dwvr4orXghfmO1AM0PfRrbL8TlF/IBtLwCbmUsP5BgQPlVIFiDMLPgWqBw36nbQZeM3YUGgGpNWlFK/Ng7iAOshiiaIznsTmaz2PajgFmgHkF+n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GTICRlYb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GTICRlYb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70BEB1F000FF;
	Tue, 29 Sep 2026 03:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790652572;
	bh=5XFFbdQQ9FQRooHXqFmb33KneDpzuXxLW3enfAyhKRA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GTICRlYbonBFamqptANSQWYSaz7wPStJIPmuBUBdchxSJ80WSsCfbaZwhNp0Rx9V6
	 q6wQMJXBHw9pH/yyiYUgB6J/2yNxyGkeLvQfowjGm1vFXkQkuYs+YuX2qYt4ONhMi+
	 7qHtVB4bDEBm42s4H3Q8TCXVLuBbfnqFo5rU0zznGdch63cn6u4NxqdMf1365YjqFj
	 +PYIpn5jHxxjmKsdU7ufLEar29lKjMAOl+OED+8NncAVk2y8IPiV9IOUpeP65zDsf3
	 AlK5e4sHlD6zmer76TbPes9UbNIgxphhK8TuZ7jbfgVjErQP4bz2lwB/QY0SIh3Wpt
	 KNZ9eBH/dhBkg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/rxe: check the PD when invalidating an MR or MW
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260929031811.1550334-1-yhlee@isslab.korea.ac.kr>
References: <20260929031811.1550334-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 29 Sep 2026 03:29:32 +0000
Message-Id: <20260929032932.70BEB1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> rxe_invalidate_mr() and rxe_invalidate_mw() look the object up by index in
> the device-wide pool and then only compare the key, so a QP can invalidate
> an MR or MW that belongs to a different protection domain on the same rxe
> device.  Both entry points are affected: IB_WR_LOCAL_INV from the request=
er
> and SEND_WITH_INVALIDATE from the responder, where the rkey comes off the
> wire.
>=20
> Everything else that resolves one of these objects already refuses a
> foreign PD.  lookup_mr() rejects mr_pd(mr) !=3D pd, rxe_reg_fast_mr() rej=
ects
> qp->ibqp.pd !=3D mr->ibmr.pd, and rxe_check_bind_mw() was given the same
> check in commit fbbe1d5cd7d4 ("RDMA/rxe: Check PDs for memory window
> binds").  Remote access is therefore scoped to a PD while remote
> invalidation is not.
>=20
> A peer on one connection can invalidate a kernel ULP's fast-reg MR on
> another, which ends that ULP's I/O.  Reject a foreign PD in both
> functions; -EINVAL turns into RESPST_ERR_INVALIDATE_RKEY for the
> responder and a failed work request for the requester.
>=20
> The MR side has behaved this way since the driver was merged, where
> do_complete() freed the MR it found by index; rxe_invalidate_mw() arrived
> later carrying the same omission.
>=20
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260929031811.1550=
334-1-yhlee@isslab.korea.ac.kr?part=3D1

