Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC87B312834;
	Mon, 14 Sep 2026 13:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789391662; cv=none; b=S2dGnkoA5e6zk1esdL6oN3DBkkIXAFYvm6DCJwLAn5svz+Yt+k+/qz3/UGSjcoo97c/EGnPXGU/q2w0HT3WdAdT/lMZLICP/d60/ABKaA3iV9cRSJjf8hgKXoxo0Ar3OCfRt8Mayvhg1Rt1+3uzG+TSDi52/ayHQHYMlt+9uG54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789391662; c=relaxed/simple;
	bh=mYcs92J9DTBm74Goued3d0RcL5er4m/vEw0yI9+k0FA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EqSSkE1rBlHylfOdhfcarxTv2Z/AiWBJkBUrptlPdZ7ILXJAS1nvMieIs3EY+0lRsFr8mauzGf8NbcnVWpiSQXThcHLwYuQJX+KzTuM8/RFhbez0ZxpSnIlDqEx1iYftI93DO2hd5DHsS/Yz9xC64Iyucq+sab/gx+0W2WEYTDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=iEhci++C; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="iEhci++C"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hk5Fx6jTdzlfvpT;
	Mon, 14 Sep 2026 13:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1789391651; x=1791983652; bh=mYcs92J9DTBm74Goued3d0Rc
	L5er4m/vEw0yI9+k0FA=; b=iEhci++CB0Fb3Ada6alhpkKsIf7cpciHeLAJyLCx
	NAq/uUhjDiXO8RARZ2PfKiYbFF7vZJ+vbA+WlRVZVJzu1ZAFrDZpFiuseWlpz/pf
	joqnXebvnbeUGBN9j64mjZB8+BwCsXEh9I+LMBSL0pBaGhupHOsO7ZR59GTxGfrx
	c1aMDJeRLtxxvI7nowvebJBB2dboZ7W+ErumlFfkwoM1eUsslJd2F0p2L7xSlBex
	hWjWRr2PKnv9eBseGPOjM+zS1gq2i0W5CaG8+xIoPXFvahuYv5j/ixiREOuP/30e
	DpGRaP22k2b6PnxGZyAruV4hXRHBhOpChB8wtxeHG8oCcw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id cLMuXz9-htTq; Mon, 14 Sep 2026 13:14:11 +0000 (UTC)
Received: from [192.168.0.215] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hk5Fs2F3zzlfvpG;
	Mon, 14 Sep 2026 13:14:08 +0000 (UTC)
Message-ID: <fd5c74c9-815a-4be8-a310-446a84e0b31f@acm.org>
Date: Mon, 14 Sep 2026 06:14:07 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/srpt: Fix srp_sq_size documentation
To: Serhat Kumral <serhatkumral1@gmail.com>
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org,
 target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260914130536.19769-1-serhatkumral1@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260914130536.19769-1-serhatkumral1@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/14/26 6:05 AM, Serhat Kumral wrote:
> Replace "Shared receive queue (SRQ)" with "Send queue".
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
