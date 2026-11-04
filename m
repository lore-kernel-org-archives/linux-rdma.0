Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793815485;
	b=XdwBvVceYXIDmfSMq0+44AtJv0eNpyGQm7qUfyHbMF0StvOVYqnYmYxDEx1j8g8nnwfM
	 RB9OO+WPPW4Ss44t6lMGNYUcQcKRkQyNorEuvGtiDK1IxmBb2I/x2jdOcqBDrcPlRHqYM
	 9MO+/dG+JLoOGYQVhQ0LGhZ0FbzWjO+YtMqn1ML6ePeWBStCM7FHaU7oB8rTHunQ447ud
	 3SZVPehVNsqCat85jzk7uCNLY7lWiq8MjW8QgCFCvhaaMH0hdUTu4v1f7X0d2ejP/7ozU
	 KRCmw/5fPhmLM6l6KXY0mIRfqeK1KYTqA3S35rXhEs3su9bcIxK7NN9u27pBL4uDWCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793815485;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=+G78NNvsB5X4SQ60JIyHDaYgJmIiCII+sR87UMBYx+M=;
	b=vvxcPsNo1v5y1IOkeqjf/hOLBGK/v1m1tsuQ3RSsMSRaKgrbZgEEZTmMaZcXiy7m0lz7
	 SZhpnfog2OyUby0ZHvb8yfiBtJPXYLnlkv8BbGV1tnj9CwAfF2sCPMFJ8419OdCr9y+y/
	 hNcseZ2rkUs16KWrAWinUhzpzpIucqp2PgU7oZX3rRdi9Ntyv1NKj1OmYkw09x4gmPYeE
	 KNnTuc2b9MqXRA767PvBv4HVldHUdxZDOMruWez2Zqy9EH+TiLe9xE3CUnoM8dzvOf+PA
	 aJMYmJYAvqmiEsd5LRq38J58mFT/Rlt16cu07gAaF1eiFVrQYRH53/4xYhIj03szG6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VI2W8W2o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A418606A68F
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 18:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VI2W8W2o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 958F21F0093A;
	Wed,  4 Nov 2026 18:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793815484;
	bh=+G78NNvsB5X4SQ60JIyHDaYgJmIiCII+sR87UMBYx+M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VI2W8W2ovr/VF+npiBEfrVPEYMQFUg2ggQsOfL7pG9PIYoSzTysPVet5k5aSWGpkc
	 X0LekeW6IPZr/bq87QLuoZYiXrI8VsTIDN1lYDCXmA9M1UpgUzBlYd7te70g3lyCLC
	 q06eNckVWROY0mLXfePoxYThXsrxCSuSLR/HVkrnUJNYQhP++oVAAR15XbLhNFmMuQ
	 CS63ZM3hOYwyMlCKifWSMRTZ/JLoHJOGKED6bUljFbWNWxl7NImcU/h3oR6x07RQS6
	 AfpNIr+bSQ1ClbeUD8eW5hzmELt1tYMwkSTWgQrKRVPAdcyFzS+L2NJ1GygRaAapwE
	 sZCfMqrcQx5QA==
Message-ID: <sashiko-outbox-197813@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/5] svcrdma: Hold a module reference for the
 backchannel transport
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chuck Lever" <cel@kernel.org>
Cc: linux-rdma@vger.kernel.org, "Jeff Layton" <jlayton@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>
In-Reply-To: <20261104-liange-v1-3-f097e10cea1b@kernel.org>
References: <20261104-liange-v1-0-f097e10cea1b@kernel.org>
 <20261104-liange-v1-3-f097e10cea1b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 18:04:44 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] svcrdma: inaccurate Fixes tag in commit message
--

commit 5aa6827a1ec45b94a0a4813a38c3cc653c0334bf
Author: Chuck Lever <cel@kernel.org>

svcrdma: Hold a module reference for the backchannel transport

This commit takes a module reference in xprt_setup_rdma_bc() and releases
it in xprt_rdma_bc_put() so that the rpcrdma module stays pinned while the
backchannel rpc_xprt exists and its deferred destruction work item runs.

>     svcrdma: Hold a module reference for the backchannel transport
>    =20
>     The last put on an RDMA backchannel rpc_xprt runs xprt_destroy(),
>     which queues xprt_destroy_cb() on a workqueue. That work item calls
>     xprt_rdma_bc_put() through xprt->ops. Nothing pins the rpcrdma
>     module while the rpc_xprt exists: xprt_create_transport() drops the
>     class reference as soon as ->setup() returns, and svc_xprt_free()
>     releases its own module reference right after the final put. An
>     rmmod of rpcrdma can therefore race the pending work item and run
>     freed module text. The TCP backchannel in xs_setup_bc_tcp() and the
>     forward transport in xprt_setup_rdma() both hold a module reference
>     for the life of the rpc_xprt.
>    =20
>     Take a module reference in xprt_setup_rdma_bc() and release it in
>     xprt_rdma_bc_put(), as xprt_setup_rdma() and xprt_rdma_destroy() do.
>    =20
>     Fixes: 5d252f90a800 ("svcrdma: Add class for RDMA backwards direction=
 transport")
>     Cc: stable@vger.kernel.org
>     Signed-off-by: Chuck Lever <cel@kernel.org>

[Severity: Low]
In net/sunrpc/xprtrdma/svc_rdma_backchannel.c, commit 5d252f90a800
("svcrdma: Add class for RDMA backwards direction transport") originally
included both try_module_get(THIS_MODULE) in xprt_setup_rdma_bc() and
module_put(THIS_MODULE) in xprt_rdma_bc_put().

Those calls were later removed by commit 07880fa4968b ("svcrdma: Remove
try_module_get from backchannel") when svcrdma and xprtrdma were merged
into a single module.

Should the Fixes tag reference commit 07880fa4968b instead so stable
backporting targets the commit that removed the module reference?

  Fixes: 07880fa4968b ("svcrdma: Remove try_module_get from backchannel")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-liange-v1-=
0-f097e10cea1b@kernel.org?part=3D3
