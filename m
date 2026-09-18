Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4C73DDDDA
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 07:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789717244; cv=none; b=Wdop9+144mPUshfVNqwmgfB/Q/Nwk32n8uKE3Ntsmt/qQtCIwWJKHUGujVo9fm73Jl/p0Qtq0mQwWm9GnGjXcVr4N8VIxvo/fxHzewHuoCs0qKEvcRdk2dSl7inXyIpLjVvgdx3XvxCA6Ee21multbKrtw8ZhxhZCGtzjI1c810=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789717244; c=relaxed/simple;
	bh=3aSchLrJFjEvybvZ5oLt7Um+eAtkp90nwiMmy2Y+oVg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZsUUf02tT/RScB/jWK0YV252XnmM79pdmgW12IX7D1vBIdMS6uDj9odCprAyZbdeQpTEbdc4UtL8D5EW9boPgbAWOXZcAMs7iMo716Q8vIO12xjFq4/MzL9C9lk59KQKg89W5wUKOF8ws7aLuDbJw6O5tHazGQwjlETJesZyDYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LiIDFXfN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LiIDFXfN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525791F0089F;
	Fri, 18 Sep 2026 07:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789717212;
	bh=fVP5a4I4DmvFIsHiAh8DtDnAM5ov3Gy9zwYI1QXr/ZE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LiIDFXfNk3u47zykUFHowOQC6v9vsOmqESUixGb1Wv7cYVzwGFb28VZO33lauu63Y
	 mk19XZi72xqT850eSUDrU8/IfOLiNYh/REA5wIbkXAzp2fKsicMTWecUMmc7La6/su
	 y9mkByrJX2QuPtgjZVcys4XqFxZtQdkL6c4NqYZPW7PvowiGRRrJxvdEmE0vx3uEnb
	 MabBC1CpXXOnPLTkqez02eqsZPDwRByPvpwmZM80GmF8GI1Lw/LDwFdYNRSITOjs4R
	 Vpnj3UfR2Wf/W/bzMbKL2zRFTTnEyy8V6ZB7hcR1mlUWN2hafF2NKWYv1dwi/jQn3e
	 0X2n/9lI8FEvA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v4 09/12] net/rds: refuse to queue on a
 connection being destroyed
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917073958.174056-10-achender@kernel.org>
References: <20260917073958.174056-1-achender@kernel.org>
 <20260917073958.174056-10-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 07:40:11 +0000
Message-Id: <20260918074012.525791F0089F@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917073958.1740=
56-1-achender@kernel.org?part=3D9

