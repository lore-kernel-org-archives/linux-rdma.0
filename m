Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CA7371056
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 03:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791430342; cv=none; b=ebvMUiMQvS7yM4qBk4j0RktKr2+UpnQ5c7jvMaiJ2p3kfhssPjzQU6HR1PwhVk299QU20QLM4FfYHrQsKW2Q8xAoupMB0PHpmkv/JKQVJw4waqzwNPNH45MEwm3gUjvbtQEEnYcMAf4wzPz7ny4g9Wln+sV4mwUcc56bnfgPb8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791430342; c=relaxed/simple;
	bh=urZiKGrAoRCkeUsM39N68Gzdgoa87neFjh4Z5Ox+rT8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=H2QxDTImmRfjOdb2eeL5Rp1tPeU2mCqzDoHzMNphZOywgyc6rDaHwhSj3VIcvAW/h34MBjufGPQ9xyvgj6qqZai39e66kIyuyMoGRgYTg607FZNQKLCjEHk0wM887k2tTgv1Y+lJj23daL17bui9pJ0Wkbtp5JG9glG3+j6ShM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pm5cw0zR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pm5cw0zR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990971F00899;
	Thu,  8 Oct 2026 03:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791430340;
	bh=Q18GOU5Y6jWDto53X2S9RZJdr77i6iuv0BThA2Wh1Ho=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Pm5cw0zRtoM16D9dCZc3hHUITD3PjJ9WSfNNgGDSWqIay7Yz2HTHOjX/PjsmVYcz3
	 jaDt3aAu5V3cppIdgGJVdydzRnSwR9kifIc/OYK/A9CSGnQHS0YSWAy8WefArTkrsn
	 sBFc8nEc9Cgj7MgoUWZyZfE3cKhiocZANnA4+0XJUe0EZkoJRguczsiN8e/bCO4q/P
	 RjG/5FMY6QP0W1hoGmznTZWKd1qvFewsVtO4coD5QKfyal61kYLGOJmHrx+lYMDQ7Q
	 jp3Iy/A1jd08vVUXNELuIMJQR72L+WTZpjf1zeS0Ev9vbQvTquHkKG9nWja1d8mLwe
	 tCYtBQiauTIVQ==
Message-ID: <sashiko-outbox-163552@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v9 12/13] net/rds: pin the connection across
 RDMA-CM event handling
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261008031333.1142174-13-achender@kernel.org>
References: <20261008031333.1142174-1-achender@kernel.org>
 <20261008031333.1142174-13-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 03:32:20 +0000
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
> rds_ib_add_conn() refusing a device that rds_ib_dev_shutdown() has
> marked.
>=20
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008031333.1142=
174-1-achender@kernel.org?part=3D12

