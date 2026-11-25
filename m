Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795591737;
	b=5U3fwPLVLaPWjGyKR6giQkOUEgKAXcxt2RcsarcViXIVHZoNXgZYsFE63Hj2S8nknE/7
	 QYmpfwq3z3VQpKOQq/yeHzxehb5McoCh73stTC/yP7PgVFFQ11PxjHRHPOuKHGzg+8sBV
	 ByjpH7Wri7TfIFVF0pVSRct7a6hWqTh3fvposwUnHZFYHgY+nynOwgWvzIcb2hALbSAMS
	 nb6MzwyEBtuYfyEgYd5cnX8dUspWEOfdguXSrvT1Rdh2Hy4w1JsOenYJeBr6VfYPcdnqf
	 TxxlCT+MwSIBYw60uFXkK7VYPSqOPlPLGbD4Y8xBkBjnaBN71HrKNEcgd0PPxauWaYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795591737;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Date:From:To:
	 Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=J/SBvBXFi8GMnR3nIyKcHK3QnWViRP9ScHpg6onFgeY=;
	b=cYbvsDVzmXVhqsMNIODK5OZ5YLkYrck0BPVyI9QZdSFtWAeh/GPsErmQR6QTfULMPYsX
	 SQ/QciKYPo/eqyPAzOdiSKyejiP8GDEWg0iWYw4CqpKjhFp89aehKExjYzApdIpYrNoMN
	 162rFYkR9sFrT/oOujW0ITyuqncmZwepnS25yqd44fCKIlk8/N4hUkXMeIiKZuvrJK+iQ
	 I2bjthMJtyyCXkdjBN5vy4wEsnAi7jt+THByhHzQUs45mIsxghgv7xcW1CJLMMZozlgUh
	 CiXeMPEDeq+3/Xp1z07sk8pY8f3pfKwR+x4/ylrwWGow8npq2hRKUpR9/vp764KEhgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=IPKz0iOe;
	arc=none smtp.remote-ip=115.124.30.124
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BAC8606A31E;
	Wed, 25 Nov 2026 07:28:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9BAC8606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=IPKz0iOe
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1795591733; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=J/SBvBXFi8GMnR3nIyKcHK3QnWViRP9ScHpg6onFgeY=;
	b=IPKz0iOekrNIdyUp+SxxgKBSQ+H96vzJjASZeKP24JQTNQanD6T6pAd8gFwa04GjSHaucczObNvZ/34M5r38x4CpjUFd0Dsb5YOcLrg4ayxCcjk6NEILUgUTYxl0P2ctHthIJPzRtGpOUDXA3AS6Q1NQplE2PqFkNiHUus9ndVU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R401e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XFQu255_1795591731;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0XFQu255_1795591731 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 25 Nov 2026 15:28:52 +0800
Date: Wed, 25 Nov 2026 15:28:51 +0800
From: Dust Li <dust.li@linux.alibaba.com>
To: Mahanta Jambigi <mjambigi@linux.ibm.com>, andrew+netdev@lunn.ch,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, alibuda@linux.alibaba.com, sidraya@linux.ibm.com
Cc: hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
	tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
	netdev@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-rdma@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net] net/smc: fix sock reference leak on abort_work cancel
Message-ID: <awaOMz-oWIw4CZ9d@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20261124073602.2341904-1-mjambigi@linux.ibm.com>
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
In-Reply-To: <20261124073602.2341904-1-mjambigi@linux.ibm.com>

On 2026-11-24 08:36:02, Mahanta Jambigi wrote:
>smc_cdc_msg_validate() takes a reference on the socket before queueing
>conn->abort_work, and smc_conn_abort_work() drops it when it runs. When
>smc_conn_free() cancels the work while it is still pending, for example
>because a close races with a failed CDC validation, the handler never
>runs and the reference is leaked, so the SMC socket is never freed.
>
>Drop the reference when cancel_work_sync() reports that it cancelled a
>pending work.
>
>Fixes: b286a0651e44 ("net/smc: handle incoming CDC validation message")
>Cc: stable@vger.kernel.org
>Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>

Reviewed-by: Dust Li <dust.li@linux.alibaba.com>

Best regards,
Dust

