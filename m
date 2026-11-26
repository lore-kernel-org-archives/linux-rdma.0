Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795719183;
	b=ii4jMq5O5oTkTmfRmD7CGeUNiMCPgWsOevByk2qqnUzhfoHtrD1xVfZ827VoodYl1g2+
	 Rq2AZ0JlB5PolFbIGpgr9rC1A3uBJAt/uuJhWB2Icbphag7YPtbQWT48gYZRCZYeUEEJc
	 w6WRRWAZYAx+iIkqRvCL8z2QGLtCYJVwFVSgDFYKIi65/RuBp+c4r26jbqV9YbjL0Tiz0
	 9Poj3c5O4gRLUqxZ6IeEp/fZjX92mw9lD349pbV6OutkJIn/7ftZK0ze9ZFTOx29/CB7Y
	 YfoK/o/JAWGWchdNYSi7grRlW5BtQr8F3qoIxqyfZ+opG9bX6YKy4xXoMoA6iqwdV5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795719183;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=ZxuOEuY77r1BVBtOkZ0+BPmez4QF02B9BaHjTytAurU=;
	b=xJyaCu8f3tZMYOJ7HFquomvAdOseAPKx24haXcT4HG4pnn/EIVjP2R2JYz7jKscRy99s
	 i1xkk3yJD8yBTY2Le8SoRuUQ8C3GmqlIZGC3uU3WVWadO+RBhMQiJjevPo2xUGEfInN6/
	 N9u1eXIOXTWsNkTyBTrxZ5pGa6s8DAWf/kH8rDX0gBzeKYmx40HK6Z/gMyMSMuY5NAHLr
	 /Xb3xymQlqxtHi0Bb0KpUFJAshv2918mupc1/Q8CiXkHTgOhmwbI/qIkWQ9rylyGtPrCF
	 94wSGPumiL+nk1ClDBlMzmN18INx5tHF6oGXMhXblLdXmENCoFyN3W2oIHWJk7LZTxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="m/C6wK/v";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442A0606A31C;
	Thu, 26 Nov 2026 18:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m/C6wK/v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC0E1F000C0;
	Thu, 26 Nov 2026 18:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795719182;
	bh=ZxuOEuY77r1BVBtOkZ0+BPmez4QF02B9BaHjTytAurU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=m/C6wK/vKN0BVQdGyaf0Q64SN5mSoxJndHpQVKEpkT/vKwd6CcD6mO6qOXRfyG/HV
	 xdMZmckkcyjig+RXl7XssfluR6vL11WdWo7A7yzSnpP3xNPg1eel9CN3VT/pLuvKLe
	 52ZVGK7k+cw/NijVLTXE9vGWqMqHiwWrLXIKs86EAX0nFx00jZPJEY7PpZ7KkCdQem
	 Fs2J8Wt6T+wD5Urkvea0pVxQZ0jptHTBGAaCZ0ROEVzQMrV0qa2MiLMcqH9zr4xn5F
	 VohcXMh4+la9vBQLakUZCYJ6giOG5J7mjntFTucPZUf7rzKguWm/mdqGMPEkafY4N9
	 nBXyG5WcoQoZw==
From: Leon Romanovsky <leon@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Praneeth Balasubramanian <praneethb2002@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Praneeth Balasubramanian <praneeth@ucsb.edu>, stable@vger.kernel.org
In-Reply-To: <20261126002227.3598226-1-praneethb2002@gmail.com>
References: <20261126002227.3598226-1-praneethb2002@gmail.com>
Subject: Re: [PATCH v2] RDMA/srp: Reserve send queue and CQ space for
 ib_drain_qp()
Message-Id: <179571918019.1293210.177305723817097808.b4-ty@kernel.org>
Date: Thu, 26 Nov 2026 13:53:00 -0500
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 25 Nov 2026 16:22:27 -0800, Praneeth Balasubramanian wrote:
> srp_destroy_qp() calls ib_drain_qp(), which also drains the send queue.
> ib_drain_sq() requires the caller to "ensure there is room in the CQ and
> SQ for the drain work request and completion".
> 
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
> 
> [...]

Applied, thanks!

[1/1] RDMA/srp: Reserve send queue and CQ space for ib_drain_qp()
      https://git.kernel.org/rdma/rdma/c/2e869a30085ec1

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

