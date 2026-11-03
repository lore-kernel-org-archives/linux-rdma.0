Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793715522;
	b=jdkItvjHjZXBl7PpHHz6cJdsEvNAs82xR49BR451D4kpZxXGd3RdMqh9oPcV1zfX0sJk
	 OMzb71whmjjC8XZF4P/KAJOQ+RvpmC4fZ1Jv4MoZyng6YKBBWdHIRpEkvtfP7Cr/be6+C
	 HOOWNIHzHP8248rwVjxDd1kQSiAO1PZen6YFGfQkzWql1mlIrv5ZU6owD1teR+WuHNVRw
	 y7Fn4MUtdY4oVBrvZyoJTD2Ql5CK6bELRqE/LnjH2MGl/CUV1RINhl/MS+Df8ry+svFUb
	 GSgMQZBvMbTLk4Ynkb6hlZdndYyrCkIMt1n0wcGQ1FMCpovOYEzmqITlh/VsR//MWaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793715522;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:Cc:References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=87L8NH0chbxJMXxlwkxaucZepbhcei/lYwpnUvY2jS4=;
	b=OYHLkddnYeh2sXwSHdhAPO7FuJ4pidgJQdi82YggGbVBITkISEIZdprBeT8vDFlmmvD+
	 lQHdahsPwbberyDDY3eOzA7MW4RY23YyAJ8IOxRjVQCkWozLcmCyiUJbbWeZwdT6L6sxX
	 RAnWJg9wfkH9oESdMMAiIAtKDKCf5mZxu6vpjanCCHlJUNt974667AUVcfg4Hgj7K3iee
	 A3rWgbrC6i4z7rjMM/ilsrbKPjvVmlL/SCnnyukoeMPGf+4wuZd+v4+gX70gBZAB583LI
	 yVFu0p/Bg+u/pQrYqw+BKrc7KBsLK8G6tCPOfj70P0XIg380bHdInT0EwQ23fHf6lZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=IRHMtWVE;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=UgDLLBfc;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385F9606A327
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 14:18:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 385F9606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=IRHMtWVE;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=UgDLLBfc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793715521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=87L8NH0chbxJMXxlwkxaucZepbhcei/lYwpnUvY2jS4=;
	b=IRHMtWVEaCXcKVrnszruv3kFHaSJccvoW+KGOCSMNJTSrjFKUSTRy1XIQfgHD2WZI2lAw+
	pluaZQCPEXoLi1/0FzdHeHUCnPkWGpCoXYkpsjlD8r742KI0NKYHI0/i/iKL6Tbpjg+Wne
	pWKvcNibOarbCy40Trkg8fJrEthcDF4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-592-X_iWXbXmPmyquY6pZ_v1Zw-1; Tue, 03 Nov 2026 09:18:40 -0500
X-MC-Unique: X_iWXbXmPmyquY6pZ_v1Zw-1
X-Mimecast-MFC-AGG-ID: X_iWXbXmPmyquY6pZ_v1Zw_1793715519
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-48e29c25101so2280829f8f.3
        for <linux-rdma@vger.kernel.org>; Tue, 03 Nov 2026 06:18:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793715519; x=1794320319; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=87L8NH0chbxJMXxlwkxaucZepbhcei/lYwpnUvY2jS4=;
        b=UgDLLBfc/bXJiOyeTY9h3E/2b9NcVvDXC2LHhKd1RL9yvya9KWHlPTuzXFDRw/ZYkI
         SyMPuW8h+ac1OXG31eFAmG8xUx4mrLWdqwU8VefOMWepj8xXAmYr50zgPseM24oVZBGf
         pVQwm2sgTBDxEbvuBBhORrgapJVaQMcBDxU8ILnrhmQNpHDzS9eiJOk4sX4J2gkAAuRD
         4ChNUmaElJnviB+3xvHvIp/S9vPdcGqNS19YHNj28eFbYlShAQ5dLnkz+44TX2vn1ovf
         nUPmyUsZjhbGga0wb0SxvRgRLABPX0orDHe1hm+r1Wbx9w+eU97m0oY43FVB85m4IP9Z
         17gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793715519; x=1794320319;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=87L8NH0chbxJMXxlwkxaucZepbhcei/lYwpnUvY2jS4=;
        b=qLzAOmGnnJNAaz3+4yJyY5ldc+LDTUZEYlBRW1Dnp4EakXzU9H+bWVSF0q/SEwFrbN
         MFdUKbX9+OSjwdmF8WmNW5yhFXXN/v/P0nxB8GfegINh5eskWXo2GDGsob6rrsLPQbTS
         VzOyWhH8vv9j7FaaBL4jEr6qxjl5220+0t64gcNt7lJHXfiJ/15WTINZX6Bb+4l/4VBb
         +x8d9emupj3qkBYaAYJxeuJqx83LmXDG8eLtlKfBrrHfR5W6EMJ8LHY6EYcx7Vgv8bzl
         tzKsy5+FwL84+ErG7cCUdKfVEy7BUe4MtgBrT4rRlMfrlhG4fWH971ere6hf7uxUczK9
         jqmw==
