Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA5B41DEC4
	for <linux-rdma@vger.kernel.org>; Tue, 11 Aug 2026 09:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786440085; cv=none; b=h/Cp7uMSZfenI663lRXPCibZvxaHGuNyiQjelmcST3+Xl/BmEpT849KqD36jNQEln7fTlWtg9aGKLp0mKqiAohxanY1tKQ/Sz+8BMAoeknb0qUfPFT+nB1y/q+Jgf9w0WWB/xr/kI8Qq5f9KIfi1LRZLmeUps5uh8zi7oZsJTJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786440085; c=relaxed/simple;
	bh=rQ83MxTdYDXXJ/sWnGZ4Dcgrn3SUyWiEQ5rBXRaIYqk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=igktx7P8tM0cTYuHJEGLEWRNEQONsGs0tB1vOr7PTjUEEK0uWZfWaCM9cuNpFfG2NQt7WQsedUau9wB8iXuZRFZUcyypq2SDlmjalWnkQ1a2NodB2VcdEFtE3Y0SdETlz+908xZnzSQmmJH0JJ0lJtlQ0L+4evhSC8eC8x4IHAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mbT5EPCM; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mbT5EPCM"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6a17211b9ecso4072211a12.2
        for <linux-rdma@vger.kernel.org>; Tue, 11 Aug 2026 02:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786440081; x=1787044881; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rxC/GxhN4TzXUqlm7Isfwqh8isoAuDWB2kvs90LXvTg=;
        b=mbT5EPCMFbyORUlitDU0ApnRJZxz6TOa+Qmhsf/wqfO2gygLyWgC0aQwaRVP8lJmdd
         eXYvl21UQNqrF97dq5Fp/6DU/Zr/lTvJNNEJAYFFYXm6QnFghubtTt4uopC60rYfpZj9
         t95J3bsZz5bi8KgWVuzy4hUmnL0x0P9/FBAplAh9cUd+1yVWkQvld+qdgs4eOzzqRmov
         vh/Qo+K8fFWE4HiUulRG/WncpO649bWo1SejwIvTheTNke7BPyLWH4b05fbNXP/GVg0i
         SMwzEXSm+bNoSaLThYQDFZBYa7OgfDDr1H88o+PMnep/zEEugDP5xnhjkv6m+bMK4wfu
         QOhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786440081; x=1787044881;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rxC/GxhN4TzXUqlm7Isfwqh8isoAuDWB2kvs90LXvTg=;
        b=Hibt5T9XI73mDSKpecsAVVmCN1YYvO2d26HWkqNPqVgjpmGcfIrssYConQRaHwndU9
         cgDgjn+rPb89Gq/D0qV37g0cZt3xGOI00CC3rid5VVAi81ixABod72bQr5nYmf5RZGya
         I/6U76FBqy9s/8VDNVk36TJIxUgaDQt5ZUD+rFv/tRB+bmbDrS+gOinykKIvJulYLwy2
         i+SxL+O/IdJnBJGtzp0pHbaqfxPQIasdK4dmSN2ojy4rcXGmysQ1wrmvyAaWFqoy1BDB
         OesbAl3b9RARflfKEeGhTUq89ATu3jnrVZ1dKkFqACZCpIfmEvQDeWFqeaDccOS1XQpC
         FRww==
X-Forwarded-Encrypted: i=1; AHgh+Rol3J564w/9XCAakoztKNEP+grX1xICSb1avLPXyJFKqWp+caSiSxXgKjTp1dBFaoReEJDiedQ9tmne@vger.kernel.org
X-Gm-Message-State: AOJu0YwOKJiBLTN+YKK98TK2iABK7gOErqB+7j3OV0ZQg/Fq9u8pwwYo
	+mTrJ/25fQ9NkkFgGJBt5Fy/3rz5aJeJV3hvXAGx3ni0rv8uhHbqgC2T
X-Gm-Gg: AR+sD11k2cVWbkxiJWd7oQm3zWgVZ6bM9YN2uvnxp0RcOpliyX7TbBkiB8ypkdEbk3M
	AagQ3O/BVicK3NRN6qIMiTARKloDlxBJWNl1JQ2xmTICmCNvRuVwHGcnKCb/Dg8jkRi1M5zbOXT
	bg/e/Khwvbr5ASgT68DaRSDR5uPpuz9R9Q8nxsDI22eur3Fl8fT1wRWcu+9mXwkKul7bqNhxcGv
	1eQgccQVwrAmvQ6+VI/TnDBp3p2k3G0lGb9ukTK8Yolp40MczUh9fAsjI0ia99U3HQZp1TKW6gZ
	4ZsjJSZGFpP6IsswZt9JsovbAZGQtA3WuLGjHroFyASYTKTlfKOlZhZkwJNggilZu/59emqZZH8
	VOuejjui4wdloss+PLPQUdmLvh7XFSDnYk4u7VBfAwyX5rhX9xrRIhkALiJlm8Vfsp5HtFM2lq5
	K8lsSpshtXiaYj4w8n9u3wKMvd6Fhq0qLdH5qHEOLkN1eQbPT1kINPMYFDpJbI1TIs4rP0J4To4
	wzBUDVUv5QCwMCOaBcl5wQzUofGgx/rew4ZzWl9DlriAVBJBQuLTquY9Xjl+HurJGLWf9ALgaAJ
	O/FzlUqC7Ur6Cyw7J6K091wxEOpqAdn9/WK29YURELBg+PGgQFaW5hY=
X-Received: by 2002:a05:6402:5d3:b0:6a1:fb92:b3c3 with SMTP id 4fb4d7f45d1cf-6a3644fd3aemr1104850a12.12.1786440081297;
        Tue, 11 Aug 2026 02:21:21 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a362ef8490sm423705a12.28.2026.08.11.02.21.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2026 02:21:20 -0700 (PDT)
Message-ID: <de87c6a6-44c9-4b78-991b-ff858e21e806@gmail.com>
Date: Tue, 11 Aug 2026 11:21:19 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v3] RDMA/core: Reject unregistering netdevs in
 ib_get_eth_speed
To: Jason Gunthorpe <jgg@ziepe.ca>, Jakub Kicinski <kuba@kernel.org>
Cc: Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S . Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
 syzbot+5fe14f2ff4ccbace9a26@syzkaller.appspotmail.com
References: <20260810133124.44513-1-krystianmkaniewski@gmail.com>
 <20260810113308.5db6937e@kernel.org> <20260810183902.GD507588@ziepe.ca>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <20260810183902.GD507588@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Thanks for your comments. It's my first contribution really, so I'm 
still learning on how to do it properly.

I'll do the requested changes by both of you.

Should I rebase the v4 patch on top of any specific branches for rdma?

I found "for-rc" branch while looking at 
https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git, would it 
be a good target?

On 8/10/2026 8:39 PM, Jason Gunthorpe wrote:
> On Mon, Aug 10, 2026 at 11:33:08AM -0700, Jakub Kicinski wrote:
>> On Mon, 10 Aug 2026 15:31:20 +0200 Krystian Kaniewski wrote:
>>> Subject: [PATCH net v3] RDMA/core: Reject unregistering netdevs in ib_get_eth_speed
>> nit: Please don't tag as [PATCH net], networking maintainers don't
>> normally touch RDMA patches.
> I also drop all patches tagged like this from the patchworks sight
> unseen.
>
> Jason
