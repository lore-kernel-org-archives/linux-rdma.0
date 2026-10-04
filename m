Received: from mta1.migadu.com (out-81.mta1.migadu.com [95.215.58.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B1735F170
	for <linux-rdma@vger.kernel.org>; Sun,  4 Oct 2026 06:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791094454; cv=none; b=I76HmDFkCYdyqLLUUR8SD6EX62b7snTtWZ6rSAVrr2eYSjPj7bIUlRzbD+jVdsf8sa0eQ52MV0uc+hQo3dbtUSjOl9uLXIzvCU7J/RBCAxye1qSuQDSAyj9QoblqR88YkujoYtteyKe86e37MHHwpdh+7bGkq8pCtcA20/HPhUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791094454; c=relaxed/simple;
	bh=uigwW52VeFNowh25BWnUCscOpszWG7zB+eEdwFHmbNs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WrUTLhoZVkMb2NC5WLDpnQSAtqlJVIc1Vsczzd/QKB4wNbLFKW/b77qTOlVty8UufyIXsbJ3S4xk/SO4jfoLgtxsiCXek23KjbIokILEC7mdvA/5ud33EAcwFVhR3r0p1KdESDoV0NTteQf87YuL44vKUARmbFtd06x7sQDjO4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TWt4MO4a; arc=none smtp.client-ip=95.215.58.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TWt4MO4a"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=uigwW52VeFNowh25BWnUCscOpszWG7zB+eEdwFHmbNs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791094448; v=1; x=1791699248;
 b=TWt4MO4aoRE4JdbpKt2Ol2Ng7YGHUeJ6ipyDBz3ga06Nq3qJnnnNg/AZBqL6699gyC3rZI1j
 n/Eo52z7bjYxPJlEYezQx2CSU3tq9wdyXlN6o8nBW5GFn1cj2cW/U82RpG3d5DTsZGcgUPaDLZi
 dWWccVjYG4vt8ch/ZzJTZSKI=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 5cb8b85ffab97001;
	Sun, 04 Oct 2026 06:14:07 +0000
X-Mizu-Trace-ID: 5cb8b85ffab97001
X-Migadu-Flow: FLOW_OUT
Message-ID: <862e30b2-5128-4b1b-985d-cd3faa21fc91@linux.dev>
Date: Sat, 3 Oct 2026 23:14:04 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/rxe: Validate inline data range in user WQEs
To: jiale yao <19888972804@163.com>,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: linux-rdma@vger.kernel.org
References: <20260924100515.502912-1-yaojiale02@163.com>
 <20260924101736.9FA281F000FF@smtp.kernel.org>
 <a1ef2c45-431f-4dad-b812-0b6cccf9ecc5@linux.dev>
 <1c28994b.869.1a105467816.Coremail.19888972804@163.com>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <1c28994b.869.1a105467816.Coremail.19888972804@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2026/10/3 21:57, jiale yao 写道:
>> Hi, Jiale
>>
>> Please fix the problem that Sashiko mentioned. Then send out a new commit.
>>
>> Thanks a lot.
>> Yanjun Zhu
> How about this one,
> https://lore.kernel.org/all/20260926070403.3005250-1-yaojiale02@163.com/

Sashiko still complains something. Please try to fix it.

Thanks a lot.

Yanjun Zhu

>>>> +		rxe_dbg_qp(qp, "invalid inline data range in send wqe\n");
>>>> +		wqe->status = IB_WC_LOC_QP_OP_ERR;
>>>> +		goto err;
>>>> +	}
>>>> +
>>>>    	if (rxe_wqe_is_fenced(qp, wqe)) {
>>>>    		qp->req.wait_fence = 1;
>>>>    		goto exit;

-- 
Best Regards,
Yanjun.Zhu

