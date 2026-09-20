Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0661E7C18
	for <linux-rdma@vger.kernel.org>; Sun, 20 Sep 2026 06:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789884731; cv=none; b=Qeu4el6J2wyO8RpWl+OwRLQhIC2Mx8GrXlbj79Jh+coFEEIg/K1YeN5Y4e7jSgIPcxqGfJ+A7QwQQAoGBhMppKsQ2FCVB52SgrnP9TyWFc/X2dtmwgLqCOMQBoAUvDNLGJBK5LMep95T5Agkph3YzOi3CeDqcFZbmGlsoJAm2jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789884731; c=relaxed/simple;
	bh=Xa/5AmkzHGkHUwV1B9mLJaki59NXTUIyBwR5cPbJ474=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EVD6LXpok58GOX+j4sJUv3UASptR39ecTjDhvn5J6+MS4I7s8VMPwg9BTeA1zv9brm9me5koVuJcVgzRC1c9FVWLXNKbFfg5Zf2r/wyggkWQygk7fHob3hQfcwGo6FOwcecFyu9OZvmKBf1pE43sY89eHroaFfycDzD+90qdKx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TmL8I5pZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TmL8I5pZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465C51F00898;
	Sun, 20 Sep 2026 06:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789884730;
	bh=LjHuVMD2ZCEniH0LUGZgZBljEffnehQL8YUMuJjXMEU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TmL8I5pZ535bcuc2Jxtr1XQ5TJgd1OKVbTKA2Rcu581SEG9efGS5GNKQKcvVcCvuS
	 hRY3ivDuy7HCd/zn2045DlCDyd3yUIyWcDVXWGHRz5arvYrrnycFXggl6QxbR9DPfo
	 Yddb9Q0CCapcBmc/+7qCU/t54Nmvy4LqQlgtDmm+gCjcSh/Sx4J5F7n8m3YubuIUyR
	 4ZI4fXNVwqDBDhPn7IScPsSx6zbAUChwmwAmRU8wVq0t5UnYRVOkFpGsinlwyYBKxE
	 op8YD+EL9Q23titxcMxG/kBZgcVBqRSCjUsnOEF3w3MRZiFkdhbdRT/foChnjZifWE
	 883x8DuoMjDyA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v5 10/12] net/rds: pin the connection across
 RDMA-CM event handling
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260919061149.250658-11-achender@kernel.org>
References: <20260919061149.250658-1-achender@kernel.org>
 <20260919061149.250658-11-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 20 Sep 2026 06:12:09 +0000
Message-Id: <20260920061210.465C51F00898@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260919061149.2506=
58-1-achender@kernel.org?part=3D10

