Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745C447A863
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 08:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153681; cv=none; b=cRb+HuMGdGAamGsG6U8LiUhlYgPrS9te0N8LprugKdKsqaocWhuAq/T2M1L39U0PqCnwYevGJpo4o1NOfm5e+aaVufNEMCtuWoT42MzQspzlqZAjiRssnNPHjyXG+s02SIcnU9ujPkeLlpStkA2hqWF5Yq6mrRM/ssmiKwgszRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153681; c=relaxed/simple;
	bh=R0jy6hp+x3J9tin8ixFopxqv6JNkQLQFuxD6HKeJtoU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tSfFcwM6z0flpVb74tqjPqEZmVkC6mFquq3Ihei6pKRShzeRfhjWaL0Ud8AZqgZ7nJqDKUZrEVeo9cmQ0Ecdqpt5KAsN+6Fqx1GTkUQrBzrHDJQNfKKngKQHjS3+eCmkw0iGjxhKGMLr7YUY6I/gmHyXSUw6Hth29tQKYQSh0Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dn22Oi55; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dn22Oi55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C501F008A2;
	Wed, 23 Sep 2026 08:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790153670;
	bh=Ho+tK9dCyVru5oldc4a9t0oeYRRSWAb+OziDSQD3+ME=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dn22Oi55fmhakBrXToNhjcpXHUMfffQUeAuj9TsN9dMTvsjcg60+3bavpFn/DFHTR
	 Eabm0cowmaDL4OYygiWEWR+8UQ3AeSjayawSZlRjruQhH+Rw2WRIKRUW2q5pQYrFKY
	 1BMGvBoqYIdIc9DpiDO3zRIq3CKtsxaEyefGg051Ek23DjzbPSjRI9itOFRZTqYRsQ
	 aD3qKPE711qDjMA5poAWdFywJLhqtfGD7VZffgO/t/nXSzLO3dAZbJEsA9NDuHxvAS
	 jFdFRcT6x3V/DAxnikyMz2jtngwharNh7tctwo3EVksI5K6hojWmGPT56wO21bwhLu
	 Y9VzEkb6lbrVQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v6 12/12] net/rds: hold a connection reference
 from struct rds_incoming
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260922085410.391323-13-achender@kernel.org>
References: <20260922085410.391323-1-achender@kernel.org>
 <20260922085410.391323-13-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 08:54:29 +0000
Message-Id: <20260923085430.46C501F008A2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Sharath Srinivasan <sharath.srinivasan@oracle.com>
>=20
> struct rds_incoming->i_conn stores a pointer to the connection a message
> it belongs to, for both received messages and messages the socket sends.
> But without taking a reference, nothing keeps that connection alive.
> Embedded as the messages m_inc, an inc routinely outlives the connection
> it points at, by sitting in the socket's receive queue until the
> application reads it, while the connection is destroyed by device removal,
> netns teardown or module unload - and every dereference of i_conn after
> that point touches freed memory.
>=20
> Chengfeng Ye reported one way to reach it, where the socket info
> callbacks walk a receive queue after rmmod freed the connections:
>=20
>   BUG: KASAN: slab-use-after-free in rds6_inc_info_copy+0x459/0x530 [rds]
> [ ... ]
>  m_inc reference is dropped from a shared rds_message_free() helper
>  that both paths call; rds_recv_incoming() takes the new reference
>  before dropping the old; rewrite commit message]
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922085410.3913=
23-1-achender@kernel.org?part=3D12

