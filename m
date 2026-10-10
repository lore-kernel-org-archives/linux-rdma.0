Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844424AA008;
	Sat, 10 Oct 2026 14:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791643326; cv=none; b=O6N5z9QBMRSJn4hopgr3R/cMy+oUBCAR6mDbOcTJzgDwsszr1Rz4knAVnvCZj+I7rwvWXxf0aaVes+dgg6Eh5uz9I/wdLOTkP2jBLhO49xiqmPegDX7s4tu/9HEWSB7GbNl8j1qznQhNrZmHuUsm4DNtKlsrZUAuxURWI31JfFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791643326; c=relaxed/simple;
	bh=+3m4RjeEqa4oR+t03fmLSElcLGWjsJyPJHQ4JE5efoU=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=HmTec7XZutaBaY/1Zj4fUL/4KNrhC81NxVUDapJaZnKV/2WWCOqm0ahHHx4aDTeScsM8PaSjndJKpGTcv/NhHO7o52CgBp4jUuKzPnM1YHR1XY5BygdLHLMlIyRXodBH7rK3+OFchiAcQ+uS+nyOm17oymHK3DbqQKDqDqIugl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mPLlMOTU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mPLlMOTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5DF31F00893;
	Sat, 10 Oct 2026 14:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791643325;
	bh=+3m4RjeEqa4oR+t03fmLSElcLGWjsJyPJHQ4JE5efoU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mPLlMOTU6Pj9FYLCyOMzmrvTbEj4g+9Y0mEfAlvC2TpHET4vRNhHAKgt6pyxf0J1A
	 OGb0hQTTMzU3TBOaVcjv+G4gdM1Pu4TQciN82vYgaiLaDlp4SOT1whOJFtakfOKMWk
	 2XVYIh7Z0kbNxUTyfgRUJBOygpjKJhxfRmrJSUhBfwGkGDqcz8NWo+pi5EK6ZrCZT1
	 7t1aOF4lfbxW6z7h5VOWPCSu4M53UQvJ6Rtvk0uQjRougnsSq4OgYrdH38LfcQb0U+
	 8MNTfcgsriFnKBX4qhpLhS9+9SlRN/EL9l2tT9knX8fdSf2z17HPwI2nKt5wrz8c0p
	 ZU/JEUpZLXx5Q==
Message-ID: <sashiko-outbox-166659@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v6 01/13] net: mana: add queue-set allocation
 and teardown helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: bpf@vger.kernel.org, linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <24eeca6a691150407d5ce94650d3ee51cf11b620.1790795005.git.weh@linux.microsoft.com>
References: <cover.1790795005.git.weh@linux.microsoft.com>
 <24eeca6a691150407d5ce94650d3ee51cf11b620.1790795005.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 10 Oct 2026 14:42:04 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Long Li <longli@microsoft.com>
>=20
> Add queue-set allocation and teardown helpers using a scratch port
> context without releasing the vport. These prepare reconfiguration
> to retain its running queues if replacement allocation fails.
>=20
> Leave ordinary mana_dealloc_queues() byte-identical to the pinned
> base. Do not introduce reset generations, sibling-port rebuilds, or
> an incomplete independent failed-FLR TX-buffer policy change.
>=20
> Queue-set retirement itself performs no function reset. Its caller
> must drain old published TX queues before publishing a replacement;
> unpublished sets have never admitted TX. The first live-swap commit
> adds that nonresetting pre-publication wait. These helpers have no
> live replacement callers yet.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>
> Signed-off-by: Wei Hu <weh@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1790795005.gi=
t.weh@linux.microsoft.com?part=3D1

