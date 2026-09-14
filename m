Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138A932A3C8
	for <linux-rdma@vger.kernel.org>; Mon, 14 Sep 2026 02:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789354677; cv=none; b=VF4V+P6xtc1aV8qQFXUePKIpyvYWTsGC514tygogh4aFliMPMGV0JUNPwN4XTZUkKTrDDC0443C5LFRWokkdDe3SINQmcri3Cd8x24tLJ1/1ZilRZZgA/DAD82p9Ya7Yt116eVXy0rZ+0fUFJHPUDQcnaVHEM2aTYTgjz57Ohjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789354677; c=relaxed/simple;
	bh=JGE9MTESqKvtg4/ZS2pdoTlCAtkHM/9h+ZXKzCT4Nxo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=g8/Nx71DpJai/qEIY4tiRledmC4QnZWDaLL1DYb6WBz483PHZfPXZj3ctMB/2IPpm1+oP/I2UeILdI6kTTPOPazy1HQO3rvzRCYNxEqDRVbtM3Vsi/HY9VlGpKopLG2g5+Fx2BO4wK1WgQ9AGmMQt0ls+Iz5JcWulxDGFlNKxXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=da32AdP8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="da32AdP8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90EB01F000FF;
	Mon, 14 Sep 2026 02:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789354675;
	bh=qMNxQMhcDklL38TdD1FdJFRsJoZBqgDiCzLjOYuKfug=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=da32AdP8wGVcvaR29j6lku/tfgxBr20OCdRXpB2a04QhS5IQqKItoEjF+mSAfzJhi
	 YsyPbxZzx2V0UOK3BkSfu+Me3xuJ4/ufvC48mpDFGZXx/AwXKoS6V59tYEQRNubvYy
	 oOTfvzKbuUEhkogr42n+wiZOHN/J0LdJDmOK3Tw2d8XcTdyYhZ27ZGrBmiLLRdRzKQ
	 2IhJgEC+QEWm5PMWjgiZDx/7uNDx9r7GxTBagw2cqLEZNC+r1JnPdtEbJZSJYzsh/9
	 XxhFe27ETSdaS1Q89dl0rqAGkMo1uuTN/7goRApVl2UeftyCb9SxhdlARNGgvpZyXr
	 VBbm8RFcxrsaQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-rc] RDMA/hns: Fix the use of uninitialized variable
Reply-To: sashiko-reviews@lists.linux.dev
To: "Junxian Huang" <huangjunxian6@hisilicon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260914024800.132429-1-huangjunxian6@hisilicon.com>
References: <20260914024800.132429-1-huangjunxian6@hisilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 02:57:55 +0000
Message-Id: <20260914025755.90EB01F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Use-After-Free of `net_device` due to unprotected pointer usage ou=
tside RCU critical section.
--

commit 473405cc107e96081de8e48759f57372e36d66e0
Author: Junxian Huang <huangjunxian6@hisilicon.com>

RDMA/hns: Fix the use of uninitialized variable

The variable 'i' is used without being initialized in active-backup
mode.

> diff --git a/drivers/infiniband/hw/hns/hns_roce_bond.c b/drivers/infiniba=
nd/hw/hns/hns_roce_bond.c
> index f2b12ae13a584..21de82b864d30 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_bond.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_bond.c
> @@ -81,7 +81,7 @@ static int hns_roce_set_bond_netdev(struct hns_roce_bon=
d_group *bond_grp,
>  {
>  	struct net_device *active_dev;
>  	struct net_device *old_dev;
> -	int i, ret =3D 0;
> +	int i =3D 0, ret =3D 0;
> =20
>  	if (bond_grp->tx_type =3D=3D NETDEV_LAG_TX_TYPE_ACTIVEBACKUP) {
>  		rcu_read_lock();
>  		active_dev =3D
>  			bond_option_active_slave_get_rcu(netdev_priv(bond_grp->upper_dev));
>  		rcu_read_unlock();

[Severity: High]
This isn't a bug introduced by this patch, but does dropping the RCU read
lock here without first acquiring a reference to active_dev leave the point=
er
unprotected against concurrent freeing?

>  	} else {
>  		for (i =3D 0; i < ROCE_BOND_FUNC_MAX; i++) {
>  			active_dev =3D bond_grp->bond_func_info[i].net_dev;
>  			if (active_dev &&
>  			    ib_get_curr_port_state(active_dev) =3D=3D IB_PORT_ACTIVE)

[Severity: High]
Similarly, in this fallback branch, an unprotected pointer is read from the
array without locks or reference counts. Can passing it to
ib_get_curr_port_state() result in accessing fields of a freed pointer?

>  				break;
>  		}
>  	}
>=20
>  	if (!active_dev || i =3D=3D ROCE_BOND_FUNC_MAX)
>  		active_dev =3D get_hr_netdev(hr_dev, 0);
>=20
>  	old_dev =3D ib_device_get_netdev(&hr_dev->ib_dev, 1);
>  	if (old_dev =3D=3D active_dev)
>  		goto out;
>=20
>  	ret =3D ib_device_set_netdev(&hr_dev->ib_dev, active_dev, 1);

[Severity: High]
Could this pass a dangling active_dev pointer to the core RDMA API, which
attempts to take a reference via netdev_hold()? If a slave device is
concurrently unregistered by an admin while the hns_roce_bond_work workqueue
executes (since the workqueue isn't protected by the RTNL lock), it appears
this might lead to a use-after-free.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914024800.1324=
29-1-huangjunxian6@hisilicon.com?part=3D1
