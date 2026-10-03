Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A171E39891F
	for <linux-rdma@vger.kernel.org>; Sat,  3 Oct 2026 17:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050192; cv=none; b=P6+AZFJZsGZFzC6or/SXfYZGAR2XZqoIncK0k2TfpDDq704P07SmZh3+XUTd8VwVLISD8Xi3P+ExGNN1tDOmuo+05y4u9TEj2dr0Vxt3n/v8+cSIgDmVIrUraf1B+5gIXeZszO51Y1ry6CZARWbu9JANYMUNfW+OoTIF3G2J/NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050192; c=relaxed/simple;
	bh=GDRmQ7JdPSpLaeRchCn5BQrO6bVIb8UoI9/1oI4DO9U=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=r6ohQz8z+QtILCVPQ+3t4zSlGOM8hm6jAgPoJGsfNQ7Vs3OvImYG8alw3e8mdIGUtnsbQ+flC/SocgGLycueNnZFGHqWjzJ4SV30P7OXoTNXQ3Byz0esmGTPK3PsyjLS6LUAxW4ZqTqWEsRNIM9Ox8Sg3BKdeLtAzj8EQBYcIMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aPAOi64m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aPAOi64m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF381F0089D;
	Sat,  3 Oct 2026 17:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050191;
	bh=shpTBDZZ9g+yeOGkoeILmLL5nNBaX6oXECHHYUsoMyc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aPAOi64mqt72bABPcyZ/HBiKFiP7Et7pjCI7ZwMQ5aMuz2WcgjAO/Qnb+RjGt0qkr
	 O+EJzkHv9bTiKxJSQzgKc9ycgGmGGdAuwDOw+6sIMLYw00AYZaGnBTjc0H3I2ZWpix
	 q2o4j3jxrmq60fmR2ZbWi0CEUaJWt2dKTLMX0J+ouMipgrxp08l97505bzEURefMiF
	 VQzy+b1uGA1bMjgr+jGtHgG+b7BSxf/UnQlVkUSq0D3yMcFzKzcvVbA/n/VwUtrVvY
	 L9x+aHw61pwA5V5BsKAFbZznSXkZlLAlEAvEYGYDAByiW8d7TfAm2vHEXx0wezjy+G
	 RJ2KXJXa913qA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v8 12/13] net/rds: pin the connection across
 RDMA-CM event handling
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261003163215.250253-13-achender@kernel.org>
References: <20261003163215.250253-1-achender@kernel.org>
 <20261003163215.250253-13-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:56:31 +0000
Message-Id: <20261003175631.6AF381F0089D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> rds_rdma_cm_event_handler_cmn() picks the connection up from
> cm_id->context, which carries no reference, and holds c_cm_lock - a
> mutex that lives in the connection's path array - across the transport
> callbacks.  Before this series that was already a use-after-free
> whenever a callback destroyed the connection, since rds_conn_destroy()
> freed it synchronously and the handler's mutex_unlock() ran on freed
> memory; the one such callback, rds_ib_cm_connect_complete() on a
> protocol version below 3.1, has meanwhile been switched to
> rds_conn_drop() by commit f97d8c7bab78 ("rds: ib: use rds_conn_drop()
> on protocol version mismatch"), which also removed the deadlock that
> destroy took on c_cm_lock.
>=20
> Now that a connection is freed by its last reference, none of the
> callbacks the handler dispatches drops a reference on the connection
> it was handed: the version-mismatch path only drops the connection,
> [ ... ]
> away, and nothing would tear them down again.  Re-check
> rds_destroy_pending() under c_cm_lock and reject the request instead.
>=20
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003163215.2502=
53-1-achender@kernel.org?part=3D12

