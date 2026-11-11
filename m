Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794357863;
	b=wU7w2Bsrw9Cew9J9a/9C2Ag5jklUyxuMNCkfPsGLKagtSkp01BWyFk7HGfOdQdWEXoD+
	 LCgJXFZxA4W9xUBLTH5DwWqGtjLDbnbASLR37LAxjD4ViyW/0Z2w+Ph01G12j4d9zhi9u
	 NXNsdB/wpyqPyZfkIaqPpeRCucm6tQXF3oLIfehnFMkS16wWZzUZyT/h0jMfexcr3UIZQ
	 tyYfh1NRwW5LXPBuZhq2l7/wPVV1j/IC+yOJEiovg0bH85pRZSedoERq5KkWu1vMg+NrJ
	 hb23XyIx6g6cERuXX/BbCXjnyy8zeYNPurGfjEursgADMQ1ihi5JvcCrTgbcUp4UUvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794357863;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=8oqnPwNZ9QuIUCkiqQZgQ2z6Wmi9drWxAq99KWLaH8w=;
	b=MC4u81wAPC9aMm0Khu1lvbAr46zDNQfpwIa6a9ctImSKx7YRgq2bwxgdLZHRSfcQuBLF
	 GN0aHgXJXAUrxzC4IF4qEnVyxaCkCHc6ZMyu1ZdomI5vW+hB90XXLTCqkj3EelQ1JUS++
	 dG6+zI+MdvWWMqqP67AzGWMKWUbHja4DfmTlr1TyByEpJOOpfCwrPBPPZH4BI8Z2fLcsw
	 FDOwEy484x7yAIN3FvdPuw1TTYXi++xGm0LdZhmYJ0Qhavo9eu0nG/LJzSujC8FElB1OX
	 PbyiMgnXNbjTZTlpw8x0U0nPUfhrmG1fJ5iQxQFHs64fYP7BtpXb5o/mA1kksqiUxYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=BdE71XlL;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E171606A325;
	Wed, 11 Nov 2026 00:44:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7E171606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=BdE71XlL
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jPPss4VQ2z1XMYJg;
	Wed, 11 Nov 2026 00:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1794357855; x=1796949856; bh=8oqnPwNZ9QuIUCkiqQZgQ2z6
	Wmi9drWxAq99KWLaH8w=; b=BdE71XlLFoQN1tu3q9sh0WsCmkwxXz0pRG8CNHKf
	9eEzCj1c6FRAgYDDeR+OKKTnFg3+JOgfKsi1AmDFuvsEjKu7SximDhbau9607+bl
	S2xGfBcaXVwBWDSHZ8soi9nLVV/tcq84KWsXgH+E0JFj1fH6LVkN2d1dwJ9phjP2
	nCIG3PBE5GIlAJKMzQ1wifPFEi8s4GiVhpkEm7pdyTAsdwhKBvgWoAmp0HbifgVL
	TzUcnW6fOc6yJfI9BEOGc1Az8DeoWUjJbsSju53wXIpFwZjy7C1B+mdmiIk3SxjH
	Q5CbNpu38jR/y7Xp2WYhUoE3xHrL6gs5venlXKBcrK43SA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id dmXf0lVUXjJD; Wed, 11 Nov 2026 00:44:15 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jPPsq16F2z1XMYJb;
	Wed, 11 Nov 2026 00:44:15 +0000 (UTC)
Message-ID: <70bd9162-e9f9-4580-bfb5-cc29107a4126@acm.org>
Date: Tue, 10 Nov 2026 16:44:13 -0800
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/srp: Reserve send queue and CQ space for
 ib_drain_qp()
To: Praneeth Balasubramanian <praneethb2002@gmail.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 Praneeth Balasubramanian <praneeth@ucsb.edu>
References: <20261110222421.205573-1-praneeth@ucsb.edu>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261110222421.205573-1-praneeth@ucsb.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/10/26 2:24 PM, Praneeth Balasubramanian wrote:
 > srp_destroy_qp() calls ib_drain_qp(), which also drains the send queue.
 > ib_drain_sq() requires the caller to "ensure there is room in the CQ and
 > SQ for the drain work request and completion".
 >
 > SRP reserves that room on the receive side, where the queue and CQ have
 > queue_size + 1 entries. Commit 9294000d6d89 ("IB/srp: Drain the send
 > queue before destroying a QP") switched from ib_drain_rq() to
 > ib_drain_qp() but did not grow the send side.

Agreed. srp_destroy_qp() reaps the send CQ before it calls
ib_drain_qp(). After the QP has been moved into the error state, up to
m * queue_size flushed work requests may complete on the send CQ, and
the drain work request needs a free send queue slot. Hence, both the
send queue and the send CQ need one additional entry.

 > Signed-off-by: Praneeth Balasubramanian <praneeth@ucsb.edu>

The From: header of this email is praneethb2002@gmail.com while the
Signed-off-by: tag uses praneeth@ucsb.edu. If this patch is applied
as-is, the gmail address will be recorded as the author. Please either
add an in-body "From: Praneeth Balasubramanian <praneeth@ucsb.edu>" line
when reposting or make sure that both addresses match.

With that addressed:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
