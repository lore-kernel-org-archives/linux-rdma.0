Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67CF4563FC9
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 16:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790093685; cv=none; b=pch4Yvc4+9zyQtZFUTRqyMMufyPlESuWD+UPY3BeNqWoV31htsPmi3Omo9a+cIXHM73GkfW47UTG3pIbLLG8sifuesDV8zWoAzXpzWJ0vd7OvF/sh3xruGuKkGmFgo7bJoDMPUpb/qjPgZA8YfCNiGtDW9Odqjze8qTuhyZ/gJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790093685; c=relaxed/simple;
	bh=IPFmWL/hwaM8Egssg2bWoFOxaU0nToukX4N5j5ID6VA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VvSGbbtDRmMYvLb2ilvcmbxjE4kAwx5p0Mdtv0wYp7wxjmgjCpl+6osbKpXIvBcFQV7D/LTRKmCDlsPIJfnVAjLnB3olof2RkdOGspCfv06Ylm4FuNwQ6swE+HC7ABWh/hywRiyRVgul/OOVL0g/xprNIRpMijkndRFEg7/94/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ovzUzEHi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ovzUzEHi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB48B1F000FF;
	Tue, 22 Sep 2026 16:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790093684;
	bh=UtguKw40XA/X1c8Z0zczY6paBywKvjtz3IJDAxirc6E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ovzUzEHiYW3co8YoS5eodR4Z5+EDXRcUalI0mAioSVEvLp29FH7yYNrPsKP/D9ve/
	 k20CxQ4VdjGZtuBpsFdCS7w1i83we7shZ1G2ZP45669NyzA61Ho+yqZpvje+t6wpVX
	 OlZvatQBRbzbbbsc1ZhnN0/duE7OYfhFphvFaK58XgD0pc1LDj1JEawi7oCdH59v9P
	 AUKJiyYUuUHNpMRbOpK4QgrXRBhD1/DCgbLs2+hSHTrleKQk20DdJBeYOnaCTaTosk
	 mK3ENYUhMnhMInm1xWK9+fFzHiDWmKVG1ScuzUJZbowlakMOg4ttxVq1fD9ukfDIN9
	 FtjOeUL6nAwZg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-next v3 2/2] RDMA/efa: Pass relaxed ordering flag to
 device
Reply-To: sashiko-reviews@lists.linux.dev
To: "Michael Margolin" <mrgolin@amazon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260922160118.990-3-mrgolin@amazon.com>
References: <20260922160118.990-1-mrgolin@amazon.com>
 <20260922160118.990-3-mrgolin@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 16:14:43 +0000
Message-Id: <20260922161443.CB48B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] efa: missing firmware capability check for relaxed ordering
--

commit 8cde16309300638ef5ed5570f8cb4ae347e5c6e6
Author: Dana Malachi <danamala@amazon.com>

RDMA/efa: Pass relaxed ordering flag to device

This commit accepts the relaxed ordering access flag during memory region
registration and forwards it to the device firmware via the admin command
path.

> diff --git a/drivers/infiniband/hw/efa/efa_com_cmd.c b/drivers/infiniband=
/hw/efa/efa_com_cmd.c
> index aac0e936601a1..07bfcb093df85 100644
> --- a/drivers/infiniband/hw/efa/efa_com_cmd.c
> +++ b/drivers/infiniband/hw/efa/efa_com_cmd.c
[ ... ]
> @@ -236,6 +236,8 @@ int efa_com_register_mr(struct efa_com_dev *edev,
>  	mr_cmd.mr_length =3D params->mr_length_in_bytes;
>  	EFA_SET(&mr_cmd.flags, EFA_ADMIN_REG_MR_CMD_PHYS_PAGE_SIZE_SHIFT,
>  		params->page_shift);
> +	if (params->relaxed_ordering)
> +		EFA_SET(&mr_cmd.flags, EFA_ADMIN_REG_MR_CMD_RELAXED_ORDERING_ENABLE, 1=
);

[Severity: Medium]
Could setting this bit cause memory region registration to fail on older
firmware versions?

If older firmware strictly enforces the MBZ (Must Be Zero) rule for bit 6,
it might reject the command when userspace requests relaxed ordering. Since
there doesn't appear to be a check against device attributes or firmware
capabilities here, does the driver need to verify firmware support before
passing this flag down in efa_com_register_mr()?

[ ... ]
> diff --git a/drivers/infiniband/hw/efa/efa_verbs.c b/drivers/infiniband/h=
w/efa/efa_verbs.c
> index 6356872753507..9e4435401a4c7 100644
> --- a/drivers/infiniband/hw/efa/efa_verbs.c
> +++ b/drivers/infiniband/hw/efa/efa_verbs.c
[ ... ]
> @@ -1679,6 +1679,7 @@ static int efa_register_mr(struct ib_pd *ibpd, stru=
ct efa_mr *mr, u64 start,
>  	params.permissions.local_write =3D !!(access_flags & IB_ACCESS_LOCAL_WR=
ITE);
>  	params.permissions.remote_write =3D !!(access_flags & IB_ACCESS_REMOTE_=
WRITE);
>  	params.permissions.remote_read =3D !!(access_flags & IB_ACCESS_REMOTE_R=
EAD);
> +	params.relaxed_ordering =3D !!(access_flags & IB_ACCESS_RELAXED_ORDERIN=
G);

[Severity: Medium]
This passes the userspace IB_ACCESS_RELAXED_ORDERING flag directly into
the command parameters in efa_register_mr().=20

Should this be gated by a capability check so we don't inadvertently break
MR registration for older devices if a userspace application unconditionally
sets this access flag?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922160118.990-=
1-mrgolin@amazon.com?part=3D2
