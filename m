Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BCCC39891D;
	Wed, 12 Aug 2026 20:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786566637; cv=none; b=fmQHReyDMa30I0J+wZ3Y2u0e90Xc5puLf0WmnFwasZNhkBKRbeMhnMFDDQ6xO0XyzouMzFwFruBoaX3tIQRLngr8YTbRqdtcemJertSIkdqpZsGtOU9KfHd3Ea0XBki0pfZNIdPSNBJU7AG5i3nZZm1Mzz1zqQNMKwoHYEvijoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786566637; c=relaxed/simple;
	bh=ya8lUrcUq0xwyeVi33naWdkV73eejL51gHxxXBh+mwQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jdRSRuV1m20I8w+7qtKydIfSqwcWo3RR2bzZj/abxBLPnTQ7v5M9KkESwhJoiKYyDdVYtK/tb8b4Z9B466zkj3uueCABVMg5Hi9WOCAU9yBm7ZyC6pCDxLY//a+yuTHeYYOZQRDf3ZHvkrSF/SD7b7UuHb4AQeSp5OvIR3PCNK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=HgvnZIQi; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="HgvnZIQi"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hL0Vf6ChNz1XM31H;
	Wed, 12 Aug 2026 20:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1786566632; x=1789158633; bh=ya8lUrcUq0xwyeVi33naWdkV
	73eejL51gHxxXBh+mwQ=; b=HgvnZIQiiCHYGxwEYaqW5rZK1c+IrzFhxm+md+/3
	d9nb+e4KDcgGatFkaNH7sFxIcN7vNXYmPcBKenrvXsX1FSXoCZPkruaYlK51T4Pz
	eJOn1B7C1rv80bjqxUOJ/wXXRBYguPcG470+pXv8hW+O6TuHRK1yHInU6TOb9Lef
	xu2skzhZ/fSQ+GNf3HgVsEksigo9RezFlf4nltPCSfvR9HHSfmLHzaJ4p22BNYOA
	a7Ucipd22JRAfIEQiNlDb9HeKKGJj25cSYiefog46qe2Fhog7LIgpLsuMptLaPBK
	4aZcY+evweNxxpsZxBc72S9V3hlnSL7WabYn6U2ON7ouyw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id C7E8VTsKW1N2; Wed, 12 Aug 2026 20:30:32 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hL0VZ6Bjfz1XM30g;
	Wed, 12 Aug 2026 20:30:30 +0000 (UTC)
Message-ID: <a97268c5-74db-4238-b0f2-6ddd4fa5c37d@acm.org>
Date: Wed, 12 Aug 2026 13:30:29 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/srp: fix use-after-free of a request in
 srp_destroy_qp()
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>, linux-rdma@vger.kernel.org
Cc: jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260812190418.200337-1-yhlee@isslab.korea.ac.kr>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260812190418.200337-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/12/26 12:04 PM, Yehyeong Lee wrote:
> Put the two completion
> contexts in the channel, which outlives the queue pair.

This change can cause ch->reg_cqe and ch->inv_cqe to be overwritten
before the previously submitted work has completed, isn't it? Isn't that
a bug?

Thanks,

Bart.
