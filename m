Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794827735;
	b=FrVus+UCrP1uwNRNWrSeAuMGOUepjX0roZW4BlRK9kgK3AVIYOy02KknEpTkChlkvTDN
	 /hfXwGcra4fXCbHVKx+5VoEagwy8AZXHO0awqDSwPHt8TrTTJRuGZPfnwWgMe8O6fKnqL
	 Zza35KF6wbDBj+11guOqVQ7h/qYSD2qmIG7h6c1bgGEsnMWI7b4ccJzQRZUzI9u0t9rhB
	 X+oETtHlNSAyzLkcJkzFpM6kbHXi/k6ewY1pqkFPAUnQtfKXmIIvgP1JJDci5NZqfhGVw
	 zbEEuMrDBrvnatydVtPPJGiKa2HGygm52I7Hh7lCCk0U0E5xdUbU6DaxiY4rYR+Hn1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794827735;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=aIsVTnrlSw5qcvPRup5WA1LAzyZIdMQsvOzKMOIKwTU=;
	b=l+OEbORS0huw5OURze1be6Yc6OB/JDe5FIoFzxxp7HYYdQ3uCp06IsJ7cVy50dqTQqsm
	 JAJpMEAuJmMHihRnd11n7yf+eYixlJdFNwrcyCmDeCR0qvwC2Qu2mKWZZ1aTAp4lTFpVE
	 xgy+VV4RPF431pAoPH/3ETglP8b+vq4gVTzXEm5IIJasIJfb/HvKiG/dZZ5bhDARAU405
	 hh5J5lQQ755zpikV+dvaruuWPxkv/3hgiKe4CfPtkdrtoqxAQhm7a0clyCfBxNh0KVILl
	 zxeTF9ajGkSVV+Dzr4bFlDwCscbIfFgm7wqHvkEqcfJ4gSSulVkE37/3hTYjGv8BaGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DQhgf9Bi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58CC1606C115;
	Mon, 16 Nov 2026 11:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DQhgf9Bi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464CD1F000D0;
	Mon, 16 Nov 2026 11:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827734;
	bh=aIsVTnrlSw5qcvPRup5WA1LAzyZIdMQsvOzKMOIKwTU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=DQhgf9BiOQIGUVMDCyBkVpb3T+W3WuaoLUH7LWvfDY81StvEuSWm39E9TRc2+qDnQ
	 6ly3gUSNkLCbrqhETt9X+EzH3135hakhE59BgstHJOjokieBc5Dr7vdaHdeVjsTdGF
	 0y0pRyFSiQaK//8ISWlE2Wxj86MGJVXUk0roaxsAkAobXH27yzoJLEV0j8fB4yYSa6
	 n86Gt/NMthHsuMO07wnXlcki3UshJwf3L3Bs43TtnDwF1UTh8uxPTmMiW4V9h5UwiN
	 Md7SrM1NQm0HNzwTNOZBzdtOUjutF2bQfcrXUlwVIBu06d47ZpCnSg45lLp6kxjEu2
	 qvwAcAn86QDqw==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Changyul Lee <lcy8047@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261111191913.98044-1-lcy8047@gmail.com>
References: <20261111191913.98044-1-lcy8047@gmail.com>
Subject: Re: [PATCH] RDMA/cm: Read the remote_id_table root under cm.lock
Message-Id: <179482773184.1347973.7401493507813884116.b4-ty@kernel.org>
Date: Mon, 16 Nov 2026 06:15:31 -0500
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


On Wed, 11 Nov 2026 14:19:13 -0500, Changyul Lee wrote:
> cm_find_remote_id() reads the root of cm.remote_id_table before it
> takes cm.lock. While it waits for the lock, cm_destroy_id() or
> cm_reset_to_idle() on another CPU can remove that cm_timewait_info from
> the tree and free it, and the lookup then starts from freed memory.
> This lookup is done for a REJ with reason IB_CM_REJ_TIMEOUT.
> 
> Read the root after taking cm.lock.
> 
> [...]

Applied, thanks!

[1/1] RDMA/cm: Read the remote_id_table root under cm.lock
      https://git.kernel.org/rdma/rdma/c/a6b0e712b0fccc

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

