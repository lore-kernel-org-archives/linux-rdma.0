Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449EC1B85F8;
	Thu, 30 Jul 2026 18:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785436336; cv=none; b=QG+sQ5s75ZPbW6Go/5eNNNOUBjuMQanPHNZKGAjbvOYxWm1vXiIdutmmSeMPF9YGt2F1XsR1OVgItM73CNi2vKmLvilY0cjXN63sVy5+1KXDNo4kg0jFAT/jRZOgHPD66cqw0g2JOiAZg0h6t2pAOfnvhayvesxQZuNffgl5zpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785436336; c=relaxed/simple;
	bh=vezDLYvtI9/zVD4pIrPyb1JXdSD8LDyulOSBDApMHvk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EcdxtoRE9MYWXcXhuPXRGfkawOSBH/CEzSgHzx+qv3JGt4xMZUJIqknZkupU2e8U205OT18nWIU/vPe8CF0ni5sKm3P9mjGmoZlvb5QuxrItLkQPY2thB1BxAFcdTvZx50+XrDtf/GBogAWaDQlMExqYRYBGt3hnFzCvpAQe1IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=v8xt4c87; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="v8xt4c87"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4h9yV652fVzlfvpx;
	Thu, 30 Jul 2026 18:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1785436331; x=1788028332; bh=vezDLYvtI9/zVD4pIrPyb1JX
	dSD8LDyulOSBDApMHvk=; b=v8xt4c8726uhd3pLmmiyOmZKCeMA4eToewXay7WF
	M+gGi6TRAXikObM+ttSTvwcToLUt4YTOnlpLpyrw03PzNshJQu9TsOUBHkT9rR4v
	ttIqh8mXQNojsC0dimFLHKBP4HB4NMWqBW72vczFavJPMKnffS+hLdZiWE1TPs92
	+mwq8K4t5ubOjgCPraF4nSyKtYWqnA3Ff3b3NdRvUWYQfq5F6/RCNOxiNqR7HNbs
	7zQz6eQ0s+uZB+KgyoXQoWkbgUFPt194s72YLzrAC5yDtwch4SYY/0SEl8GbEXUV
	j03hSuPsEOnEPNjkOcI6iVV4jOW9QV//3I0RoxxixiW9kg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id d5mrIP5RJLdb; Thu, 30 Jul 2026 18:32:11 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4h9yV22YPmzlfvps;
	Thu, 30 Jul 2026 18:32:10 +0000 (UTC)
Message-ID: <dd8e93f3-2153-41de-8fa0-7dd81fdfc06a@acm.org>
Date: Thu, 30 Jul 2026 11:32:09 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/srp: fix heap information leak on a truncated
 SRP_CRED_REQ
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>, linux-rdma@vger.kernel.org
Cc: jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260729093203.1503201-1-yhlee@isslab.korea.ac.kr>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260729093203.1503201-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/29/26 2:32 AM, Yehyeong Lee wrote:
> Drop a request that is shorter than the structure being parsed, and
> check byte_len before the tsk_mgmt read.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

