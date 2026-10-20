Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792502421;
	b=YADJSyEOw3k3Xl40PCYiUz+p4XusyWTtQwXSipEJ4D01+wx/FPUODWy4nI5Ngbat9AP+
	 CQdQBoFmF1KVPa3I7lfNxz2rRZyHaaYmIImZYlCCs/jrF3urQ8uFJYfLWvMfwvdAqVlHL
	 PnOhf3DGp6KgRGPkToq9h7CIBTGfGwZvJ8GJF8ps314u37Gk/pYfvJgZw071B03TXnkh1
	 wg6YVHolabPd6LQm6EDfxpe0J9lYPb4+7gxeiSbUh/h/Z1xzNQA5KOtGoiXQTcH9ESG09
	 4eC9HLlku/Zztt1vajv0nMqyf8wv0Sn3597UMfzuQpClvb28uVeZDk/9qv0x/URhS1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792502421;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:Cc:References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=YGlVowyICXxSY3GmL0FDAbeqb2mzJ8MTPMKSU9lgtjA=;
	b=AWGPF/7GJ8iPydYoEqpjovTl/1yHp8+oQLiUTjJyYPViEt6gYTOnoTqfNExma7s5zP2x
	 34MiqlR71DOXf58HAM4HIwlT52oEYkG/q8EWibrkB6vup8wi8kVcA+dC78BOhGyEKO55p
	 Dd3mtil74JmYP2gSL6oF3IZMjUzm5CJEEWUxuZ1F+L5Dwvv18Oui05ic20R2TXOsl1v5v
	 K94b2ujBf2+ABSAGdfcSKt85OV3bqIP8HP+Fo7PhWVh81G3hUl3jSSSSD57U6GCv73rSv
	 FTjBCdoZ8QyCzadIqoA2Od1kxGgYy258XY8bBQXFq6KNmbKy4y8qPF7zgBzrnFgQwsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Gi7r4+qI;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=YBx5Tne5;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCC1606A32D
	for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 13:20:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5CCC1606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Gi7r4+qI;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=YBx5Tne5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792502415;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YGlVowyICXxSY3GmL0FDAbeqb2mzJ8MTPMKSU9lgtjA=;
	b=Gi7r4+qIZhoJJ54YhWU83/CMU1o4l285H/FydKpDlbqYrRkASW7nMY06Ncm3VZBZk2BlNU
	yGz/Ak9Mc2Ep0rjuc1wXLNZ1l7gkvoiTCEcVMg2x9sA2+KDNwOzC3SCpSf2jPf3uMTRkSr
	VVQHq2kFPyb1LkRB9xu6BcyxTaekgE8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-ktkSLzAuP8iyqEiDgaY27g-1; Tue, 20 Oct 2026 13:20:14 +0000
X-MC-Unique: ktkSLzAuP8iyqEiDgaY27g-1
X-Mimecast-MFC-AGG-ID: ktkSLzAuP8iyqEiDgaY27g_1792502413
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-48e17d30a79so1425084f8f.3
        for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 06:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792502413; x=1793107213; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YGlVowyICXxSY3GmL0FDAbeqb2mzJ8MTPMKSU9lgtjA=;
        b=YBx5Tne5g4RFNcVbiW6tixRaK1MTvqjSN0YtBjFAFvBE1SPrZrcYSUiBXWShOaQlW6
         dxnefxuhgrlV48tDt4Aoq7ZvLOpx9rbeQm82C4uvEqOp36DPGg/DzI2518eZAF5ZyvMl
         EWE1l/1sMHnordL0myni1hk7Rx64CaR+ZtO/tGdVIlTU297/VBFBoJlJ21+8hXGQNPAw
         AP2XZ04Xg/BFxsg7If8S600bk8KKYr1h1f5DY2ayp7DKVc/iA1uXxsEVBdJ3raUodmXO
         3723cbujZr8T/0LY3ZUQ4H2jvoM4YBwyzvr6Yc/N0Si2Ggyej8mf/+G6kIzQnXGX3ZcG
         OMTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792502413; x=1793107213;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YGlVowyICXxSY3GmL0FDAbeqb2mzJ8MTPMKSU9lgtjA=;
        b=ufbe1MaUfiVlbloazn7QbpU9b22Kb1ktjgK7hXoL9SExfm1kwJB1OKx6R/5EURtEdP
         Lq24KqFeauosupn1TA3OHwkacpeRCPj8flD9ccTrwUpXbahaOPYjxamEL0u3O2GaK6ov
         c5AAdrQyU7cMrPDQIbxedcXPbflXeNW6I72OOAbj+R1itX2Sm+W+N4ae2PACkZKWAJmG
         AjLloVDQVaZCBksnbFfj2NWJ9DkDhX6ZDi5WI4KL01yNNjNI9KYEq2g0O0ZHVp86vqaX
         qa0dtF7obywyj08BUaObC2zScG6rYOQlZ3DKZiGQ4eKd3I4yEABVlynvGawxYhWgFakq
         c97w==
X-Forwarded-Encrypted: i=1; AKwUvBynuJLqTcF7n7HvYo2UEa1bXKutWMG1ugRZpY26nmhNDoKrL8I42vatJstogrobPXO7EWCfKNb6daHH@vger.kernel.org
X-Gm-Message-State: AFq9FYKgHjyOq0OQFj8rP80GeO1klnzk5BF5Q/iHIrA5uWA87qGFAn1N
	I/fBoUdOavGMqcNQA+S9k0am3499fzHvvjUzHDGSV0wontRXDc84SfQNs5S87hLu5xy/4z7dxXn
	vz0Fz+d/69QX8Cypd+1m0MwpFXLPwFMBOiAKTZZ1IszqiIyLN/05HBUDX2/j94i4=
