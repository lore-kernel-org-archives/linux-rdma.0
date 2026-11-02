Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793601094;
	b=rHcLjsXv1gzDdvBxLABKrsqxyMYHTKdkWNt/rZf73ioJJbQ3n8VW89ybD8sorsNZyd3U
	 rZqVkTTnqs4Jco8lo12EgQvklxUTCkkUW2ThFRiSzN28EjPGmrWYLRI3QoteKNds5AjIP
	 JUeB+tRwQYXdqwgythmPNtsQkO4JTzmUaG9HwKZkB5LRyrm1YtkdTuOcpuYRbbHdJQaJf
	 4UhI+ZSS/Wpjw1VzL/XQfeK5YHDuAYuHYbaw3opaTMwxydq9rQBPXMX9WyqMhuMj6SLa+
	 d7eMNqJ1wlmxTvQEftux5BEu8eezC2gYorHkSDgFvU3+1/wDtMqJzfNc2jks/E97dBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793601094;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=oRyN+vAFTxvnLE0IhN+wyTVAw3lnsHX/d4mRKXPEl6Q=;
	b=DoDaBRd5J6SnBKkVYLn2TbZ6sqwf2iJfVScCrgIF5fN5vf15abqBbplv8ZsIolSM0OAC
	 YoZzAZHluNQhMd/3sSPHPIXgarCC9wqMEfZTjo0TQqX8BBva5l9qxYx7V4G3+aCx17G8v
	 zvwrFIad8+nPG7cNlDRnj7zpO2JCC0G0wt13Tx45pf5JDiL7FZP/u4Fo4ri5thnhA2T6y
	 3J7vODqaSeQbXuYp4pvfQWg4ipUOK9cm180q15J9jlWxBQwYjy4J2daQ+qZR3jkpbNshL
	 jn0iuGtk1w5FOWxrovXjeleSGpHhqdeCyTmcdTcm10u9R99iYlIgPgJ4NszWgLOmTWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l86KFKYW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A27C606A324
	for <linux-rdma@vger.kernel.org>; Mon,  2 Nov 2026 06:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l86KFKYW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDC241F000C1;
	Mon,  2 Nov 2026 06:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793601093;
	bh=oRyN+vAFTxvnLE0IhN+wyTVAw3lnsHX/d4mRKXPEl6Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=l86KFKYWvVISJQTxOLJaFZER8Qr+57X1OPctf+EOBxggikN6YiVjk0ii0HfM/7hj0
	 wJRj7CrZMtcU1WPISrtDGhDh8L31YNIGpDhRrDIgwO8sWpTSaz/r5CwHkwQ+BoayV9
	 fA/WqM5H1wcNdAfJ4SnSr6kc7mntm63qZI5YGFC1F5dQrgSdAdiPJiD8bOu/5v5NHK
	 wqyLA3SviCe/3g1F/T46cGN/1E2j4zk/a+VQepNJX5OFIXGbUrsizmK3RCWK+QsHC5
	 Bnwq7EQJcppvsY47w1TMoubvTgP60Semhdl2K+3MAoPjQxIuJyz3FDKMW/4AIn1nw/
	 fCewmncv9JQdg==
Message-ID: <sashiko-outbox-192959@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/2] RDMA/srp: refuse a target that cannot receive an
 SRP_RSP
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261102061938.617371-2-yhlee@isslab.korea.ac.kr>
References: <20261102061938.617371-1-yhlee@isslab.korea.ac.kr>
 <20261102061938.617371-2-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 06:31:33 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> srp_cm_rep_handler() takes max_ti_iu_len straight from the target's
> SRP_LOGIN_RSP and srp_alloc_iu_bufs() then sizes every receive IU with it,
> so the target alone decides how large the initiator's receive buffers are.
> Nothing enforces a lower bound.
>=20
> The initiator parses a 36 byte header out of those buffers. A target that
> reports a smaller max_ti_iu_len gets undersized buffers, and the header
> reads in srp_process_rsp() then run past the allocation. A report of zero
> is worse, because kzalloc() answers it with ZERO_SIZE_PTR, and on a
> transport that maps addresses virtually ib_dma_map_single() returns that
> pointer without looking at the length and ib_dma_mapping_error() reports
> success, so the buffer reaches srp_recv_done() and the read of the opcode
> dereferences ZERO_SIZE_PTR.
>=20
> Refuse the login instead. Both the largest messages the initiator parses,
> [ ... ]
>    allocated 33-byte region [ffff888106046a80, ffff888106046aa1)
>=20
> Fixes: aef9ec39c47f ("IB: Add SCSI RDMA Protocol (SRP) initiator")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102061938.6173=
71-1-yhlee@isslab.korea.ac.kr?part=3D1

