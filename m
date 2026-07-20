Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32BA83921FB
	for <linux-rdma@vger.kernel.org>; Mon, 20 Jul 2026 19:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784575242; cv=none; b=d31eOy6MmqdGam/AgXCM6QI/OsP2kzaNQQacb/7sdXmA0vItWDV/AO3IVQrCMbTMeS+4EhGRl9rZWjMLyziJIOpp/xGCn7xCGdSkyIvDVM8VrK1nqAz7kAd35m4EvxTdTzXEC6Pi0OgFWq7C37XiPDLMgVlsRMwBSnX1jKzFyek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784575242; c=relaxed/simple;
	bh=YkDga7IATsXl4YWnQ3AMcuAE7o5H50j43pX7QJYnMuc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Hi6uL+oDkZWvYDxpgdz0/ZbvT+/NW7EH8fdow6c44p8EgvDAB1rsCdgLlhwshD7cLcM9YBcCccDdiveJqZxaj8S0oqpMAV+ofbXHPSGh1RSrNB4OC7Uabw2Mr1F7dFalZ+MxfQ/UESCvTv3RwLA+f67bLdj90irjl4udmMRZwjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZcrB9E44; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZcrB9E44"
Message-ID: <9f89e398-9848-40bb-a674-9719d94a6151@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784575238;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3wJ9D0TVK5fJr6gVBjocMtF4cEPIgYn4knacn+k2k1s=;
	b=ZcrB9E445+ortxUfaOi+fZvfwmU7Q2NEQESE9kDfGrLO43olHX3YRXFKc07EL1Es0MVvYV
	1KBKm86o+qi1AfeIOn8tjNNcI9VtLDiWppbwSzWhvxmvVCyI6l51U2UgnHhU6v/C2PXUBQ
	2VjuGeLSD5HxW53jet49vgwzyKcZneQ=
Date: Mon, 20 Jul 2026 12:19:55 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [RFC PATCH 1/2] RDMA/rxe: drive UDP tunnel socket lifetime from
 the GID table
To: Serhat Kumral <serhatkumral1@gmail.com>, Zhu Yanjun
 <zyjzyj2000@gmail.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 David Ahern <dsahern@kernel.org>, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzbot+8c9eede336e3a843750e@syzkaller.appspotmail.com
References: <19670ac6-ebab-4074-ab4f-3db06e1db291@linux.dev>
 <20260720181551.30322-1-serhatkumral1@gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "yanjun.zhu" <yanjun.zhu@linux.dev>
In-Reply-To: <20260720181551.30322-1-serhatkumral1@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 7/20/26 11:15 AM, Serhat Kumral wrote:
> Thanks for the trace.

I have already provided all the details needed to reproduce this issue. 
I suggest reproducing the problem locally first, which would help avoid 
a lengthy back-and-forth discussion. It would also allow you to validate 
your own fix in the same environment before submitting it.

Zhu Yanjun

> 
>> KASAN: null-ptr-deref in range
>> [0x0000000000000000-0x0000000000000007]
>> RIP: 0010:ip_rcv+0xeb/0x570
> 
> This shows that the failure is not a deadlock, but a NULL pointer
> dereference in the IPv4 receive path.
> 
> To identify the exact source line and confirm which pointer is NULL,
> could you also provide the output of:
> 
>    ./scripts/faddr2line vmlinux 'ip_rcv+0xeb/0x570'
> 
> My series does not modify the RXE IPv4 packet-processing functions,
> but it does change the lifetime of both IPv4 and IPv6 UDP tunnel
> sockets.
> 
> Could you please run the same selftest on the same commit and config
> with this series reverted, and report whether it still crashes?

