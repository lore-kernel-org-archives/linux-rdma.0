Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793766272;
	b=WlEcbOKE3N7vYq1sjeqUdu2QkdTZ3Fbq8S4IBhjmrsLg0rUFXSOKefHCrc0smHxK6bkh
	 Fe2Iubjs2JnvShu198duHcO+2FTXvjlRcYi4KkDPFVfrNloP64jVcxA7tiRNdp0O+j/fw
	 i+mb5LT3tovx6ItNStKRHAC9+prJuoygruPQBy7KLUA3xS88aaYf8RKlaxoAUwWjeWxW3
	 SsGpSudjOqiu3okwhC5AzGLj8iXbcXkEBRZ0ad7LBU/ynqKkZGoG/c9VHETzb3QIbraAx
	 C9fcZXoq32uBVhLSyiVQVDOQxf6h8AhLh8wbLymfcG1BTYljIWKhPYum8WY7sA0h/oQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793766272;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=JtoG6ytdTBZ6+6rrsSX/UPIic5reRVgL4nPQI35siIQ=;
	b=CiSEwgMo0jIZ/VoDg1ulhE6b6HI9fwdm2AfohoqG+Hh90Q3Ny48KAcmLvYANJjqFeGr8
	 BAaM+wRp3bjfNSvVtLu/punf2J+B+rvRcNr0tGaPeQoJRs4FVNV1s4dBSAiE2VdGIMVqM
	 poJfNSDCdtfs5or4ak9mMdgSoNYA4MgsPSxPFTRiP88ZvWozrFGM8xP73yrV9aAMrjqPO
	 5MHDxqD/NePdqJ9eyTR5+beUvXuMsM/XgFD/6i35CdMp9zcSqVTQCOyteE6mBVXYj3xNE
	 iRPN5c80J+jm07aI6R0n2XuCGCnvgnlaoy2YEn1KhjkiWjXMesv3NZbG0gfw9iArVSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FlfmqtfQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDC9606A31B
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 04:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FlfmqtfQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2491F000C1;
	Wed,  4 Nov 2026 04:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793766272;
	bh=JtoG6ytdTBZ6+6rrsSX/UPIic5reRVgL4nPQI35siIQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FlfmqtfQ5m8zwDwsAqLIxtVyhrc/84kZnwUt2qFQUkWZPVg0bswYkcW2LivBzg7IQ
	 ipQ1WKsJFVNxzi4n9dlXZ8u0CpYcDIQZfG1RD97KKe6o3CUN8zdxdIKFXEk2mL+QHu
	 8RhYK8qFpFz6CshGDwci7Peq7lqussPwWvv1vC4TrM8UsHzAnaASAR8BGRSACc9CK7
	 0hGWC8AHjlnO3mcrGD+wGWEBbgt87/nnufNezFuPLg51xXwW21Bnd/FmHr7BMm0OTW
	 3XaJdPl59Ao07knirYLQ61DsfjBHS0a9FdD2oM8IC0+gEiqEk0vwvvfEZO18UEro4r
	 LFDirSBOq3XUg==
Message-ID: <sashiko-outbox-196652@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 1/6] IB/isert: do not publish connections being
 released on a second list
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261104040318.1844865-2-yhlee@isslab.korea.ac.kr>
References: <20261104040318.1844865-1-yhlee@isslab.korea.ac.kr>
 <20261104040318.1844865-2-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 04:24:31 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> isert_connect_error() and isert_disconnected_handler() take a connection
> off isert_np->accepted or isert_np->pending and release it, but they do n=
ot
> check whether the other one got there first, and the connection also stays
> reachable from the list that isert_free_np() walks.  Two callers can
> therefore release the same connection, and isert_free_np() can release one
> a CM handler has already freed.
>=20
> Make the list the single owner token.  A caller that empties
> isert_conn->node under isert_np->mutex owns the drain and the release; one
> that finds it already empty stands back and returns zero, so cma keeps the
> id and the owner destroys it.  isert_connect_error() drains before it tak=
es
> the connection, which is the order mainline already uses, so no drain can
> run on a QP whose id another handler is tearing down.
>=20
> A test-only delay in isert_free_np(), right after it has taken a
> [ ... ]
>    ret_from_fork_asm+0x1a/0x30
>=20
> Fixes: 691b0480933f ("IB/isert: Fix dead lock in ib_isert")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104040318.1844=
865-1-yhlee@isslab.korea.ac.kr?part=3D1

