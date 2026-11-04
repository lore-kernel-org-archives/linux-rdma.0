Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.10.208.62
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793821611;
	b=iMc4+xcABcpD/9o5F+gQ2SVbk2plJ8K6fU2lgLMT20JP3fVw8J1roE3fT+XqZkqTW/1k
	 AnpAHTshD1pCTSJSZyA64/KS7HvEHo04IinDK636oFACb+A6oNve3i8x+IPgWyeUkbyqJ
	 89dFvp2DHPorHWIsT6wmUTtuQXVWJ3+fUa4N//5no3F5+HJZ9F2aIt/XS7+XW693Jc5oX
	 ovvL//8mAP9B/tK9XUH6deiDy1GY20yEtYd19M3FjckAGFGg9EmpkY+F20zghlzZVE0xh
	 YLXZyUqdV4Tn2HuaaYt0WvOahWDMBnzHeJJQcOLjAcdPG7712kGiIGlzoH755+3xH+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793821611;
	h=DMARC-Filter:Received:DKIM-Signature:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:
	 Organization:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Rspamd-Queue-Id;
	bh=5mMtQ1ykVc8hLzz2/8sqp19SKRaqnGNJ8R6YMinTtwg=;
	b=bptOKJ6Blq7Qh7g8bvb6IxVkdTnxDkZnEtXP7jHw27obKl3KBA4wP4dRKrh+/qWwX/wn
	 gKVbZAdeRbNIgapxrye7hLAKBh5wBC6gpUCMQJx7tCYlD4KLm+0TPCmPkfoU2/z2Z3t8K
	 /YjRWZQYe2aJdL5spp+L/6OGupcOejmWpVFK8fTXM5yZKcaTvMXRvGAq0xKKIXFTKRBTE
	 ZdWJLVArgGtASTqa8vDYQ3Xc+sOBYPNQF/qE5YOfeQuchD9YQfIF5gVwKTkvzGpzRWWR+
	 C/k57oLLC9+znFHzAlYU3eTkiz/PJgGFxI8faF6RhuAZs3r8vqj4yA/OPBH8qwjAPxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mandelbit.com;
	spf=pass smtp.mailfrom=mandelbit.com;
	dkim=pass header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=NRxKGG1F;
	arc=none smtp.remote-ip=195.10.208.62
Received: from mout-b-202.mailbox.org (mout-b-202.mailbox.org [195.10.208.62])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE940608C9B3;
	Wed,  4 Nov 2026 19:46:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EE940608C9B3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=NRxKGG1F
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-b-202.mailbox.org (Postfix) with ESMTPS id 4jKbY920ZgzKnmR;
	Wed, 04 Nov 2026 20:46:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandelbit.com;
	s=MBO0001; t=1793821597;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5mMtQ1ykVc8hLzz2/8sqp19SKRaqnGNJ8R6YMinTtwg=;
	b=NRxKGG1FlFJU0JKddYKfBWf+IlBopX9xQGcJjScOYCfQEpRyxTfXYn/MHAsXMhnx3avkGl
	4Et5+naPtOW1dMERriWlbEQnNo0DzRvZRvwc5H8BNMQqU8OewOILlNzTU4z/6jppef2oEe
	rGb10Y6/ZHa1iL98uNrNXyNLtkmalVPK2eqiBmNTtpQdegCuW/TnYufkHCs9JOBYIaR25X
	Max+TSm2/XFkMp2bk7TS2EU617Jy/dVb6sjLPL53TQSDfo+LbshEGMUU6ogGo9RLnJqwpk
	R6SrNqUGQ0srGOS9UK6J4R4Kyf1ZYpZMMWzyQyPgMX3Zg7SmtdFwYCwwPKAtKQ==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of antonio@mandelbit.com designates 2001:67c:2050:b231:465::102 as permitted sender) smtp.mailfrom=antonio@mandelbit.com
Message-ID: <f4bdb8b8-45d6-477d-bd7f-4ca4bbafef7c@mandelbit.com>
Date: Wed, 4 Nov 2026 20:46:34 +0100
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
Subject: Re: [PATCH net-next] net/mlx5e: Prefetch packets of upcoming CQEs in
 the linear MPWQE path
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 dtatulea@nvidia.com, cratiu@nvidia.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, netdev@vger.kernel.org, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, daniel@iogearbox.net, hawk@kernel.org,
 john.fastabend@gmail.com, sdf@fomichev.me, linux-rdma@vger.kernel.org,
 bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261103235823.536706-1-antonio@openvpn.net>
 <DMM0ADCEGAAB.2RFNF1ZI5TGWK@gmail.com>
Content-Language: en-US
From: Antonio Quartulli <antonio@mandelbit.com>
Organization: Mandelbit SRL
In-Reply-To: <DMM0ADCEGAAB.2RFNF1ZI5TGWK@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4jKbY920ZgzKnmR

Hi Alexei,

thank you very much for the review!!

On 04/11/2026 01:39, Alexei Starovoitov wrote:
> can we prefetch 4 strides ahead without the CQE, like gve_rx() ?

Yep! I measured your version against this patch on the same system (one
RX queue, MTU 1500, mean of 3 runs, gain over stock):

                                    v1      yours    yours + shinfo
   UDP 512B flood, packets/s       +39%      +35%      +36%
   TCP, 1 stream                    +7%       +5%       +8%
   TCP in an ovpn UDP tunnel       +36%       +4%      +34%
   XDP_DROP reading the packet,
     NAPI CPU cycles/packet        -38%      -45%      -32%
   XDP_TX, cycles/packet           -35%      -30%      -33%


It matches my v1, except where every packet becomes its own skb, like the
records of a VPN tunnel (ovpn from a development tree here).
In that case I got only +4% instead of +36%.
Dropping only the skb_shared_info prefetch from v1 gives +5% there, so
that line is the one that matters.

Its position depends on the packet length, which needs the CQE, but in
bulk flows the next packets have the length of the current one. So v2
will be your patch plus a prefetchw of the skb_shared_info line computed
with the current packet's length: +34% for the tunnel, the rest
unchanged, no CQE peek and no state bit, and it also covers CQE
compression, where v1 did nothing: with it on, UDP floods gain 26%,
TCP 6% (-46% cycles/packet) and the tunnel 32%.

> Pls add XDP_DROP and XDP_TX numbers.

In the table above. XDP_DROP without touching the packet doesn't change
with any of them. With the prefetch the XDP rates hit the limit of the
sender (12-16 Mpps) before the NAPI CPU saturates, so I quote cycles per
packet there.

I'll send v2 with your Suggested-by soonish.


Thanks!

-- 
Antonio Quartulli

CEO and Co-Founder
Mandelbit Srl
https://www.mandelbit.com

