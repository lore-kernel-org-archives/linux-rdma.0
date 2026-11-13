Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794546316;
	b=q6hlGeCoz+cPeWzcbdmWxVN+NfSsuOvEQHVsHd8LecorlMNPT4yKQntWrT7ZiNpqRPyE
	 S7MsLnDkHhU2NXqlG06H76OiOj0n10tJxVm60q5FowfkZED20zfPbW13Wyir/rgfRhL/Z
	 RCJ42fS2ZLNZzgsuWJ18N6lPmjs1U3ArQt9kRHGX3OHCXg59qWNXL1+lzwu/U803rHa9s
	 aRsMtyCqqzNEGc6udpdXAa7g2gbgbJcN+RTOjBpJlbmgFMnxNw32c3wveapb65qiLqIbG
	 v2LoVBrrqVTU8KIoOHlAeAKeINMSwkPOyuvb6YQEDPwqsgaN5eHs3uXbdZdVVk9Xg1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794546316;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=puooujvsdJu4tBlhidLv6fi7tbzeF9DOPz3wqMPxO6A=;
	b=ODw1W4cKGQrlzVpmy0rLMzyPbNdvTeWgscOZqqGoIX9RX4F7cPBrvaZiZxuxdfuh2Sjz
	 IqRkZhRYi3bGLccnXnBL9qllann0PtevTkfo4r+QyCLIyR16BM/61jEyHD3jqWUq5jS67
	 H9LX+1gBUBCiiVtc5Z+wQbHgMLcEOCoxlp3bIi8TTJlXla5mRgJAzL4TF4UD6KqDOK91A
	 ZSg/bPP0/wALRNnhEeiWUV3iBpf/3611pEm0GH+VeZnEbNeRMB0DSoaskvEeFguO/SoDe
	 IGpF2N1fv9eup3n6HJv30C9nGOUKY1jVPdUmtaJXVBD3hKw3muAGhExy3IkkXxkJB9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Sm2GmR5w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF9A606A330
	for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 05:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Sm2GmR5w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A891F000C4;
	Fri, 13 Nov 2026 05:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794546316;
	bh=puooujvsdJu4tBlhidLv6fi7tbzeF9DOPz3wqMPxO6A=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=Sm2GmR5wy6JbYAS0WmdU7JPkm48FhzOrz6YRPvPxGTXFRQln/cTsMRMxYjkQLd1LZ
	 scRYHBYvOJd0RrFgF9AH6bS8vADaYZlHPkDrZ/FbHwLyo0T6N0NcnXY5JvzmC4JGz5
	 J5LLw6RDvT1GIeZ71PoqiLXsahO95990Sa5y6TGh2OeL97H5Xa6eQbhmYgR5NqOu4B
	 ZMO4PdCoB3FXiLq4tcJ+l9/5b8sa0CdE+tq36UmBB9KqbPl6MjZbsSxJYfdLMbNZ6+
	 waWuc/MepilIvB5I9BLhfwO8dj7EbBf3dEuGip9eHUaeModgliGB1Q3xp6EiyhT5jC
	 kAIzQu+Zdw3/g==
Message-ID: <sashiko-outbox-212199@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v12 10/12] net/rds: hold connection references
 in lookup, sockets and c_passive
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>, linux-rdma@vger.kernel.org
In-Reply-To: <20261113044355.2932029-11-achender@kernel.org>
References: <20261113044355.2932029-1-achender@kernel.org>
 <20261113044355.2932029-11-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 05:05:16 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

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

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113044355.2932=
029-1-achender@kernel.org?part=3D10

