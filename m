Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485B14519A5
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 08:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153674; cv=none; b=fMHgBhs0y1xkcojc6tGKo0bNl71+P8cmnMFRStfHbjGcn4rkH6apAEKSRNwV7KyvcsZ99gUa8YTHqRRQibQjpFWBxv2+kYxno9xT8YHA8Sfv4GrRbMQkoAkGndWHw1KsTlZboZJwC1GHi7IZRfkPlraQJJkKgWhPE8mgLC/bRgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153674; c=relaxed/simple;
	bh=V4oPbzBrcKKqOvHEdd5IcgwookqPrrxhwEMHS1WntvI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gGj0ggrP13Dew1C5RjX37j1mB36foSEXX3yVCxRIdt6OiFahiYkXYh1vxlpcjy8HY+kOCaopFMnuneNetIVgHso/JNMZtlYZM3JolEjzv8joLPZ7vg3NuPskHOzjR13AQZrMZRsufUVsbWWpoGkr2jqUpEmAKoS38a6iEuzq3X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XRE59pTi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XRE59pTi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C211F00899;
	Wed, 23 Sep 2026 08:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790153664;
	bh=HCQ0jNW7l3C4SSTOI//M+1izwKBRjHEIFCHCjP+7fFk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XRE59pTiUJmwNyk+Cfj9jWMHnKEwgBTApwCwNDyyhw6kE4wT8M78HJwpvitJ7Kz+b
	 1qqgePaNeA4RGWHOW5/ysNG5UaAUmOWdJbbTfBG4y2XcIh8L3WxqwSfV6ETUH4E4b6
	 J4a9/S05Z7QOp139U6nsjPu/jUJ3luK5x25XWgwoy2Ppup9QR+1RlLv7dCepOpufwd
	 z2xMgPN3opQzNY+qflxJPTAMuI+sIizcdyFFKXd8Q0FJocFTs8yRFx5Z2URjzHmUNj
	 c+iy9sM2gm/b45hHbottvvpjbOrW47RZ+Gxx30QGNdF8YkUWFgQKEgOIIn5aez6/fh
	 aK4PUtuqM0vvA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v6 05/12] net/rds: split connection destroy
 into quiesce and kref-governed free
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260922085410.391323-6-achender@kernel.org>
References: <20260922085410.391323-1-achender@kernel.org>
 <20260922085410.391323-6-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 08:54:24 +0000
Message-Id: <20260923085424.74C211F00899@smtp.kernel.org>
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
> rds_loop_kill_conns()) and, one at a time, when a peer negotiates an
> unsupported protocol version (rds_ib_cm_connect_complete()).
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922085410.3913=
23-1-achender@kernel.org?part=3D5

