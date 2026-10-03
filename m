Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABFA39FCDB
	for <linux-rdma@vger.kernel.org>; Sat,  3 Oct 2026 17:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050190; cv=none; b=E/ou/yd3tyxkg7NMS0yj9+3djGrUbvVM9U5t+X1QDZUaALpPmC0jZp0l9DUq3WpVMFxPM1zrWCd1fPq0lHUT74CibNva+vIEyHPn7z35B4DSPDVYEf8LcWWUG5XNcO0lUnOjVRZ0AdYFEq75Qk/++czaDJxf8HxZxk82Sb89tho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050190; c=relaxed/simple;
	bh=f9BRYQUYn5ljEFajkluWHmMOMemPlMov0hfrllKzulo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fsvhPjOUnFlhDHpZ5ygjm3j3t0uSrz/XEnJ4pKvZgtRZUeTVZXWsX3+e3ukS81/hm29RsKYfRPRPBxI/u0HLhY++Me9Pf9ZIKH3vhPiw9GXoEpjZn3jYbCvShNl49voeoMFPNZ/r7+sbxB1RnBt3BU6OIwo8Fnw34eJdwIZm1ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JbFLhndN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JbFLhndN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B286B1F0089D;
	Sat,  3 Oct 2026 17:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050188;
	bh=sZ8e0IPuZIBx3roGfnzAKjvrUD5mTeL+2wPMpkbPajo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JbFLhndNTaX5gWHeeTXOmIfhvqf1FTObt+n6mVW460TZsLSz0K1AI6orLvPIA6wGo
	 HFrbxAHYoPha62+QZC2snQusjtCr/Xx2tUsnkspJagZp8k/xNreBpEBvzkHYz/MIAY
	 jxPkGo49vvHXmQp/swrhHrG1MTIx9mIm47ivJvq7pQq69KIbsfs79hn4DHU6Ny/Dv4
	 0IMJqLCA5coZR11oATLVb7XfmJNhg6XuZdzTx17jklSquIlJwKX0fJk57XpvLqhnVm
	 elW2YVsC86vMiIFOvlvhVjZRAFavAThM8bWYTaDXIDEQFXFtOCMIrIkYgnrGlxepY8
	 OMKScwYbr2aAQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v8 06/13] net/rds: split connection destroy
 into quiesce and kref-governed free
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261003163215.250253-7-achender@kernel.org>
References: <20261003163215.250253-1-achender@kernel.org>
 <20261003163215.250253-7-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:56:28 +0000
Message-Id: <20261003175628.B286B1F0089D@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003163215.2502=
53-1-achender@kernel.org?part=3D6

