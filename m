Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794735467;
	b=ZCf8bFv0UYgoS/teNUreHSA4WKv/cnLpiGo5S7ho9OZnprXPuQRpw/giTcAY5PM299Hi
	 Z/UYUowi3vmzsutpUBMUlF0AOJV+DymNiSLMarrUlLFb1CZwe9d2/3lU/Hjkd7o+pIIji
	 JyP6JHePRSFl23Mb2krv9pwuhNgZ+WjjMnAn/oALISknNJ4RpNlpJowHrn2JsBTuWrXvw
	 odEef7SpiBjZ8QwKZOUsB1Q7dDGmwS5h4Od7UfHcxiMwTRyuS0Wak7pCArH3LFIS5+APZ
	 atiulscz/aTwYgI/VCkWRd23k2ylX0sC0MYP3Tu6RvAzslGOzN+2diZeflrnGprbV2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794735467;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=I2b7PP+El7I26h/5mkAj6vNbRpq7BbwaQUvnfhFQyqs=;
	b=fg1pcg05g1X5FE/b87dOGhV2lYOwaytmQLn3Vx5x3fT2h7S9bjKqLcYvE01wXMN8w17x
	 jz45IoxuK0cHN9+fU9KMVwmV3AxHtGUWX+hjOXKWfMmmzJZlJ5wp927prYunBtQ1TTI5t
	 O54+ZSMSixlYXM4+4mFFYB8YqRBFGb5OXlkFKOTuNU+k1lVWeF7ED36dBAjyrKCqSCbop
	 5MJZ9JYH84k0gdkMdCO3d3kQNph81ZIvuHIUu7uytzuV9JwGHUCVji26IOTy7hZ5jmt6w
	 pUcIh3og3IQPcIJYRNOQQCcd85oiP87+lSDus1A74CU0XJ3WaCmuqyGPHFbVzNWtIng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=HejNnmMY;
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A45606A31A;
	Sun, 15 Nov 2026 09:37:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B3A45606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=HejNnmMY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1794735465; bh=l9YAYkprJ5X1/VsW+JPN2Olt0TJob6Ww2LOpepA/seA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HejNnmMY3O4kM8ejz8rccgQvRjPlPkA3uSaCoC07hp34tIoiXYO3tGs0MrVE3560q
	 /0RtMGniBOUwy5inKkqObH0bOxRkE8A18zZR7zVZKrcF8YQ3muHAom1f0Oav5SaYsD
	 /Zxqt964Q9YJQzz89CmhoFPVZkVJ5nHKpY7OyM1IRsUvtRO9EkK2ADFiMJNvR37gcg
	 clnsEGz/qCFis1IN9O9rTUTC3zzW4UuQcJ+9PSTy5+0rPj0BocFfv5q7wqDWD3sCo7
	 Y5ZS31sWmXqpe+RDhUv/gOjsKG9ptZLMkHN7m/HzaSksJULgVebk/GSfjLvIbdBqFR
	 seubAGutxNn9A==
Received: from [0.0.0.0] (unknown [213.228.1.188])
	by rcs.proxad.net (Postfix) with ESMTPSA id 67DD544C0736;
	Sun, 15 Nov 2026 10:37:43 +0100 (CET)
Message-ID: <0c42ad09-0aef-4e98-80b2-43cac04adfb7@corp.free.fr>
Date: Sun, 15 Nov 2026 10:37:42 +0100
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
Subject: Re: [PATCH net-next 10/10] docs: networking: describe tunnel key
 partitioning in TC queue filtering
To: netdev-bot+sashiko@kernel.org
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 jhs@mojatatu.com, jiri@resnulli.us, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, michael.chan@broadcom.com,
 pavan.chebbi@broadcom.com, bharat@chelsio.com, donald.hunter@gmail.com,
 corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org,
 dsahern@kernel.org, idosch@nvidia.com, shuah@kernel.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 oss-drivers@corigine.com
References: <20261109131039.959438-11-acassen@corp.free.fr>
 <179442433615.2199510.11200298531505956799@kernel.org>
Content-Language: en-US
From: Alexandre Cassen <acassen@corp.free.fr>
In-Reply-To: <179442433615.2199510.11200298531505956799@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/11/26 20:12, netdev-bot+sashiko@kernel.org wrote:
> [Severity: Low]
> 
> The commit message says this documents "what enc_key_id means on a physical
> port of mlx5". Should this paragraph also list the limits the driver
> enforces? As written, the driver can refuse the GTP-U example above, and
> small variations of it, for reasons the document does not mention.

v2 names the tunnel ports that select the key. The driver refuses the 
other cases with an extack message that says why. The document doesn't 
repeat each driver limit.


> [Severity: Low]
> 
> Is "Without it the filter stays in software" accurate for the queue_mapping
> filters this document describes? Leaving out skip_sw does not seem to
> install a software only filter.
> 
> If skip_sw is removed only from the filter, tcf_action_init() rejects the
> skip_sw action:
> 
> net/sched/act_api.c:tcf_action_init() {
>      ...
> 				if ((tc_act_skip_sw(act->tcfa_flags) && !skip_sw) ||
> 				    (tc_act_skip_hw(act->tcfa_flags) && !skip_hw)) {
> 					NL_SET_ERR_MSG(extack,
> 						       "Mismatch between action and filter offload flags");
> 					err = -EINVAL;
> 					goto err;
> 				}
>      ...
> }
> 
> If skip_sw is removed from the action, tcf_skbedit_init() refuses ingress
> queue_mapping:
> 
> net/sched/act_skbedit.c:tcf_skbedit_init() {
>      ...
> 		if (is_tcf_skbedit_ingress(act_flags) &&
> 		    !(act_flags & TCA_ACT_FLAGS_SKIP_SW)) {
> 			NL_SET_ERR_MSG_MOD(extack, "\"queue_mapping\" option on receive side is hardware only, use skip_sw");
> 			return -EOPNOTSUPP;
> 		}
>      ...
> }
> 
> The filter level skip_sw is not merged into the flags that the action init
> sees, so this happens whatever the filter flags are. Both failures happen
> before mlx5e_tc_tun_parse_outer_key() runs.
> 
> The "stays in software, reads key zero" behavior only seems to apply to
> actions that can run in software, such as drop, mirred or mark. The text
> looks like it was carried over from the commit message of "net/mlx5e: TC,
> match the tunnel key without a tunnel device", which describes generic
> actions.
> 
> Could this sentence say that the queue_mapping request is refused instead?

It isn't accurate. v2 drops the sentence and says that only the hardware 
can match the key.



