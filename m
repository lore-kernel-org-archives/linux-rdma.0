Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A513DA5DC
	for <linux-rdma@vger.kernel.org>; Sun, 20 Sep 2026 06:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789884731; cv=none; b=PC6qNX6gZZcCJhTq7loazf382gXPCUBj9raraarbQQE1pU0wKONoaCBS6HzsN4Je3r85reZGWM2hVU6f+Xl/qJwCTviTD1qlQSfFZhVpRWU0CBcWHKVXYcpwJvXekT8l+vfG1YsOoCjEaeG+Be6+Y13YjueoyJ9EoNoBec/IrC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789884731; c=relaxed/simple;
	bh=7NUVLXYXBLXOgggiyEbiHbA/AyqB5hR5AbDM7XXSkzM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=b0yGqdr8FKnlHkIGNLD+pEwS8jMAHZiq4e23QbyC1wzm43o7rMp4Ii3cMudxA4kl85aFw0TkNu+JIeQ9UM5awrEEO+l+/RX2LjmUiO9/DHuoB2BQv9rOOV9m3rLrpaHUfk53Z3nqIY83nrkioS+CjFcHP5udOkOE0qYejFU16nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ig2Ovw1C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ig2Ovw1C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB3EB1F00893;
	Sun, 20 Sep 2026 06:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789884729;
	bh=S0cf9gGE3iPJsaXT5wHthdR6aENDRrlw/EC3Qs+y7Z0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ig2Ovw1CMbKmTo+a9+flclOjlwWn84cszBtGAon7CLQcCgyu6cvHMBbvJIlODdI+7
	 vj6jz/Sih/1DiI6IfDV3u2dGiAP+QUPtWTYsLD9kTnjR4agEgPb4mOY/ArsQJTzKIl
	 2qEdF2c6/6wnGPP8CNozdfiQmTs0P2ddlNh61eoOc+91EFGQu/DIAGWpenrTlfRCfH
	 DZT7EPgUhM9t5OcsUcbswRiUFebnvL5jJNvu3EeLcnvHjaMirdbDW5mORGlJ2Jc5yK
	 VwRb+XShyrbOsokiTs+jqW5c3T+y2sr+OIQuWDWg2L109e9psyCzwYHTrpByHNAJl5
	 +n8Ueo3FC5kPw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v5 09/12] net/rds: refuse to queue on a
 connection being destroyed
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260919061149.250658-10-achender@kernel.org>
References: <20260919061149.250658-1-achender@kernel.org>
 <20260919061149.250658-10-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 20 Sep 2026 06:12:09 +0000
Message-Id: <20260920061209.AB3EB1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> rds_conn_path_quiesce() tears down cp_send_queue by walking it with no
> lock held.  That was tolerable while a connection could only be
> destroyed with no sender in flight, but a sender now holds a
> reference across rds_sendmsg(), and rds_conn_destroy() can quiesce
> the connection underneath it.  rds_send_queue_rm() adds to
> cp_send_queue under cp_lock, so the unlocked walk races the add and
> can corrupt the list.  Worse, a message added after the purge sits on
> the queue of a quiesced connection holding the connection reference
> rds_send_queue_rm() took for it: the reference is only dropped when
> the message is freed, the message is only freed when the queue is
> torn down, and the queue is only torn down by the destroy that has
> already run.  The connection would never be freed, and with it the
> transport could never unload.
>=20
> Splice the queue away under cp_lock in the quiesce, and have
> rds_send_queue_rm() test rds_destroy_pending() under that same lock
> before it touches either queue.  rds_send_probe() adds to
> cp_send_queue under cp_lock as well, for pings and pongs, and gets the
> same test: a probe queued after the purge would pin the connection
> just the same.  A sender that gets there first has
> its message purged; one that gets there second is refused, and
> rds_sendmsg() returns -EAGAIN for it, the same result the early
> rds_destroy_pending() check in rds_sendmsg() already produces for a
> connection whose destroy had begun before the send started.
> rds_send_queue_rm()'s *queued becomes negative on refusal so that the
> wait loop in rds_sendmsg() stops waiting for send room that will never
> come.
>=20
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260919061149.2506=
58-1-achender@kernel.org?part=3D9

