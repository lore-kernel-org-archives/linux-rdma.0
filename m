Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B4457ED8A;
	Wed,  9 Sep 2026 16:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788970588; cv=none; b=iC4IXsQlrWIlCjQlCUv8YXwoo0z1bGNRMJiqG/EifoFE2ipm566lsjfXVuig0uXZIT7/XeOZPNl56a3kqajmV9/QM2oADpjN2so9wpJjm6GTd+tzquLng5gvXSmwAfQh4x8Q3sv4EaYThqlQcLMoh8qwpqodeaK6kzoVfKlnNms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788970588; c=relaxed/simple;
	bh=PPuQnrD+MLnw8GXlfvojoc6oGDlhlW8D5EUjqOEEnmc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dnZOCN+eIkUQ7f6hl8pc9eAGdoJb+YC0dL2zRcGZTfqv2dIR4idg4KyDDCS1bZhb0rxGQ4lna6zZ+y9DKDDIkH21lv1jx7nDEruA6Of1G/O6Ji0hAAMDLpfiyzaUADM130BUVjJld2o5OyPoHp/t75MXgIEbL6DLx8wTTdLgfPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=mvlz73eI; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="mvlz73eI"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hg5XS5rHdzlfvpK;
	Wed,  9 Sep 2026 16:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1788970581; x=1791562582; bh=/uDJktCmC9hhwnIl5iUACX30
	+vBf0uQ3TiawRNWqX9c=; b=mvlz73eIE75MIJ7ZJN1/KLfZK/JmEPL8amSfn7Jb
	zrerfbR8TGKU2+cM29hWOa2OltRkLpAmy23QgF7tPNbqOB5ya4MEobGt1q2J0lg4
	PQiikLjXk0q0vrNTGiknFmaaEaDKeEUNmuBoY36zl36JWbZxRz/DKqNZQiR2U4E4
	wDn62Vn5EzUfok+rYBHMpJ2tOuiIIF3AgtHZ9bew7eNcE0lhA7KH7IUly6zkTNrb
	UVDl7Jy1STXc31sl7wDe/s5ODA8yQ5aYjz8C1l11xebis3awvdvaFewH+fP9vLLJ
	mSaWtpK/7m5jKd2IJol0emmA41GJJ6pkU6U5oBgkuxgczw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id iuQz8JIluDj3; Wed,  9 Sep 2026 16:16:21 +0000 (UTC)
Received: from [IPV6:2401:fa00:80d:9:bdb1:3a99:5373:a9ef] (unknown [104.133.214.195])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hg5XM18lWzlfvpG;
	Wed,  9 Sep 2026 16:16:18 +0000 (UTC)
Message-ID: <d9bb145e-025f-4adc-986c-f5a4ae017d7b@acm.org>
Date: Wed, 9 Sep 2026 09:16:17 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] RDMA/srpt: Clamp the CQ size request to max_cqe
To: Leon Romanovsky <leon@kernel.org>, Serhat Kumral <serhatkumral1@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Sagi Grimberg <sagi@grimberg.me>,
 linux-rdma@vger.kernel.org, target-devel@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260906161235.8563-1-serhatkumral1@gmail.com>
 <20260907063251.GE13683@unreal>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260907063251.GE13683@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/6/26 11:32 PM, Leon Romanovsky wrote:
> All these Sashiko reports suggest that sq_size is being changed in the wrong
> place. Can you check for the correct value in srpt_tpg_attrib_srp_sq_size_store()?
> 
> Bart, can we simply decrease MAX_SRPT_SRQ_SIZE by, say, 100?

Sure, that's fine with me.

Note: the default in the ib_srpt driver is not to use SRQ. SQR is only 
used if enabled explicitly via configfs. I'm not sure anyone is still
using the SRQ support in the ib_srpt driver.

Bart.
