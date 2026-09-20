Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795D33DC856;
	Sun, 20 Sep 2026 05:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789881868; cv=none; b=PWu9xiaDXtfVHy/qvOvsY4G10ZEN34jSyLKeFiCDhOSwumGdmJQvEZs+a8d1hQROmgwQUrF/V4NUOU4W1ySlOusrp2wQ1QB+nEEhWgg0IebHbOPpIE71yaUzNXXlpZQ4gKECLT7bSFKMcb4fs9+sieQImHNxD/ABZXSwL5PwqmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789881868; c=relaxed/simple;
	bh=G8sqJ5CuFXzowQbaxpc0aRbWTCKMGRAMzBAXWAlA4rg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=g5nJnVkT6seYyUr+L1lv6f3tdhUpFDcjDjUA9PDGQLFaY+5gvH5OCBxRfJ/3JEzWMhn+x2Ng4TSaUecZ1il4nH7YO+MUsOgWaH4ep5FXEMQ1BSArhC5mwtpLiVlVVW7WOJ+2XrHtAB360rLtbzpfrsePkmnhkz4B6ZBtVxjXokM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gsmqp9Lv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gsmqp9Lv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F7F21F000FF;
	Sun, 20 Sep 2026 05:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789881865;
	bh=7pTXEjq1ZKz6Dn+VLsGRTdOf0MDMfWAt0QgEmehyCRU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Gsmqp9Lv2RsFTpM9xXqZbF1JT9pVEHtLEIfu6RIrcc+NvF9cHKTG9xlgD2QIQ/uLE
	 31KOCcl947wdA4kS+tMWhgZYaVEqG7SgaWT2m/hRiZnAhCQEhEeGU3fcWoekQoeMzr
	 40IPVyNJ3QsRXtEZX0S5q1s3Eo0igoabfKkH/NsR8cB2g5Sbhk0dBSQbd0c/7kN1fY
	 nCxdaqfxdl1TIK1WdPp1oLtd/dyeMQwiHom6RrEE4Rn/2ZbYNWEBNVawrILgJlDNg1
	 H7ifJbt+1doEvLdp6Cl6VQsCkYvrDmPRmFaOwgtsiihbBdJJCOOgaEqLO6oz17fxT0
	 sU4RAu+aQhTHQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5.15.y] net/smc: check v2_ext_offset/eid_cnt/ism_gid_cnt
 when receiving proposal msg
Reply-To: sashiko-reviews@lists.linux.dev
To: "Junjie Cao" <junjie.cao@intel.com>
Cc: linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-rdma@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20260920051336.712097-1-junjie.cao@intel.com>
References: <20260920051336.712097-1-junjie.cao@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 20 Sep 2026 05:24:25 +0000
Message-Id: <20260920052425.7F7F21F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Guangguan Wang <guangguan.wang@linux.alibaba.com>
>=20
> commit 7863c9f3d24ba49dbead7e03dfbe40deb5888fdf upstream.
>=20
> When receiving proposal msg in server, the fields v2_ext_offset/
> eid_cnt/ism_gid_cnt in proposal msg are from the remote client
> and can not be fully trusted. Especially the field v2_ext_offset,
> once exceed the max value, there has the chance to access wrong
> address, and crash may happen.
>=20
> This patch checks the fields v2_ext_offset/eid_cnt/ism_gid_cnt
> before using them.
>=20
> Fixes: 8c3dca341aea ("net/smc: build and send V2 CLC proposal")
> Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
> Reviewed-by: Wen Gu <guwen@linux.alibaba.com>
> Reviewed-by: D. Wythe <alibuda@linux.alibaba.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> [ jcao: drop the af_smc.c hunk, smc_find_rdma_v2_device_serv() came
>   with SMC-Rv2 in e49300a6bf62 (v5.16); take SMC_CLC_MAX_UEID from
>   fa0866625543 (v5.16); SMC_MAX_ISM_DEVS is the pre-b40584d14570 name
>   of SMCD_CLC_MAX_V2_GID_ENTRIES ]
> Signed-off-by: Junjie Cao <junjie.cao@intel.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260920051336.7120=
97-1-junjie.cao@intel.com?part=3D1

