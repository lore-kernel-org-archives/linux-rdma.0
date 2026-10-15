Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2224825BD
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 07:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792050421; cv=none; b=GChBFFXrjvn62jnZJPhk+s0pjf9yZ4ESmRHtQTzLnJvmA2wzgLoC85a0WpVvTHLwUb3Xin6fe8fnoc9YUbT7HZZjQZopT9xl5BuCG5R85oVfOy1k0PQNzuxLneScwozLtIeMeJoVJFN8AaAzzzga50TFfO9jzrq7CGMaI+TqLjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792050421; c=relaxed/simple;
	bh=6UHjJliqF9K4zi8MTRY0D4g3HGixAtyzI+smduapvUw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gi1FJ1mLSxbh2h3Myj3M2l/cQCv3beifiGBl9fto5vG/UmbPuE0mWdNLj9tJrt2+RBRIvmd6Y00bzPeszSvHLrdV2vC7MQ7rsUQQr4IbwT8dTJkPrxvQjSJPl/Ab6Uili/LHMQ2IRUz5h1Xm207S3EUUZiF7wvOVHsa44zoXBRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=I4aZWQJa; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="I4aZWQJa"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id CDAEEC62200;
	Thu, 15 Oct 2026 07:47:52 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 73D0960360;
	Thu, 15 Oct 2026 07:46:56 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id B966010328B8D;
	Thu, 15 Oct 2026 09:46:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1792050414; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:content-language:in-reply-to:references;
	bh=Xj4hLpHjzheP4AEGLpAFn5JMjwlG+fQsoZ3qshX2rR0=;
	b=I4aZWQJa5eiMyD2REL02NTzzy7IuxQ8lj0letekuQ91rK5zrme4YUkJhRJysD+FfKkEYuT
	PEkt0FYKr1T6q2KU797FoRXLy7yRKSncC0itrLXXM3ogzKDH12QxTatZIPgFeiginCetqK
	wBObo6K1YafbwYlRDsar1dzlynLMsRa/2JFV3KWAYffJA0xLoLskd9OQ13dVitcYQcdL3k
	y+od1ZIbNhZcK8fkgkx1zCtPpem8AlyfVrri8SQRzW7d340wK5lXpTRlZWN2kjEBDHTFbc
	dgB9wfe1wfWQLBdqqk0XkA/thJiXwYCdxMwbOr9qZqyzH6zQEZl5PWG7/Tadsw==
Message-ID: <cccfd292-6169-449e-a675-a9bb54ec4191@bootlin.com>
Date: Thu, 15 Oct 2026 09:46:41 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 1/3] net: selftests: use skb_share_check() in the
 loopback receive hook
To: Nicolai Buchwitz <nb@tipi-net.de>, netdev-bot+sashiko@kernel.org
Cc: davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, o.rempel@pengutronix.de,
 andrew+netdev@lunn.ch, mcoquelin.stm32@gmail.com,
 alexandre.torgue@foss.st.com, Jose.Abreu@synopsys.com, saeedm@nvidia.com,
 tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org, dtatulea@nvidia.com,
 alazar@nvidia.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-rdma@vger.kernel.org
References: <20261007-nb-net-selftest-shared-net-v1-1-458369bfa1ba@tipi-net.de>
 <179149509090.434549.9918598206439291164@kernel.org>
 <533b88ce917b59f4f59f52145d2f035f@tipi-net.de>
Content-Language: en-US
From: Maxime Chevallier <maxime.chevallier@bootlin.com>
In-Reply-To: <533b88ce917b59f4f59f52145d2f035f@tipi-net.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3

Hi,

On 10/9/26 08:49, Nicolai Buchwitz wrote:
> Hi Clashiko
> 

[...]

>>
>> Could an IPv4 frame that arrives during ethtool -t make the hook read up
>> to about 64 bytes past skb->tail? Examples would be a minimum-size TCP
>> segment or a frame with ihl=15.
>>
>> The over-read seems to stay inside the skb head allocation, because
>> skb_shared_info follows skb->end. If so, the only effect is a possibly
>> wrong selftest result.
> 
> The length check is pre-existing, will address that in a follow-up patch.

I'm unsure about this, Can we instead assume that when one is running the
"ethtool -t" selftests on a machine, they are doing so in some controlled
conditions ?

IOW can we take the assumption that we won't get incoming traffic at the same
time as we run the selftests, and if we do get some and that triggers a wrong
result, this is expected ? ethtool selftests are very cheap to run, only a
handful of seconds, and don't require any extra dependency, it doesn't cost
much to re-run them if something unexpected happens during them.

ofc. getting a stray frame during the selftests mustn't crash :)

That's my take on these tests, but feel free to disagree :)

Maxime
