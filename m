Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.110
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794972651;
	b=y86JeSWPC2mGvBW9wDuopiPqa2FQ3NXboXWQ170f7QIie87QvXgekYF7rt/mOCcAA2oe
	 wOYUl9Y9pwrgoJ5KAMazltC5Bd5El+GCeInNPqa0r5P1+T/yMv3/baybJeB1XAoSGCBRX
	 MKgH/FUnOlh82TXwEMno6Vzo7sle/HhejM177o4PpbT1Lex5UIU1TnLBiD0tpwNNNF6NK
	 zL38y3asE7tFlCB/EmiYZeV5b5hoPvwEf+EqScqpvDz7sXelmplXjwu9Idf1pgAsac8mM
	 ixOPPaP7JRFHbRUjXwqEukmN/HdBs+qrgV7oSTZtzXe3fzngImr9+MY3jQ25hvrL7hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794972651;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=APG9sCSTr31Qk5e5LlTF3oLTJAVZT+6WIuV88gEjZIE=;
	b=g04Sc31WDhzRZXdwggjEmlWiBlQkIWxM+zGaeANqCcPCk6CINn6IiwX8AMaYoAkivrPk
	 hPTdg75m585JVlZHX16Ypt+I30HFJzb5DGGUm3hm9+znnseWIBSvSqJ5r7XHQUho4QYJ2
	 /WuoRiUMhl7GtA3UhWDKTgFVOIIZpjEf+Xd8BZAdnR85O4/gveGlZkDUNfr4sm1gEXNBG
	 pqs5iwe54wrle3eAvRuIFuFIcbw3enntCjTznpF5kI9vujp8QQqm5h0ddrl1+9JqgrR1d
	 05860ZV5SZigeEAhbj0Bj2ME8FQyXWXfW/EBAj/wo/HNIyq9L8zq2IQZriz1gcJYpHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=GkkHMI4b;
	arc=none smtp.remote-ip=115.124.30.110
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA1E606A31C;
	Wed, 18 Nov 2026 03:30:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9FA1E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=GkkHMI4b
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794972639; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=APG9sCSTr31Qk5e5LlTF3oLTJAVZT+6WIuV88gEjZIE=;
	b=GkkHMI4brIkg/t2A3Ic7bT6pq3K8ePRiO6/VKOgCjaYnr3DP10gTSyI9ihWvoyjOFX63w8UqMOioy9oowWkbKUK/MIvFjJN1lZC3Y29dlQ5DAte5xhfrR8VhNTuuZBY85TEa7ZdqHIxf+ibybu7nUZ9+5kGGpUmx4w2WCIFBicE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XF.Gjmt_1794972638;
Received: from 30.221.96.70(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0XF.Gjmt_1794972638 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 18 Nov 2026 11:30:38 +0800
Message-ID: <9c049865-1ac4-553f-d894-ca4868bd4e4c@linux.alibaba.com>
Date: Wed, 18 Nov 2026 11:30:37 +0800
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH 6.6.y] RDMA/erdma: Use IRQ-safe XArray helpers for QP and
 CQ tables
To: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 leon@kernel.org, jgg@ziepe.ca, kaishen@linux.alibaba.com
References: <20261117022839.23186-1-chengyou@linux.alibaba.com>
 <2026-11-17-1-daily-reply-0002@kernel.org>
Content-Language: en-US
From: Cheng Xu <chengyou@linux.alibaba.com>
In-Reply-To: <2026-11-17-1-daily-reply-0002@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 11/18/26 8:19 AM, Sasha Levin wrote:
>> Use IRQ-safe XArray helpers for all QP and CQ create-path updates,
>> including the GSI QP store and error paths.
> 
> Queued for 6.12 and 6.6, thanks.
> 
> 6.1 has the same bug and is not covered. If you want it there, please send a
> 6.1.y backport.
> 

Thanks. I have sent the 6.1.y backport.

Cheng Xu
