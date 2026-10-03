Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B42A3A7F79
	for <linux-rdma@vger.kernel.org>; Sat,  3 Oct 2026 17:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050191; cv=none; b=tz1Btj3p9JUia3mZqoIsq3BA2gvjsHZajkW9Pa+2K9z111HVMEVt1QA4A3tmZyHrTyBtWd/Y07Q4I3YjVLX66KGG0aFpXdzNuegwf0Ze6TEu2bxzFPCFrNNnO6HAvMWg7FTduEtM6IWvNOdExEf9cPjJpHeQcpswPCyZSR5q+yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050191; c=relaxed/simple;
	bh=PTOT5pK/IS6mLWB6kowiAFVCxoN/yRwje1RKLR5CgGc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VaLAzie8ivEZA+qbGOpO8XLI5ePaQRvhUk0J26SZKVNV6WVEV8tPz9XOjZchQ/YyPpO8Opd6wOAC3UdWicRqSeY/SLksih7DMpAjhhrRLaiIhZrvs5FjKQzKPV0NlZkedLt+miphPNh31F9o/DJxDK8Wq+DFm3r730+fKPfv/Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kYAPPGeC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kYAPPGeC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 231121F0089B;
	Sat,  3 Oct 2026 17:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050190;
	bh=nYgKo/+Cdh2+Kq4nAvw6jUgx2hnVHSuZXK2uP8CQ3g4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kYAPPGeCMb4hgr1bAWvX9yd+mwSJFE9Xz7mlAz8wqSxRLBY7ote2ad91JfJvnCOh0
	 GXX1D63q4y4KHuZAtJYpQ9SHD5sFg1RcJQGmgZN+dpqqVVoScFMDlLGYmZ1ORAT/Rx
	 W4wtHujf4PzTrQVKso9AmIBU+omoeQvKHcj+T3ESDO/5EvS67S695Ju2Ab4bKyXU2Q
	 YPln2m+HSul/j7HotO7mSr59dD0PE9W/ppZvWDwYTWGdosQmQd4g/lPBI7/mzZkwD/
	 ZVGCSYRvCTveljXnbVwJLJGX192aWBdDTcLAXLMXRPc967834BL4j5farObJLUHUl6
	 4UNSDS77y9I4g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v8 03/13] net/rds: ib: refuse to attach a
 connection to a device being removed
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261003163215.250253-4-achender@kernel.org>
References: <20261003163215.250253-1-achender@kernel.org>
 <20261003163215.250253-4-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:56:29 +0000
Message-Id: <20261003175630.231121F0089B@smtp.kernel.org>
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
> builds a QP on a device that is on its way out.  Nothing drops that
> connection afterwards - the device's shutdown walk is over, and the
> connection never returns to ib_nodev_conns, which is the only list the
> transport exit sweeps - so it outlives the device, and the module.
>=20
> Make rds_ib_dev_shutdown() mark the device as shutting down under
> rds_ibdev->spinlock before it walks conn_list, and have
> rds_ib_add_conn() refuse, under the same lock, to attach a connection
> to a device so marked.  Every connection is then either on the list
> when the walk drops it, or refused: the connect fails, the connection
> stays on ib_nodev_conns, and either its own drop or the exit sweep
> tears it down.  rds_ib_setup_qp() has not taken anything from the
> device at that point, so the failure needs no unwinding beyond the
> client-data reference it already releases.
>=20
> This mirrors the UEK gate on the device removal flag in
> rds_ib_add_conn().
>=20
> Fixes: fc19de38be92 ("RDS/IB: disconnect when IB devices are removed")
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003163215.2502=
53-1-achender@kernel.org?part=3D3

