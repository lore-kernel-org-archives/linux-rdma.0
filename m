Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCE6407CD0
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 08:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153686; cv=none; b=MeL2l9d+47QqsZ310UG4c1SETyoehwqmwaub31xht4FpHu0UkpZVvBZg7AxYkt48TtU3y9300HcaigV3ZWVb4QeA2qkUUBClgKvhONIqZcM4taFkJpZhh/ZaEf9VAJPCHWeAeIzSF2fQ5P4L5l8BkdFKKOEhC2srSgJe3hTSZAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153686; c=relaxed/simple;
	bh=PkMPtp4K1ItRUChrBM1/JFR/5DTXB3aNJSYxLLQEDBc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=n+TCQsQUGjIW2xeIFmECM8xfWHhsFsccAeWnaQvoz0Pco8HwymO3rDJoxWgDrxkNjvZFTNItahwtTAyNyjFug/O0/FZYvVYcvJUvKfNehkef5Ae6VaAwSmqyXbvTncSypAlINi48UwTPy4IcAfapdyQZuZWQaar5pzsH5awy9eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F6OiMvcm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F6OiMvcm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E7A21F008A0;
	Wed, 23 Sep 2026 08:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790153667;
	bh=/48Gt9IcsInx/3gFS86cY8SKzTv8rXODPwqwjgxKoOQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=F6OiMvcm2HM69g7TgP3W0WtqThJLElgJWNfQKczcVhXB1UU1nBOf4ckGKAOfOkEKb
	 CtwpFog0i6Ecska2HLlokjR6GMQI4Zq1IuBGOXw6aPc76Duo4bfdxBCsr7OI9/d2ZY
	 sq99lXzc0cbCFUHxA4HwfEF5ZhHB0XIOy0XCnM2FOOq03ZQ5QP56aXIjq0koEOgOPm
	 M4qbLB9PPjGyfhc5MR+GVZAVjF9IiZGlvf0oOOD58UDeM/yoWf3Ia2p7fbzFUBiFJ0
	 qsiafrZwq4R1a1gQxJzr7QrIgV+fG2ci7/YJd4+DF3s6RW/1HEetmvB1vE2OvZkAdd
	 17wtiDRDb/GZQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v6 08/12] net/rds: hold connection references
 in lookup, sockets and c_passive
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260922085410.391323-9-achender@kernel.org>
References: <20260922085410.391323-1-achender@kernel.org>
 <20260922085410.391323-9-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 08:54:26 +0000
Message-Id: <20260923085427.2E7A21F008A0@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922085410.3913=
23-1-achender@kernel.org?part=3D8

