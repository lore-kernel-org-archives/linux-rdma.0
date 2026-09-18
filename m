Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78393DBD65
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 09:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789724230; cv=none; b=Lf+pcsI6syJMhEFATRJ408E/500QTWGdiKmDdcOVn1nYswOIgS0VfEwFYLLYXVaENeXQwYDugT4weE+VhjPJlWV8rx98RDNmBLF6ydvLEm0MF9UxpVh7XAULsmFOHvUzD8sbfY55dZUdzkyRYjZiclcEcYrJ4KKNFuwY81dQtZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789724230; c=relaxed/simple;
	bh=RzKsAbLMyo+3PPDlIUyKLJjMzpgz4b6j+HGaiFGD0iQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=u29uCEkr0lyewktlYk48oGSCsyQsanbk8U2A2c7IE8ICYvbbqF/JN0lR/+eoOGxYXpog9kUdA/n8wcyT6+yT2WhO6v34btEm9js1DBPoTAQPRA2HRFKrlpU/0SQJQZU2M98W7ZuWOyzZGvEBlx0VniWpD6sWYuN7UAg/7+ElFIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=epqaKcHK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="epqaKcHK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2619A1F000FF;
	Fri, 18 Sep 2026 09:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789724229;
	bh=c4J+rk8KVQ3YRFvr2EeT/A6eV3ojofkk1xWtDV93ymc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=epqaKcHKBvGqG0Q1oqe0lCoT6ce6ep96iEfhtZ1hCGdvukV55b0HHOhj9nuEa8lC5
	 RzEcXWmkuvLW0UFEv2eXG8LFfukrJGIo8LVa4g30QN/ylnQ/FLKYAcjIORTA7FZOxk
	 YMNocpDd39WgJQ1AcWXDA29Ws5t9ujL2uxLFKTk4oaBvxWYnxOdjtwMR86C5dUd42k
	 lYD4kpZ+q0I41q7oMXLcXCN/HPeGbnUrL41DW0DRwYZn90ne7sp1d9Q6PtVoIRrWee
	 naOY1kvHJuxhchsE+I0b3x9OWMcC2GEvS+i5ZFJ6Smeiwp6TcQnLz17ApvJgf8SOC8
	 BRVhETmAB77UQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] RDMA/mlx5: Use DEFINE_RAW_FLEX for leftovers flow
 attributes
Reply-To: sashiko-reviews@lists.linux.dev
To: lirongqing <lirongqing@baidu.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260918092337.2338-1-lirongqing@baidu.com>
References: <20260918092337.2338-1-lirongqing@baidu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 09:37:08 +0000
Message-Id: <20260918093709.2619A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Li RongQing <lirongqing@baidu.com>
>=20
> Commit e91fb8b9d0ed ("RDMA/mlx5: Avoid flexible array warning") split
> the leftovers_specs[] array into two separate structs to silence the
> sparse "array of flexible structures" warning, but in doing so reversed
> the member order: eth_flow was placed before flow_attr.
>=20
> _create_flow_rule() locates the flow specs with:
>=20
>     ib_flow =3D (void *)flow_attr + sizeof(*flow_attr);
>=20
> which expects the spec data to immediately follow the ib_flow_attr.
> With the reversed order, flow_attr is the last member, so ib_flow
> points past the end of the struct and the num_of_specs =3D 1 loop reads
> out-of-bounds memory (whatever static data follows in the .data
> section), producing incorrect flow rules or a crash.
>=20
> Rebuild the leftovers attributes with DEFINE_RAW_FLEX(), which declares
> an on-stack struct ib_flow_attr with a properly sized trailing flows[]
> array.  The ETH spec lives in flows[0].eth at exactly the offset
> _create_flow_rule() expects, so no layout-dependent composite struct is
> needed.  This also avoids embedding a structure that contains a flexible
> array member as a non-last member, which would trigger
> -Wflex-array-member-not-at-end once the warning is enabled.
>=20
> Fixes: e91fb8b9d0ed ("RDMA/mlx5: Avoid flexible array warning")
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918092337.2338=
-1-lirongqing@baidu.com?part=3D1

