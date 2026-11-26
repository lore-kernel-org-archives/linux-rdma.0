Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795652754;
	b=F0OCxsXHO1m7hfZUNfQX1QbotFmOoCJ0BGHZ6dDkaX9+UAzkF8Oqx7ezHCm+ELZhc/y9
	 ma5lR9SC6f1f4z0BEsc7k+hVucMe6A9iKvSxZtwFsAPS6CpHyuJLIzlvrbujWoOwOUOlS
	 oI4Z79qfELsMO6Uyx52Vu4AWSfKLvtLpU1dTzoqyXxbo5uFbYO1eL9MfltAVHmOmPn+pT
	 L/B8veQ8kyUaX8r1nXlSRZNm86U1c4JF5SKFyZvJMqzcpWZa8yizWNOtRbEWwqOKDCn4z
	 jtfb0lgZx5qGzNLtkOP6u7L7nHsGWMOyflBSc+ufuuPO0qliS4PPhei3Ws9+lpfMgZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795652754;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=DEct91eXqHwHosR/PlQfj/kxeS6hT28qCOSckdPvPv0=;
	b=u4xO+815dPIbTlv/Rqhx39tTmKdX2rwSrQLnFjGUySugruf8cT1qJEac4B0DRhV8FlRZ
	 84iwveZhP0qC/sB8pyYemdQVmmBQ+LxqBqZSVmdDiynZAPkwXgo6p4EqRbNxbjQ/U8cZS
	 0fC6etiJmU2Pk4UDBcmsdnKlTuhomunXgWjz6uD1Ua08sQyHKsC0372aTH2XEdQdyVIEI
	 RUs85auHD10JxIZ8SrFCHu+3opuC6KGLELQjeNS5eVIV2DAf13hf9HBLkc8GhYBlZS0w3
	 8fsnf1Wa0zyLhF65gZ+00Ct7M8HUkb9DW53wgInZN3NXp9qeadCl6GKhyYPzA0NWHog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E6J2wqe+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FB7606A321
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 00:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E6J2wqe+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C2C1F000C4;
	Thu, 26 Nov 2026 00:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795652753;
	bh=DEct91eXqHwHosR/PlQfj/kxeS6hT28qCOSckdPvPv0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=E6J2wqe+RHZbslyVnf4jvUX45ibAg8NEYlcCH3VHhEIvRbLGtL4Wp/24djqAWl/Dk
	 RI/FTLH7Fk5C5mlnpDWnECuRJxHbTiFTWf3HmVqFfey3WV7onSetdeW3vU+V9ZMSuH
	 prNB3HUBYEHCTILOOtmtRYM2qTYToJdPUaoKxiHDC+QrRTNpNFKi6gN7GhCl/fE11a
	 c+ToykmQ8OnkMnwUAlR5Xgipkmrrg/Tqzxc5IYCAiCsioe5NRaBYt9i+Q1chRgnte8
	 mJVonYWP6qkGvOnMNx2B9auYzpiqJIr6Kzvf6mn5lYrs7fM71YzbQw99ddDZOJplLC
	 6AMj+v8WHk+xw==
Message-ID: <sashiko-outbox-234474@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] RDMA/srp: Reserve send queue and CQ space for
 ib_drain_qp()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Praneeth Balasubramanian" <praneethb2002@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261126002227.3598226-1-praneethb2002@gmail.com>
References: <70bd9162-e9f9-4580-bfb5-cc29107a4126@acm.org>
 <20261126002227.3598226-1-praneethb2002@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 00:25:53 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Praneeth Balasubramanian <praneeth@ucsb.edu>
>=20
> srp_destroy_qp() calls ib_drain_qp(), which also drains the send queue.
> ib_drain_sq() requires the caller to "ensure there is room in the CQ and
> SQ for the drain work request and completion".
>=20
> SRP reserves that room on the receive side, where the queue and CQ have
> queue_size + 1 entries. Commit 9294000d6d89 ("IB/srp: Drain the send
> queue before destroying a QP") switched from ib_drain_rq() to
> ib_drain_qp() but did not grow the send side. The send queue and send
> CQ hold exactly m * queue_size entries, which is the most work requests
> SRP can have outstanding. If the channel is torn down while the send
> queue is full, for example during error handling after a target stops
> responding, posting the drain work request can fail with "failed to
> drain send queue", or its completion can find the CQ full. The QP is
> then destroyed without the guarantee that ib_drain_qp() is meant to
> provide.
>=20
> Add one entry to the send queue and the send CQ, as nvme-rdma and iser
> already do.
>=20
> The missing reservation was found with an LLM-based tool that checks
> callers against the rules stated in kernel comments.
>=20
> Fixes: 9294000d6d89 ("IB/srp: Drain the send queue before destroying a QP=
")
> Cc: stable@vger.kernel.org
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Praneeth Balasubramanian <praneeth@ucsb.edu>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126002227.3598=
226-1-praneethb2002@gmail.com?part=3D1
