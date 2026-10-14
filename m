Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15A54F4743
	for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 10:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791975323; cv=none; b=EZzPuK4NcoKuwl2neGmTaB5ghLQm157lysBHUVS4qofRByQT9YwawyWvJulRdmb5gGVGbpWM5zrhvF6PHjTP9OLBD+jkr6EoU8dCXwTNzaA3aYB68E4T2rjhc+HqFB8qsDYXbSIFzSqruK2Hqc6AKb7K2UKcDVlUprrAtYQSMjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791975323; c=relaxed/simple;
	bh=5sYir2XZ0/ruhqGwVRf74n6XvVc1WUfv2AsSZ9ap2HA=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=aS19KZgzFmP38vmbNX49dBIUiGQ70KHxy+uoo+YyPApgf8DT1NPw+LUwvFwp0A+LYOPHyW0RDKbxNyG8WzkPZES/uVcqkcFv4cdTKq1rLCWKLXWsUkuFv/VibyhpahE9sTJB9IlRYDkK0Og/CJANn7Cni8uzETQS8FcJzoUSCJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CYd8UWfn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CYd8UWfn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BCEA1F000FF;
	Wed, 14 Oct 2026 10:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791975322;
	bh=5sYir2XZ0/ruhqGwVRf74n6XvVc1WUfv2AsSZ9ap2HA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CYd8UWfnVSiuQUqcKHPC4cQETvF14SMLrDcjG3QqBD8huKLVhczN3YZt5EH+lbGRg
	 izOP4ReKWnvEbyz/ML5F747Bl7M5mSKjDUCPUjfIoP7NM73SwcZtV2wuwmP4KP0iru
	 aBDV2OSbmvOPxor8yaA5sreoBkowwbbLxjiq4k5tsxnadho0WdLE8n/H9nZd/7KStj
	 UJFvV19XXzinOqlGgFHocSfsyDSZDXDX5JH+xqCl98LMnRg8rXaPoT9vA+zJoonZ48
	 E0T6Y2+Qh/oeVv4AD2eE9XK+vgD7YocUAylWXjuFdXvKHkuvH8pjOTAXjYTpZnK4hc
	 ZX2+5ei87XJKg==
Message-ID: <sashiko-outbox-171165@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next] IB/IPoIB: Cancel normal flush work on device
 stop
Reply-To: sashiko-reviews@lists.linux.dev
To: "Edward Srouji" <edwards@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261014-ipoib-cancel-work-v1-1-6c0faac016b8@nvidia.com>
References: <20261014-ipoib-cancel-work-v1-1-6c0faac016b8@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 10:55:21 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Carolina Jubran <cjubran@nvidia.com>
>=20
> ipoib_ib_dev_flush_normal() can race with ipoib_stop() because the normal
> flush work does not run under RTNL.
>=20
> Before commit a77a57a1a22a ("IPoIB: Fix deadlock on RTNL in
> ipoib_stop()"), ipoib_stop() flushed ipoib_workqueue after clearing
> IPOIB_FLAG_ADMIN_UP and before calling ipoib_ib_dev_down(). This ensured
> that any in-flight flush work completed before ipoib_ib_dev_down()
> performed the final clear of IPOIB_FLAG_OPER_UP.
>=20
> After that commit removed the workqueue flush to avoid a deadlock with
> workqueue tasks taking RTNL, a normal flush can continue running
> concurrently with ipoib_stop() after IPOIB_FLAG_ADMIN_UP has been
> cleared.
> [ ... ]
> Fixes: a77a57a1a22a ("IPoIB: Fix deadlock on RTNL in ipoib_stop()")
> Reported-by: John Popplewell <john.popplewell@nmc2.ai>
> Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
> Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
> Signed-off-by: Edward Srouji <edwards@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014-ipoib-canc=
el-work-v1-1-6c0faac016b8@nvidia.com?part=3D1

