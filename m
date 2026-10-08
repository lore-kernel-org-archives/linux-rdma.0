Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12A81CFA2
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 03:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791430336; cv=none; b=lN2RF+EMM2TwPkPIFP8FH8GdG282+I46VJ7dbdF6BugI+o0CGwabYXO+rYgsqguBAvY2wrqSxURvTXIH5K3ihUaLbXHVA/FSti7mUj1Xvw9YK5udfbcDrvt6/Q4IrA31xuSPBbxDF4XFCUr2u0XSad7JcLnepx/HOUdmjlhyVx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791430336; c=relaxed/simple;
	bh=u1I0NALs8+nARS7VfrRp9ZKvE/RAx+FStDdFWjEVlLM=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=tx2kipWlRJAiWAs/1V8hcMpmmGlHCuaAozJ6gw3ZlLrMeCXW6UI2VOW/TcSAFnTVVrWuytNl4ncd65kYJecJhgS1ZnlBVxH03Ey5mkFubivdbp0Va/w6JFbDKSpNkNy4uIOei9p7WCZgo/bljNk3pyQYI+MRnRc+6VCLZKRVIkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V0lL8Vbx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V0lL8Vbx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC621F00898;
	Thu,  8 Oct 2026 03:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791430335;
	bh=ehWd1zgGG3fKqucr+u8JWze/uBvVMgigdlAM/8ij+KU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=V0lL8VbxegnsERq2XFB7Ndk09wDvT8HTG3tPH61D+09DF908vmnF1fvcGizwkRcyi
	 GSjdGcbrOtmEYD1FGiD1OOa97HRUip7DBLIvkRdtqb9fDxJ5C+8PvXr95i+SuYUFzV
	 N9G6/jA80QH8o5X8Sz2q0cAXEbKqN/fJWeATBCNM0pgXUOd2Wvdj1ITC4OqvygmKgH
	 FEzvg3a/eHxIsFYwtzn9J5iZkbQLQpZLZVNLxPCXKM6MS97qfk8Mk2ZyX+lVcumthu
	 OhHbRMx5eSdNsEoI0hrrpk93Zvt5t3i36TVjLaPtOPO40BHS72Llc1v45eKxMSy1vk
	 C9u78V650yxPQ==
Message-ID: <sashiko-outbox-163544@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v9 06/13] net/rds: split connection destroy
 into quiesce and kref-governed free
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261008031333.1142174-7-achender@kernel.org>
References: <20261008031333.1142174-1-achender@kernel.org>
 <20261008031333.1142174-7-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 03:32:15 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Sharath Srinivasan <sharath.srinivasan@oracle.com>
>=20
> rds_conn_destroy() tears down the transport state and immediately
> frees the connection, along with its paths and its workqueues.  This
> relies on the assumption (documented in the rds_conn_destroy()
> comments) that "no one else is referencing the connection", which "we
> can only ensure ... in the rmmod path".  However, the callers stopped
> honoring that long ago.  Today, connections are also destroyed on
> network namespace teardown (rds_tcp_kill_sock() and
> rds_loop_kill_conns()), and the following patches deliberately let a
> connection outlive the call.
>=20
> This leaves loose ends since references to these destroyed
> connections still exist.  Sockets cache their connections in rs_conn,
> and congestion updates will walk the maps' m_conn_list.  The CM
> [ ... ]
>  infrastructure, no rds_net, single conn hash); destroy keeps its
>  one-call external interface; holder coverage split out into follow-up
>  patches; rewrite commit message]
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008031333.1142=
174-1-achender@kernel.org?part=3D6

