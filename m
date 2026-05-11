Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DAC3A6F0E
	for <linux-rdma@vger.kernel.org>; Mon, 11 May 2026 08:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778486466; cv=none; b=HyH7Mc0xfwmFLIKnvd9bvWOs4hL3l98ryzbVegI4+IAhLbRlgoWy8J/Z0hQ6q4CsGRYpHhw16cdrBB3kGGu+AOTUEn9OURys41JfdJ5J+wBQx578PAwfFijBJPKWrCohxXIiFpCWigLoirAq0k5HMuU8QmyJeDdC5rIQl40mbio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778486466; c=relaxed/simple;
	bh=RRMCr4RBj+TR69vT9H5CJVjUWJ+4b0PdDD0czc7kMxc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gq7UIIouFhqZ6HJAtFG0tVElb/KMTd6zYG3QP3EUhLt7mB5dxJkD3N82+6ScKYY4O1DpR4pakzWhefyBqZP9gV+PdHonQPq4Z1KkkoozZ+9/KGLeWZvtdsOeJy2pHsIIvqkJakttpUA7lRf+C7/ynIsjTD0PpzW+unl7HpEZWHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QYs7KqZa; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QYs7KqZa"
Message-ID: <de0c4cb0-4abe-4b2a-986f-c502018d16f0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778486453;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K64yy1twB3BJTLAsfdctdNfrKw4nKiSQwPaKTV3owZM=;
	b=QYs7KqZafMY1j994hAusyFF0W9bTdTWUVIQ+oVAC8Ef6Aow4j/yhN//vl+IS61L305ifo4
	2SGCRuWDCk3YeI//YRNc/TcOBVCrLsfuxmJL9z6lhB5MAdEo2GUD+q/h6m34YKsuZc107g
	B1HLSXgba3pJEE34Bo1xQpJ6G14w9oQ=
Date: Mon, 11 May 2026 11:00:43 +0300
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH for-next 2/2] RDMA/efa: Add AH cache handling on create
 and destroy AH
To: Yonatan Nachum <ynachum@amazon.com>, jgg@nvidia.com, leon@kernel.org,
 linux-rdma@vger.kernel.org
Cc: mrgolin@amazon.com, sleybo@amazon.com, matua@amazon.com,
 Firas Jahjah <firasj@amazon.com>
References: <20260510083035.458081-1-ynachum@amazon.com>
 <20260510083035.458081-3-ynachum@amazon.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Gal Pressman <gal.pressman@linux.dev>
Content-Language: en-US
In-Reply-To: <20260510083035.458081-3-ynachum@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 10/05/2026 11:30, Yonatan Nachum wrote:
> +static struct efa_ah_cache_entry *efa_ah_cache_lookup(struct efa_ah_cache *ah_cache, u16 pd,
> +						      u8 *gid)
> +	__must_hold(&ah_cache->lock)
> +{
> +	struct efa_ah_cache_key key;

Consider memsetting key to zero.

The code is fine today, but if padding will be added to the struct by
the compiler in the future, you'll likely have lookup issues.

> +
> +	memcpy(key.gid, gid, sizeof(key.gid));
> +	key.pd = pd;
> +
> +	return rhashtable_lookup_fast(&ah_cache->hashtable, &key, ah_cache_params);
> +}
