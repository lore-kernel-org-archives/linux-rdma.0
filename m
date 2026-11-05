Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793884219;
	b=dkEeWHv10piB6i6KfLt6k6HZ+KtMu2pTcRoNW+2O7+2DXBzlaXn5+3S4eN3RUB38Vlv9
	 VvWyBOMviYUUhFFhmrD9YycWmrT8WLycdxvChG756sfRnhkh/lkCObmo2REm31BlL0yXr
	 IysXwPGvCu/Lgpw03BvhL5OTDvCw4c+lEFDo2H5wmSdne+2dT7yxNrXssORQXfvr4fH44
	 r89XDYwAC0z0voJSQCv/RQQASUFJAUhXWP18m2r+TqFwl+EHcaSSn03LwH6Z4yLacI3x7
	 nS0BXbGaQBSqv21A88yN4c9GrHNNtmO3hnNSCT8s3XNaEVBjc3LbvqxSqV4fb2odqRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793884219;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=3cUkyEpktu+NmIcQ3SdYEc+BYO4x2GEJ6xHGd4FeclQ=;
	b=2BIOaXnWdC9UpRLVsr8mhQiaG+OOxLMspqKCZHmbWmKr7+FCom74v/6sS0hVEohAlSdV
	 H8sRWJDrfSpCev7/PpGJaeA6gzYYx8Xxnezb4v+OZGgaCUnfKvGqNv0lx/EvZ6qOruJB+
	 i2MJdcL0lt3RhWk7B4lHO6Sjv/0N8lot/Tr4l2ZtaHtCxNY0HCDI5/yUqNJHN2ruoL9dM
	 UmIkyYEu1LsNGmGtlhEFLeNDYIhyZLtTnYxij8Q/LPVNg7nAvW6LCdQl25jUO6c6JlvqR
	 g+Oysks6Tz9bqMQcNB/wyhm7SKP4Lh/jNjugCR/S2Yv7tyKGK+yKQW62ykD5vmLQCCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LfY1dxnG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8389606A31B
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 13:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LfY1dxnG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D35FD1F000C1;
	Thu,  5 Nov 2026 13:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793884218;
	bh=3cUkyEpktu+NmIcQ3SdYEc+BYO4x2GEJ6xHGd4FeclQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=LfY1dxnGDe6pQsULX3xdw5Mny0/1eQoXbXqItgFzk8POXPB63AALwtta8LDCefBhi
	 QMNb1Mvqd7Dnfo8CnswC/IRsvHCbcomMqfFGyzthNZ5sJz7TajT6O/RaABI81Q4XBr
	 duDDJuTHr2gvW0St9vZcuGLuMZGL+K1iA5wtHdhLqtXoUAhu4OPL0BKrSnP93+RWC/
	 p7gN6z0AXOaL8JLltaF5qzzQC0x9rLOYfn0ZdS7qNz7ixB200l72Bb1ojYIMLwU7M8
	 VOVsGgt8LYQlywVJU4F4id4+w2hCSDUiXtmMY55+BiLxEfzONJ8lnnX5auvKlAIvph
	 yeUWSnQclPHCg==
From: Leon Romanovsky <leon@kernel.org>
To: jgg@ziepe.ca, Selvin Xavier <selvin.xavier@broadcom.com>
Cc: linux-rdma@vger.kernel.org, andrew.gospodarek@broadcom.com, 
 kalesh-anakkur.purayil@broadcom.com
In-Reply-To: <20261104200244.52979-1-selvin.xavier@broadcom.com>
References: <20261104200244.52979-1-selvin.xavier@broadcom.com>
Subject: Re: [PATCH for-next] RDMA/uverbs: Zero the QP attrs in
 ib_uverbs_query_qp
Message-Id: <179388421542.3218.2626156510779264377.b4-ty@kernel.org>
Date: Thu, 05 Nov 2026 08:10:15 -0500
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


On Wed, 04 Nov 2026 12:02:44 -0800, Selvin Xavier wrote:
> ib_uverbs_query_qp() allocates qp_attr and qp_init_attr without zeroing
> and copies fields such as alt_ah_attr, path_mig_state and sq_draining
> to userspace. Drivers are not required to set every field in their
> query_qp() callback, so uninitialized kernel heap memory can leak.
> 
> Allocate both structures zeroed.
> 
> [...]

Applied, thanks!

[1/1] RDMA/uverbs: Zero the QP attrs in ib_uverbs_query_qp
      https://git.kernel.org/rdma/rdma/c/997ca6555b9fc3

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

