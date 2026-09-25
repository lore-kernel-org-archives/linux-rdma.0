Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F79623EA8B
	for <linux-rdma@vger.kernel.org>; Fri, 25 Sep 2026 21:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790373028; cv=none; b=HAt3LbjPKh+cKgav7atTCD4kVhM0J+jCSKExgMkOY3pJjXPJJ9hrCr0dn8y8ElvD0JQCd3K0yDGMuZJlLKYJYwHWJNTOundoqaSD4kkMS9GkYdrdTDokiaILdNP/uB7HcBWZXBXVaLZIt8dAUQXgDMy8/OqoWjG+7U8w3NvWJQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790373028; c=relaxed/simple;
	bh=2Eg0D4AZaTbHd8iv0h2/I4YGhPp3dVFlk4dy0Bm4Cs8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VSyfTQoOEvH2KbBY3SVGEm83tHlfjlKkbf/YwXO3rjxDqDWm4eHC9rEZ/8cMhgKakI0KU6Ez2iTN7ACMcqqdWCHs1skOQ15Aqv7q0AQYpeELu/EZ5S0odg/3p+7ZpL88M5T/wN7Z3HKS1/iLtxW83gPulUNXD/lClWz6LIja72Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Caa+rwR2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Caa+rwR2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C882F1F00893;
	Fri, 25 Sep 2026 21:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790373026;
	bh=iKhwsHrKhMB3brylTlPtLCL2iVPnCdXrfK+HUFePY6k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Caa+rwR2pNNMm71KWHMeovb5PHXr2CePdJPl9XS8zcWZI00fso01mD0lz2ui4Rn6v
	 ht71sFuyvCXvQcaZqH3vlMqPdC3rbGTIN7GKcMCpfFS7CKKfxdwCuCMS1Gdc/mRDRP
	 KQH9vW45OvFVXH3c/uSyKi5FW+1jfJkiQDPfx5MT9IPTNrso8+5IE+ZTMJ6CucUfdI
	 d82altjyhwCQF4DQYreBsvGU1fJje0mDVDwFmVItCJ3BNtIbDlxMnvlZcX+LcMj2Q0
	 uDew8cS70YcKsTF7dhLRx4E38vWRQxc3pbVk5vcdjr26aS6eJD5wX4+HRXgcojn+vS
	 rzIPr4VOCK4QA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4] RDMA/srpt: Reject an srp_sq_size that does not fit
 in a CQ
Reply-To: sashiko-reviews@lists.linux.dev
To: "Serhat Kumral" <serhatkumral1@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260925213629.8039-1-serhatkumral1@gmail.com>
References: <20260925213629.8039-1-serhatkumral1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 25 Sep 2026 21:50:26 +0000
Message-Id: <20260925215026.C882F1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] ib_srpt: UAF in configfs store due to hot-unplug race
--

commit 1f57db75193afbb14a2edb4aa5126369171bf0a9
Author: Serhat Kumral <serhatkumral1@gmail.com>

RDMA/srpt: Reject an srp_sq_size that does not fit in a CQ

This commit modifies the configfs store function for srp_sq_size to validate
the requested size against the device's max_cqe limit, preventing continuous
CQ allocation failures that can lead to memory exhaustion.

> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/u=
lp/srpt/ib_srpt.c
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -3603,6 +3603,8 @@ static ssize_t srpt_tpg_attrib_srp_sq_size_store(st=
ruct config_item *item,
>  {
>  	struct se_portal_group *se_tpg =3D attrib_to_tpg(item);
>  	struct srpt_port *sport =3D srpt_tpg_to_sport(se_tpg);
> +	const struct ib_device_attr *attrs =3D &sport->sdev->device->attrs;
> +	u32 rq_size =3D min(attrs->max_qp_wr, MAX_SRPT_RQ_SIZE);

[Severity: High]
Is it safe to unconditionally dereference sport->sdev->device here?

If an InfiniBand device is hot-removed, srpt_remove_one() drops the driver's
reference to sdev, but configfs items created via srpt_make_tport() can hold
additional references, keeping the sport structure alive.

Once srpt_remove_one() returns, the IB core drops its reference to the
ib_device, freeing it. If a user writes to the srp_sq_size configfs
attribute during or after this process, couldn't this access the freed
ib_device and trigger a use-after-free?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260925213629.8039=
-1-serhatkumral1@gmail.com?part=3D1
