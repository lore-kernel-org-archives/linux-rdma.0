Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022BA3AA4E4
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 03:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792208301; cv=none; b=hqsv9nhfmQiIwgnY5uqJPRrPQ0WyN4/MXnkXtPdQ3ECogQA2AVzlueRyFIqosHpgyY5e2vyduPCMaQusVSSIUQQDl3mnC/yo/yjciJtYhkZlvvzUq4c/pzxBcaM3PLq54CRF9MKnyIiOLCpbBpHVaiFczMLFqd0YLjDLq9XQVAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792208301; c=relaxed/simple;
	bh=5IKfpMGEaKsGRlyyMFQtsTF7VhR7nIweNT9XUzWBL4o=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=Q6//dd2VkalcHjD2ERL6X9BBTQRwvU4v9lu09dSyVZ4FcZfKL7piIKiq9PZ9/BVYCTnapGK33EjDLxvRRsQlgr218KAAUSZuDjwQds4riKy4UN1yY3kCCEQDZUohU0DVRhcMaxXtj2JEkTYhqcqxsHtP1aXUng9q8oRTs8P0tvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TQOaw5gB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TQOaw5gB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA8F1F000C5;
	Sat, 17 Oct 2026 03:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792208300;
	bh=2tci0TzFAtgLbSew58bgh7Loom0cMrZx8p3oDW/CAw4=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=TQOaw5gBmlqN/kGnWyR+ltB8mkcqcbjLM/Va8WWzij90pDbM5lNnpRCpbmVOS7wpD
	 XAkw7jp5c/rwYyckcbQN+yL/ojOLPR1n4gBXjZK/lbahOGxAMQumZrtTzuLOJ458X2
	 FGfiAgBaxZe1OLQLX6KWjTsg0N88TzYq1+ri2UwDNe0rFXh4kAbseX3D/pS84pJu8b
	 /XV/zVKzhqM47sYUAbQJyDGbn5G9UcM0/Aq9dTwhA1lVgr+7Lw7MQyXAm7Nibsb+Ht
	 BBNZcDbGtGX3DurNl4DqnLkZL7Ecvour9cHds3BbKpDtG4cQhrLkxv+l8EJQ9KZ1ZI
	 jheh1G9cGxwqw==
Message-ID: <sashiko-outbox-175261@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v10 09/13] net/rds: hold a connection reference
 from struct rds_incoming
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>, linux-rdma@vger.kernel.org
In-Reply-To: <20261017032319.2563014-10-achender@kernel.org>
References: <20261017032319.2563014-1-achender@kernel.org>
 <20261017032319.2563014-10-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 03:38:20 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> struct rds_incoming->i_conn stores a pointer to the connection a message
> it belongs to, for both received messages and messages the socket sends.
> But without taking a reference, nothing keeps that connection alive.
> Embedded as the messages m_inc, an inc routinely outlives the connection
> it points at, by sitting in the socket's receive queue until the
> application reads it, while the connection is destroyed under it - and
> every dereference of i_conn after that point touches freed memory. Netns
> teardown and unloading rds.ko cannot do that to a live socket, which
> pins both, but a transport unload can: rds_find_bound() does not check
> the transport, so a socket bound with one transport (SO_RDS_TRANSPORT)
> can hold incs that arrived over another transport's connection, and
> unloading that other transport destroys the connection while the socket
> stays open.
>=20
> Chengfeng Ye reported one way to reach it, where the socket info
> [ ... ]
>  m_inc reference is dropped from a shared rds_message_free() helper
>  that both paths call; rds_recv_incoming() takes the new reference
>  before dropping the old; rewrite commit message]
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261017032319.2563=
014-1-achender@kernel.org?part=3D9

