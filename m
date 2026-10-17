Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA473BE168
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 03:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792208302; cv=none; b=Y6gCjLtNNZkh+PXXv5cPxENqPPyLSM5m+BJgx5Zu2YRsE2L0zekqsWmbRDbXGnMP9oi+Ftc6BNrn/gt3+azjDQAT0LjSS2ysjBFl8u7HvfMBZF4JSUPADypN50QPijAAk/VZxKdP4kFTHyUR7WR1fzd3ilGeokvy/0ykN0CAyoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792208302; c=relaxed/simple;
	bh=C9RtRdg5M7W+yX2ap7uauv6kTuVf8b5lxKMl36vaZ7s=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=T5er6oRtLbNTIN/WpDg+6PxQTKiWHYpVI53lOe5ste1M9tVhsw2Hwat2KTQMg6S6p/9ovhets5hk8vvJLT2xAsHaFvu8dMg7E7F81ZnMX5rA5CFXsViWuucnJFQnYY/EuzlVQbD6juYzIYRbprjIAmBVCbxzqoboWepW9huYLZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a3wOD89O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a3wOD89O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C7A1F000C4;
	Sat, 17 Oct 2026 03:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792208301;
	bh=3j4yW7NuZ/9UKD2G/apiA8P3FZdux2HGza6FSI82wQc=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=a3wOD89Orh2bQ5f7PgavwSTgyXQY0jR2qQ1TEGJ15yQW/oUEojy2iUAw7sLN+d/CG
	 ok0bvih2frYTBJQemxy9j9LvPqJdlMZZM16+CRrBSbU1PnTf/G51ZWRGpK45oCzF0A
	 nmeNn8BTaxO83/6z1pkMYU0//UzB/L/PVFeU6optJvU63tpeuTg32DqgaBT5muvEDY
	 LHxUBVBKqOdQA5Qt6SrgCuCF7x4ArTDnCglkkvsc5EUwotiKIFoT/lFWqOAWXJ66Vj
	 W9LW5e5v504p5JtVbQxg3jkk/aCbhirYJ8MJeUvS8EpIJtKQywUzsQfpu5g/d4G4nI
	 xsISB471K9Vog==
Message-ID: <sashiko-outbox-175262@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v10 10/13] net/rds: take cp_lock to purge
 cp_send_queue in the quiesce
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>, linux-rdma@vger.kernel.org
In-Reply-To: <20261017032319.2563014-11-achender@kernel.org>
References: <20261017032319.2563014-1-achender@kernel.org>
 <20261017032319.2563014-11-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 03:38:21 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> rds_conn_path_quiesce() empties cp_send_queue by walking it with no
> lock held, while every path that adds to that queue -
> rds_send_queue_rm(), rds_send_probe(), the retransmit requeue in
> rds_send_path_reset() - does so under cp_lock.  The unlocked walk was
> justified by the destroy running with nothing else alive: at every
> destroy trigger there is - netns teardown and module unload - no
> socket can still be sending on the connection, since a bound socket
> pins its transport module and a namespace closes its sockets before
> its RDS connections are torn down.
>=20
> That argument still holds, but it is an argument about the callers,
> not a property of the code.  Splice the queue away under cp_lock and
> drop the message references outside it, so that the one walker of the
> list follows the same lock discipline as its adders.  This does not
> by itself make a sender that is still running safe - nothing here
> [ ... ]
> not one worth a panic, since the socket side keeps its own reference
> and retires the message on close.
>=20
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261017032319.2563=
014-1-achender@kernel.org?part=3D10

