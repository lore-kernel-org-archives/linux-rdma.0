Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708243264C2;
	Mon, 21 Sep 2026 05:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789968026; cv=none; b=NnG804R1Hmhng3CZ29AFaxBmEUyUg64sbNi+szlZE3UcPKEHNOCBq0BZu0wPFotn08bschyU2+gGiPhgKoByS99upC5G/0voi3YLoTXjmKu/PTwJmoQ00m6tgnW7fKmpDjYaFpmKarcAJ+6q/J8fdw21M3cPTUbwQEfIu22FvhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789968026; c=relaxed/simple;
	bh=TfKqkYOGgFjGbzFDhRj9zD9ndjrzDWeoCIlBCe+moi8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SssFOLVJgzC1JXbUx2i2SdtxU3N9jjbUckD3DC2PMg/LAkLI0KD0coe1F8UPHWlim/klbW0ZwdgiUmQ0x/FTFqCMe2yZeq89ePyN0PM7pACMkCDXkmexc90YwBgPORBkXhpNYhpQ83zmgjyt7xYKOaq0DtwIqzOncbtkN1s4wBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AytWB3Fy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AytWB3Fy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E7A1F00893;
	Mon, 21 Sep 2026 05:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789968025;
	bh=UNNVU/1YgDP66oKAl0Z/oXJwDiO7Et0GHhTzOCcHbWg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AytWB3FyZzwrmIk4wCjgJSgUkfG8EccZlBpzXmYYMG70DhY0393np/3ucVwJdWBfP
	 V9PQ4dyMddmu3VWUQT7FOiLqtbe+lC9IN1L81TqywqZSswSgZ9UkD8buY2BaM7/p9h
	 Xq8bQvR+tD6e0XTmTRYt3CzgS715sHdiKE+ERtEBmLkKFUeXhYw7chuPlV4x3htPaA
	 cIbAHxRng21CqSVxBbq1weW48pQ2P7pVPfWIvoPBT/9yPxsshW9kSaHzWz/W3W18yH
	 T0DyR4sNS7W5ptOmMDtT8txlDXuneW2Bflv1ZMKHgcBFcyhACFA8EVaJUUL9fKyrPa
	 JbgVQH/7CK6RA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5.10.y 1/2] net/smc: check smcd_v2_ext_offset when
 receiving proposal msg
Reply-To: sashiko-reviews@lists.linux.dev
To: "Junjie Cao" <junjie.cao@intel.com>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, linux-rdma@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-s390@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20260920051403.712116-2-junjie.cao@intel.com>
References: <20260920051403.712116-1-junjie.cao@intel.com>
 <20260920051403.712116-2-junjie.cao@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 21 Sep 2026 05:20:24 +0000
Message-Id: <20260921052024.C1E7A1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] net/smc: protocol regression in SMCv2 proposal parsing due to stat=
ic max_offset
--

commit 32692cd08a75040e1005cf9b8d09a85a6a7acc74
Author: Guangguan Wang <guangguan.wang@linux.alibaba.com>

net/smc: check smcd_v2_ext_offset when receiving proposal msg
   =20
When receiving proposal msg in server, the field smcd_v2_ext_offset in
proposal msg is from the remote client and can not be fully trusted.
Once the value of smcd_v2_ext_offset exceed the max value, there has
the chance to access wrong address, and crash may happen.

> diff --git a/net/smc/smc_clc.h b/net/smc/smc_clc.h
> index a57a3489df4ae..f7f656b297f9c 100644
> --- a/net/smc/smc_clc.h
> +++ b/net/smc/smc_clc.h
> @@ -306,9 +306,15 @@ smc_get_clc_v2_ext(struct smc_clc_msg_proposal *prop)
>  static inline struct smc_clc_smcd_v2_extension *
>  smc_get_clc_smcd_v2_ext(struct smc_clc_v2_extension *prop_v2ext)
>  {
> +	u16 max_offset =3D offsetof(struct smc_clc_msg_proposal_area, pclc_smcd=
_v2_ext) -
> +		offsetof(struct smc_clc_msg_proposal_area, pclc_v2_ext) -
> +		offsetof(struct smc_clc_v2_extension, hdr) -
> +		offsetofend(struct smc_clnt_opts_area_hdr, smcd_v2_ext_offset);
> +

[Severity: High]
Does this static calculation ignore the dynamic size of the flexible
user_eids array in struct smc_clc_v2_extension?

By not accounting for the user_eids array, max_offset appears strictly
limited to the case where eid_cnt =3D 0.

>  	if (!prop_v2ext)
>  		return NULL;
> -	if (!ntohs(prop_v2ext->hdr.smcd_v2_ext_offset))
> +	if (!ntohs(prop_v2ext->hdr.smcd_v2_ext_offset) ||
> +	    ntohs(prop_v2ext->hdr.smcd_v2_ext_offset) > max_offset)
>  		return NULL;

[Severity: High]
Will this falsely flag valid offsets as out-of-bounds when the proposal
includes user EIDs?

When an untrusted remote peer initiates an SMC-D v2 connection proposing
one or more user EIDs (up to SMC_CLC_MAX_UEID), the packet may be
correctly sized and well-formed.

However, because max_offset ignores the flexible user_eids array, this
check returns NULL and drops the capability, breaking protocol compliance
and interoperability with SMCv2 peers that use Enterprise IDs.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260920051403.7121=
16-1-junjie.cao@intel.com?part=3D1
