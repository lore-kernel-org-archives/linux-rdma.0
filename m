Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69E1443307
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 06:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790576125; cv=none; b=fos681bC06JixNY6c97OrTnrM6EyJ0HaUPUizQfrNzjCFWBLtHGYvgpAlgnYH+LCZMyL5oaQ4EkryNjCud07mxnWGTbaABosX55cOham99VFPp0WyaKn+P7R1t7SZ2LdL8KjQ17wlQgW8d8LRHq+WEBvO3dcJz85gPernkZ//+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790576125; c=relaxed/simple;
	bh=tP7bCw7btx6yLodQJ+ci14Tb4BQnejSjy5tCG8CJM6c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kkXDpvNRiwQx7EUvuXJW3n/NUJOAnodXzoLfBM127nk3TI+Rr/V6U5g5yv7vUY9/NdsHY/7Jz6LFugKIgDVLhxktFla0StiEu9EbxUJrnXmJ2DE6CTJ5YxKMt9ElQ8PiR7GxLbYl6KRnxVfXfIbFdg7F60OW6XDDFyjkjHdkYu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kE5J6Ejj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kE5J6Ejj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C641F0089D;
	Mon, 28 Sep 2026 06:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790576105;
	bh=4b/HHpIDDnqyUAJIAIH4PX4l/680jkfTQDoDoR+3oD0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kE5J6Ejj2KzSyyDMrwhZkH3RPk+UMvxF91lLk3h/kT0EVM7mfHd3AxwsQXb2508nN
	 wsL3AWUI30L9Wk6FVk4lY4fb0W7S4TFzYE0iMFAkrHaNoeRckAbd3YckxlTSMQyGYt
	 VsDC2++DBBVbafskLleB6RO7I571lEVlogCWfhnYltjYckI87DieVlqh+dQ1YxTEQv
	 z0oUQwqMyVAylbqZFUR5v9e44brXdGZaNNRSWI5MIGyyx43PJTZT3z72ReNdC7lQEs
	 hFR5oqy/m5kb0Af0bCXu/Q/4yB49UCyk8U3PLV3cUZFrQvJyJkZn118yCpeLSU6XPo
	 K2CKV0JR/9tUw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v7 11/12] net/rds: pin the connection across
 RDMA-CM event handling
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260927061448.167862-12-achender@kernel.org>
References: <20260927061448.167862-1-achender@kernel.org>
 <20260927061448.167862-12-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 06:15:04 +0000
Message-Id: <20260928061504.D8C641F0089D@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260927061448.1678=
62-1-achender@kernel.org?part=3D11

