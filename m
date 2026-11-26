Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795664698;
	b=MP91DFrqnaUa+74KTLSGw3iASNwsKy+/kSjDzhxGd5e5SsbRFmY/oBIbPBGGOzIh3f8P
	 oPHkDrvcEDd+FYpnLQzkRLA5r78z5QDL5og4s2vuy2IhglY4gxIGUG4cIRKpFCTjiQMxH
	 UnBp1QtrTM+Ujqj+Xar0eA4cxmnfqsTfOzcE/bupdROKK465KAbtAFyWRNg74SJI+FRiK
	 j3A1mFW2Yco+rV1zi3CNBP8X7d/lUjxpEwVPVEaZDL4WJg9Vot/g0xytO0qzBVKp51qcQ
	 /ZgKrtnBXMURsLk/hWSpB8lYw60f58Lc4NF1CKVHvGmE771t0tnk6EYdGnYWSIbMbsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795664698;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=a1XdsjosZwZGqaoF7joUV4nyDbSVtXV+eCYlvwE3PiM=;
	b=KLvSHswRtTIhkrTsKpOprjgqntlJD9chIcaKs2Gy6WrVNc6Y1w5VNh8JK4GgLGq2rccc
	 WMg0BCbHrcS3zksE4PJdXs5kf2gN5P6tP4/WDB9IgnhuFT2nCuyw2q1lpq0/Ev9MSsvUL
	 /g4kx9rqFaDrcQVqMBTnm7TEw0FqoEpzwevVOD4X7Oar3zdHhXyXs/oft9YMwJHBOJ5Cr
	 zYw0GoQFsp3qFk/aFClzDNX5zwRQhSus/JVTMg+8QueNV+rvvqD41GLJd7bddBuii+q6j
	 Wz/vufRLV5T8mhmUJBhLQ4Rvz/NZBLO4UgkcnLcs8xrLeRNqOPQijlr+NUgveKvRZgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rv9MDqoF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83B2606A31E
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 03:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rv9MDqoF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E421F000C4;
	Thu, 26 Nov 2026 03:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795664698;
	bh=a1XdsjosZwZGqaoF7joUV4nyDbSVtXV+eCYlvwE3PiM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Rv9MDqoF9OhhvvCQqmRQrXco2nzK2gymov0WTAySejIbMJ+5ZIHdIJjY6Bxyd4XWv
	 J0WjdbdNW2AnN102XsYoTe8Uh3ZdQuyMyaI784QZvUbPYCag3mp4/m+RmDGHM4OJuK
	 Usdx/wjA9WxgWKUy3elT4uC3t1jO52FNngfSNXD2lLRg1QwoUGenCuM+Gnwk/kiYgC
	 wpeL3uEMaqS9hSzM9754bYN7q36ca/ym4TrdnrjDMotiUdTWW67APN9Ab+TSc9+1VL
	 Wt36B2yKsFc0ewloL96N/5XkSGMb0BP7b8clseZkGggTlrfbywz3izIyr/2riN2vYg
	 0BmIR5ppIV6wA==
Message-ID: <sashiko-outbox-234704@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v2] net/rds: tcp: bound the message length announced
 by the peer
Reply-To: sashiko-reviews@lists.linux.dev
To: "Weidong Wang" <weidongw@illinois.edu>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261125-h047-send-v2-1-b29031cf6b93@illinois.edu>
References: <20261125-h047-send-v2-1-b29031cf6b93@illinois.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 03:44:57 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Weidong Wang <weidongw@illinois.edu>
>=20
> rds_tcp_data_recv() takes the payload length of an incoming message from
> the peer's header and queues pskb_extract() clones of the received data
> on the incoming message until that many bytes have arrived. Nothing
> checks the length, so a peer that announces h_len =3D 0xffffffff and keeps
> sending makes the receiver hold up to 4 GiB per connection. The clones
> are no longer on the socket's receive queue, so they are not charged to
> the socket and TCP keeps the receive window open.
>=20
> Senders are limited to RDS_MAX_MSG_SIZE in rds_sendmsg(). Apply the same
> limit on receive: when a header exceeds it, drop the connection once,
> then consume and discard the rest of the stream until the connection is
> shut down. Discarding keeps the receive queue draining, so
> rds_tcp_conn_path_shutdown() can finish as soon as the peer closes
> [ ... ]
>=20
> Fixes: 70041088e3b9 ("RDS: Add TCP transport to RDS")
> Cc: stable@vger.kernel.org
> Cc: Zijie Zhao <zijie4@illinois.edu>
> Signed-off-by: Weidong Wang <weidongw@illinois.edu>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125-h047-send-=
v2-1-b29031cf6b93@illinois.edu?part=3D1
