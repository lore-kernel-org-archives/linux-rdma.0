Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793177036;
	b=dgQt4BBO/ayrvZ56uQcXowGTMgFJbcsWIPjNb9+EKqbYbOQPjLSOquo8pBA5YxiX2aM5
	 vd51PgVY3jn2e8TsFTJdpFTup3Rfr6VHTxrQjeX8BmBc+ERM2PcxWboVDzbHlvFL3uyzN
	 YDCAEWO4VKOclqBcktInNcNNdQRRMtr5tXCwgZKBVTiNtaKy6vjkIavogvLBtLT8u9Ybb
	 bSLQJT3qm0cPtykFchUJD86uRGGkWBDiFNK/MXv4EQQ5pG8EZmu3DqTFGSTK8pJwqe1dG
	 cR0Z6jw4l7Pte/mq/+Y7cIx3bhlaHSfvOuFGvESTDAUVA9JuW1cupe6l5QAeGpt0u/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793177036;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=LMwbpJ5FecMxJ5P7RbpHp11xGjgqCgb5rSN6ahzVqzY=;
	b=mCCOXk8x2+IQWsILC8Npb/e2NWD2Eoj/4VfbaD+OMsi2Qp6fu2WOrWD3Jxh97acajdok
	 kwGnRPE+dhZdnWaajRbdSDnb/vnTJ2yMAQFptAlnisbLPD8+kLFWPi3yRGp3YCwVoraHw
	 7mxbk7FI0fgvt7VX9YuWF9UVxL6/WHHCoY2e8iYGHVGEmzNiRI9OCIxNXduatHPZcq2ER
	 mt0yYBcZlJMCDHF2n6eQ2/WEcapCOG6RWJtUqMjSknKSe2BntJRrimkF86eeFBt+VNiNq
	 C0FFVS/UfXtGMn1EW+ZxvZGChdcaXBqFu6poR+Yiev7081QTe0TfEDRbv2yHgsMjtuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e0FGFPFZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B976A606A31A;
	Wed, 28 Oct 2026 08:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e0FGFPFZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514F81F01825;
	Wed, 28 Oct 2026 08:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793177035;
	bh=LMwbpJ5FecMxJ5P7RbpHp11xGjgqCgb5rSN6ahzVqzY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=e0FGFPFZV0eKLLl32jk8I59lTEHQZEc8BJazgceNrvGoPpcwCu+4WvrvaSKgCd9WX
	 IzOyxh5oVJv8Nwhf5GAZZMKstLdzYZ32czuXW9YbIlsF03Nm3316wrUZvZlxWKb6du
	 1PI+nawkxeyHD3BszZ03n5XTcheeQMbGpQFJ5Fs1Kcei/oeJBiMO3407pEVCoFxfRp
	 w+UqDHQWXzrYlTaICvdhu1UyuH0FoWiPJyYnP7SA8hO6sA+LJGZky0dPGRW4/HJK6q
	 FsTNGORi3mzq4nTdwM7L+t0toa2Kn+9DsarvP71ZTDicaw2OfwnPj1BKd7c89OkoOU
	 Zl4DnismZRDgA==
Message-ID: <829c448d-e6e2-4874-a166-7624e87489ef@kernel.org>
Date: Wed, 28 Oct 2026 09:43:49 +0100
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
Subject: Re: [PATCH] RDMA/uverbs: Don't return the shared zero page from
 rdma_umap_fault()
To: Zi Yan <ziy@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>
Cc: linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261025-fix-rdma_umap_fault-zero-page-v1-1-186255624f1f@nvidia.com>
 <78802ed9-9cc6-41c4-b131-7c7d38f7ff39@kernel.org>
 <DMEVZ5MU1YA9.2X3HCCHNQOIA7@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <DMEVZ5MU1YA9.2X3HCCHNQOIA7@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

>>> +	/*
>>> +	 * VMAs that cannot become writable map the page as a raw pfn, like
>>> +	 * the device memory it replaces. The page lives as long as the file.
>>> +	 */
>>> +	if (!(vmf->vma->vm_flags & (VM_WRITE | VM_MAYWRITE))) {
>>> +		ret = vmf_insert_pfn(vmf->vma, vmf->address, page_to_pfn(page));
>>> +		goto out;
>>> +	}
>>> +
>>> +	/*
>>> +	 * This VMA is forced to always be shared so this doesn't have
>>> +	 * to worry about COW.
>>> +	 */
>>> +	vmf->page = page;
>>> +	get_page(page);
>>
>>
>> This split handling is pretty horrible TBH.
>>
>> In once case we take a reference in the other not?
>>
>> Why not perform a PFN mapping in any case?
> 
> For writable path, a new vmf_insert_pfn_mkwrite() is needed, so it was
> not fixed. I can fix that part as well.

We should do that; returning kernel allocations from this function in ->fault is
bad.

How urgent is this fix here? (can it actually be triggered?Specific hardware?)

> 
> The read-only zero page part might need more attention, since
> we just prevented vmf_insert_pfn_prot() from using zero_page. Do we want
> to add the support for rdma_umap_fault()?

We just have to make sure that we cannot install it writable etc. But that's not
a concern.

Just have to be careful :)

> 
>>
>> (Does GUP have to work on these things?)
> 
> These are VM_PFNMAP mappings, I guess not. But I am not a GUP expert.

So we installed folios with ->fault in VM_PFNMAP!?!?!?!

That doesn't sound right :)

-- 
Cheers,

David
