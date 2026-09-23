Received: from mta1.migadu.com (out-43.mta1.migadu.com [95.215.58.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5F44ACC60
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 11:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790163477; cv=none; b=RLOmwK1odw9c8kGE3iI1Z4UC1g74qcnZs+PBCJ+Sb82s5QE4pWkma+nwMhIKMpwEZGrzZprok2o6dSe+anfQAfcz26UYZ8rC5lf7gPnoA4EPOemcmtUtZ69GHF1cN069R0YH7CkNrfs5CZ9mCEg9RfgNVk6e7tpmP3HGzWbyDAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790163477; c=relaxed/simple;
	bh=50wBOnOXusYI9cgpo8V/8VLTMtK51EIxGKYQc1l6qJA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O9Rj5oY5RsERTuCeie3lnvgqZr6s1iSCULY3L0qY9OEWbhcWnIhTvvsICROrFLiiMegPa4EpctMgZXfswaVmcqaKmzrwyEN9eQjCl0KMMIwfpTsfI5kLWvlV295c6Fo90biVtADBZ7/J2t16oqvx2Lilyy0wbch4SHmDAgoxSWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mNq3WpRL; arc=none smtp.client-ip=95.215.58.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mNq3WpRL"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=50wBOnOXusYI9cgpo8V/8VLTMtK51EIxGKYQc1l6qJA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790163458; v=1; x=1790768258;
 b=mNq3WpRLYt8myaTDuV4A+JLpnGPTdHTMt/MDXNy7bq2oGJsTpLpXRLB3WL2vp122y+m8ut9d
 hs6VmtlZeZOZbrhq+OOQHI9ibVJUad9i4LqpE87fo/DnxlW8X9FRhLbBBYzaDUcR86q0kO3MIsq
 ck7w0TefvSFyYaj7HTe1sYeE=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id cc9f7085222a17d5;
	Wed, 23 Sep 2026 11:37:38 +0000
X-Mizu-Trace-ID: cc9f7085222a17d5
X-Migadu-Flow: FLOW_OUT
Message-ID: <16b70ab0-bbb5-415a-ae1b-b68276f8046a@linux.dev>
Date: Wed, 23 Sep 2026 13:37:38 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] RDMA/siw: Fix qp use-after-free in siw_get_base_qp()
To: Leon Romanovsky <leon@kernel.org>, Wentao Liang <vulab@iscas.ac.cn>
Cc: jgg@ziepe.ca, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 stable@vger.kernel.org
References: <20260916184400.2093106-1-vulab@iscas.ac.cn>
 <179015250789.3394760.13528866578642274394.b4-ty@kernel.org>
From: Bernard Metzler <bernard.metzler@linux.dev>
In-Reply-To: <179015250789.3394760.13528866578642274394.b4-ty@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 23.09.2026 10:35, Leon Romanovsky wrote:
> 
> On Wed, 16 Sep 2026 18:44:00 +0000, Wentao Liang wrote:
>> The reference taken by siw_qp_id2obj() is dropped before the address
>> of the embedded ib_qp is taken from the QP.  If that reference was
>> the last one the QP is freed and the pointer returned to the iwarp
>> core is dangling; the core only pins the QP with iw_add_ref() after
>> the call has returned.
>>
>> Copy the pointer while the reference is still held.
>>
>> [...]
> 
> Applied, thanks!
> 
> [7/7] RDMA/siw: Fix qp use-after-free in siw_get_base_qp()
>        https://git.kernel.org/rdma/rdma/c/ef15197f81ffed
> 
> Best regards,
excellent, thanks.
