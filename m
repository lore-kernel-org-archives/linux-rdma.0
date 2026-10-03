Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F49F39EB59
	for <linux-rdma@vger.kernel.org>; Sat,  3 Oct 2026 17:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050184; cv=none; b=OPDGjfiAj0GKG/ayOGnJoaEbvCh0++MJ97/iR6itzaMrTjz+emphI0mETn7FMmDDRGPz7kBE1oXEUh1K2NxRxgAUtE2P/VjxolTi4NXruE3wLQq4UpxIa3gk7fYKy2M3aG11mu9SP++B5JNF+2tMzvS7RO4Ec02Vh9089txLyXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050184; c=relaxed/simple;
	bh=iLXQ0b6Fq/NeqAFfAHsbKtNSweK5yQHsgYjsrqKzX88=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hW4HIVszJJM/1AhOnmprVFI4txx8/Oo3x7HLTeULwlWFuA62diBUWfNlRt8D7KiD7DStOnUcf0cZZAW5VDPATGjSLKDDU2dJXILnQxVk2MmSJNKykRerG09JbIbkZ0bQmN5lUENhDZi87RpiLj1A4X7+q5wfAeTlArYTVIZH3ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MKlytpPy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MKlytpPy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79EA1F0089F;
	Sat,  3 Oct 2026 17:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050183;
	bh=5NEbVNBy5/yvlSFkQErZY9cyPXQm+/howB4j/+2ksKQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MKlytpPydEpW3GUxELJ0liuMMOzn/Jn+uSvYfg/IwJ40ahyEzItV7/qjYbMY3cdW0
	 0fMq3zcoJl87egn5Mt/k14UV5uPYBguxRdJsat7dKKdmGipBL1AO574EXBUX108H3S
	 yrU48v2q8vrHPGmWHgkuZMmQ9nTY7IbcGG9Z7tnnZnAH/AHHtZtbyWGfmIfmEW4kSR
	 psoOjCBsUPiaaKSJrjRYFmEXtD8CyHPQ0+8NTpqgMTSbj3BxhJYNfzOu/Vik/fR1ah
	 pIROlSGMeg7vHhMXOSTw/OOtQpCtKIPLqF8unrTxyi6XK/K23m7pA7ZfSyuOAwpRO3
	 yo9xnzt8watqw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v4 2/2] net/rds: don't let the rdma_cm destroy an id
 RDS still owns on route failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261003163408.250568-3-achender@kernel.org>
References: <20261003163408.250568-1-achender@kernel.org>
 <20261003163408.250568-3-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:56:22 +0000
Message-Id: <20261003175622.D79EA1F0089F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> rds_rdma_cm_event_handler_cmn() hands the return value of
> rdma_resolve_route() straight back to the rdma_cm on
> RDMA_CM_EVENT_ADDR_RESOLVED.  A synchronous failure there - -ENOMEM
> from the route work allocation, an SA query that cannot be set up, a
> RoCE route with no usable device - makes addr_handler() destroy the
> id the event was delivered on.  That id is ic->i_cm_id, and nothing
> clears the pointer: the connection sits in RDS_CONN_CONNECTING with a
> freed id until its shutdown calls rdma_disconnect() and
> rdma_destroy_id() on it.
>=20
> The ROUTE_RESOLVED case already avoids this: rds_ib_cm_initiate_connect()
> forces a zero return while ic->i_cm_id =3D=3D cm_id, as the comment there
> explains.  Do the same here - drop the connection and return 0 - so
> the id stays RDS's to destroy from the shutdown, and the reconnect
> gets a fresh one.
>=20
> Fixes: 55b7ed0b582f ("RDS: Common RDMA transport code")
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003163408.2505=
68-1-achender@kernel.org?part=3D2

