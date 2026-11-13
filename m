Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794546316;
	b=COK0HhlwVbTcdNPIncEINjWxseXt3m/+R+3BD7znB5d3/Vmxcm5fyYXmSURaXC3YCL6K
	 +8Ckc67wP/Hed/c61WJpCXvZXqENaM84bWoebTVz/dR6OHqgcYYBs/GJVTDTqWFe0ixKs
	 Aol4PTpv+6439j/aQnUR4fmF+VbIkzGoz3DonYiWTx7UJD3EAglV6LAFJHbx9lzzFS8c5
	 Qt3/0QiBPrZzBBOQOZBGd8vKm4N7TmdUPGHDbniSRuNuzC6UwDIupeIkquqVLM6a32+9g
	 O7b+ZfM+jwO/hIxg1tS4oEryIlZx30LLZcbALQQeVag328xNnn8vO79phs8YIodhFUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794546316;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=IpK11cb8CNe5dlIYz+sh/1koCVTZyCKG5D1BDaJhiMQ=;
	b=k9j1HNvl9o59zGZ2nuB/9LgUsiA+gzjvlxSvN6dViaNPpbA1ibAFG/MlO0Qh3mcyuJhU
	 +1O2ssk0gEc4nnAVEVwmN/hU6IcLsDPSHXBqKXK32ODYYYw8ifGWpG7CR9FVLh8IXBqsC
	 Dvcud+hfMLTIBreCkXoyWS1vjPRpzT3dwxbXPXiYnrVLxvR83xbHY/uUXb5xAo6BXO1c+
	 xu77DYXxHMN4o1UGzGib5B8bmcMBPVQ/vvTnl/QBQEGE2CMrq9sYHFXK5JjdsrOPPuzMf
	 8y2mBJAQ7RrQ9hOzSHFh9Z6lnUoUy3HbureV3QuQFyXlk6vxZmNPjWmB13Sgd2y9f/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dJZqRSEE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F09606A331
	for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 05:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dJZqRSEE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE8EF1F000C5;
	Fri, 13 Nov 2026 05:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794546316;
	bh=IpK11cb8CNe5dlIYz+sh/1koCVTZyCKG5D1BDaJhiMQ=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=dJZqRSEECUF6YZOlyT7JNVWTOLXkmeCg8owHqYR3ZwIGoTQ/MQHikx1RdRq6153zZ
	 N9B/cUZaUNDr8RgkJjvEU+T800JpQ+Hr/cfwnrVLNZ3T+0Y7WoIhxl8+UX6sFJrcQg
	 5LdfEL8UCHcWFkaUI+WIFF7BKNJWtj5tNkwmENoOXhXRu3RXt8pIAaqd99gmb/joc3
	 j5xLoTBlRiLdyYHTwuvFPjPoeE+jMP5YRy2udYM3ynPPR42ppRNyAhm95pdGwTElqQ
	 ETLLzoTI7lJRcmTLCsT7HP3yGPFMKOzzOICYorppLFJs6OgntFaf3NjYKeV523UaEg
	 pAaD/JM0RiHFg==
Message-ID: <sashiko-outbox-212198@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v12 09/12] net/rds: take cp_lock to purge
 cp_send_queue in the quiesce
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>, linux-rdma@vger.kernel.org
In-Reply-To: <20261113044355.2932029-10-achender@kernel.org>
References: <20261113044355.2932029-1-achender@kernel.org>
 <20261113044355.2932029-10-achender@kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113044355.2932=
029-1-achender@kernel.org?part=3D9

