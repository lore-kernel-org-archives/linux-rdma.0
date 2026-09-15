Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D64282F1C
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 03:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789443462; cv=none; b=alL9nkMzndWRFXDGQ1ZYgGk/9R6/yD4XlauNO+iz2lo9jJYoMWcqcOcfv2oR2JNDVGmjZFoXqUt3puRdB3ZCkM525AA9RzOWqz7pJKZGHmU8+4azWo4h7bRsiu8zrbX8/HPUkAFFh5SquK1J4cTdguQbn3G03sGh3gAZv2QVT+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789443462; c=relaxed/simple;
	bh=CCUTdxoFmxCJWyxsdVzRxUIW9uvf9gP6O7lOSZlXWcc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DCSpykuft+BWcCjqNu+z8m7QnQiDr3q1RyumHQsj2mMIQKAi1lBs8x5LIzTsE3fOgRSGuCACfKZu9tpNvXsR/RrYiwZBsNRNUBdS3H1PShzSrfhMpL2ZmK/dcsRq+kiO71lKjWrEnxGk60cSOJCwKDFd+msuj2fMtu7xzWnNdis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MSaHY1VS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MSaHY1VS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEBF21F0089B;
	Tue, 15 Sep 2026 03:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789443459;
	bh=PfQaTALGBJ+SoqjYr/qHybBEkRohFKpmBBJrMcO08z8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MSaHY1VSkhdtB+I5C0OX0yBvtv7zslRRPD5Sd9rVLfzXmPbNTGSb8QsEvFwwTqeF8
	 p4SBUmcpmriH3rLMX4aj1EIU9g9Uh1ikwon94RuXb/BBSMy649NQG06NFwBqrLh+Rw
	 z0PEzKRVVluvYf1htCDOkYcTiv1gXfwsMVgjBQEHLGuddtLXM9BzlZHT6dk2qSU5eS
	 7f3iLnkjrEU5y2rVoHzM5HAbS/kGGq2VMlLzvOLuGmUDhuCleeBWDODREZ1hGaWbwx
	 ZBq07E1B48NMarpSk1yj7h5JyqvAF9ufk8UMVWhB+Tt1ad+1LobIBRpQKBjIsYUPmU
	 V4NjBeRssmTxA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v3 02/13] net/rds: free every path's transport
 data on the passive create paths
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260914033719.138057-3-achender@kernel.org>
References: <20260914033719.138057-1-achender@kernel.org>
 <20260914033719.138057-3-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 03:37:39 +0000
Message-Id: <20260915033739.CEBF21F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> trans->conn_alloc() may allocate transport data for every path of a
> multipath connection - rds_tcp_conn_alloc() does - which is why the
> lost-creation-race exit of __rds_conn_create() loops over all npaths
> when it frees the connection it just built.  The passive-connection
> exit right above it, taken when a loopback parent already has its
> c_passive twin, frees only path 0 and leaks the transport data of
> paths 1..npaths-1.  RDS/TCP loopback is exactly a multipath passive
> connection, so this is reachable.
>=20
> Move the loop into a helper and use it on both exits.
>=20
> Fixes: 1c5113cf796b ("RDS: Initialize all RDS_MPATH_WORKERS in __rds_conn=
_create")
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914033719.1380=
57-1-achender@kernel.org?part=3D2

