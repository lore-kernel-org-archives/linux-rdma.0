Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794546315;
	b=o/otR/anU3SWskpmPIN6I2kkIf73OOkahEV0kV/UH+jXyUsym0wS3Ndl/39C1KG+3KrI
	 SqynwdbpVa5TbGVtaHKwLuSI4kRsY993NlKIarMOLhohIWs5zVf1CLC1J6i7WWtTmUY3d
	 IEMXwJHWjio92nMSE2lRb68RMP0cC0Umv+2lDA3DUv39vBCj7zxAheXdoTDqQzDSNN9AI
	 oVccT94hzxhD5k6OlrptRz0UnV5qndCw1vBwZp0D946rVm2j8NCYL7cltN+4/Jjlb+QMh
	 DiYq2iA3Qvvm/yun1uh6Q08srR7u9oo3RWZvdUXjNv6SShYi4WhZdZ8riMCtqQZtt7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794546315;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=YyQmb2KIVp3duyReFHHLrdgs8gf7yj4rDVDS7R9P0NE=;
	b=V4YvUhAy+3tzDvS0LU5tn59KPrD3jl73ZSZJ58PIZP6CCTrbccQIbBJ6Npgt1lT9UKKg
	 oaQekF44lo6RnYtkf9g5zCsRKK29iA/NwWOARo8cIkj2+TW/XyfLUfM9SGurG2gLSiZqK
	 NZ8sF92zRoifHIUUvJYI1Y76T1XS/7UE32wCSBJZO/5zP3ajbl5w0DBlYYV21Id9sZjLa
	 4bBWZ+gxH/38ply9KkzwzrqrAf9IibgpksdyBqUIMfPNRDu7RPNmfov4rsgiDyRXNkbYk
	 M2ak28aPxyj2xZrEmq6VdXengvcdg1FonK5NZIFyeJbz5pZqTACtvb+htuhalj9HH5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fgYUmtUF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B566606A339
	for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 05:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fgYUmtUF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646B51F000C4;
	Fri, 13 Nov 2026 05:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794546315;
	bh=YyQmb2KIVp3duyReFHHLrdgs8gf7yj4rDVDS7R9P0NE=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=fgYUmtUF0yu67uuqMsLm3OoRva93KYm9Jiv8GUe9Icfy32doXxjzqU7PGQmxlLMXf
	 fj61cwaDrfG1uFgI1cnvtUDoUor33lW57/ER5Eq95FnG6h64JaDQ4Y2/6k0l7KYbM+
	 RxbY2BYg1xrKSsSqwsCw6vf1yY2bHf/9GsjBut2/D/+h8WyZjrLJsJCuiQuD5P0Pov
	 5ZpEpXm3ZZRyr+Bu5KvWwflPuS7dLwWLWD3TkVGPae+BGoHLJYj8M3UQsbPTrxq82s
	 O2AC0NM6ak5ELn6BQTIohwfGVzQiUqSWZIuTSY8GqJ+jVuknPi5fvawsLJ7ISmv1lP
	 05tyo/vOQEfJg==
Message-ID: <sashiko-outbox-212197@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v12 08/12] net/rds: hold a connection reference
 from struct rds_incoming
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>, linux-rdma@vger.kernel.org
In-Reply-To: <20261113044355.2932029-9-achender@kernel.org>
References: <20261113044355.2932029-1-achender@kernel.org>
 <20261113044355.2932029-9-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 05:05:15 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113044355.2932=
029-1-achender@kernel.org?part=3D8