X-Gm-Gg: AYBFou2VTlIyewDvqK9sfFt6HMOTYateSs9yoPdnBS7xZ+uZABT9HP0Ru5sb4Ozay9L
	8fmEzWGkVXMLl0t6Hto5lNcAawM95M34itnyeskCsb8rVd3Pw0kDAmPInnW8XUygTGhr6RZyyTV
	zyf3GcwVMT6BFCKnsSadDoqwnuhJtumKepd6aQdVfyIglq0wD+s5vUJPpD2mnERJflZ6jKVtNxt
	Bf9Q6irvo2fWqT6zNC+3aBJMA29AoWG6cCMOYT+hMZ4c2bkuu+5iVFWefcvre6m0mFjy6UdUR+n
	bgm69fGmYnaC37X8p8cSWFNKZ4UPwCwpr8if4hQRnH/5CsaK5SdceLjCYIWLTp4jWlpnwnqZVPj
	YHiZ3cdqlaOx4t3uK+A3Zoo4LWAIcu+AuGO7eucB6egzTEjiTGZoVWZS1m0iOjcYqsbA+D47PFg
	==
X-Received: by 2002:a05:6000:2583:b0:48d:ee31:a07b with SMTP id ffacd0b85a97d-48e07f9adebmr25137933f8f.42.1792502412476;
        Tue, 20 Oct 2026 06:20:12 -0700 (PDT)
X-Received: by 2002:a05:6000:2583:b0:48d:ee31:a07b with SMTP id ffacd0b85a97d-48e07f9adebmr25137177f8f.42.1792502406697;
        Tue, 20 Oct 2026 06:20:06 -0700 (PDT)
Received: from [192.168.188.234] (ip232-47-231-195.pool-bba.aruba.it. [195.231.47.232])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e1d8244e1sm5905840f8f.44.2026.10.20.06.20.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2026 06:20:05 -0700 (PDT)
Message-ID: <5a195aa8-eb68-400b-95ad-e51e0ac95545@redhat.com>
Date: Tue, 20 Oct 2026 15:20:04 +0200
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
Subject: Re: [PATCH net] net/mlx5e: Fix NULL deref in PTP TX timestamp
 recovery warn
To: Carolina Jubran <cjubran@nvidia.com>, netdev-bot+sinfo@kernel.org,
 Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Alex Lazar <alazar@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
 Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>,
 Kees Cook <kees@kernel.org>, Leon Romanovsky <leon@kernel.org>,
 open list <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org,
 Mark Bloch <mbloch@nvidia.com>, Richard Cochran <richardcochran@gmail.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Shahar Shitrit <shshitrit@nvidia.com>
References: <20261015080218.1102172-1-tariqt@nvidia.com>
 <179205178078.408196.12399315538524843906@kernel.org>
 <842aba00-2293-4fd8-bc17-dc109b16da56@nvidia.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <842aba00-2293-4fd8-bc17-dc109b16da56@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/15/26 11:37, Carolina Jubran wrote:
> On 15/10/2026 11:09, netdev-bot+sinfo@kernel.org wrote:
>> This is an automated message. This series looks like a fix, but its
>> commit messages seem to be missing some information:
>>
>>   - How the issue was discovered, e.g. hit in production, hit during
>>     development, syzbot report, manual code inspection, LLM or static
>>     analysis tool scan.
>>
>>   - Whether the issue was actually triggered, or is only theoretical
>>     (e.g. found by code inspection). If it was triggered please include
>>     the symptoms, like the stack trace or error messages.
>>
>> Please do not repost the series just to address the above. Instead,
>> reply to this email with the missing information, so that reviewers
>> can take it into account. If the series needs another revision for
>> other reasons, please include the information in the commit messages
>> then.
>>
>> The evaluation is done by an LLM so it may be wrong, if you think
>> that is the case please reply and explain.
> 
> 
> Hi,
> 
> The issue was observed during our internal regression testing.
> 
> The kernel reported:
> 
> BUG: unable to handle page fault for address: 0000000000002ea8
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 1a9bfc067 P4D 1a9bfc067 PUD 1a9bfd067 PMD 0
> Oops: 0000 [#1] PREEMPT SMP NOPTI
> CPU: 0 PID: 0 Comm: swapper/0 Tainted: G           OE
> RIP: 0010:mlx5e_skb_cb_hwtstamp_handler+0x10c/0x140 [mlx5_core]
> RAX: 0000000000000000
> CR2: 0000000000002ea8
> Call Trace:
>    mlx5e_ptp_poll_ts_cq+0x228/0x5b0 [mlx5_core]
>    mlx5e_ptp_napi_poll+0xad/0x380 [mlx5_core]
>    ? mlx5e_napi_poll+0x750/0x7e0 [mlx5_core]
>    __napi_poll+0x30/0x200
>    net_rx_action+0x181/0x2e0
>    handle_softirqs+0xdb/0x340
>    __irq_exit_rcu+0xd9/0x100
>    irq_exit_rcu+0xe/0x20
>    common_interrupt+0xa4/0xb0
> 
> So far, the issue has only been observed during our regression testing,
> and I am still working on reproducing it reliably.
For future patches please include such kind of info (specifically: the
backtrace) in the commit message itself.

Thanks,

Paolo

