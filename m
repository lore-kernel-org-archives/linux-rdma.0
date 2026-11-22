Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795354773;
	b=nKUwPsZxgoHQP7n+yR/4nrezFtJwfWrW0+a7UPwxppZrQiaFqRGOzusqFwTFINvvunMe
	 thviN3opTL/0uQv5Ct5b2p1rdFc+AnwbtQEzsCPKv9Ml/6jXuud1drqWejES7ghmfBYih
	 PmjRYUJm1EbxdVkuIV70iOXOhoyoNMs4YzuZAYxf+uEw15DxlMKlR6rFVj2BRdqG8k7bX
	 Y7HdG5zg06Rox7LeSVcqFNU9wHkNfqXQc+vRXdB3O1hqX3/ZXQiAIXVHxslDTLFCpQ3x7
	 iqK6GyppOzTaC8WogGBFY/yz4kcIIsStg4DH6eEVv+rGQNt3zYl041bQLX9Hf2UG+uQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795354773;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Date:From:To:
	 Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=X8TSjd+WfGzDMUdlZJT7yri6iqipvuTY9+Zv1zoCN9Q=;
	b=5aqgnQbVzsy9Ra1dCKCwTEYX8cYzRk79PHJQoGMI+VlmR/7tqhAH9pWRYScTBI9aM43r
	 2ZbeZdy7O/g4gbfLP2GLSvRKJM3OgEBATpU6bBTfWzLgE3UpuQXGXlszllA30sROtXc8V
	 1MFNW1vxoP/T+KTjjUD+KirWlKe2Zp7vqpz1osTm9nAYkf2JFqkyNFtWl54OCijLBNjA4
	 6P/Il0vcv/0CcHLsYtB8CGTmQZnxoLqrIi3YgG6OdglnuRmWOsdK2Yl/NjPD+rqGTm6Im
	 3JRoaaIiEmIQKYFeY0JEF0ZwdjTH7ID575dVE8rK/XXY+x69qhe3lDYa7hg8WpUStWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=rJ2HZwgi;
	arc=none smtp.remote-ip=115.124.30.100
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08FF606A334;
	Sun, 22 Nov 2026 13:39:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B08FF606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=rJ2HZwgi
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1795354762; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=X8TSjd+WfGzDMUdlZJT7yri6iqipvuTY9+Zv1zoCN9Q=;
	b=rJ2HZwgiANhJqOTYNSHQbI2QZt20aBIuWCBm02dqSIjFp2lrf8+/aIuyK32Pxx5OppvYch7eeOPGo5hm5VoseSwMcoxpkyRbbNg5OcgvavrHa6j47RDQjP4NPBEaQQg50OdFUnN/K5SDeo8mPEd9RbX9boANsSOYKm8zAYWQybQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R471e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0XFB.rel_1795354760;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0XFB.rel_1795354760 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 22 Nov 2026 21:39:21 +0800
Date: Sun, 22 Nov 2026 21:39:20 +0800
From: Dust Li <dust.li@linux.alibaba.com>
To: Piyus Kedia <piyus@iiitd.ac.in>, alibuda@linux.alibaba.com,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>, netdev@vger.kernel.org
Cc: Tony Lu <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>,
	linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org, Kapil Vaswani <kapil@presceralabs.ai>
Subject: Re: [PATCH net v2] net/smc: validate the peer's CDC cursors against
 our own buffers
Message-ID: <awLwiDzVpdJOr6BZ@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20261122042120.2430434-1-piyus@iiitd.ac.in>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261122042120.2430434-1-piyus@iiitd.ac.in>

On 2026-11-22 09:51:20, Piyus Kedia wrote:
>A peer's CDC message carries two cursors that are offsets into buffers
>described on this side: the producer cursor counts the bytes the peer has
>written into the RMB we published to it, and the consumer cursor the bytes
>it has taken from the RMB it published to us.  Neither is checked, on either
>transport.
>
>smcr_cdc_msg_to_host() and smcd_cdc_msg_to_host() copy both into the
>connection as they arrive, and every later user treats them as trustworthy:
>
> - smc_cdc_msg_recv_action() adds the producer difference to
>   conn->bytes_to_rcv under a comment asserting
>   "guarantee 0 <= bytes_to_rcv <= rmb_desc->len", which nothing enforces;
> - smc_cdc_handle_urg_data_arrival() reads
>   *(base + conn->urg_curs.count - 1), an unbounded index into the RMB;
> - smc_rx_recvmsg() clamps only the first of its two ring chunks
>   (rmb_desc->len - cons.count) and uses the remainder unclamped for the
>   second, so bytes_to_rcv becomes a copy length;
> - smc_rx_splice() walks PAGE_ALIGN(len + offset) / PAGE_SIZE pages calling
>   vmalloc_to_page() without checking the result, and get_page() then
>   dereferences NULL once the walk passes the end of the RMB.

I think Bryam's patch is solving the same problem here:
https://lore.kernel.org/netdev/20261112-b4-disp-0287c16e-v9-0-e5e8fa688177@proton.me

Best regards,
Dust