X-Forwarded-Encrypted: i=1; AKwUvBx3ol26fPpNP3eKyV+NG0HA9MPzItVihMNGTFUW4MZuLgG9uzZ5ag0V0mJMhEcNdbzzdxjr4sPRenEN@vger.kernel.org
X-Gm-Message-State: APuU4Z/1FIkezzigVNb2OENls3751lVDDijFfD4IGfqLUAdfjpRQjtzq
	AGk58M7F+OFJXvZuFKsLMlDIfy27rL6dKSXZeDrTmwrkzE7vmBKz2WCSZnxre2qhj/Bj3BT1QMc
	2P7TEv6qg6qPubmXvlrZ5e0+T8aDN5aWDu4i85EZJoAUicN62frtY7s06TglU7Ss=
X-Gm-Gg: AYBFou0JhbxEh738R45R/l4v5ugj2JDI4v1roH0n9T5j7DrprkGBuiEkRmEKOPk+kxy
	50GvQs6CHd0Vb4UesjS6HfY6DNtytaYEPcp9WS3ZDEl9Cgg948WI7g9p8YOnlWIIlVfkSq4U2yc
	vwK/zvpK2qL3Ege+vynEStVGQqPS0tDMPfffZtQ6m1XrBF2OZLpYa9quQ3Kv7w0OyhIMqUPovyj
	5d3g4ihhsghZRDGAZc1UeernWIeULhwslyfWKSjLY3W/IOOSU5qTGkvpnftFHH4kPRE9CNcVgWu
	lHBWqlugmal2eMa9ptwp1HB4oU5+fH5OimbKNOErB6OEkEyCihLsUjm+iTRFMCKW16I4aYdFE7g
	z8Z9HNo+Hak8Yw4qOeIjZvp91fC+V3EwNVE9zN5mB26semH5SAc4FVY93dITyHNrkpIq97atGwP
	KnRpLogTzwdUJ2Vi+e+GUbPUOqPJt8EGp+epTZB7wsMAI=
X-Received: by 2002:a05:600d:c:b0:4af:83ad:8f70 with SMTP id 5b1f17b1804b1-4af83ad8fa7mr160826705e9.35.1793715518732;
        Tue, 03 Nov 2026 06:18:38 -0800 (PST)
X-Received: by 2002:a05:600d:c:b0:4af:83ad:8f70 with SMTP id 5b1f17b1804b1-4af83ad8fa7mr160826195e9.35.1793715518348;
        Tue, 03 Nov 2026 06:18:38 -0800 (PST)
Received: from [192.168.88.30] (ip231-128-192-82.pool-bba.aruba.it. [82.192.128.231])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2ab3ea6a9sm91268795e9.15.2026.11.03.06.18.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 06:18:37 -0800 (PST)
Message-ID: <4d97a782-8d88-4dd0-b819-fb704582f2ec@redhat.com>
Date: Tue, 3 Nov 2026 15:18:36 +0100
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
Subject: Re: [PATCH net v2] net/smc: don't spin in smc_rx_recvmsg() while a
 pipe holds spliced data
To: Bryam Vargas <hexlabsecurity@proton.me>,
 Dust Li <dust.li@linux.alibaba.com>, "D. Wythe" <alibuda@linux.alibaba.com>,
 Mahanta Jambigi <mjambigi@linux.ibm.com>,
 Sidraya Jayagond <sidraya@linux.ibm.com>,
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Eric Dumazet <edumazet@kernel.org>
Cc: linux-s390@vger.kernel.org, Wen Gu <guwen@linux.alibaba.com>,
 linux-rdma@vger.kernel.org, Tony Lu <tonylu@linux.alibaba.com>,
 Wenjia Zhang <wenjia@linux.ibm.com>, netdev@vger.kernel.org,
 Stefan Raspl <raspl@linux.ibm.com>, Hidayath Khan <hidayath@linux.ibm.com>,
 Simon Horman <horms@kernel.org>, Ursula Braun <ubraun@linux.ibm.com>,
 linux-kernel@vger.kernel.org
References: <20261029-b4-disp-da7f8e6a-v2-1-9052904adf72@proton.me>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20261029-b4-disp-da7f8e6a-v2-1-9052904adf72@proton.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/29/26 09:03, Bryam Vargas wrote:
> While bytes spliced off the RMB are still in a pipe, recvmsg() waits
> for the pipe to release them before it copies the data behind them.
> The path to that wait skips the timeout and signal checks, and
> smc_rx_wait() returns at once on RCV_SHUTDOWN. With a signal pending,
> after SHUT_RD, or once the peer closes or shuts down writing,
> recvmsg() spins on a CPU until the pipe is drained, and SIGKILL cannot
> stop it. MSG_DONTWAIT and an expired SO_RCVTIMEO wait there too
> instead of returning -EAGAIN.
> 
> Check the timeout and signals before that wait, and end it when the
> pipe releases the data or the connection is killed, not on RCV_SHUTDOWN.
> A zero-length read returns 0 without waiting for the pipe; a
> non-blocking one returns -EAGAIN while poll() still reports the socket
> readable (splice() can still take those bytes).

@SMC experts, please review. IMHO the above trade-off sounds like a better
solution is needed.

/P

