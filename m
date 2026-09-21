Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B79352037;
	Mon, 21 Sep 2026 05:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789968025; cv=none; b=njwDgXOpiCGvhrdLMlAiHVdtyOuWSXblScpUg+/IG2PTNRS04UeePZaTtsPiCmN85mqmxPFuyjVoz3HPjRjQspcOuZ1dsQt9T1fX35jdy17F/uTGzDCIwr7TUTq8/d36X6dW0M7FVK3vqqLqAwKdHz/MpfglyGAyhjEkp8JFowc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789968025; c=relaxed/simple;
	bh=kxCl/oyJ21JIYPfNVWYB29HSrClTiorIx6qhAun/hUg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Is4sIY22Ik1keIV+z51gzVk+wR/KvZDEzgw7PLvc8R3D08bFcuXmdZ1lxVn89TQjSUqu03oObloY/iQQ+rgMJPdfagm26zJy0dZg3lkxxGmiZ1phnGYQgidJ8AqnbFGv4+T9AZJCQeuytFqd62dgnnU5p8DP3kE2qTaFxsZbUeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m5YgAhdH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m5YgAhdH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6DD1F000FF;
	Mon, 21 Sep 2026 05:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789968024;
	bh=ZFZyGOLkK7sbGRNvJ8q5/tXz+eReaW2dCnHlzM5CKlY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=m5YgAhdHvbLa6UwYanNtwyiWQU+Pn7KsG/qsY+Xn8eaBU1joGv1ehL//M0f04OZ7f
	 GkasqS2TraZOfxwCcEbABZ7q9jebfvM/0C9CzwECHQw+0vAYuPkE8BXRAM5DwN86fK
	 4n4NobRJnagUcVJBSo/dLyVklTqKnFWuLZhqWS/RIjEKgEnKCCfl0+Gc24MFX5AP3t
	 Pt7EJSuyOfGSLWIRZp4vHUdQthiAy3bSojHXfdzvuufmclyZokDHiB1/g4Fy094Oux
	 zliIm56GYLoyCudBLTZ5YqQJWd6pOARIJ9HInfx2+zYMRSjax2u1tNAiBjX+RfP9PS
	 WT4Ros1YfGhfw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5.10.y 2/2] net/smc: check
 v2_ext_offset/eid_cnt/ism_gid_cnt when receiving proposal msg
Reply-To: sashiko-reviews@lists.linux.dev
To: "Junjie Cao" <junjie.cao@intel.com>
Cc: linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20260920051600.712147-1-junjie.cao@intel.com>
References: <20260920051403.712116-1-junjie.cao@intel.com>
 <20260920051600.712147-1-junjie.cao@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 21 Sep 2026 05:20:23 +0000
Message-Id: <20260921052023.DC6DD1F000FF@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260920051403.7121=
16-1-junjie.cao@intel.com?part=3D2

