Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C0F4C77C6
	for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 22:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792017702; cv=none; b=ZUcadDmsQZq2t6rlhy1d4vchD0L9nX4RoKRvSC1Z15fWrnqXM3sikBiatXK1lUTGDFg+v6SSMU0beN44paFr3Z+IEY8Y8YC7Bs3ejF7CDGPTt0ljRBDv1n3sDLM8s+g5UhmCNncxW7aH5A+Sv3G8v/0DFJm3mZytLPVaZhWu+pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792017702; c=relaxed/simple;
	bh=PJmCmns8krevdW2wcU4+edcGsxxMHIQoHW3GAFaiqIs=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=l8q2fGzCBRH6rib7dKeHZ97l8Ig8mH+Xq5QOXpc6XKrxa6FJOKh8u4nwf9mXGsO7NDn5MW6ruAZVQ485G/MO5AI6ziSnulG75M/4pCASmtTHV9JSyNUMxqDtY7dV1glB9EdXVso7KwhZ4BKtSKXv5QcAd3tKQt6GkP31NBcx9Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ei7KfVkK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ei7KfVkK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A6D1F000C5;
	Wed, 14 Oct 2026 22:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792017700;
	bh=qobFofQ+rJZ1mRAfJSKthcYr10jATy2ZYjeefkVl7Dk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ei7KfVkKVyOiez92DGuEGb+VswVmRIxGH2yPQn+O+UQUjF445nX7KozqzuXGzsuLp
	 ucRdG1gYRNrge+YkqR4pUuTRdcTORo+UYAMut5harE9fk+aXw6xuEVBiSguevbCdBs
	 aGbDvb+VEzhHzIcqLBw+2BIW0Hbcp3lUy0h2DcuPmIGQakmDYywxxj50jIUoIfAI59
	 T4lDg/HrjfLByOduNCz4UhVE/w8dPP00wsszT69R9U6hP5QjdI3iSB7tcpv1v9TiJg
	 Y6qOM9TrFoIuUelzAnklbPC3KZIAaTQT30mWYD/OFVzYREyxXNbY/dGOAR4xOhnsaO
	 lbx2/Alc9MJGg==
Message-ID: <sashiko-outbox-171988@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 10/13] RDMA/core: queue pair attributes for
 unconnected transports
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Davis" <eric.davis@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261014-uet-ib-core-v1-10-a0e626117113@broadcom.com>
References: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
 <20261014-uet-ib-core-v1-10-a0e626117113@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 22:41:39 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] RDMA: missing IB_QPT_RU state machine validation in qp_state_tab=
le
--

commit e32578d06dac38500b6cb1196755de6b03c64308
Author: Eric Davis <eric.davis@broadcom.com>
Subject: RDMA/core: queue pair attributes for unconnected transports

This commit adds creation attributes for queue pairs on unconnected transpo=
rts.
It introduces job keys to authorize actions, initiator identities, and
semantics checks for ordering guarantees.

> diff --git a/drivers/infiniband/core/uverbs_std_types_qp.c b/drivers/infi=
niband/core/uverbs_std_types_qp.c
> index c6225156fe30e..47ca994f9ac96 100644
> --- a/drivers/infiniband/core/uverbs_std_types_qp.c
> +++ b/drivers/infiniband/core/uverbs_std_types_qp.c
[ ... ]
> @@ -197,6 +331,7 @@ static int UVERBS_HANDLER(UVERBS_METHOD_QP_CREATE)(
>  	case IB_UVERBS_QPT_UC:
>  	case IB_UVERBS_QPT_UD:
>  	case IB_UVERBS_QPT_XRC_INI:
> +	case IB_UVERBS_QPT_RU:

[Severity: Medium]
Will this newly added transport fail state machine validation during creati=
on?

When UVERBS_METHOD_QP_CREATE() creates an IB_QPT_RU QP, the core immediately
forces a transition from IB_QPS_RESET to IB_QPS_RTS via
ib_modify_qp_with_udata():

drivers/infiniband/core/uverbs_std_types_qp.c:
UVERBS_HANDLER(UVERBS_METHOD_QP_CREATE)() {
...
	if (attr.qp_type =3D=3D IB_QPT_RU) {
		qp_attr.qp_state =3D IB_QPS_RTS;
		ret =3D ib_modify_qp_with_udata(qp, &qp_attr,
					      qp_attr_mask | IB_QP_STATE,
					      uverbs_get_cleared_udata(attrs));
...
}

However, IB_QPT_RU appears to be missing from the qp_state_table in
drivers/infiniband/core/verbs.c.

When a driver invokes ib_modify_qp_is_ok(), the missing table entries mean
the req_param and opt_param default to 0, and the transition is not marked
as valid. Doesn't this cause ib_modify_qp_is_ok() to unconditionally return
false and reject the QP modification for any driver attempting to support
this new transport?

>  	case IB_UVERBS_QPT_DRIVER:
>  		if (uverbs_attr_is_valid(attrs,
>  					 UVERBS_ATTR_CREATE_QP_XRCD_HANDLE) ||

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014-uet-ib-cor=
e-v1-0-a0e626117113@broadcom.com?part=3D10
