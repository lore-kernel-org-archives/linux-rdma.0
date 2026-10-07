Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3AC041169B
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 16:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791390262; cv=none; b=bMdwML2SopM3JDzji4VmZf+vxClNSebZFpnvdb69Nk5qDjIKL8rd95KiFCQLkzqSt/JtKcZj3rsOsYNEgSq8QJPqgr0mfpsxf9b+loyGdFHxPGOQyRZzkf1TAwV8BvDVB6IODtZzcWfm3YfS3mGc6EBEWc4t9cL7qCAAb8kgG7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791390262; c=relaxed/simple;
	bh=GKAx8vzn053K/2OIqoJSJuS0YF5rn6qTTGrhATijUBc=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=UyIu2Xw+xGjEv4nru9J8uXg9+mQpCO25qd3jCl0vOW13L3xK+k6NDpjTHFjdzUIPmopw3KPiwkTEfYpb0qN7/WYYMrQvTQj1e1/T5TYhwxaXOfzNwsoiEIqOKCR7iZIfT1WzgLXk8QzV1G+DWv/mrXphUjqOgqiI6B2TCajZngg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LFph/7K4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LFph/7K4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC821F00898;
	Wed,  7 Oct 2026 16:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791390261;
	bh=ZgfBcTjAPPjOtgT187KLo/FkbgGuLtrFgTZ7huCKEks=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LFph/7K4c4b7dVTMOQuU1s/0cJF+yho3iRCxZ+QnxygrScCU+e00VGkG/6dekJoFu
	 N050Moq7zEL0HjpWLBaRne1h9FnvCf80L1REbBeK4R++H7qCBAEqkvrbYNe/P2s68p
	 r3mhChgikB+8gAD6/q4W84GVEFOJGhm8LJXlfEEKBqi8tr9w5zcqSey5TKEeXcIoOB
	 OOvex0G4x+63xI2G5Adc38dnW7yYqScB7i3+Hrv6hlnrMAm2tMOKWZp9D/ZFusdsh8
	 dfnuXaASj6NxliMHfVAm9nI2Wj8Cr9Zvw9gJm+1XIBIIlcLvyVSLgx+VJAIY0JOUSM
	 c37zBHVdH6lrQ==
Message-ID: <sashiko-outbox-163192@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [net-next v2 3/3] bnge: reserve TX/completion rings for the
 RoCE MPC channel
Reply-To: sashiko-reviews@lists.linux.dev
To: "Siva Reddy Kallam" <siva.kallam@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261006161256.1493672-4-siva.kallam@broadcom.com>
References: <20261006161256.1493672-1-siva.kallam@broadcom.com>
 <20261006161256.1493672-4-siva.kallam@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 16:24:20 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] bnge: strict check against tx_demand breaks graceful TX ring fal=
lback
--

commit 03cbac58eff7b84409d8e42c716c6db377e04ad6
Author: Sachin Holla <sachin.holla@broadcom.com>
bnge: reserve TX/completion rings for the RoCE MPC channel

This commit updates the driver to reserve extra TX and completion rings
specifically for the RoCE MPC channel when RoCE is enabled. It modifies
the ring reservation logic to account for this extra demand to prevent
pool overflow.

> diff --git a/drivers/net/ethernet/broadcom/bnge/bnge_resc.c b/drivers/net=
/ethernet/broadcom/bnge/bnge_resc.c
> index 4711dd4945ffe..9dfb22b7c7c7a 100644
> --- a/drivers/net/ethernet/broadcom/bnge/bnge_resc.c
> +++ b/drivers/net/ethernet/broadcom/bnge/bnge_resc.c
[ ... ]
> @@ -327,6 +344,13 @@ int bnge_reserve_rings(struct bnge_dev *bd)
>  	if (hwr.stat > bnge_aux_get_stat_ctxs(bd))
>  		hwr.stat -=3D bnge_aux_get_stat_ctxs(bd);
>  	hwr.nq =3D min_t(u16, hwr.nq, hwr.stat);
> +	/* Drop MPC TX ring from L2 TX ring count; it is owned by RoCE driver */
> +	if (bnge_is_roce_en(bd)) {
> +		if (hwr.tx >=3D tx_demand)
> +			hwr.tx -=3D 1;
> +		else
> +			return -ENOMEM;

[Severity: Medium]
Does this strict check against tx_demand prevent the driver from gracefully
degrading TX rings when firmware resources are constrained?

When firmware grants fewer TX rings than initially requested
(meaning hwr.tx < tx_demand), this condition immediately fails network
driver initialization with -ENOMEM.

When RoCE is disabled, the partially granted hwr.tx count is passed down
to bnge_adjust_rings(), which scales down the L2 queue counts gracefully.
Could this logic be adjusted to verify there are enough rings to satisfy
the absolute minimum requirement, subtract 1 for the RoCE MPC ring, and
then let bnge_adjust_rings() adjust the remaining L2 rings?

> +	}
> =20
>  	/* Adjust the rings */
>  	rc =3D bnge_adjust_rings(bd, &rx_rings, &hwr.tx, hwr.nq, sh);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261006161256.1493=
672-1-siva.kallam@broadcom.com?part=3D3
