Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792937906;
	b=24ZHgLoYzW2ygwzBrWPINiS9yrsw7CJp37DGn2j8JNBk/VoZAebqyqpW+1xLKoH/BDDz
	 2/707g5FMhFYlpDKmuotNolT2boH6G97RBMXU7QsEKDNX6pLmRRPyTjATDuirhlUF08vQ
	 WXqjN0X2x/mztJePu4NcSpkjzi4jU3KiXA1K24lTGbQmHWXRnhTxwrgXpR6yQdFdhkuo5
	 QuIp73eiP6xw1D1Ze9/gLA6xAxTXIGlSGfiM/2ejiaju9JjOJQzoN8w13pUGKbrm/UUov
	 2O2vJ8P2tMMe6GkBEQy59BxzpwwSls8z+8rablIaZPAzxpR6xVBv5Z1ztZqA1MBxusg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792937906;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=1jP9LR4qPl3i+2W7AG1phxkIUNhYD6OyLXs6hxnZ+u0=;
	b=YVXFQlj5bhDnRcFKvielnDpgmuVA5qTz3vHTlq780RCuHDSbmDQ17ZFsdQxlhKccA1vd
	 bIE2jxkUAURAi0SVAEFP12+sTW5kx6Qezpp/TV2DlrBpoQPcN34L6Zz0onllynLzoZNks
	 ccGe822n+7glu6MbRxNyaYOkU7dyh0etlIkp/EWYU/xFgvhqg/kBWW57dzdc0YHCQ7VkB
	 c8h0fACm2CAs2Kd5/fP5823FyZFAzcX8NSZfuFUn/+p5WnMxYv7MtmMYxjThCwtWuzGPq
	 RLbM/X8H2i5p/fLuyHKwe5BXFpqCmrOaqQhunr/Qqym356uMFQrq5cy9FiRxq8WKJUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=PBypsm2a;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57506606A31A;
	Sun, 25 Oct 2026 14:18:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57506606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=PBypsm2a
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jCJkz2xhBzlfvps;
	Sun, 25 Oct 2026 14:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792937896; x=1795529897; bh=1jP9LR4qPl3i+2W7AG1phxkI
	UNhYD6OyLXs6hxnZ+u0=; b=PBypsm2aE4uyXUYFQ1Lu+zEFaRKe9hwPzl8huodj
	MQ/JfZnUNnHtT+jpvMmZ+4Hx+W+bpmvrvtm5z16slnOOwL5Rq9OoA24v6g9r37dS
	JEepcJK7gT/LIy4y0cbLJylPY49M2ax8BJAVA4/8W6QvUM/fT7iveuoOIUTFmM2i
	Y+NQmV1d3YVq7f25HIWq0DVq6JEgvEQyEMKhT6kaiWu1sQdPFsMpdy0XCzayZJnN
	sK4SkB1TZ4AZvSeB53sjB5jT9kxzNJMrNAEJW+SnGyavfTWmsFiIAYEBTAZTtgdH
	vubRHnDwQcFIalsUhaKN/nZgMED1e4rvNr9q6RRF0nhXmg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id egaML7tfjA0s; Sun, 25 Oct 2026 14:18:16 +0000 (UTC)
Received: from [192.168.51.14] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jCJkv73kBzlfvpN;
	Sun, 25 Oct 2026 14:18:15 +0000 (UTC)
Message-ID: <1197df7c-f083-4b25-abfa-41cb4954a2cb@acm.org>
Date: Sun, 25 Oct 2026 07:18:15 -0700
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
Subject: Re: [PATCH 1/2] RDMA/srp: refuse a target that cannot receive an
 SRP_RSP
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261025114155.4007867-1-yhlee@isslab.korea.ac.kr>
 <20261025114155.4007867-2-yhlee@isslab.korea.ac.kr>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261025114155.4007867-2-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 10/25/26 4:41 AM, Yehyeong Lee wrote:
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 5811f02df9805..a85d28b95306a 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -2379,6 +2379,13 @@ static void srp_cm_rep_handler(struct ib_cm_id *cm_id,
>   
>   	if (lrsp->opcode == SRP_LOGIN_RSP) {
>   		ch->max_ti_iu_len = be32_to_cpu(lrsp->max_ti_iu_len);
> +		if (ch->max_ti_iu_len < sizeof(struct srp_rsp)) {
> +			shost_printk(KERN_ERR, target->scsi_host, PFX
> +				     "Target reported max_ti_iu_len %u, too small for a %zu byte SRP_RSP\n",
> +				     ch->max_ti_iu_len, sizeof(struct srp_rsp));
> +			ret = -ECONNRESET;
> +			goto error;
> +		}
>   		ch->req_lim       = be32_to_cpu(lrsp->req_lim_delta);
>   		ch->use_imm_data  = srp_use_imm_data &&
>   			(lrsp->rsp_flags & SRP_LOGIN_RSP_IMMED_SUPP);

Is this change perhaps incomplete? When reconnecting. 
srp_cm_rep_handler() only allocates the receive buffers when ch->rx_ring
== NULL. srp_rport_reconnect() calls srp_create_ch_ib() and the latter
function keeps rx_ring, but ch->max_ti_iu_len is overwritten from each
new SRP_LOGIN_RSP. If a target reports a larger value on reconnect,
srp_recv_done() calls ib_dma_sync_single_for_{cpu,device}(dev, iu->dma,
ch->max_ti_iu_len, ...) past the mapped length. That breaks the DMA API
rules. The HCA itself can't overrun, because srp_post_recv() uses
iu-> size. Since the series is about bounding the receive IU size,
please make one of these additional changes:
* use iu->size in the two sync calls in srp_recv_done(), or
* on reconnect, refuse (or reallocate for) a max_ti_iu_len larger than 
the existing rx_ring[0]->size.

Thanks,

Bart.
