Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462B33C4554
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 03:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792208303; cv=none; b=OGpnbSMiYarbbXPMVf7xphoRhY1Csb35ZlwXlsPynybgslbvujkYLU0g0LfnbkcFfxM8aNDyyUrUjtlgBCfXiZUf86Mcl65QDr6cGY4ShVZdUQuL4aCJ1BU6rplKIuN/j8K02smP2o4359ejeqCVsY3xL93T3NbPHbAiginLKHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792208303; c=relaxed/simple;
	bh=KQN/Fo9eMcACdx9pWt+c8038+tLE3VeBTSZA+aOWgCU=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=XAXgdtrofVnWywikGVxlx6FkUL6C8AAUXrffd9OwW6WTmU8d/RyntwRePyORF6NDrCp02nQ6dL/UmHUAnd9vG25WO6c/Y0RLn2xnf8fBbhCuKU4ZqeHMA+ZqHvhWvF32VhzPqQuiNLLMIPlFW2TeC3K0eesAB/tZ2uV+w+yJZO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ObchTbYM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ObchTbYM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8CF1F000C5;
	Sat, 17 Oct 2026 03:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792208302;
	bh=JAzcnxeFrcvFGX8P2+lVn+s160BI+AKkTG0kcrrZmMA=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=ObchTbYMu78WOQu1M4eaSnW8tswuwqAmyQr9bW3gRA5yUuXPGsoDardlMtd05TXyF
	 83ZzFUhG1JPOF8YxDu0lWU/NydH+vQjBJFV2ouNdgpWhf5QAaL90s3T1JDU5SVVUkP
	 +/1ocqcUEbBiyV9JOowU6CQYApkt+an+O1eXkx5vJbi75EDoyQYTYlkuxszC7nWQqT
	 z/+ch9bIDGPAJeDEeYksXmUeM4oOBaXdq019gW9dw8RfxOmPVHpZI/arf3g28u8CTC
	 y1f6poxgepx8xBaUn1hDjMHMJsPnJgrtqeGXjDtV/RZWESPHDWyvQkATG/ReAJBApR
	 cwFP30qrq0w+g==
Message-ID: <sashiko-outbox-175263@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v10 11/13] net/rds: hold connection references
 in lookup, sockets and c_passive
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>, linux-rdma@vger.kernel.org
In-Reply-To: <20261017032319.2563014-12-achender@kernel.org>
References: <20261017032319.2563014-1-achender@kernel.org>
 <20261017032319.2563014-12-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 03:38:21 +0000
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

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261017032319.2563=
014-1-achender@kernel.org?part=3D11

