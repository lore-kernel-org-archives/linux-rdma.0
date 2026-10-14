Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EEF0377A87
	for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 22:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792017830; cv=none; b=Gk4ZVrwEYY2dtu45J+ON3p+acs7BdfLjjlCCjYaleMeO0nAiKqY7qhwamqhHV0KXS3amYZAa3PauEd8B5cLMZYmKhxrL7c+j6ypknVU3sG3AlWx2GNrl1txKODfWIWxEt7wrHFuOTu5b0eqT9ikh/PqE8Y9IkU1aT/a4D3bRdmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792017830; c=relaxed/simple;
	bh=rUo0u/wZSSlwOLtiyGSv/AO7CC40zmxKLKk2wdpkUNQ=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=ZI2fV3WfZge8R0/xfSmFjJ2J/ZW+woSs2BcuPJ1npMb1ZvtPHZIoIrj2nFV79gv3eRKm/TyYwVFDv0W2SoKgYyRXoMEgcYKNzLOCqWTeZpoidSbiiYAtcbPVyxjT9HGYb/P6jvcNZhgjRIouHKdblNlZQzZ5fU/wKNFLW1Q162Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UyS7/NO6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UyS7/NO6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9CC81F000C4;
	Wed, 14 Oct 2026 22:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792017825;
	bh=Sgj9s30XuDKD8w0KwE/6vjN5B33lkgpjvZFp/n8o1zc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UyS7/NO6m/NZyFCIflh1r8x7mQb8OyPMqIDOB+oCo7d4FhRYV6RyNatGVLSKgVDdN
	 FH00LQ8BOHYfF2rI6Z9nwjKgR04sayMSMsDFsTeQAEQnlMYtKVNDNHeW2Bu8JbgdZo
	 ueX+ZC98+tjxqOTABBuHwLz2pkGHQA/wQJssC54l4DlE+oYGpW9jmiC6tCBcn+CvtI
	 WypttSWlzHJo89r/O3Flj+KGjWvBnFMTYq5ESvCcBkvNS3g3i3Z6g+13Cc0GWzwHhT
	 tn9b0kdvyUFDhZtJWS59RiQ6ZGHZcfVJCjJM7prM/lTrVeE4YSuqAPeQ4cvvjIWYe2
	 8Zj3XFCl+xrbQ==
Message-ID: <sashiko-outbox-172001@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 04/13] RDMA/core: add the reliable unconnected
 queue pair type
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Davis" <eric.davis@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261014-uet-ib-core-v1-4-a0e626117113@broadcom.com>
References: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
 <20261014-uet-ib-core-v1-4-a0e626117113@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 22:43:45 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] rdma: missing state transitions for IB_QPT_RU break QP modification
- [Medium] rdma: missing IB_QPT_RU validation in legacy ib_uverbs_post_send
--

commit dcd2780ae82f1b92d760ff7dc346585d88f3a3f7
Author: Eric Davis <eric.davis@broadcom.com>

RDMA/core: add the reliable unconnected queue pair type

This commit adds the IB_QPT_RU type and its userspace counterpart. It also
defines the field layout for a reliable unconnected queue pair number used =
by
UET, and exempts its full 32-bit width from the usual 24-bit restrack
assertion.

[ ... ]

> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 02f3312c7cf24..8d74ed4fc581f 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -1188,6 +1188,7 @@ enum ib_qp_type {
>  	IB_QPT_RAW_PACKET =3D IB_UVERBS_QPT_RAW_PACKET,
>  	IB_QPT_XRC_INI =3D IB_UVERBS_QPT_XRC_INI,
>  	IB_QPT_XRC_TGT =3D IB_UVERBS_QPT_XRC_TGT,
> +	IB_QPT_RU =3D IB_UVERBS_QPT_RU,

[Severity: High]
With the addition of IB_QPT_RU, should it also be added to qp_state_table[]
in drivers/infiniband/core/verbs.c?

Currently, because IB_QPT_RU is omitted from qp_state_table[], its
configuration logic zero-evaluates. This causes the core helper
ib_modify_qp_is_ok() to block all state advancements for IB_QPT_RU QPs, as
the implicit 0 values flag any transition parameters as invalid:

drivers/infiniband/core/verbs.c:ib_modify_qp_is_ok() {
    ...
    req_param =3D qp_state_table[cur_state][next_state].req_param[type];
    opt_param =3D qp_state_table[cur_state][next_state].opt_param[type];

    if ((mask & req_param) !=3D req_param)
        return false;
    ...
}

For example, when transitioning from IB_QPS_RESET to IB_QPS_RTS,
ib_modify_qp_is_ok() checks qp_state_table[IB_QPS_RESET][IB_QPS_RTS].valid,
reads 0, and returns false. This causes the driver to reject the configurat=
ion
with -EINVAL.

[Severity: Medium]
Since IB_QPT_RU is an unconnected queue pair type, should
ib_uverbs_post_send() in drivers/infiniband/core/uverbs_cmd.c be updated to
account for it?

Currently, ib_uverbs_post_send() only checks for IB_QPT_UD to identify
unconnected QPs:

drivers/infiniband/core/uverbs_cmd.c:ib_uverbs_post_send() {
    ...
    is_ud =3D qp->qp_type =3D=3D IB_QPT_UD;
    ...
}

If a send request is posted for an IB_QPT_RU QP via this legacy API, the co=
re
will fall back to connected WR parsing, allocating struct ib_send_wr instead
of an unconnected WR struct with destination fields.

When this malformed WR is passed to an unconnected transport driver's
post_send op, the driver might attempt to access missing fields, which could
result in an out-of-bounds read or type confusion.

Should ib_uverbs_post_send() either parse IB_QPT_RU as an unconnected WR or
explicitly reject the operation with -EINVAL to prevent this?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014-uet-ib-cor=
e-v1-0-a0e626117113@broadcom.com?part=3D4
