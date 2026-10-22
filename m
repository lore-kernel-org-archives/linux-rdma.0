Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792674059;
	b=RINJzbmiHK9UaOwnEYxTP2CONj/ZzRga0I+xxZjUdZViIp4KO+bPgV1rsvs6MQaFp/Ds
	 JFOCPyYlS+zOTJiXz1pQDIxbD9gctpi3A6IwWiL+ccV2BM/285H+GamGI6xdSO/TVWe2N
	 BweN9zovxMaziFuasctGwNYttKN1xovKMWuMXdqEfkItbyWPKLZjKkbeNYAHf5iIabq9Z
	 Q9HAADAGSknRnI1XP+4xbNq+q9jyGu3ffMUXjsj3Ar7PHDbXqSxGtQQVMJE209QYWaS6q
	 lAX8YjEp6oqHgjhWwnwdj2mpMMPg0BtauteAccYPEogKVeEQhnJ7EgWd6xt2mgae/4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792674059;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=3AzPZ01hTSAgsWEyu0h9Ofjn43zkYv9zMoDNLsEz7YQ=;
	b=01VxpZx/lE14VvB0nZeuA0Cx8a+eMj4o1o1Y+0FotzHY6DXbDIyMRV9rAXMTdpt80Z44
	 MHlkg5aYD2y0x+oK2P5I448akrvR3SS1v/0SfNHQ2yxZ6YlLH/2mxFh4ZaRItER9Fkxpm
	 zEM/6ocMZvM/cEQltQ3ORyrXMqUOXKamzM9jNYxlYnTsRVljIRkk2mWtyWf1KFOkUc0oM
	 Gqi9OFNLOkjOsFHt5H5qznmu0PlqOorIih060Fpdj5/er2rEM1L3dycoOmsHG3+8PCN4U
	 te1NCfdIbIANRXH/xfo2OYJyHhkkNjSOpx5gmUm72huq6ifwD/3iMEtGYmpfEVMIpvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=cTLbrift;
	arc=none smtp.remote-ip=209.85.222.170
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB18606A322
	for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 13:00:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9AB18606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=cTLbrift
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-93f36c18b75so121325285a.1
        for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 06:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1792674057; x=1793278857; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3AzPZ01hTSAgsWEyu0h9Ofjn43zkYv9zMoDNLsEz7YQ=;
        b=cTLbriftFr1LV8G0roNHwM20QIFC/tuPgaoDNV401sC9eeB7eaeLQJO2buW+6dPlCx
         5Af/zw5Usyi8VhsLnKmWLnu0F+ARE83VEl7OBNvKUMwCNIrr7Ty8pyPHtnWKLMnnzWCH
         4fxXJLKvuWGdtgp5aVzAZYWZZ97a9diknRvCfd8ik2k67KyKpqP3EN0OvM9isNVmnm/Z
         UqmfPPR+MMr9l4AVN76ylHBufwNklPWZk61e8r2Iv2V+IMW85gr8Jwgci30WvFvKNs2k
         Rkds7TVbVlEvEZkeJrXLdkzuk3a35Rv/FQa8NRvCqVcb9ZxOHY0Nt9OD20aePD1xh/En
         ViPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792674057; x=1793278857;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3AzPZ01hTSAgsWEyu0h9Ofjn43zkYv9zMoDNLsEz7YQ=;
        b=vBRFDjbH4ooBALWjE2aWxbGIa9NFDmFkDRhq0riEIhl+ysZLOwWb2UGoz+bzsMb31N
         lBpXsa5oMwCwdN84dR+M11MnXDUAjqwTmhnblDiSTkzQWJF4oZaudABvVBd7TnXOt6Yx
         V0khg7CvKw5m+Jrezg3X8lDplNsr2ffAh5AtbgvBVM1keoDzFFmWs3ybKujF2lynA/lb
         dC+Rj45VDTNsAxgweHZ9BBOXELvR3b3ZjZKRwTYjQu2z6nSSG8M/lWCWFj8uDizhaxoo
         ohahtJzIbl/ut54dflY7VA3ekQSuVCj9PgyXExIFoEM7qH0Bthoyj7HEBAnsZ7SP6d5u
         6Y1Q==
X-Forwarded-Encrypted: i=1; AKwUvByBleeMJZLR6MulzHmNsCjrBA0Z89w1SDwIwAYlwCueeIeJWN41VrPYsRqDsv3mXlCD8VWKQ0KZL9K9@vger.kernel.org
X-Gm-Message-State: AFq9FYIcxQehV7JV5DrJSxlzjwefe6X6N6XUX23Kk2vS6AroQ4rIXf0u
	hE8b1xLT49BR0Al3Rhha6AWPRqjEUQFxBj/KbEFgJ7Jgh4WX7WBwZQq9lITTXRRPjOkWAEcguxD
	HOLMTsUI=
