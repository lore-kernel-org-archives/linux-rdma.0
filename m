Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792938307;
	b=o76JKDCbPz3u352PORLIWHdQmChex3TZeJJ5tQ7/UEN/HT1v+P+Um0kUdhpWl4Yz+0al
	 ewwb7cFxAnf7FYApWQJ3B8cO9uq6aq7ACbDVqVAthLfxyd2xf4oRLaEebNHqZ4s1pzjzq
	 yajnUK74wyJZ+mX61wqGzR1GRwlmrLm22Yq5DTH+NdrOq5d9F8MQHxnYPweGIQF59hmEZ
	 TuWxQjwt4XRnP0AVwsg08KjbU+NZsSp3q8vduktdbDy3I47/sksWBueX/bL4D9XSjfIGc
	 sE3HydBgQsSGq+SNvPHTFPJLdQB4fkp/RUM8dnt1B3QxKJX0iebRzhe2JJCKMkzouNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792938307;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=XuARxIh9n2FAjunuV/K/iOjxz3fT6I3PzvZxFc4AZE4=;
	b=Wzb0FxQl6WZ92HYL7SU/1PvN6QtH37adghuX3YCiHq/BWObZCqy0ZOWRxjthTrY5YqW8
	 Nk2GWcJfKHXcjWIX86B0kXS0UyGuHVrms+5smpfIdj/BSm02l26yqjpXJMQme50qmg35J
	 s8LGA7VuJKxsii6WHdUz+0vQTYZic/zjP7fQ2vDjFKcGXUfRmpjgPVfyIZ4bBgs+NcIEP
	 i/k395Zor1oc8gCS+XUKTZeTerbhTz9f2Muq/TAdgb+4wFWEb+bt61nFE1qmngze9CgOb
	 W0rzaqAD9/PPzHRsyeGb6sSEeaeq5T9Qr1+alNmcqPw/QcoxWoLDxRYF0QibkXwoALg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=1Lg5NRpX;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21647606A31A;
	Sun, 25 Oct 2026 14:25:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 21647606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=1Lg5NRpX
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jCJtp402kz1XM30g;
	Sun, 25 Oct 2026 14:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792938304; x=1795530305; bh=XuARxIh9n2FAjunuV/K/iOjx
	z3fT6I3PzvZxFc4AZE4=; b=1Lg5NRpXXtRBUewIDVHYND13Fow6N6LY1DF+IJfB
	d7ND3Gshx0uCovUQMCJyxfWfZLmAyqXw1Gep4zMS7Zj5ebRgipUjzQ4j4V+QZSsd
	yX1DJwwK3R0+hs1UZ6Zf5F6nHNglEpDsLR4a/uRC0xuTE7PbmGoeYcxUifHxcVQN
	2WJ+b98BPRqVPM66nqKJ5TjdAeSAuJ1eBbXLlxxcqBCLb+QI3kBMS7x6kW4BB1wl
	dN9Trey4fAkBJWuye0gWbpUbByqzXEbRTHpROK+PQYIiJKvl811tT+ZlZEUVoS4D
	E7mn0lATOs/HijjaC/lK2sdB1NlLiS+sdfk7d13mRNWLkA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 45DdD3b_UuQn; Sun, 25 Oct 2026 14:25:04 +0000 (UTC)
Received: from [192.168.51.14] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jCJtl3gDhz1XM4Tl;
	Sun, 25 Oct 2026 14:25:03 +0000 (UTC)
Message-ID: <4ac46ea1-75a2-4608-a97e-2ea8bef3bb68@acm.org>
Date: Sun, 25 Oct 2026 07:25:02 -0700
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
Subject: Re: [PATCH v5 0/3] RDMA/srpt: fix the descriptor table checks and the
 context counters
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 linux-rdma@vger.kernel.org, target-devel@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261025013748.3755639-1-yhlee@isslab.korea.ac.kr>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261025013748.3755639-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/26 6:37 PM, Yehyeong Lee wrote:
> The first two patches bound initiator supplied descriptor data, and the
> third widens the counters that hold what the first one admits.
For the series:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
