Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713926;
	b=Lf0t48X2sKOv6W2SjOD6pFc8PLLFzCokD/cVimq19Z+7aJlnFkEdSL/FfFL65oaLfn3F
	 uJRBN6UQvSnMxJ48QoIhvGrj5Jm4EQFfKTM9DbOs1SW3JamTk1b0mTC6FF96K1c3fpFEp
	 1MiUhC+QRQWrAhoxJQCr/83dNQShSwVwVwZ9QkaDAY43d2KgMJyES4NQCVy/f/ueigvfL
	 CXEWUj2f+s9Dan0wNGibfAzdGrdErtXBrztFjkYKRsMh2mX5g+w7fa4xybleYK9CWdjAx
	 pzMKxQ1WYSsgEf/3M4BKUhmU8o7ze7xSy2bkk04K9tSjqRz7P+ReO9aO2GWh+FX+tCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713926;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=W1tkqKF93EHK5v1LmFbojcUWZtW3bK8Eocj3ZPj09P0=;
	b=UqHvmEcVe2Zf1jF2/75iR/Zv6rhem6HqG7acJmiqYyDrrNtsUXDI9jmJcqLXDD2nOfOX
	 QQ0JJDaRHKA14dEn/F5VvkuDbQ5S4acsqxad6VMxmwO6nJUi7S19HCe0beOUPx/sFxTFm
	 6hfYv8BdE/DnK3YJWvCjzUCS0MyXMIOayM+YpkTV6lRZO4Z6jW4z0Tn6GzdMQnYbsusZC
	 YcntrjzYbW1y9u1UgcfaEpNQj2n2tAtSSjHxm58FuuNa3LZe2BvFieALb1iOSDLQqmOk3
	 Oz0OTt+7HcyNUXtqFzJsC8WQXpZ1xP0wMVWTvunnZ1mVinPAY4CYQfH/Z1VB06VLW1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="K/n/rmOB";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691156082BCC;
	Tue,  3 Nov 2026 13:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K/n/rmOB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48FF51F0093A;
	Tue,  3 Nov 2026 13:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793713925;
	bh=W1tkqKF93EHK5v1LmFbojcUWZtW3bK8Eocj3ZPj09P0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=K/n/rmOBfIf1cNYRN7pQ2I5IiMt8Hf4XbACakBlz4xqpsSp8owd8YyjSt0N29Agq0
	 MbXe68/dA3Au0e2tImespBQoo8oKjp0SfGUnbDndCpbiqol88qFaTO6VqzH9Jcmljl
	 b+3cdfpxhU9m+wxEHZxKvFtZdUoNdzlk1Uic0GXb4gLw8r0zGQuVHFHKC+eyishg2G
	 eyJ1s756v9+yjzdRmFL+ey5nESMY4SyoiQPIx4+OjwkDrwuIZLEyM3wp8HsIwmqPpe
	 TV/gTCJ46ugFRkP/55wOJYmhkyKvUjM0c+p0608Z9rBnfxqLzL882NP7ETOVy/lIJ3
	 4L0iwsKQ1y/RQ==
From: Leon Romanovsky <leon@kernel.org>
To: Zhu Yanjun <zyjzyj2000@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Tristan Madani <tristmd@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Tristan Madani <tristan@talencesecurity.com>
In-Reply-To: <20261030193235.3470653-1-tristan@talencesecurity.com>
References: <20261030193235.3470653-1-tristan@talencesecurity.com>
Subject: Re: [PATCH v10 0/2] RDMA/rxe: copy send WQE to kernel buffer
 (TOCTOU hardening)
Message-Id: <179371392293.1727833.9297401437119983949.b4-ty@kernel.org>
Date: Tue, 03 Nov 2026 08:52:02 -0500
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


On Fri, 30 Oct 2026 19:32:33 +0000, Tristan Madani wrote:
> The SoftRoCE (rxe) send queue is mmap-ed into userspace, allowing
> the requester and completer to process work queue entries (WQEs)
> whose fields can change between kernel reads.
> 
> This series copies each WQE to a kernel-private buffer before
> processing: patch 1 for the requester, patch 2 for the completer.
> Both paths validate opcode bounds and SGE indices after copying,
> preserve DMA progress across multi-packet operations, and write
> back updated fields to the shared queue via WRITE_ONCE / smp_store_release.
> 
> [...]

Applied, thanks!

[1/2] RDMA/rxe: copy send WQE to kernel buffer before processing
      https://git.kernel.org/rdma/rdma/c/a668a8564748d5
[2/2] RDMA/rxe: copy send WQE to kernel buffer in completer path
      https://git.kernel.org/rdma/rdma/c/195c20429f13fd

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

