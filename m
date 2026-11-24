Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795481488;
	b=myTFluna1uTZfpIe8mjSq3Btm167N+yH8hDFDcNLj/N2Ee2AP3aCoEKHQ1zGqH4bE8PO
	 5hOk48eJsB6CuOSEtiLZrWliwS/NpGW6JpR58e+IFcq8B2o9n3/qEKhV++lRwMg4vYkof
	 VV52jvywKXzxMVmFkgwk7SIgCNSAlfQlDLdvdSQD8ZX+NrJn10VLQNA8gNug5gLoYJkHm
	 ZFjhw7NtXE3Nz1JA4+xUQ4uIyE1LcH+vEmYlsGt/zt0xWIE8vZiF3hp24kFTc44ziNfV/
	 7cJ0DLBTM5mPvwFv1S4D1UEKvXynQjXoveeA9+rK9CJGVLdJpxjYL8Xl8063pjdf3aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795481488;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=CupvvumsHimfV7ulNBG68FK+shA7mpf0MF6IOEwDHXI=;
	b=Qoc4kRNt9MQXQ4YQaYeFff1elxNkUYfLpt/X91sy4+ZOimADK5OYMrnP3ax7rIdEh9G/
	 tN3n3tlGFc4Ul9Mj1HQ5AVCcU0han1WEjOQ0n9FU9mqt94JjMhkSR/GcskLThUKanN0aN
	 irZAMB2dQ7W/lNmNXgNg19nffl5j+EmxIgCkfVxG4ziHBR4fZpC4OvBcWR5JMprkYowNG
	 KBU0fnUPaMsypyYhqc8xIo7HlD4/WObDYkSmvF3v8NROIPdMvph5K2MX+3o/PU/Dm8Cxr
	 /1Xgrmcyo1jfh+I7ScZx88mwjbQeOjROmrSEdrEJJemvU9sBHM8Tx2aUJgUltXmmYjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dJq4Prna;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE347606A31E;
	Tue, 24 Nov 2026 00:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dJq4Prna
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 126D91F000C4;
	Tue, 24 Nov 2026 00:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795481488;
	bh=CupvvumsHimfV7ulNBG68FK+shA7mpf0MF6IOEwDHXI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=dJq4PrnaDbsIU2q31nWY81UjyKFLM4moZayU0G5VQlPi55A2mGN92kGGSqI7guR5B
	 MDWYAEl9cG9927PRECHEkNYLADCPDAM/3fdX+MNGHG66zuwKs/nKfMVypV7xolMq8P
	 SKj16Em2/6Zbcs4pzTAjdCeOFlzWnMMeLtz9BIoJnOO9GI5swIen2OwrcV1DOvjr5d
	 ewN/bsMM9h+S4pMXfvK1NZBLtmdXtsfOg9W64GnYYXdCSvMMQEVgIRwCK0gDZ0/Ga2
	 6C9ZHhUqGvXXK0X3XOHIglVqRud3+4Ak3No/sKTUaZVJZdrxnmEsx10GrfBS4Mjor5
	 61mbj06Yqh46w==
Date: Mon, 23 Nov 2026 16:51:27 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>, hexlabsecurity@proton.me, Dust Li
 <dust.li@linux.alibaba.com>, Mahanta Jambigi <mjambigi@linux.ibm.com>, "D.
 Wythe" <alibuda@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>
Cc: Eric Dumazet <edumazet@kernel.org>, "David S. Miller"
 <davem@davemloft.net>, Sidraya Jayagond <sidraya@linux.ibm.com>, Guangguan
 Wang <guangguan.wang@linux.alibaba.com>, Tony Lu
 <tonylu@linux.alibaba.com>, netdev@vger.kernel.org, Wenjia Zhang
 <wenjia@linux.ibm.com>, Ursula Braun <ubraun@linux.ibm.com>, Hidayath Khan
 <hidayath@linux.ibm.com>, linux-s390@vger.kernel.org,
 linux-kernel@vger.kernel.org, Simon Horman <horms@kernel.org>, Stefan Raspl
 <raspl@linux.ibm.com>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net 0/4] net/smc: fix the failover cursor switch and
 wrap rollover
Message-ID: <20261123165127.2453df54@kernel.org>
In-Reply-To: <9f3269af-64e5-4752-825b-5747cf8ddd86@redhat.com>
References: <20261113-b4-disp-1a9ab9b0-v1-0-4a7c8d85d849@proton.me>
	<9f3269af-64e5-4752-825b-5747cf8ddd86@redhat.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 19 Nov 2026 10:08:20 +0100 Paolo Abeni wrote:
> SMC maintainers: please have a look.

Tossing these since SMC maintainers are not paying attention.
