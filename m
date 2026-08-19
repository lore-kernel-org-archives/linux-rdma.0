Received: from mta1.migadu.com (out-149.mta1.migadu.com [95.215.58.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E0F3C5827
	for <linux-rdma@vger.kernel.org>; Wed, 19 Aug 2026 06:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787120944; cv=none; b=jb6loVg0953ZCFuEndYJHUtShaHRVc9dxkjTe4n0sclBVmHo+ziLd4ED1nvlBNLTMqUNsbDnmdaj37nSO4VXg/7qFywr0X6PAadfgefTiXnEXcxKYctD7kesKjHH29licrgLQWPxzRyeYBrOMwg4EQ5bilw1cxOMQ8gUp/HiFRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787120944; c=relaxed/simple;
	bh=8CB/lE4/49sfkaUzUzFM0kUF7Peyvb1rL/t6EKc0jA0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SAN3vVDOEJq3+XtzjBPOmT9EovlYI6J3HkA076IytkXAjl5nA2tdHKpyhzfJBHcjrbQ1HHY0Bppu8eAhJk+WSavRt7OPwDHxhH8qZ2HjmKXjDiaT1d2aqORqHUVU3JzLOaKCj+g7tO+MbZyXa1fb/8RzPbVVcAmfdY/Wh3EXgGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xNSagfxq; arc=none smtp.client-ip=95.215.58.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xNSagfxq"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=8CB/lE4/49sfkaUzUzFM0kUF7Peyvb1rL/t6EKc0jA0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787120940; v=1; x=1787725740;
 b=xNSagfxqxXIwuiPIKBdzuETzXkIxO0hv5oVL2oLJXJCLrZhalTkjkDlZ7m6GpqVNuyq/wVf+
 xzPEojG/GGq4T2eTwGxtgDVl5TuQae3cEfoiJsgd0dqbTEgdvRu3XpdJcnTLBeCkQcRZ3dVz6Rr
 x5pSGZc+Y8NepYWjBfKsZKT4=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: from [IPV6:2601:647:6300:a030:bc85:bf86:ea62:1b8a] (2601:647:6300:a030:bc85:bf86:ea62:1b8a)
	by smtp.migadu.com with ESMTPS id 1f7a16524ac85e93;
	Wed, 19 Aug 2026 06:28:50 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <0167d920-1cad-4117-ac19-870a340601d7@linux.dev>
Date: Tue, 18 Aug 2026 23:28:47 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] RDMA/rxe: copy send WQE to kernel buffer before
 processing
To: Tristan Madani <tristmd@gmail.com>
Cc: Zhu Yanjun <zyjzyj2000@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, Moni Shoua <monis@mellanox.com>,
 linux-rdma@vger.kernel.org, stable@vger.kernel.org
References: <20260816104432.849996-1-tristmd@gmail.com>
 <2063d67f-27c5-4329-aaf5-39823f9de6ff@linux.dev>
 <20260818133319.4128416-1-tristmd@gmail.com>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20260818133319.4128416-1-tristmd@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2026/8/18 6:33, Tristan Madani 写道:
> Hi Yanjun,
> 
> Thank you for the review.
> 
> Regarding concern 2: unless I am mistaken, rxe_sender() calls
> rxe_requester() then rxe_completer() sequentially in the same
> work item (rxe_req.c:836), and do_task() prevents re-entry, so
> the requester and completer should not run concurrently on the
> same QP. But please correct me if there is a scheduling path
> I missed.
> 
> Either way, using WRITE_ONCE() for the state and status fields
> instead of a bulk memcpy() is cleaner and eliminates any concern
> about tearing from concurrent userspace writes (concern 1). I
> will send v2 with targeted WRITE_ONCE() writebacks for just the
> fields that need to be visible, dropping the bulk memcpy.

Sounds good. Please go ahead and send v2 so we can look at the actual 
implementation and discuss based on the code.

Best regards,
Yanjun Zhu

> 
> Best regards,
> Tristan Madani

