Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B87537A836
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 03:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791430341; cv=none; b=lTyJhtPQrRw8I6QJQwhMNbQ7v1Qc3aqT2wOo5TwAsIPy3nj6K2yccaPfa9Ws92TVdtXY52ttPYpe+/Y77SeShEDRUNLIu65xgfg8IQRa0YH62i2tiRuYuZlD9fHuawmiF1SuT6EOxNQh0tUNaMDOze4jYRkExMI3LqSTQvS0bHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791430341; c=relaxed/simple;
	bh=vlsGaqP6pgp3f2Bl3sehMw3DmWlSUEs9KqgIiFrKOdg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=oXol4HM9YChbH8hyL+h310JnERseg9XOUl27HT01oJlo1ojiPhzv4G/RzUxxI4+AT5JTETnHjB5RS+kM9U5aco2hq5MT7UCi2Ny1rvogh0z8uLZ8J6v9OhHNQSxKwMvPOnzWQ5CNC1OPRWsA1Aul5Li7Wn/O9EEmIEt1Ozag+lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I40kSfl1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I40kSfl1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCD81F000FF;
	Thu,  8 Oct 2026 03:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791430340;
	bh=itBENq34ikExWHil8gKxmBi8PLpse2fBU6cWEn42DkU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=I40kSfl1GjbDBtm9975xQFImtFpmd+MgcmuhLwGoU6oQeage74SkiK1uuiie4K+Vy
	 KBF6kkVjNckJlBrIYxuIm+ONBW/z3c7e7DBeU+H3gFKH80bS938uTbJ+cR1EiR6KZj
	 6RptNrsJS1oA8BiHO2UrjKWBo2znf10lsZqdOs34/TUthVaGedvHbzz/tvo7gxucMx
	 Ry4dDykN/K//FlpBzNlFLg8YqlXK0NpeC4M11H0B9jSdvYX2xFW/oFYBhvm5RAW1Vi
	 WTBulxhofRYUWkmUqI3jB/NSYIFZZOh18xxwtVRHkv+nrgc1TrkyancCVeVTb71T66
	 rQG/UK/vZaCoQ==
Message-ID: <sashiko-outbox-163551@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v9 11/13] net/rds: hold connection references
 in lookup, sockets and c_passive
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261008031333.1142174-12-achender@kernel.org>
References: <20261008031333.1142174-1-achender@kernel.org>
 <20261008031333.1142174-12-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 03:32:19 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

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
>   rds_sendmsg() itself holds a reference for the duration of the
>   call, during which reads and updates of rs_conn are serialized by
> [ ... ]
>  them synchronously before the final put), and the sendmsg cache is
>  serialized with rs_lock instead of UEK's socket flag; rewrite commit
>  message]
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008031333.1142=
174-1-achender@kernel.org?part=3D11

