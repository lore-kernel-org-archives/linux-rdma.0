Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29592571DA
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 03:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791430335; cv=none; b=jKQ2BFirIr4mVxDoVpapPyqFlGdHUAT1tEVq8aO+QRtkDXTrBRTcO/pDZmI1rj1SO2dJiy8kY5Tur4PynDmEhNIwPRfv1quPhpABTL5a6mACz+aBCJZG/UIgFR21K7p+HNRoHulxxyc+5a3C5RhcK6N1uWshaLb31V3EH/rNNzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791430335; c=relaxed/simple;
	bh=n3I+TzMkjgYLuzf/otKyIYR0QZkKTY3aQTvgqMe1Y8Q=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=vAyKKIswbY/X66IHcGC7FW2DhaZ6e9k5JdyVw6DW6mFVHFwlWkkVpe0F681FT0u0xqVL4oE1ycY11CfkOPfGizOJdPkkpoF2V7jRn50RKijbvrwpay4eJb10F9vgsHnDNmddDxbbSgzCcdUSARdtm8TCjPms976y8kvssHnWj+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OJWuB9JQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OJWuB9JQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8418E1F000FF;
	Thu,  8 Oct 2026 03:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791430334;
	bh=nC9xgc4fWkIFof3wchea4PhVWIfcvB+n0OLo6H1mLXU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OJWuB9JQTDebcUnp+MHWtEPZhUFPk0rQM/Z2V6HtCUiyyGTaBCl3F53QLTnm6A+sK
	 StEH/YAV1ahvLsMVo0lqP7tP/9xLB6iFU1RaYCsxcIOh8SU4XYeLJOPa70QIrB5w8C
	 TeAfAs+SPYle34ZwfpzWWiBy74pAcpmmuzvLyFt03dh8nThYGwStzzBpqmgSlt29SM
	 Nl0YEJf7/ATyw+aYeeODdlOVC87so4vccUc3Uxtd8mbK5VUlPOAU3kWWNA+nJwt1vK
	 n3qyPczABsb/5bAPmDI7F3OAZjerRiSd0C0z9Hzo8CK6yVRbeuoPj53TaJHiNPdYfN
	 az08EG1FKKwaA==
Message-ID: <sashiko-outbox-163542@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v9 03/13] net/rds: ib: refuse to attach a
 connection to a device being removed
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261008031333.1142174-4-achender@kernel.org>
References: <20261008031333.1142174-1-achender@kernel.org>
 <20261008031333.1142174-4-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 03:32:14 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> rds_ib_remove_one() drops every connection on the device's conn_list
> in rds_ib_dev_shutdown(), then clears the client data so that no new
> connect can find the device.  A connect that is already past
> rds_ib_get_client_data() when the walk runs is not covered by either:
> rds_ib_setup_qp() goes on to rds_ib_add_conn(), which moves the
> connection onto the conn_list the walk has just finished with, and
> builds a QP on a device that is on its way out.
>=20
> On a hot removal the rdma_cm still catches that: its own client
> removal runs after RDS's and delivers RDMA_CM_EVENT_DEVICE_REMOVAL to
> the connection's id, whose drop shuts the connection down and returns
> it to ib_nodev_conns.  On module unload there is no such event - the
> device stays registered - and rds_destroy_pending() is already true,
> so every drop short of a destroy returns early.  Nothing drops that
> connection then: the device's shutdown walk is over, and the
> [ ... ]
> rds_ib_add_conn().
>=20
> Fixes: fc19de38be92 ("RDS/IB: disconnect when IB devices are removed")
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008031333.1142=
174-1-achender@kernel.org?part=3D3

