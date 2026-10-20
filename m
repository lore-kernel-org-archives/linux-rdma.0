Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792481333;
	b=dpGa7tIeClJMfm7dH5DMi2lujQ/dTFdraQTosU3a6T4GMla6+W9mgbLCo97hiJX6jI9a
	 i2USuTfXja2gY9a3Tpx9U1D4jmWBTRa+OV2cd2JsIeCaJykHN/sEqSX90CKucHv1738pK
	 PvesVbKQYLmUQjUOygOpZ9g5VqoiicB5otUb6gM3wb1UyW2M+RZuuEPOY6ooqxPeUJQ4U
	 h+SQtuebqCWLcreSibxjPY17ZbWDBue9z/1El5GFhA7AWJcP/wrMcxR3sk+Ox+0XOvinX
	 DAqKv1v6yXAS3FOnBofimajhLknzluENO6Qxs4l6C/dW3ffb32et6EormfsoY4dfEqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792481333;
	h=Received:DKIM-Signature:From:To:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=dmD9D8RPrM81jpIubbxeAy2zWVCq/I0y/3bjHdDWsSI=;
	b=TzvYvm+1WVlR9tVWeBFMHU2Btci9NG+P8wrhjkOUWYAE6ve+0/bqulZEpYLNfsDNz2UU
	 9tUY+tZ5s6/AooGxEUjJo5t2p7ITi/4l6wZy+IGacF5nrXBDqBTUeHB5bVQXSSlmOjcoQ
	 XAnJSZPZCU/pIrUQkJCEof/jipAIbyOpZZAZne5ONIXCaeUban3auqnF4BchO8UXETeGb
	 2i4VVKfd/SeginJUm9GpFmmelZ846Rn5wkCBgGnyt3cep9dGOr+NAZCl85E9lZikXv1Q7
	 pcowPDCsvy8bRdOBm1o+gNjp24vim6q+Aa/VP/BMl4cObhjUwui7DsyKMxOtUnQXqSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Om1c5vJV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF15606A319
	for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 07:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Om1c5vJV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5407C1F000C6;
	Tue, 20 Oct 2026 07:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792481332;
	bh=dmD9D8RPrM81jpIubbxeAy2zWVCq/I0y/3bjHdDWsSI=;
	h=From:To:In-Reply-To:References:Subject:Date;
	b=Om1c5vJVldDG1e5S3NkihjEYWSJfIInWZqSyPuBXJSgatrnrVTmNa+8qA93C+lLqR
	 +/auE0Gfh+TLFzRu5EkpBHwlyINhheEOlu4jQGprxoTZ3FgVmj7adw7ja2Uab+6BMH
	 iNz9FSpAxvF+/CBi/oFRBdqQqRSDlQLZJiO1+VltpecDk+sbkXqIqPqeIU/iBNkr0e
	 tiiXNqODRnkPzkvuEYJZDMbXtQ5zCjcpHPBTU5enmWCgaxw9uBjrHZd1yi2PO/pPNw
	 9HRvI4yQqEVcpTwBCknKTkRSHkL2Ko9aTf5NZeDU9x4CQ5TzoFH/TPYKUyNgWImrsC
	 eZ2Qgv2LA1QxQ==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Eli Cohen <eli@dev.mellanox.co.il>, 
 Roland Dreier <roland@purestorage.com>, linux-rdma@vger.kernel.org, 
 lirongqing <lirongqing@baidu.com>
In-Reply-To: <20261019050503.2313-1-lirongqing@baidu.com>
References: <20261019050503.2313-1-lirongqing@baidu.com>
Subject: Re: [PATCH v3] RDMA/mlx5: Fix CQ resize destination index mask
Message-Id: <179248132999.608853.8099862001557728305.b4-ty@kernel.org>
Date: Tue, 20 Oct 2026 03:28:49 -0400
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


On Mon, 19 Oct 2026 13:05:03 +0800, lirongqing wrote:
> In copy_resize_cqes, the destination CQE index is computed as
> (i + 1) & cq->resize_buf->nent, but resize_buf->nent is produced by
> roundup_pow_of_two(), so it is a power of two with exactly one bit set.
> Masking with a single-bit value can only yield 0 or nent itself. The
> buffer has nent entries, so valid indices are 0 .. nent - 1 and nent is
> one past the last slot; whenever the masked result is nent the following
> memcpy writes one entry out of bounds.
> 
> [...]

Applied, thanks!

[1/1] RDMA/mlx5: Fix CQ resize destination index mask
      https://git.kernel.org/rdma/rdma/c/0fe31052d948a3

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

