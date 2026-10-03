Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50EE3A4F51
	for <linux-rdma@vger.kernel.org>; Sat,  3 Oct 2026 17:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050190; cv=none; b=Ab/6UkC9InoclALqeUWUGmB5ngamPn9n+CUbMZ4ag3s4E2Xmq9QLGLcpnxDP4W6/eZglBZwOAdtUrPX793U8rh79tZmwEDhQOPNwVTmYM7M4HFl5qsGYSty+zuTvdYMXHz/uHlgoiqX6+/SHtEG8N2UpwEcb5WKaOa0c+kPNhuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050190; c=relaxed/simple;
	bh=maP3RBMnGLklByfO2DNAS8PBiq4kNwMYorGT3fFbDQQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=g7Via/5292PXTHkncB+VNRAmseTTjd6EnTvWYZaX3mzb3ZKdJTeLIai3b5AzcxPY1T0VmpdKV98guOOV3OwnCLE9vbzYP1pNeIGlIHALpdkB1eJJHH8FfEWaQmDKPBYXP/ny/l+ZsVMEAn/PcHhYh+1tPeRzIl4VapoJwRdWRJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NAKvy9n7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NAKvy9n7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0AD1F0089E;
	Sat,  3 Oct 2026 17:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050189;
	bh=vjPAymvy1mKAvWPnRIGlo8lD5/s02BEtvs83UKCRiq8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NAKvy9n7dw2XtnMmt+nhuPPol9RK14xjqYQcyND/RbDE6jmSyZQvrO9kPXaQ47jtK
	 z8U1GaL7gscVgiI7rmIaVCNVDesu90bBYjMtTrH+FN0oSwaQ0CXXW673LQrpCvySYr
	 i8pmgYAYC1PXAmJpQCcW4On/iO7ZkY2km8H3+LfTJMvdreivnfzj3oy+g/3ko2sosc
	 fhsLgIpmcprph3VW7Y0rQ/KZA0FYEcDLEORdq8YbH57BVRv4z6Lye/tt2GhjMIj2jE
	 +oqO7Ci4ytfDnabYv6ZqFlvXj5wAomCEl+zWHuIAJAc4BxL6UQGKj/9k+fdcOwqh8s
	 vCo4+QL6llHGw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v8 10/13] net/rds: take cp_lock to purge
 cp_send_queue in the quiesce
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261003163215.250253-11-achender@kernel.org>
References: <20261003163215.250253-1-achender@kernel.org>
 <20261003163215.250253-11-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:56:28 +0000
Message-Id: <20261003175629.6D0AD1F0089E@smtp.kernel.org>
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

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003163215.2502=
53-1-achender@kernel.org?part=3D10

