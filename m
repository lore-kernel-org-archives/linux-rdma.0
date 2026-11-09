Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794223807;
	b=I8s6oj6GcYT0w9AN6Sb6xjj3nsVGpFIntkONEKRDV/ki4giV2XvRrAZ8HQFhWmmsrgYv
	 /TnX8oC2NfqmK78OJ7eP/n0p4d1TfC6pDaQGet+ciN1Vpr6ZLmuZLxnwfPI7FHwhgpKbp
	 6AS7Q8l24CDi8Pu4Q5wwSnRtsuV/0X8NKhteZ4WFVv9JJAycG8OPERiBlH6tYbDKFzOD4
	 88SOnxxmeVDa6SKYMQ4L86djrJlxx2d6O1FWNrP0oFKldDQwpBbPp1y3Qt2BRnES/aikw
	 IKNS3aAHN2wiGX5jqjafRn0DGEEaJHYJBXan8sd+KGETepCoZdfckUI9MSsAe+LBMcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794223807;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=Q9bg4GFkoWaAK2C5zUAD66Xn134QnbGdqRvjABS9U8A=;
	b=nVVAj1YcggFYJKoHbtjAQ1XebFcFtgOYQLVq+d/ETWsHHKP5bppSjLT1wP0EXZtHa87B
	 ibmTkCipbguUBYD/LNYJvRpVyBMXQ1hOVnQxryewcPvcHHIfsrlJ/4HSa2sL4sYlDHY72
	 cpMLUM74yVf7/yabREastk2NvXmvvjFFNbeZT3g+BTnpXbJVdhhT9xpQAcZ6Q25n97QCu
	 QXz71P27ZZ0FEuY895eXWs/ikzUnwqKolm40QJ1nmtkbVOi/OJGkHb6UbG0B5FWLtk/wm
	 GcMZRRVFXby8Vm+HKzAq4bJaXOL5vMVLGW0tOge+sZHCjO0dEYcTccZ6A8O+k8X/fuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UpRw8f05;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E80606A32A;
	Mon,  9 Nov 2026 11:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UpRw8f05
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A7B1F008A1;
	Mon,  9 Nov 2026 11:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794223806;
	bh=Q9bg4GFkoWaAK2C5zUAD66Xn134QnbGdqRvjABS9U8A=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=UpRw8f05BWm66qF1RCk5ZxC1d89csgDJvNs3yjEYXhffEuvBsvLUrPi7mbq3WFzC4
	 fgRTkg3zJuVCwY549fhLJcmyuN1MAV6XmwfmQ7BV2V0ozC92HDTW1/d1DloVRH/7ey
	 wzOpxc7kR5BGkMMgGsbuHvv4/SUdnPEXKKMlG2zwpEjZHF1yo9MrorSR0D/0bccSfe
	 F4ipKRT+NIEhb1/E4WSVjt1UQyOHdW7eecc1x9wtclsEKrfON5QXV5W29DNquPRnZE
	 QnuvxEwqKBDZWXxfdkbGtweT3S6oNzNmH/t99geZkcXqIFud8X2A7BRwokWyZC/Nr5
	 9SsvUp6ZQo6pw==
From: Leon Romanovsky <leon@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>, 
 Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <20261102061938.617371-1-yhlee@isslab.korea.ac.kr>
References: <20261102061938.617371-1-yhlee@isslab.korea.ac.kr>
Subject: Re: [PATCH v3 0/2] RDMA/srp: bound the receive IU the target asks
 for
Message-Id: <179422380363.232605.7836961018401691588.b4-ty@kernel.org>
Date: Mon, 09 Nov 2026 06:30:03 -0500
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


On Mon, 02 Nov 2026 15:19:36 +0900, Yehyeong Lee wrote:
> The target decides how large the initiator's receive buffers are, and the
> initiator never checks the answer.
> 
> srp_cm_rep_handler() takes max_ti_iu_len out of the SRP_LOGIN_RSP and
> srp_alloc_iu_bufs() sizes every receive IU with it. The first patch refuses
> a login that reports less than an SRP_RSP, because such a login hands the
> receive path undersized buffers, and a report of zero is worse: kzalloc()
> answers it with ZERO_SIZE_PTR, which ib_dma_map_single() accepts on a
> virtually mapped transport without looking at the length.
> 
> [...]

Applied, thanks!

[1/2] RDMA/srp: refuse a target that cannot receive an SRP_RSP
      https://git.kernel.org/rdma/rdma/c/bac7e7bf07cb64
[2/2] RDMA/srp: do not DMA-sync a receive IU past its mapped length
      https://git.kernel.org/rdma/rdma/c/915fb85a378e02

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

