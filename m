Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794443459;
	b=OcYSW5gBg/bFGhHHfsvKKou9PoUlAlXD1royTFzcbYobI7ZinyUrDB7qF+l6mAiWsTuB
	 5pqIMzVpaNX7BD0ogIt/0SD1RfqKs4mgHP0VMT5FbopSr1+jaLxGBBTpBbDmBDJruSi9i
	 qZB9uG4e1HBEptteeyNqwJZMgiBvDEPEWrX4mSs6wvUpZWdcmODRvlb2BZWQN3XXlVJrQ
	 AIttBunGkN/0uPyQ4MCtiEcZaXbfCooA8r7rzSdQekxSxMz4PGMuL2CfCUQa/0kkHR2Nh
	 tgrPVM26/5T/axkfJbebcIo8FHlWQiDSY1KPURsq+PPhtTxTKabxSoiXfg35wkez0FA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794443459;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=KtSOgS0IYH+s3iOWjZRxLNf2p/EksNk9mFXjusJIRn8=;
	b=nQX7nVuShAHdl6UaDnSzgmqixiy62iDQxqcrzpLlilYdMmqcTAzqLeU1d7sU/4RORWYo
	 uVz13vwCCagyByftFHzM3OAdHpVvSFK+G5KDjzKsCnQMamlKY916Vu5fcMDny9RuiBIMm
	 mE9khsehil5yIgQNhaFPCHksemV2VwYscqFnU5cNHLitYJCtmHiRYYETLX1gXzI4kiGwv
	 x19TC3M/PC+AMWQijXFOGFEdKWtLkztsWvAymrxFxPrJkuvViXu2WLR+Sxw86Vs4z3TTA
	 ed79JZp/F1RM4dN1PdMvVkFJfp2A4uVCymahBuM1JWtljZxSk0UCOrsXPDm8g5GIPjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GFubs3GR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D1C606A324
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 00:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GFubs3GR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C45B1F00A05;
	Thu, 12 Nov 2026 00:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794443459;
	bh=KtSOgS0IYH+s3iOWjZRxLNf2p/EksNk9mFXjusJIRn8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GFubs3GRO+VQdWpaFDNaVy35ntWPWGUbxk2gMxwVIdGmqZ0e8cJnalM3ZuIcFPRcL
	 uLcht8UCoq6KWms1MfkMUQzuwCNT+bMregK0PCjUqiYkW2bZlH4p57Dttd6DntWme3
	 T0+AKRg3ILAvCfpCtjWg83+NeayGTRkE5ZZ8C+G6A4OEN2oftHusdvIKcqLGKfwmoS
	 0KH2fD5TIgdZTOGCXrOGCyJTtnmOkTB6gy44EX5zeuwJDSpcyn5DcaewYyZLIs9F6E
	 4uzwlfAWz5UX6RX0hhGlPUOpPdy3QTi+wV8qKo3rq+RRCGo4wmeqfR9Ao1kGjHMFXu
	 rOabCYdv2ib5Q==
Message-ID: <sashiko-outbox-209925@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v5 1/8] net/mlx5e: ring the tx doorbell when an
 accel offload drops a packet
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261111001831.3710881-2-toddfreed@meta.com>
References: <20261111001831.3710881-1-toddfreed@meta.com>
 <20261111001831.3710881-2-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 00:30:58 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> when mlx5e_accel_tx_begin() drops the skb, e.g. because psp can't
> encapsulate it, mlx5e_xmit() returns without posting anything. the skbs
> before it in a bulk dequeue may have been posted with xmit_more, which
> defers the doorbell to the next one, and an mpwqe session may be open.
> the device then doesn't see them until the next transmit on that sq, and
> since the queue isn't stopped, the tx watchdog doesn't fire.
>=20
> flush the sq on this drop like the dma error paths do: close the mpwqe
> session, post a nop and ring the doorbell.
>=20
> mlx5e_tx_flush() doesn't check whether the nop leaves less than
> stop_room in the sq. for the dma error paths that is rare, but a run of
> offload drops would post nops without stopping the queue, and could
> overrun wqes in flight. so check it in mlx5e_tx_flush(), like the other
> producers do. the completion of the nop wakes the queue again.
>=20
> the next patch makes the psp drop reachable from user space, with an
> ipv6 extension header set on a psp socket.
>=20
> Fixes: 2ac9cfe78223 ("net/mlx5e: IPSec, Add Innova IPSec offload TX data =
path")
> Signed-off-by: Todd Freed <toddfreed@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111001831.3710=
881-1-toddfreed@meta.com?part=3D1

