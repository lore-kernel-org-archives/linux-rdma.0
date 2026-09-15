Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC4741D22C
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 03:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789443457; cv=none; b=Ws4EKhOxiUaC/YozQzwfy84kGNUdnEBYPSY3SdUVKc2DhOQ7MWpsPHygpR3oxpx24DRoUDCu288NsZ98iKiWGzUJmqptEW/mIQjD6+NzIotzHhwjmnp4Egdsq3vEI2d14NDm/7Bd4RdCFpcGynOD6RsDgULTZ3LrTgkpjukBe1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789443457; c=relaxed/simple;
	bh=MkxSmnFB09F0b9C1lcGKfTNSv7HCHjIXHl0x0JuG4D8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=YuVy2Yd07zfi60S8I/wOp5IAW78q+Z6tSyE++4/Y9i6nojcwpCNXsSnq5Fyb3w1vCL0p2aZGVNvgY2d4KejUbcaGjH5+HMaSbt44Z6Iweyq7wKei9eCsO+9wUCSo7NPF/7fICsFTlqoDR0JS5blYN0AEy7oIgRxgVH8+JrtSQqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=glSCtrTO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="glSCtrTO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284641F00898;
	Tue, 15 Sep 2026 03:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789443455;
	bh=53mOs+wgz3bi7+2R45voZoyS5FgmnPlV19z6pYVPzEQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=glSCtrTO9gjwXJ+muDWTDWJ5irrYKOFhf+uuQFjJxKmKq3Mg7SO0R0v25fkwaxkDh
	 7wokFp7zPtfOfT93XpdP6doRJYqhpsSFloL78a6RZsMWWVRHA6RLVHnh1UbhKRghRL
	 q3i+lvUOoWufvgSmhD3WDif3L7qZus+hWJbhfuxxZdgqKDQAm43qyf2RXIfW70Zv4e
	 Pm4oQu/trorgZvpf0GgH2wZ3wRwlTav5A0lMUNQ1Oy/0Y33du2jBM1fKcz72VzrTha
	 xLDK2fEZi6fqXNt3uBDJUkZoAm5cJLTV+3ZguxUcyeBgwMAMfz0ZzS2zSBHKWqjPvn
	 BmA4Eg40j+NRA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v3 05/13] net/rds: split connection destroy
 into quiesce and kref-governed free
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260914033719.138057-6-achender@kernel.org>
References: <20260914033719.138057-1-achender@kernel.org>
 <20260914033719.138057-6-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 03:37:34 +0000
Message-Id: <20260915033735.284641F00898@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914033719.1380=
57-1-achender@kernel.org?part=3D5

