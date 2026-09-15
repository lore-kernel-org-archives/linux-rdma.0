Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65D4425878
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 03:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789443462; cv=none; b=CICNPcmxeExAI4o3FjTcBu2kHoeI+7wG8cKzZymnbtAk9IkkOcpQQ4ai8NWc1hpSgEkTogCdbMc/lB09ug196jPnRMeDTrpAnHi9vY2jO2DSJ97HaDR6yRqWeSdYP3AOCoQlChQyizzo7SHBSN0Jg7bGrT42O7V+DoP7BPxdIpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789443462; c=relaxed/simple;
	bh=pId10cakWljucZOBFurH7zLeD0tYOg9MokoRO2t6gko=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Jm5YgG6sh3Bk1QWoEfAzwJGmFuA29+MHRIaemOtxEPFGwJ+19zVPl/Vzcnb064CYcFa6czug4nsO1WX0qaKi+MfRcrp5gEPzf9fwBMphsLcQwLdvureMiK8gssOILwI0zJOGYr8quAwSt/77bTT9W38FKUqpA3EBnlunYC5VOSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RBLJq6Ar; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RBLJq6Ar"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B601F00893;
	Tue, 15 Sep 2026 03:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789443459;
	bh=ks8IzojWC+6p0QomDEIQkxh2K3tR6DUUhtxnueEWvH8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RBLJq6ArKK2hlhNUEeW0OWxeG1Dpn6fIL/dDhR+gAbvd0om4xFok/HfBg5XbrSlFg
	 IrXEwcpSeJQNEh3pHMchxkZiI3/skQff072hJ4pTi6X8RQk88d/sglIGAmu4qoZX7q
	 roQbgLbS2Z7Z26frNDZfnEWgsv6rQ7lmvaiRnU4TEMe0aWyHo/EgTMpzMmW2Flx37X
	 RTtfIqeNwwLO9d4FSHlKNpJFNav0DePunStQF1S7OypWCDtV7CwM8wTJDiii/iJ08t
	 QkRoSLc+aN0YoKPkhWjnZWJiJOvud1Fv64GeWriq9DWdCkg0yLRtLUrxKY9RsCjTmX
	 VKxQdQBTjphVA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v3 08/13] net/rds: hold connection references
 in lookup, sockets and c_passive
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260914033719.138057-9-achender@kernel.org>
References: <20260914033719.138057-1-achender@kernel.org>
 <20260914033719.138057-9-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 03:37:38 +0000
Message-Id: <20260915033739.45B601F00893@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914033719.1380=
57-1-achender@kernel.org?part=3D8

