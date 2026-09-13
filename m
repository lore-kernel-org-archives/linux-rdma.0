Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1333B382380
	for <linux-rdma@vger.kernel.org>; Sun, 13 Sep 2026 03:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789271444; cv=none; b=BlISvt08eF6FySyiRXSwBp1Jkdsv+2lq1WNq9qMRa3j5a7y2nm6zMjzDdblslSWAdSkVuFAC3rK2HHgp/w59mtmOUHPHfbbPPnnYyPoGG7pKBjyEAh8YrZwxmttbc/ObgdwK1uZpi7eL4tpMt3wrtNbJRgtx+/Gdt6HzhUaNBY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789271444; c=relaxed/simple;
	bh=Rv8S1oxLZO3578J6wp2kcqXRikjxrjHwitptJ8+hg1g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=msqudf5miFUxjZUAOgEGg3ikNo1i4V9T3v1OPSFqrrjuo4tRUlawE4/zYf7NJcHC1/5wH5wu7ObrGr7wGYkkQFa6SAekO9PfPnw4dh1reCL++G3NyD4oZFJpYR2dJQy/C+VP9FJobw7qcexlcFyPMcXmjZltgNi6VTsFVfTObuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a/YjVeh/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a/YjVeh/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE0901F000FF;
	Sun, 13 Sep 2026 03:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789271443;
	bh=KiW2t1lo7RFOVOhT40HnUvSscc7M2mjdoluIjVLRlEk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a/YjVeh/bjqxaHw63Zxy0j5J9BzyDuwoAF6nbt0Zi/XzLo3Q3pQo4HhdloRR+z6xC
	 rg6lcU1si0QmnNGVPe1fOVQ/we2yA9j1UThFpFta/kXA8cvOUzQvIUhx0kCdO+WKMh
	 sb4/pkIcFe2/5LhVFO940FwgSOCAmTFUvEr9EUpjtwT6t2hHUeCAiG6+FWEXxWkNeo
	 uhRlsSNyKc3cJN/zjTF7pcM9xfJDyFVm9lw6ciTkjYCPR61/+5mYvo5pxRq1xvKjKY
	 LgrjOAIpMnXLK5W0mFW+b7dkhRANkH1r99qKHcDTqUGeT3O2qSVwvC1f5qifRJ23xW
	 oSt5TP5HnPwjA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 3/9] net/rds: split connection destroy into
 quiesce and kref-governed free
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260912035027.27447-4-achender@kernel.org>
References: <20260912035027.27447-1-achender@kernel.org>
 <20260912035027.27447-4-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 13 Sep 2026 03:50:42 +0000
Message-Id: <20260913035042.CE0901F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Sharath Srinivasan <sharath.srinivasan@oracle.com>
>=20
> rds_conn_destroy() tears down the transport state and immediately
> frees the connection, along with its paths and its workqueues.  This
> relies on the assumption (documented in the rds_conn_destroy()
> comments) that "no one else is referencing the connection", which "we
> can only ensure ... in the rmmod path".  However, the callers stopped
> honoring that long ago.  Today, connections are also destroyed on
> network namespace teardown (rds_tcp_kill_sock() and
> rds_loop_kill_conns()) and, one at a time, when a peer negotiates an
> unsupported protocol version (rds_ib_cm_connect_complete()).
>=20
> This leaves loose ends since references to these destroyed
> connections still exist.  Sockets cache their connections in rs_conn,
> and congestion updates will walk the maps' m_conn_list.  The CM
> [ ... ]
>  infrastructure, no rds_net, single conn hash); destroy keeps its
>  one-call external interface; holder coverage split out into follow-up
>  patches; rewrite commit message]
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260912035027.2744=
7-1-achender@kernel.org?part=3D3

