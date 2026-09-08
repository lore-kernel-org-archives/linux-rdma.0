Received: from mta1.migadu.com (out-103.mta1.migadu.com [95.215.58.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811BE1A680C
	for <linux-rdma@vger.kernel.org>; Tue,  8 Sep 2026 03:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.103
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788836891; cv=none; b=SwjBLLdOsEAfJ0OJcKdUoKFEv9dKCJ7QQUP8SAF8FTZed82+pZnWuE//GGXp6eW1vp/pYodjBVYl9tILIc0rt2df2V29yNDy/ec6T920A5BEhv5lFRD1I4qnODRb/1eWwSI/JRQjheZF3sSxhgNeNpeQj48LRAam16O/d/ysKXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788836891; c=relaxed/simple;
	bh=BmCauOLoaxAXfvUP8OS0W9ObbGWZblXO6KayfYFvswc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=qoPaBB0u4/A9iRS+1nJI/3Qrawog99it9TNNluq9tHRWVT2iM0B2oVZ6NVI40j36E0w4jZMhX7Rbx3yRODDkl1wc9AbHPx93JrvR8SeLy/wkgeAn8VAsavkpelxBxfEy35mJ0CryCO3zeVgUwF/VcQuf78HqiUnCB7QEw5sWuKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qeYISuiZ; arc=none smtp.client-ip=95.215.58.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qeYISuiZ"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=BmCauOLoaxAXfvUP8OS0W9ObbGWZblXO6KayfYFvswc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788836887; v=1; x=1789441687;
 b=qeYISuiZa04atPB64iE1hUqelkvdGMJV97UfF/5wrOEuJLErw2QlvVsHveke2M1qfOvuK8h9
 fdMnrCOn28s8xHmCOgd+ySvTHFmHSdYQoZxaKtOTDA0PISEjyinA3Omg3+4OPiK837ah1FrSjCs
 47Vt2uVorKUMSOdP6/El7QB0=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6f099c21813941e7;
	Tue, 08 Sep 2026 03:07:57 +0000
X-Mizu-Trace-ID: 6f099c21813941e7
X-Migadu-Flow: FLOW_OUT
Message-ID: <4bb04e58-7e69-46bc-9ecf-283605b18340@linux.dev>
Date: Mon, 7 Sep 2026 20:07:54 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/rxe: Use validated num_sge in local buffer
To: Nicolas Morey <nmorey@suse.com>, Zhu Yanjun <zyjzyj2000@gmail.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Tristan Madani <tristmd@gmail.com>,
 "open list:SOFT-ROCE DRIVER (rxe)" <linux-rdma@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
References: <20260907161550.716670-1-nmorey@suse.com>
 <27376486-9cab-4d42-8ed7-36e13231dd91@linux.dev>
 <681ae665-523a-441b-bbd8-dbae51ee64f1@suse.com>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <681ae665-523a-441b-bbd8-dbae51ee64f1@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2026/9/7 14:44, Nicolas Morey 写道:
> On 2026-09-07 23:20, Zhu Yanjun wrote:
>> 在 2026/9/7 9:15, Nicolas Morey 写道:
>>> For both SRQ and non-SRQ receive paths, the WQE is copied into a local
>>> buffer to provide a kernel-owned, validated copy. While calculating the
>>> memcpy size from the validated num_sge prevents overflow during the
>>> copy, memcpy() itself still copies num_sge from shared memory.
>>>
>>> A concurrent userspace modification before or during memcpy() leaves
>>> an unvalidated num_sge in the local buffer, leading to potential
>>> out-of-bounds reads in rxe_resp_check_length() and copy_data().
>>>
>>
>> Hi Nicolas,
>>
>> Thanks for the patch. The logic makes total sense to prevent the TOCTOU race condition after memcpy.
>>
>> Just out of curiosity, do you happen to have a reproducer or a POC script that demonstrates this race in practice?
>>
>> It would be great to know if this can be reliably reproduced or integrated into testing setups (like rdma-core tests, or tools/testing/selftests/rdma) to catch similar double-read issues in the future.
>>
> 
> No reproducer or PoC sadly. I haven't tried to make one though.
> This got caught by one of our AI tools when checking the backport of CVE-2026-74377.

Hi, Nicolas

Thanks for sharing this. Could you clarify whether your AI tool detected 
this purely through static analysis (and provided a suggested fix), or 
if it actually triggered a runtime bug with a backtrace/calltrace?

If you have a calltrace, please share it—that would help a lot in 
understanding the issue. Also, if this was flagged and fixed by a 
specific AI tool, adding an Assisted-by: tag (or referencing the tool in 
the commit description) would be appropriate.

Thanks,

Zhu Yanjun

> 
> I assumed from the 2 existing fixes (ending up as CVEs) that this could happened.
> 
> Nicolas

