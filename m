Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8211C514759;
	Fri,  4 Sep 2026 17:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788544297; cv=none; b=m+4GhcAh26DPrNKSoqKspsDxOrQRS2H/Ex/YWPKD8Be5PQ1itWmaodNQ33lLDft2U2OiV/2cKU/K7Mea6EJMw2551Tto76AUoYJVq7mfeo7qTzEqGyXG7PNIkS9yrl/RzFlnfqieFabiBOxLMPIDfvD1e31rH0m2TygDnHOznxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788544297; c=relaxed/simple;
	bh=AGBNRvpUguuZmeBNwr/jzkPrDpvPWpvNCDX+BRfJums=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S/MNMga84WSVYT5p+gY8GGqLQlO+GWVCb3R7tAoq+g5wIQkh+wp70iqe1+3bSBH30MRVKbpkXCzwLGnhOz7eWEPlPJ8MTkYpDbzs7RSRlmyuBwzksZMEtGENkwbDLsarBV6KF2b5xrTX++FSJdjLHtypB1o/W+7AOz1ciBQ8coc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=RUwhu+WG; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="RUwhu+WG"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hc3tV6PtczlfvqM;
	Fri,  4 Sep 2026 17:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1788544288; x=1791136289; bh=3toRDUVP0KxxPCPMGUBOR5yF
	AhS1kbFkIltjOIzPAR8=; b=RUwhu+WGrCxWm2qprCiEoNqU7+YvKwT4jhfX5YXy
	L40wdi28E/FlfQZpbyox+r7JBHN0oZF/nGFnwZfkcrdk1r/l7yp9D01l9c7Z0tyC
	A+NY2kJ6mFmnIfxB7ejI3A0lmVt8sa/wRgk9m1SKCzt7MqTSQ17j/GBDhFKtFCB/
	Tb2gV8vCtYJqKuglKdkhbtJCdZD7wttVMRb0SOQ09fHEDRzSwpaCNHsq9xnzHgDO
	Ke6uv7agzJ+NFIwoJEPvXgh1BV/Vfq77PzY5F8OLZH3UFTZClUGqAoHdce1OmoTc
	k6Kmhuv+ttwJNf4SMYkZMaqGRXHsBkT1RG7/pIqwMGjRig==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 3r7wscqe2P2f; Fri,  4 Sep 2026 17:51:28 +0000 (UTC)
Received: from [IPV6:2607:fb91:ae5:2e6f:f1c:8bca:e326:bd26] (unknown [172.58.117.86])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hc3tR0WXqzlfvqC;
	Fri,  4 Sep 2026 17:51:26 +0000 (UTC)
Message-ID: <d1b08cdf-8ee1-45f8-95a7-be24dd9bbd16@acm.org>
Date: Fri, 4 Sep 2026 10:51:15 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (subset) [PATCH v2 0/2] RDMA/srp: fix use-after-free of a request
 in srp_destroy_qp()
To: Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org,
 Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: jgg@ziepe.ca, linux-kernel@vger.kernel.org
References: <20260818035229.505098-1-yhlee@isslab.korea.ac.kr>
 <178835394804.2431629.13448768133099421237.b4-ty@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <178835394804.2431629.13448768133099421237.b4-ty@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/2/26 5:59 AM, Leon Romanovsky wrote:
> Applied, thanks!
> 
> [2/2] RDMA/srp: Fix srp_remove_target()
>        https://git.kernel.org/rdma/rdma/c/9cdfad5dd5529e

Thanks Leon!

Bart.
