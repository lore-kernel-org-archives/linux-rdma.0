Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D1547A89D;
	Tue, 18 Aug 2026 16:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787070415; cv=none; b=pKkdtD9nsgnRKTQocb6m+rntJE0t5A18ETXGaOcO2yQlzlisK9+zhRZqzrDhPAlDgrrlYwjHFo1LkWsSSW0YX/Q9g0NuKgQUL08lK84HKaUX57MPP/pdL1DnsUR5Hngnjr3VaKuXN++kcOwt0LMdeJjRQRU9CARGOLKL7Or6gbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787070415; c=relaxed/simple;
	bh=67SNMX0XuB6JPf09fWcN7CU6sgTZ3M3Hjoma2XIKIeg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vgn0RvSInfKByGuv0NkxcziM4B/7u2DoVXY5p6TCCaj+BHPuT+ARtKKptifDsuvW0Z1H/RAU6Bego4EBfwb0DiPPF5bKGwZ26VzTJzgKtOHA7hOwjy0sQG1T8L7adGnXa5A04FVvp3nIGc2049IWXtfEtvJVab7fGaPSin4jL0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=qGrN9hJr; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="qGrN9hJr"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hPZpb5ylPz1XM6JF;
	Tue, 18 Aug 2026 16:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1787070404; x=1789662405; bh=we4628W9EvYfCIfPQIpPyQR1
	BetSr8Xkh7piaePlebE=; b=qGrN9hJrtBsYSzIKBM6rVm+timV5BCKZnTZqcIVU
	SlVwIm9KUAO7gm7g4ZMM2aQwt+IMkVeCnMoW438jdKwUpKkfvPoRhdzSdjUuboBd
	sieq43EMXUrlosy966U2cPdUQaMUmacibK5MTu6Rls4M3IyPjkzlR82C2Q3GP0vc
	8dXPFXLnCw0U6DGcQGd+0MRkAxLmq4ilX044QdOSEw0gaA0WyXlwd7jDkt5fSglm
	1zyYXvncK+h72M2zWtTA/JdaL/baNP1sbeNWpEJ7SA9p+0CLXpW7T9tjoTPpT4g8
	sPYRONNDAGiqWwGwrhLzml8Vo7mU/OYol92cCrCT5ZHGyw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id cxRagM53wLZq; Tue, 18 Aug 2026 16:26:44 +0000 (UTC)
Received: from [100.80.228.34] (unknown [104.135.182.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hPZpW29cZz1XM30g;
	Tue, 18 Aug 2026 16:26:42 +0000 (UTC)
Message-ID: <3ca5809e-96be-4073-8596-4ab53d72d6b9@acm.org>
Date: Tue, 18 Aug 2026 09:26:42 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] RDMA/srp: fix use-after-free of a request in
 srp_destroy_qp()
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>, linux-rdma@vger.kernel.org
Cc: jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260818035229.505098-1-yhlee@isslab.korea.ac.kr>
 <20260818035229.505098-2-yhlee@isslab.korea.ac.kr>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260818035229.505098-2-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/17/26 8:52 PM, Yehyeong Lee wrote:
> -static int srp_inv_rkey(struct srp_request *req, struct srp_rdma_ch *ch,
> -		u32 rkey)
> +static int srp_inv_rkey(struct srp_rdma_ch *ch, u32 rkey)
>   {
>   	struct ib_send_wr wr = {
>   		.opcode		    = IB_WR_LOCAL_INV,
> @@ -1170,8 +1173,7 @@ static int srp_inv_rkey(struct srp_request *req, struct srp_rdma_ch *ch,
>   		.ex.invalidate_rkey = rkey,
>   	};
>   
> -	wr.wr_cqe = &req->reg_cqe;
> -	req->reg_cqe.done = srp_inv_rkey_err_done;
> +	wr.wr_cqe = &ch->inv_cqe;
>   	return ib_post_send(ch->qp, &wr, NULL);
>   }

This patch introduces a race condition because it associates a single
CQE data structure with multiple concurrently submitted work requests.
Please drop this patch.

Thanks,

Bart.
