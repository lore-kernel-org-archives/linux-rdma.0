Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793168287;
	b=WlghJ2/pgVt2rfnBHi8Kl+mM7MeC1t4ydQRXC3owml1FREKO2XgrP61T3hZ8z5afsq/h
	 gHbdRFRuzZ/SlHWQc1/cWPAIBCbndYgrc6Jgoi65z9E7IZodIkBTanWdDfpQeiPC7NJW8
	 OqkeECtpZD5DkGkGRwLYpOiAZ3kCrnYUtxCi5UESx5EcxP3cljygRIf+r9WZf905bJCTB
	 9Pp7Dvpn4PTorRK1J8AQomnC+Is6J5VS9tP7tmnswHQLoTm0+DqVf/S+tg7JkLlr5vQqJ
	 yb5KDNOFRL6Z10SheYcDuQW5zOManH5O8AlxvJREXseNRCOoI6VauYZmiCXihDKA75g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793168287;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=cBAZO+R38JOBsBpekJthljtmMcSoP8FvoCNmEe2UGg0=;
	b=O8ZJFzvBerc6nFrMao7lLHmNsoy2RMewqUmiKRfUSsCzhgaCKs0QTlxi/xgd7lkeLvlc
	 kv1MuFbV5X9Mzdh/Wib/mbmTo1ODfCYLz4LSVmymzdo3ZhPN5qumKS0Gm32hPAF5FePoa
	 9HAdUxJgYYeCEaY61QZxS7p/M+TJ7SGi7OgMQI8TqPKt5EGk72fM0g7Dre006g3donpmt
	 9FPTEEtYyO3i0dG5OvCihS5/l+q8nybhqOCWmNlt/09ciXvFtDvq1SbWoAu/ogPiB0PRE
	 4rOjXrMAY3sKUyq19jVngLdzY0H2YWPgKY6BPK4eTLlWvQqNUPHSHlXdQotVxDzJAkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hzvXf1mU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CEC606A31A
	for <linux-rdma@vger.kernel.org>; Wed, 28 Oct 2026 06:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hzvXf1mU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD87C1F01825;
	Wed, 28 Oct 2026 06:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793168287;
	bh=cBAZO+R38JOBsBpekJthljtmMcSoP8FvoCNmEe2UGg0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hzvXf1mUayPjoJVAKu3PBXly6TTm/VGQLAYrSRILkljFukn9QDfGFOZNcOYTU5oDV
	 +DSc7bNPtWKIQgop36jWZp/n1IFpQL4alCHpMXV50tETu+fHX4ftv9uVQw/hVagodQ
	 0tsCy4cgIwVwXTEWLAOaSuMd4MIfBvV/zshkbteIOhh8yw5924jfLqSoWaP9+XoCez
	 vXh8//j5MbMrrZQanP7QUFQ18s2ERUMSZpm/xOa9L/XEqnZQG7D4dZfJsOgoh3vUHI
	 u8Vg2lwTlnhzgWqaBHp2VgdpIRQMWZjXlSsUTjlzEV4f5+QV/ZrtHgFd+8ZNgB4l4d
	 Ly4HmHZR+Rfug==
Message-ID: <sashiko-outbox-187553@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-rc 1/7] RDMA/bnxt_re: Clear stale RCFW resp pointer
 when wait ends
Reply-To: sashiko-reviews@lists.linux.dev
To: "Selvin Xavier" <selvin.xavier@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261028113404.33289-2-selvin.xavier@broadcom.com>
References: <20261028113404.33289-1-selvin.xavier@broadcom.com>
 <20261028113404.33289-2-selvin.xavier@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 06:18:06 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> If the wait ends with ERR_DEVICE_DETACHED, bnxt_qplib_map_rc() returns 0
> for destroy-type opcodes, so the caller sees a synthetic success without
> a CREQ. is_waiter_alive and resp are left set, resp keeps pointing at
> the caller's stack, and a late CREQ is copied into a dead frame.
>=20
> After the wait, take hwq->lock and, if the slot still holds this
> command's response buffer, clear is_waiter_alive and resp. This also
> covers the timeout case, where it is only defensive since is_waiter_alive
> was already cleared there. Return success without checking evnt->status
> when the slot still holds the buffer, since no completion was processed.
>=20
> Also reset the slot in the completion handler, in the same critical
> section that clears is_in_used, so that a second CREQ for the same cookie
> cannot be copied into the caller's buffer. With this, resp =3D=3D evnt un=
der
> the lock means no completion was processed.
>=20
> Clear crsqe->resp when __send_message_no_waiter() takes a slot as well, so
> a stale waiter can never match an internal command's slot by its own
> response buffer pointer.
>=20
> Fixes: 3022cc151197 ("RDMA/bnxt_re: Avoid the command wait if firmware is=
 inactive")
> Fixes: 691eb7c6110f ("RDMA/bnxt_re: handle command completions after driv=
er detect a timedout")
> Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028113404.3328=
9-1-selvin.xavier@broadcom.com?part=3D1

