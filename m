Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072513A453F
	for <linux-rdma@vger.kernel.org>; Sat,  3 Oct 2026 17:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050188; cv=none; b=Th2Cb1QtzbXwTWxkohUroLkdvY1c7/LGeUubLS22Hw9Fliy5ji/VOKzAZtZcaRjSy11r5xPo3XmrcK8wadNLGBsEYFeamHI9PTDCAYzecYbL3eMDDYj/CiL/zuUajQuHVwXL7oxPao9wBDmP2qqjN7qW70nzGbgm/TqYDSxLmM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050188; c=relaxed/simple;
	bh=MT3VI3k+VQKfrfsoebR2Zd73iOXvlTWfQOOoghFUGcM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=QiR72c8eZ0QOFCtr2kA1tMFsWb6xlKe91Jeb0xDp1KxpYblIImGzzluIH4ENMgPtj8cLMtn8AmpsaKf7XrkfQjVp7Efibnk46cCqCesGnA6c1vhSS4wHQ7zV0VvVtSVA9SLkL6nkZs84EAfIbJmtgMjbiMWnByAZANnbYmEbA+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b/UFf4Ne; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b/UFf4Ne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43E01F0089D;
	Sat,  3 Oct 2026 17:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050186;
	bh=+TE8AZXsrFf6/+EFYunc001rzcJKTncwWBmYr09nIBU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=b/UFf4Nevx5omHKpMgLu1uJvJSbvVuGTBWKBmxeQyXTa/+5XW2kcgQYDo+V7mxlpu
	 X39Jb9izsQRPcgxtL4mf/ImsSL+hTsrfQGDorIfiZhIy4WcLC7RsNu38DaI75OTLa8
	 3kMMO5Cl7QkQ8vrUbD0cBiGEp6V/mIFgOgJ9ipl56azID1CnBOjrsMgJRxkN0+t9Yf
	 VDnjhEtdOKcmmZnVjdXurrZObQd8pgq8Mt0mmVjnNOtQ6igBLdz9u/Yf01mploXK8i
	 VR9S8f39sU86rZ+F4D3AYzaKFv7v33EZTiCNmUAk28JLXzuTQGiu4T6KqbQlVV2BJ6
	 K7rCd/CYK07zA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v8 08/13] net/rds: wait for connections to be
 freed on transport unload
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261003163215.250253-9-achender@kernel.org>
References: <20261003163215.250253-1-achender@kernel.org>
 <20261003163215.250253-9-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:56:26 +0000
Message-Id: <20261003175626.C43E01F0089D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Sharath Srinivasan <sharath.srinivasan@oracle.com>
>=20
> Since connection free became asynchronous, rds_conn_destroy() only
> quiesces the connection; the actual free - including the transport's
> conn_free, which lives in the transport module - runs when the last
> reference is dropped.  The transports' exit paths destroy all of
> their connections and then proceed to unload, so a free that is still
> pending - once the following patches hand out references to lookups,
> sockets and incs - would execute transport module code after that
> module's text is gone.  At this point in the series the initial
> reference is the only one and the wait returns at once; the guarantee
> becomes load-bearing with those patches.
>=20
> Count each transport's live connections in t_conn_count (incremented
> when a connection is published in __rds_conn_create(), decremented as
> [ ... ]
>  place of UEK's wait_event_timeout() + WARN_ON(), plus the resweep for
>  IB's asynchronous device detach; also cover rds_loop_exit(); rewrite
>  commit message]
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003163215.2502=
53-1-achender@kernel.org?part=3D8

