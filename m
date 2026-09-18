Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D2C33A9F8
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 07:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789717227; cv=none; b=EQJ77WiCD8JATPo9ZqZhm6SpssA0yCb7l6JK/tM00Fp9NGov5bmJSB0npIJu/HYDc7RXUMaSp9InQLUrqcYfzYp3YPSy5J5oPsTdWDafas+FURM7jERajaXPldrEtgik120MBP3OHPVVa4erE1J1JJShSiKBA3nkWNQFLpBRcbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789717227; c=relaxed/simple;
	bh=UQ9XNF/DcCB9gIX34GiXcjPLtZz10kW00f3tL8yn7mc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BmiPA8N8vaBAKksoeOW3y4KGVTEfrUCzEMDbRSxrWR+RwylvGRnRFOjPxD1jGC52FPpK/TarEIVulV0o8MzyHhVnapxw3Vnxm6ICPFkB2Ua41Vfl1OpnRfSF1g9ogdPS7v7zTd6EiPXCV2gtwP/1bALHgkKAvLTthtq/BgkjJK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BXJmMZFh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BXJmMZFh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21991F0089D;
	Fri, 18 Sep 2026 07:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789717211;
	bh=CqYDxH8kjNZGlmarR6KTGlHRcFE3R4VD/eZr6JQMGbE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BXJmMZFh22fkFJ05mZBdOSr6+DkzqRIvpwds8onz9LNZgYTdIDzrm032kOeP0i7EA
	 v05bACHtEQphWgQHLe9V1Bp1uBu+58XcIxsVG4Tqz4CVJjI6+qUFndYjEBCxCSULaZ
	 8CpKoyHCKnOW2uAB6jFMGGc1SA0ut0OckLP7GIftwvbuO81Zx8wrgUm5h+JSnwnjyE
	 u95iOGvfGL6WSq6LVyFi+JxuJkbNwLJsEg8VSdscRCNM7iLd53wVhIUJTjjCGN2Cac
	 6HGWUOIWXXOSh8+JOkO5tFkaPZT7NQLD2FDh6X8Yatiec4XcqwJTQ3hpvfxida2yUX
	 6P1XqK4+l4wFA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v4 08/12] net/rds: hold connection references
 in lookup, sockets and c_passive
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917073958.174056-9-achender@kernel.org>
References: <20260917073958.174056-1-achender@kernel.org>
 <20260917073958.174056-9-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 07:40:10 +0000
Message-Id: <20260918074010.F21991F0089D@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917073958.1740=
56-1-achender@kernel.org?part=3D8

