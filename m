Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166A9379ECD;
	Fri, 18 Sep 2026 05:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789707755; cv=none; b=AvYag6X7pVKWdoxsltY4O4O9OVlKcrecDyFW1SkFQpVuYoyY1hiNr388PbBLmOyv852A9oYDUT66F7vhFLMPThrKJ38Fe54zCvg364GzR+XUbmwHwpavqzbWX9iE0GIOIves+4YwK48O9T/6pHnubHhmvEJxsgMpkGDoXwO9Cis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789707755; c=relaxed/simple;
	bh=pkst9J587zKd4z3pXPBESFcxi1oZO6Ae20b4Xo9IJ9M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=t8tPqZ8QLI7Pa7GYaKDXZfA7SnTx1zP1o2zxk5Q9pPldzxF4tZG8Abj9rO5ZAmU2EKHDZMaz0YA/bcLNsHSDUuVFLtNoT/1LJ9fGi+YIWLC2R4o6A2OXV6QdFlDNZsfQZ24ejd9iaIJC5wUllR2EKA7+x5uO+1ZyjGv1k+dSCMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RjJWtCcU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RjJWtCcU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B551F000FF;
	Fri, 18 Sep 2026 05:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789707753;
	bh=T7u8SKB94D79PZQegDtf17srGE/cr+XHPJHYBqY4u14=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RjJWtCcU/VOQWDDHhdmWfV5ZbMROojLEzrUqpVUv+we86Po1UzjlWS8qT5nRDjhH1
	 F6MMCyGXUHPtg12es0YkqBWbOzDOJHX80J+rvoLjT55xZ/vVuJjWtgE0chPWedqMso
	 oubdMGKdrhRoUK1AczXSM3Um88c8u6l7X48Zg8l6qY28zMn6Bf3vPOHRhREwYk19lk
	 nBcU82zVnKDEBZa1RXqxLukBFjHRHxcgX+Z3apWbXRIc3YeX0chd+vRbd1FogyvSPE
	 n/P/VowgT7Jq4R+Oqdd7G/Q3EkK1kkmkXxnZsl9SwF3MkTAaz1oviYmovWXKjUPF1F
	 jGllC8esSEqFA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.1.y] net/smc: check v2_ext_offset/eid_cnt/ism_gid_cnt
 when receiving proposal msg
Reply-To: sashiko-reviews@lists.linux.dev
To: "Junjie Cao" <junjie.cao@intel.com>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-s390@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-rdma@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20260918045353.686837-1-junjie.cao@intel.com>
References: <20260918045353.686837-1-junjie.cao@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 05:02:32 +0000
Message-Id: <20260918050233.51B551F000FF@smtp.kernel.org>
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
> [ jcao: SMCD_CLC_MAX_V2_GID_ENTRIES does not exist in 6.1;
>   SMC_MAX_ISM_DEVS is the same limit (8) under its pre-b40584d14570 name ]
> Signed-off-by: Junjie Cao <junjie.cao@intel.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918045353.6868=
37-1-junjie.cao@intel.com?part=3D1

