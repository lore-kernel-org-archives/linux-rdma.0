Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C5C4AA402
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 07:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789717235; cv=none; b=Kn56tIawTeBHAiTFxowhxAOk02occFGER1weVWGzfLz4iMPu5b6rezC7mVMj3YjEti0P7p5P6zT+F0EPjZGfC7uA1MLJJy9v/NWHUtogjjNZTpXOvHXUSt8JL3Hwn99cKMJNcjQTUCqQxkNPw4U3mb9dhjmA2EwQAC8VeZtnUzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789717235; c=relaxed/simple;
	bh=bsHG4tRRGfZSJ0jPJaCMYcDbmAOrPtPCGHd63K8AXcw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=blJnPF0urDqSwERg3Q15nLbHNDgwx2/58A8f7X6cwpuM3MQAM0hzAmMJEjczoH6A81kSBwhP+GwPgeC06XvNMWfIqJZiprxbtHdWyixN9y9Lpa7wu1M5CaLWLj7UdrB63cmSHJ7Jg5oKGqVCPcvIeW5UuVprurpnAN9BSMzaWFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yj83yOgU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yj83yOgU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E021F008A0;
	Fri, 18 Sep 2026 07:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789717213;
	bh=B45vWwtVcAup6P943IULRqGsUOHC389kiGyANWtpHxc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Yj83yOgUBmss69fVq10WdoFgsDqjLeeHVWIe25mQtuaovtwme1sHVp7E3hPWihGuD
	 tJqlInt/0F87lbRyWqi2gn6s12jXbDGebEIx2lxfp5aYKZHG08YD2nFLL36zu/nXTp
	 IKv080VK41MJRTwwb6GJQobjKDnZXKxqeCDcYZVSIEsPzfWUcWigKN/gDMFQ8HbvOE
	 itZi+3J3N/uhZATChyaN7kpxbu6tUu2TBqkcQQG3Xx3fxSSz2aFvuM3fyMzBMo1x/v
	 V6bCmr472jWNANIlAY0Zdni9ZXG0z5YPIuq7k1lqNLT8YVHogqny31GOOHTrtz6V5q
	 6mDv1ERXXzUFA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v4 10/12] net/rds: pin the connection across
 RDMA-CM event handling
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917073958.174056-11-achender@kernel.org>
References: <20260917073958.174056-1-achender@kernel.org>
 <20260917073958.174056-11-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 07:40:12 +0000
Message-Id: <20260918074012.F2E021F008A0@smtp.kernel.org>
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
> Now that a connection is freed by its last reference, the remaining
> exposure is a callback that drops the last reference other than the
> handler's - which has none - and the reference handed out by
> [ ... ]
> away, and nothing would tear them down again.  Re-check
> rds_destroy_pending() under c_cm_lock and reject the request instead.
>=20
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917073958.1740=
56-1-achender@kernel.org?part=3D10

