Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F0B33469C
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 07:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789717223; cv=none; b=uHkABTWeJ/i0IJwsXCcrm4zyVuySGodGrYmosyAF/i0NP2K36cUWJ6Sp3QjiYuRVq3SpgRqJAQHV3f3lr325zMKm/fIVJHS40zOkbfhEH9yeuw1KJKR1LoQ7rdQ5kDdi04rwdMfOz7C6HKKQu4/926/TLJULRDgN0LBPuzXDNY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789717223; c=relaxed/simple;
	bh=NlgM6KIEhtBO+iKvu9BJOEIDc+SKp7upEkJfNJ7z06c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GcQ6rzDg6WuJDXushi3dLHAQ12/uNeozkz2U23ZLUTDFR4iRyQUz2S1TsRGlCL1jmNpGGlimUwAy/u88n5mO5Ip4mzZQ4vP66CZmUsmwOjEYAFXxzRPK2xv0B/AoOtsOOxZI5xIVFB7TQ6mGRveWEsgP2mVaSkiHjY61Puim6pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iBUPVbOA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iBUPVbOA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 540C41F00899;
	Fri, 18 Sep 2026 07:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789717208;
	bh=H2YXu3cfH2HFGwhBld/9XOLhFkilfhn+SqdSMGJi+k0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iBUPVbOAwZ8/JR3kE7BGUKYdp4FgzG66o4xpiPd4/menoZDf6myv9LgA9lWCAyWvo
	 y3V/BPqOsUCOt36fPYauAIdJfg6YwiyIWtms+JiNNWVKofeHEA2/8+HJQydufZ2EDr
	 9B8zao2Wj9/XAWtQtzm2eanFVLvkCShIoJIjd2YEN4kchFbmJBL6JN8Nyy/YwglA/7
	 jhauIEvMr6WV8KE+HU5VvNUz1xBbfgq+Fz3XT4Zp7puauKyHD/j8sZVQt/IpIBm4Ug
	 0EZOVJT4Ed+QNsIZYNeGeJ9KmJnTqK2qLarxc4r05zFgijXuxFwGKjIWWQmELpyW4v
	 ZfFcM3aIgyg/A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v4 02/12] net/rds: free every path's transport
 data on the passive create paths
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917073958.174056-3-achender@kernel.org>
References: <20260917073958.174056-1-achender@kernel.org>
 <20260917073958.174056-3-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 07:40:07 +0000
Message-Id: <20260918074008.540C41F00899@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917073958.1740=
56-1-achender@kernel.org?part=3D2

