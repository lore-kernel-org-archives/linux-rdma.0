Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793699581;
	b=lX/+9zC7Er1kB9BHB3Lt3JB/adFr/dJVB5alqZI9UJQVD2wFRWih3P14kDlgFQWo62R+
	 HDeHFxZQbQPRdiR/V/ks5Eqmah5xHGSUmqaZty1EfYSMdbZbNLFkzOyeP6wfv/5kHfIzK
	 mBwl/VUH5eDGwde9TkbxUomBsqQeVeQUHtusIIQn0avAXdT+HjmQIbsNuuI5RSNNdG1pe
	 giCHNDdHrTV6aQmBo5g1xejMAf4FhyzcgvHlBjxfY+IAwVenuXLlA8IrxFgCS3u9L+Enx
	 E/Bj/tN97kkLj8yAq1dgiI16QlZmMo5WYVLSisA+VgNb0WrsQamYFjpqI82SZ/jh22A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793699581;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=My0Z66KYNuRTAK3B795dnm8lK2ZMXMW4aavFw/8R0xM=;
	b=eOQZ5KRLjDlZU8MVeV4lpdPq7W/zdekm9NES2bMIHNTechzyRsY6cE9Qaf5sTaZi8Uc0
	 /j5KrMTsZNyZ/DzBEgVpOPXjwzGoplXAFXmnjgjJ9wgjhwy2n326pY7moODYXrk948xlT
	 mIfdNBDd4wxYyBoLnR2GD2+bQWd5ckVir5+4eYSpmy1Cfcozpnmg1goXeTwaONwAla73Y
	 Ntsoj8gObdod/NO9mPctmi1ElfatASheHxTY4QPD9pZkVGn7PqsObY5DZOhB3uLdadUJU
	 rRabUIPoPceYwS0y60OQdZFFDS2qXPKvbDU/VkUQ0nH0ePA4JIQfbZPXHX+aCkY0QhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZtqS1jy+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35EA16082BED;
	Tue,  3 Nov 2026 09:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZtqS1jy+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A851F00A1B;
	Tue,  3 Nov 2026 09:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793699581;
	bh=My0Z66KYNuRTAK3B795dnm8lK2ZMXMW4aavFw/8R0xM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=ZtqS1jy+YkNh/dusWp74kZOjGgEJPbo09JcPUd7JZiNBgXFL68rxZb76qlpeP5PHY
	 +sY/GPIG7+iuKTV6cDE42VArd0HnhotreVjoORDNIsiUzEMMzHfIoK6mh6kNSmysM7
	 NzksDfTukp22zaCX39Ff260mkElMwMg3Adh2F2Zdo9+c6/PjXjFGk/K/SpB3HDJGKy
	 lLvAVHAdQEFm0Iuo3Kqgkv0/iTxWUqzXZYlQt+XxrZlkqzDsIA6mcyO6m04yF3rXoM
	 zY5eVeJWjFJL0eWS29GEfgqGQPFBt2tpHBM+W7hm4QMrfUASOjbNbeWQkmYDFbKLDd
	 OPbZSIZ67pdrg==
From: Leon Romanovsky <leon@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>, 
 Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, 
 target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
In-Reply-To: <20261025013748.3755639-1-yhlee@isslab.korea.ac.kr>
References: <20261025013748.3755639-1-yhlee@isslab.korea.ac.kr>
Subject: Re: [PATCH v5 0/3] RDMA/srpt: fix the descriptor table checks and
 the context counters
Message-Id: <179369957811.1712752.1012285000662293438.b4-ty@kernel.org>
Date: Tue, 03 Nov 2026 04:52:58 -0500
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


On Sun, 25 Oct 2026 10:37:45 +0900, Yehyeong Lee wrote:
> The first two patches bound initiator supplied descriptor data, and the
> third widens the counters that hold what the first one admits.
> 
> A 510 entry table fits in the default 8276 byte IU when the additional CDB
> is empty, so the bound accepts it and the counters then have to hold it.
> With only the bound, a conforming command carrying 256 or more descriptors
> still wraps n_rw_ctx and leaks every context it allocated. With only the
> wider counters, a command that sets ADDITIONAL CDB LENGTH to its maximum
> still walks a descriptor table that runs past the receive buffer.
> 
> [...]

Applied, thanks!

[1/3] RDMA/srpt: bound the indirect descriptor table to the IU
      https://git.kernel.org/rdma/rdma/c/d5e2467b86d496
[2/3] RDMA/srpt: reject zero-length buffer descriptors
      https://git.kernel.org/rdma/rdma/c/f38458ac4ff689
[3/3] RDMA/srpt: widen the indirect RDMA context counters
      https://git.kernel.org/rdma/rdma/c/f9258be57e3e19

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

