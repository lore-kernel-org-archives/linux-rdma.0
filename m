Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792684583;
	b=xiko8Rv9T2aTqDwisNSrj9rzTLB1RxsKFFVC+fD6wra/yS3CElJu57YoAcDDYZPzFQ9Q
	 K0MHjpvAGb89EvewKRwfOqfC8699158udvGxCacSs27/tpeh0H0GG9y/fcww4JDSFgPTg
	 H/S/KRCW05X1wbcdGSwfLpUj2+aZI0TCn7cjThjo/cz5ZhViir8HnCbNSeSU3J6a+7lVU
	 Lp+sHO8nVKUBFvOuuOfZ5kzRsmVxzIxgMnlDnIK2aL8BKffirxG/J+bnirJmg8Vbm/qBj
	 rtdgs8Hd9Yh6HA/liiKgA1dnBWrKeRy2pTRzpPMjFmMlUyeyUgZIC+5BFjVzsJtgb5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792684583;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=/mq6HJmwjim9RVI3EhHLhB5GxdA6qNIr6nDr4mwkuO8=;
	b=QtfBPBp507FWwsdtegChO/5YfomUkWQVnPN9ekbPHpEroJ4BImawE6NZQtSANonlfacY
	 RtlwywLFJW10sxPmxW9mItsGkPH3EIIvrdF298lWQwIQGW4t5kLEAlbdzWdbcvuwcZEu2
	 5BUhIZ2vXWFLHTmF01ELJCY5UlpfHW0hiaeY1HjV4XpDWzwq5lKCUvkJVblkkGE2XOdsy
	 ZHkk7P85WLVduMqv7pJEkALlogwRhMaWlceCdF0agC1f9ttHXL9j/6rrH+5bTzrjcqpXi
	 Hln59CoR5WVPzuuSzKcSGVvT0UxgwhvIgBO/n4Mj0K3vGv1nBsP7/t6zMRR93qANNjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=Cydx8dk5;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0BD606A31A;
	Thu, 22 Oct 2026 15:56:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8D0BD606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=Cydx8dk5
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4j9W3N25Hmzlfvpd;
	Thu, 22 Oct 2026 15:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792684573; x=1795276574; bh=/mq6HJmwjim9RVI3EhHLhB5G
	xdA6qNIr6nDr4mwkuO8=; b=Cydx8dk5I8GUm4Uy3zZqHTQndz0D5hV/g+a5d6Gk
	05wBGFwQ90nrnmmGk/3ObPOMmGGDOwC91+5YZiZtetryuDxk4vH8PP/iVcpalluE
	wniXRSOZNiGWcRJsNEFKyG1PXqnX7P9L8w+KEGd1aPuBSlWQhBfupbfSsqpcWikd
	l5cEThhZDyJz9FjtGF9t6lhKiLhqz/ZPCBCwQO6O0qPO9oytkwbnovUcYqL4aTG0
	6u510dp9LEcCXafy2//xgAw3AnqN9zJH5hir4tqMhZke4Jc7pK3h4IfDEP1zdeIr
	jiT4S5PL59uKPf4+uSs9K5Di2QcB7zEG+S0qAA7c5BklPA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id OIm9nWVqjCF6; Thu, 22 Oct 2026 15:56:13 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4j9W3J75Bbzlfvps;
	Thu, 22 Oct 2026 15:56:12 +0000 (UTC)
Message-ID: <ea3e91af-53b7-419c-b83e-d70d002ea321@acm.org>
Date: Thu, 22 Oct 2026 08:56:12 -0700
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
Subject: Re: [PATCH v3 1/2] RDMA/srpt: bound the indirect descriptor table to
 the IU
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 linux-rdma@vger.kernel.org, target-devel@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261022143901.2991062-1-yhlee@isslab.korea.ac.kr>
 <20261022143901.2991062-2-yhlee@isslab.korea.ac.kr>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261022143901.2991062-2-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/22/26 7:39 AM, Yehyeong Lee wrote:
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index 7197d95f2216b..97758082f71d2 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -1117,6 +1117,8 @@ static int srpt_get_desc_tbl(struct srpt_recv_ioctx *recv_ioctx,
>   		struct srp_indirect_buf *idb = srpt_get_desc_buf(srp_cmd);
>   		int nbufs = be32_to_cpu(idb->table_desc.len) /
>   				sizeof(struct srp_direct_buf);
> +		int desc_off = (u8 *)idb - (u8 *)srp_cmd;

The idiomatic way in the kernel for subtracting pointers is to convert
these to uintptr_t instead of u8 * before subtracting.

Thanks,

Bart.
