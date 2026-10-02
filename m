Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2E94477F4
	for <linux-rdma@vger.kernel.org>; Fri,  2 Oct 2026 09:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790932383; cv=none; b=iDYbdSRC/HZWEvfVqemcW17dgalRPzesC572M2JcG+5roz20tJmjkpF2nRQHDepf6F+mV7OVVTpP5odZBWIGLU7q2CyHAlBogp13c5LjgqHH532rKjVxVDL7KQFoHoL7zmMRXHSCVpgNyYrdCMILZm7Ust4rEUArGUmzFBNop9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790932383; c=relaxed/simple;
	bh=Fd04m459ufDhZNb6/qS2/NedNQNvi51+IsRYoaOiGI4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Q/PWV+uO1H/BEccvS5ovfN7XBsXJeg326qFLEZnFQy0aXWs1Tphe78QoUZChbrPu8RbQjMevAie5YhsWlmOITUCfYgT8E26Myobgy/0p8FZAG1dWL8nP0t4a7ulJ1Ff/9St/jXKIhmBYvlYa4i7foJP9gUa8EgJ8OjaegkUWeFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WM+fCGmq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WM+fCGmq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB71E1F00893;
	Fri,  2 Oct 2026 09:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790932382;
	bh=aKRp/qB/9ib/ch7xHxB6mnWnPtgXnJJtLlMVfTZOZq0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WM+fCGmqqhlk4hgRY3flCMQqEyDFhmFBtQNfVB1R+jFNNjSr7fBSSgqCAJOOBiCUk
	 k9V+IeIIG+VMHRQwYahzxDSYL0Oy/yc1aoA1gNtHvZYkvnb8XBUW9tl9T4nuAX3Duy
	 y5x2zMAnLtN0Vm/ytMeroTkMxpimkdr23Lcl6E4UbqRtq1vGHglhel0PngyRSkhLIS
	 BcQUk13slX/qBFDztLHdG7l1fr1VFpChe5cUj63Rn0OmkUila7UFmv6Zucsc25UcF0
	 NN3AEGqtXgk/vJlBS7j/lVq8IjYdDDneu28b3BJTG7KodmOjoG1qWEnV5nmBsb/ms/
	 mb1gobB9O1FvQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 04/10] RDMA/mana_ib: Maintain kernel RC QP
 state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261001182015.1757203-5-kotaranov@linux.microsoft.com>
References: <20261001182015.1757203-1-kotaranov@linux.microsoft.com>
 <20261001182015.1757203-5-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 02 Oct 2026 09:13:01 +0000
Message-Id: <20261002091301.CB71E1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] RDMA/mana_ib: Broken UC QP modification due to removed case
--

commit 5fb460641c0259509af070b4f53dae8c74239937
Author: Konstantin Taranov <kotaranov@microsoft.com>

RDMA/mana_ib: Maintain kernel RC QP state

Update mana_ib_modify_qp_state() to support RC QPs and initialize the packe=
t,
message, and frame counters for use by work requests. It also arms the
requester receive queue at the initial PSN.

> diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana=
/qp.c
> index edaf03372cd81..8c2ec4d091f0d 100644
> --- a/drivers/infiniband/hw/mana/qp.c
> +++ b/drivers/infiniband/hw/mana/qp.c
[ ... ]
> @@ -1058,7 +1076,6 @@ int mana_ib_modify_qp(struct ib_qp *ibqp, struct ib=
_qp_attr *attr,
> =20
>  	switch (ibqp->qp_type) {
>  	case IB_QPT_RC:
> -	case IB_QPT_UC:
>  	case IB_QPT_UD:
>  	case IB_QPT_GSI:
>  		ret =3D mana_ib_gd_modify_qp(ibqp, attr, attr_mask, udata);

[Severity: High]
Does removing IB_QPT_UC break Unreliable Connection (UC) QP functionality?

By removing this case, any userspace or kernel client attempting to modify a
UC QP state will hit the default switch case in mana_ib_modify_qp(), which
returns -EOPNOTSUPP. This prevents UC QPs from being transitioned to active
states (INIT, RTR, RTS).

Was this case removed unintentionally, or is UC QP modification handled
elsewhere now?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001182015.1757=
203-1-kotaranov@linux.microsoft.com?part=3D4
