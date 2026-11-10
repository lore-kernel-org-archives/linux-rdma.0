Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.10.208.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794307262;
	b=0Y2AHls6tpL+jxqMPpH6pmuZk7qfUu9+hXCbRzv0Fqr38D3R06a7UdjtagTTLbrtq9wI
	 dzdTzHUJBxHYe+tuOAAI3UuR2Lrg1ZJQgxBy6l+6d9pKlFQquElI09rMeD01dIPzlfjvW
	 V1r9r+IUumZ6iNKbeZh6I5HUeoG8eKx7RTVPxKY86cITcutFu5Exto2YFDN8Asu9Xcky6
	 +b7mX+fIerSZhR1aH6U7MpiBitslvKUdBetflbapbbI0xY8rWuAvVKuKmGqKcdL6+NytY
	 W5Vxju6dGCjSLfa28/1aXKlHb+Q/Ollld0J/8SngWYCEl1/ZoblfF5xMqkR95pGEMiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794307262;
	h=DMARC-Filter:Received:DKIM-Signature:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:
	 Organization:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Rspamd-Queue-Id;
	bh=aRfxxKk5JELB+Ani22l80ZT8QKCCTc2Q/EP8+1DWDqM=;
	b=osZKNehOkuESCGH7kG4fVPsGBVGp+9z+otvArPZT+mZKOmvpjs17aEsvJkN5EQAaeRJh
	 TEBEEnTssczQUbg153o6s8YvGmA7M8gRhbkuB68A7BJrP0x/2gWFQhvvpgkiOqVx9j5DG
	 z/0qN0umtRlESRM9oO1XkzkqcC5W8LPkb1O15rX+RanVoggGpul1RIJxW1S29RkCNNsPr
	 3qirRBrtAC2uxnpfyNZP1RLjCYZtvFSdIS4/UIzSKPNIRuUXHIi+jFte/7Fqn8bRE/XXO
	 9Bejnudpy+Fds21TiPVwGMnWZmvcA2nQRA5PFMyuEKvKX4jlLe7L4/7pVplD1yIaHtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mandelbit.com;
	spf=pass smtp.mailfrom=mandelbit.com;
	dkim=pass header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=mVM172Nb;
	arc=none smtp.remote-ip=195.10.208.46
Received: from mout-b-106.mailbox.org (mout-b-106.mailbox.org [195.10.208.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B318606A321;
	Tue, 10 Nov 2026 10:41:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4B318606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=mVM172Nb
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-b-106.mailbox.org (Postfix) with ESMTPS id 4jP38g4GZtzNlgV;
	Tue, 10 Nov 2026 11:40:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandelbit.com;
	s=MBO0001; t=1794307251;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aRfxxKk5JELB+Ani22l80ZT8QKCCTc2Q/EP8+1DWDqM=;
	b=mVM172NbFfAuP9fWqdRHbtUWgMm4uhNbiOnlaF7GqnRp64feTeIessWyiri9s0RhH9BLcm
	z84etFtO0Koq+RHOsFB+3RXhr4NeeHch4j+QxBP+BgL++Et/CzCLj2FR5U4rMKOcTUWr8W
	ZkxhArrFaaOTNjM6tdkUwZXk3rjAUYmbb7i3c4yyndIr/ShLisygS92YwgifWlMJuleeIm
	8gfCvys1o1l643c+66UwKGscW43RH6BKMR25fioNQOfEtesGfvYs3ONSyUwed/Fn3Svzd4
	2z+fsz6atXytLLSf6Axqf945s3hs/2ra/unKY/LJxITOr3UlOrwr96TJKs7K4Q==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of antonio@mandelbit.com designates 2001:67c:2050:b231:465::2 as permitted sender) smtp.mailfrom=antonio@mandelbit.com
Message-ID: <674eb8ef-c93f-4926-a760-62df154ed3eb@mandelbit.com>
Date: Tue, 10 Nov 2026 11:40:49 +0100
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
Subject: Re: [PATCH net-next v2] net/mlx5e: Prefetch the packet a few strides
 ahead in the linear MPWQE path
To: Dragos Tatulea <dtatulea@nvidia.com>, netdev@vger.kernel.org
Cc: saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org,
 cratiu@nvidia.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
 daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
 sdf@fomichev.me, linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261104195241.1883539-1-antonio@mandelbit.com>
 <a31e1e60-7e31-4a14-a087-428d1e3627f2@nvidia.com>
Content-Language: en-US
From: Antonio Quartulli <antonio@mandelbit.com>
Organization: Mandelbit SRL
In-Reply-To: <a31e1e60-7e31-4a14-a087-428d1e3627f2@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4jP38g4GZtzNlgV

Hi Dragos,

On 06/11/2026 11:55, Dragos Tatulea wrote:
> Thanks for your patch! These look indeed like enticing numbers. I'd
> like to take some time to try this at scale and on other NICs (CX8)
> and CPUs (Grace) and also check latency.

Thanks! In case it helps, I measured latency on my side in the meantime
(I don't have access to the monster Grace/CX8 equipment, but it's still
something :-)).

Request/response over the bare ports (one transaction in flight, like
netperf UDP_RR/TCP_RR), same system as in the commit message: one RX
queue per port with its IRQ on a dedicated CPU, MTU 1500, default
coalescing (adaptive RX, rx-usecs 8, rx-frames 128), 10s per test,
prefetch off / v2 / v2 + next-WQE follow-up (see below) interleaved,
mean of 3 rounds:

                      p50 (us)              p90 (us)
                  off    v2    +next    off    v2    +next
   UDP, 64 B     24.60  24.61  24.60   25.37  25.37  25.39
   UDP, 1400 B   25.08  25.08  25.10   25.94  25.96  25.92
   TCP, 64 B     24.65  24.64  24.66   25.48  25.46  25.85 (*)

   (*) one round at 26.59, the other two at 25.47 and 25.50

p99 and p99.9 (37-45 us and 67-100 us) varied more between rounds than
between the variants, and nothing was lost. So no latency cost that I
could see at low rate.

I'm also testing a small follow-up: v2 doesn't prefetch when the stride
4 ahead is in the next WQE, so the first strides of every WQE are never
prefetched. Following the WQ list to the next WQE (only when
cur_sz >= 2, so it is posted and its pages are allocated) removes 26-32%
of the remaining DRAM demand fills on the RX CPU and adds 1.8-3.3%
throughput, measured with TCP inside an ovpn UDP tunnel (where the RX
CPU is the bottleneck); its latency is the "+next" column above.

I had planned to send it as a follow-up patch, but I can also fold it in 
a v3, whatever you prefer once you have your results.

If there is anything specific you'd like me to run here, feel free
to let me know.


Thanks!


-- 
Antonio Quartulli

CEO and Co-Founder
Mandelbit Srl
https://www.mandelbit.com

