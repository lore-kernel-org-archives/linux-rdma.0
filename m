Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6975E423EB2;
	Mon, 27 Jul 2026 17:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785173649; cv=none; b=tCkZBGb+xmT9Gh9X8bGRvsw6/RSIxRM+p2n5KNLhTmMvShNjBr1Tvba1EDxWzcg/9eAJ6riOviLt2t1QwiD7xtsLUr8aCtxuWTHeHq0KLBlB10SY79oPxbLXnMdAtTiwacY7ykInByYBLpHUMN7SHvMOYvbYwNiJdQqnn7unrqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785173649; c=relaxed/simple;
	bh=8h6DjbnT2h5fwMK3RYYsrwYREhtwxrA8izC0p7z/KMA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TydnZcHAOtv/udWs/I8tD8xwJ5fghvrbK1pVXCwKsIXvnGAPKx0FSR3UO0JNHpTVyOhHoVX2YNM5QJyer4fhsbSy6miGylJxzs7Q1rdsbcUAvJZJNKYouxK37zfDWRcEIuKxX+nPSD4jdikOc7RjD5N3G5LuSpJ6YXwHVh0zCtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=SPHkznAJ; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="SPHkznAJ"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4h85LR6mqDzlfwHP;
	Mon, 27 Jul 2026 17:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1785173645; x=1787765646; bh=8h6DjbnT2h5fwMK3RYYsrwYR
	EhtwxrA8izC0p7z/KMA=; b=SPHkznAJCNCOPt9M7YsIHMDUW5pt/w1NlAcV2GEP
	ADdqEW7s+QT5QkoNwbXmW5Fu895aEYc8VFG8o0F2P4BuW9QvgP1HEJzUwn4xY22K
	jLU8PVC9dt+UY3ouUyhAt/8fe7C18yg3tFIx0Qt1Wx53v7AnIsjZG4FcCDAeLALY
	VDWVONivG9Fo53ha6/7igFHAfJW4p4a5NzJ33bPjokaM4cQG/vr1FtXXPrKZ8dlt
	C1nTBMgYV/1IpEw1PNSdbHf4VmvzuAp0kkvRIIVr0xYt97EJLIHOsUWnR4ONGCA9
	NxAV0mwBVT9P1FqzfbDBGbxY5DWWX1ajLtlzZNwr+zQsXA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id mC5Q7FigczLP; Mon, 27 Jul 2026 17:34:05 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4h85LM5GjVzlfvq8;
	Mon, 27 Jul 2026 17:34:03 +0000 (UTC)
Message-ID: <aeba0acb-5646-471c-acea-979cf93f1640@acm.org>
Date: Mon, 27 Jul 2026 10:34:02 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] RDMA/srpt: fix NULL deref when sending BUSY before
 target_init_cmd()
To: Leon Romanovsky <leon@kernel.org>, kensanya <kensanya@163.com>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org,
 linux-kernel@vger.kernel.org, TanZheng <tanzheng@kylinos.cn>
References: <20260723024456.52851-1-kensanya@163.com>
 <20260723095120.GF110966@unreal>
 <56479481.2552.19f920118cd.Coremail.kensanya@163.com>
 <20260726075511.GC12003@unreal>
 <71e36b0d.4e93.19fa24c787d.Coremail.kensanya@163.com>
 <20260727090046.GJ12003@unreal>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260727090046.GJ12003@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/27/26 2:00 AM, Leon Romanovsky wrote:
> Say it to your AI tool that it is not contradiction, but wrongly
> implemented Bart's suggestion.

+1
