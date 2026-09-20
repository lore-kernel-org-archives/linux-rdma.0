Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524B43D9DC8
	for <linux-rdma@vger.kernel.org>; Sun, 20 Sep 2026 06:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789884730; cv=none; b=H00Re+95AHHhmejTdZjcRsucCmIqXtZ5Br8XVXRTmdYDPyzCJhczzVwKpUNV/2T2hHylPaVe1mCjAsKwwCE7rYd2OZodMjMJhUD6Fo8iHMFnCIIjomHTnX+KcTr6drDlbeq7THnOumRhqDlGnBTOFLf5tI2JIvooXSa6dCo+sLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789884730; c=relaxed/simple;
	bh=95v07YWcFtvTPSzwh0eKhycpx9mzxhDNbNc92wjXW90=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Yqw3rlIRcPHuOVPRQ8hy8VJgP3/LLZ2YPsC1BP3F/Ak02cGVHU4wzC9BvGdOmFJx7sEmGElJ6w2OvnPOb+VQ339bLWmO/s2oeTa5GUEeoMglPU4uGAcM++e2m+/ic5v+O7bhmeQhiziKnWXtywlCoCVeUzUZBuxoAVZ+ejyAz64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h4LHZjnE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h4LHZjnE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196C71F000FF;
	Sun, 20 Sep 2026 06:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789884729;
	bh=dbGAsYDVThc8TxGcA4UdjPWPcLOZETn9Axk1EwvAB5U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=h4LHZjnEmJcw5DKGtIOzd8aQLbM+PlRafLes3bt2hHp2iN5pphPbkW/r39S50nWBV
	 rNrQDxGhqqw431AN5s0lYLukIKE7F1M285Xd/wR9LXwiglGyvbBJwEEbmcsnzRPnkp
	 Hzuhc53EEfmq0fKyQ3/QHVVzFyncRVjcDIutjVs/x9Lla6/iFeFaqDzSytunuUvYsT
	 +sFSNJsDHxA40gdiehab1dbR6qyQBfKQ5SdrRHa2PaD2eYRouciu/chcFlXKTfCwSa
	 Y2z4LTnDCeeBHTzHJ8kDpEzKiKcKkKT6DhtA5qyTKdLbPEWhHBjUhBz7OYBIxc6Cmd
	 vQHoIQpxLB6DA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v5 08/12] net/rds: hold connection references
 in lookup, sockets and c_passive
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260919061149.250658-9-achender@kernel.org>
References: <20260919061149.250658-1-achender@kernel.org>
 <20260919061149.250658-9-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 20 Sep 2026 06:12:08 +0000
Message-Id: <20260920061209.196C71F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Sharath Srinivasan <sharath.srinivasan@oracle.com>
>=20
> Hand out real references everywhere a struct rds_connection pointer
> previously escaped bare:
>=20
> - rds_conn_lookup() takes a reference on the connection it returns
>   (kref_get_unless_zero(), so that it only ever hands out a live
>   reference), and
>   __rds_conn_create() returns the connection with a reference held
>   for the caller on every path: lookup hit, fresh creation, lost
>   creation race, and the passive-loopback lookup, which now also
>   holds the parent while it dereferences parent->c_passive.
>=20
> - The rs->rs_conn sendmsg cache owns a reference, which is dropped
>   when the cache is replaced or the socket is released.
> [ ... ]
>  them synchronously before the final put), and the sendmsg cache is
>  serialized with rs_lock instead of UEK's socket flag; rewrite commit
>  message]
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260919061149.2506=
58-1-achender@kernel.org?part=3D8