X-Gm-Gg: AYBFou14COdNSTD1PoxDX5NMBQhP6k2KDdFvVB1TOJ+XLRSSlt9/TUKf1B9Woc4RPXx
	LQlj56WarLE7k8ezrB08/x6krpn4qjgs8YZlU9oPUkcLJF70UnJz2e0u2mm/ueVtvn4BhWwngB+
	EjcJ7q8VpPFJug4hkq5wnlu3LjL3G3JWucRN0E/ZyDqsNh53Kc5lsPzxaYQcG0M67A7HFSudOBh
	k1A3OC4mjRc8s+tRfc2ngJk3IckKEuyArYj6j0wn6lz4Y9yazC2end4C2yNZeFKDZv1XJbAQi/Q
	hX0ny/ASlrn739IkE3DZPnvh4FOO12pWWYOFjziL5Zc4OQZhLssbGxYb71dRJvUZ0jb0b4ynwRy
	qCWE8BBpR+m7l+g3nhZ/RLbbyrU7CGCiUjMRf2c5pXCmyHJbWxxH0SsNKESwJQj+eYC4FxyFwb2
	rDY/UokkiuPJOZ/AzuWAuSOKaoc3lIHyQaivshCV9cMeFNdIrZ0xtaUFqGWDO4gFKojmjVGPyc9
	huDm0M0NKx+gsHTv59Ch9NbQT6fyAqAOTEf5Pc+di/owIFfmkSFzQWNJZjPsC1eW90IiotB
X-Received: by 2002:a05:620a:a986:10b0:93f:5e6d:880f with SMTP id af79cd13be357-93f5e6d89a6mr457592785a.74.1792674057333;
        Thu, 22 Oct 2026 06:00:57 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.251])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f56d9acd3sm515283385a.14.2026.10.22.06.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 06:00:56 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>,
 Jakub Kicinski <kuba@kernel.org>, =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net] net/mlx5e: Fix stalled channels with threaded NAPI
Date: Thu, 22 Oct 2026 12:56:49 +0000
Message-ID: <17926738093796.1.mlx5e-threaded-napi-stall@toxicpanda.com>
In-Reply-To: <cd140948-317a-49d8-885e-0ded451195c6@nvidia.com>
References: <20261021-b4-mlx5e-threaded-napi-stall-v1-1-d719c17b3ec4@toxicpanda.com>
 <cd140948-317a-49d8-885e-0ded451195c6@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Thu, Oct 22, 2026 at 02:38:41PM +0300, Tariq Toukan wrote:
> The arm doorbell carries the consumer counter, and the device tracks the
> last index it reported an event for. Arming while CQEs posted after the
> last event are still unconsumed generates an event right away.
>
> The affinity path depends on exactly that, since commit a8c2eb15797a
> ("net/mlx5e: Stop NAPI when irq balancer changes affinity").
>
> Event moderation can delay that event, but not drop it.
>
> So the root analysis doesn't match the mlx5 device behavior.

The CQ has a backlog much deeper than one poll, about 6900 CQEs in the
run in the changelog.  The thread polls 64, is off the IRQ's CPU,
completes and arms.  There are CQEs posted after the last event, so the
event comes right away, and the device now remembers the current
producer index.  The thread polls another 64, completes and arms again.
If nothing has arrived in between there is no CQE posted after the last
event, only older ones that are still unconsumed, so there is no event.
The rest of the backlog waits for the next arrival.

That matches the counters of the stalled channel.  It had 0 polls and 0
events for 150 seconds.  New connections then gave it 16 events, 16
polls and 1018 packets, so one poll of 64 per event.  It was armed the
whole time, it just took a new completion to get an event.  Then nothing
for 14 seconds, then 93 polls and 5917 packets, and it was empty.

Is that how the device behaves, no event on arm when everything that is
unconsumed was posted before the last event?  That part is my reading of
your description, I haven't got a way to check it.

> Is it a degradation? Did you have any "good"/working version?

I don't know.  I've only run threaded NAPI on these machines on the
7.3-rc5 based kernel, I have no older kernel that I know to be good.

> If arming really doesn't raise an event here, softirq NAPI would stall
> the same way when the IRQ affinity changes under load, for example by
> irqbalance.
> Was it seen there too? I believe not, so it must be something else
> causing the stall...

I haven't seen it there, and I haven't tried changing the affinity under
load.  If the above is right I wouldn't expect it.  With softirq the
path is taken once, that arm raises the event, the interrupt lands on
the new CPU, and from then on the check passes and the poll goes on
until the CQ is empty without arming again.  A NAPI thread takes the
path at every poll, so it needs a second event for a backlog that the
first one already covered.

I'll fix the changelog and the comment in v2 once I know I've got the
device's side of it right, and move the check into
mlx5e_channel_no_affinity_change() as Jakub asked.

Thanks,
Josef
