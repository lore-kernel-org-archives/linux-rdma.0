Received: from mta0.migadu.com (out-241.mta0.migadu.com [91.218.175.241])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB8140B0E9
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 06:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.241
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791356080; cv=none; b=anFlWkw9v/F1CW6lx7N8SSrTeh6QmwPBDhe1xozsli6pjswYZeI0V+ppepDCsBC4gpfj+UBHl3sjIlj6M2AY5O/yuaDf/KYxygX14lgNq9NekkBm7Pn3YcHx0GyYxMsXLwCB7n2U27cxvfSK1GTAnn9ulri+Xwi5PSaHGbEE5fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791356080; c=relaxed/simple;
	bh=wx+ZphHwDllvQj8s1LyNT4E8KL3k/eXA7BQmc806xpg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UmMQ+vm94riVaBAhAZC48sCR2AWIrC+fJmIL0bSCdqo8harTglf8HJiw6WDl6+pKv30jIhj5RAZNr0RgdrVQOQ30jL0C+6xxb6zyZVrvyxjlvESKKuNdg4BciDPC0yKCSu9i+gpflGv1vbeFLz72mBh8FkIeee9IBHuZsP/pltc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Hm5WSiwh; arc=none smtp.client-ip=91.218.175.241
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Hm5WSiwh"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=wx+ZphHwDllvQj8s1LyNT4E8KL3k/eXA7BQmc806xpg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791356077; v=1; x=1791960877;
 b=Hm5WSiwhHCccVCdF0jpIRe+x4Oz5gAsCmwXVqhI4z+yAJd6+xnHhQVRblLI9Z2Hnn0j91FMw
 +T52j/0WFEMCYUBzkI6PDSDZAmP591G55Jmz7039oFcuO+0EmMK7ut/3afLb5viP7FngssHZzVH
 a1nh+7WtrXf9IbKQqfa3FE8s=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id cb843fb7101e1d52;
	Wed, 07 Oct 2026 05:00:10 +0000
X-Mizu-Trace-ID: cb843fb7101e1d52
X-Migadu-Flow: FLOW_OUT
Message-ID: <86debfbb-b507-4ec0-8ed6-bf112b5f960e@linux.dev>
Date: Tue, 6 Oct 2026 22:00:02 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] RDMA/rxe: unchecked receive WQE cursor causes OOB access
To: Willy Tarreau <w@1wt.eu>, sungbyeongchan <tjdqudcks0424@naver.com>,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: Zhu Yanjun <zyjzyj2000@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, security@kernel.org
References: <20261006091239.828415-1-tjdqudcks0424@naver.com>
 <asWzwbYj7kVTiQ3L@1wt.eu>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <asWzwbYj7kVTiQ3L@1wt.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2026/10/6 19:51, Willy Tarreau 写道:
> Hello,
> 
> On Tue, Oct 06, 2026 at 06:12:38PM +0900, sungbyeongchan wrote:
>> This report was prepared with AI assistance and is being treated as
>> public under Documentation/process/security-bugs.rst.  A tested source
>> reproducer, logs, configuration, and proposed patch are available to the
>> maintainers on request; the reproducer is intentionally not attached to
>> this public report.
> 
> Please do *always* post a patch. Maintainers receive lots of messages
> like this one every single day, there's no point sending a message
> saying "you might be interested in a patch I have" without sending
> the patch, it wastes time and effort doing round trips. Just send it.
> Same for the reproducers, if they're not too big, just send them to
> the maintainers (not the mailing lists) so they have everything to
> start working on when they open their mailbox.
> 

Thanks a lot. Willy. With AI assistance, too many problems have been found.

Yanjun Zhu

> Thanks,
> Willy

