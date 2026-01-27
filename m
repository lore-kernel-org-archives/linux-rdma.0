Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7AC2D7DE9
	for <linux-rdma@vger.kernel.org>; Tue, 27 Jan 2026 22:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769554492; cv=none; b=u0qk1/cKXAO7KcdGprFWKFEifS+STk+2VlwyR1SgqKM4MZ30HDRHaFea0YAY4FFqM0zmSoKEMDugufeKjq+T13p9OVMvriTHfF7b5Ur0V80M35thgXFC1caaW5b3cCfJv29yzA8IvIt5S0D43ozpH42CRn1SnFCwz5Wlz2ejLDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769554492; c=relaxed/simple;
	bh=dRjEAIOD3vwwb+g58amczMp25XHVjlLmuSWKRLMMi4s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Sv9rSgksAux+bvYgZsU8aZPl9A5OkPV1pZLgebWdj7re452KAkk1Mp3Mu+K9ghyNqgR7BJEISAFm7jv8HKF9xgg1qvJfi+CACi2Oo7ljkIbj5EXzT7LGRdUFB8cKJJ2pvD+aCpdEPH+8xduDjv+DwYNCgfig0afZ9tpPQVLHaJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=S88eXmBE; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="S88eXmBE"
Message-ID: <f3402d0f-40a1-4792-a8e2-be65c71a176b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769554487;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VrRCEjBxGLG3qptlHBDYU9bJ3gKYsa+WLnudLXQJNws=;
	b=S88eXmBESekyn/oaMiePv8Obvxc14A9SjC1v8QIe8qILTE5/3L6vaOYa/UuTJuXTgOxdKq
	UJTKHbojND9ohoVHzuYmgntac1K4xIb1kWPrDL4zjXJctZ09DoOBiXk27pIgCOohh/lF2b
	Dk87u0Ph60rxYj6TUqAA65vbk+76inM=
Date: Tue, 27 Jan 2026 14:54:42 -0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] RDMA/core: Fix stale RoCE GIDs during netdev events at
 registration
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jiri Pirko <jiri@resnulli.us>, linux-rdma@vger.kernel.org,
 leon@kernel.org, msanalla@nvidia.com, maorg@nvidia.com, parav@nvidia.com,
 mbloch@nvidia.com, markzhang@nvidia.com, marco.crivellari@suse.com,
 roman.gushchin@linux.dev, wangliang74@huawei.com
References: <20260127093839.126291-1-jiri@resnulli.us>
 <21d63279-79a2-47aa-b305-30a55b8f40f4@I-love.SAKURA.ne.jp>
 <20260127160000.GG1641016@ziepe.ca>
 <05b40f3c-0d21-411a-b61a-156246482327@linux.dev>
 <9975b59a-58e2-4766-9e4e-c927a1d7a3d0@I-love.SAKURA.ne.jp>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yanjun.Zhu" <yanjun.zhu@linux.dev>
In-Reply-To: <9975b59a-58e2-4766-9e4e-c927a1d7a3d0@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT


On 1/27/26 2:16 PM, Tetsuo Handa wrote:
> On 2026/01/28 6:17, Yanjun.Zhu wrote:
>>> Can we feed it to syzkaller please and see if it does actually clear
>>> it's repo? That particular bug already has 5 patches claiming to fix
>>> it.
>>
>> #syz test: repository_link branch
>>
>> The above command will make syzkaller test your commit.
>>
>> BTW, your commit should be the topmost commit.
> No, we can't ask syzbot to test this patch.
>
> All kinds of refcounting errors that appear as
>
>    unregister_netdevice: waiting for $dev to become free. Usage count = $count
>
> problem are reported there, but syzbot has not found a reproducer for
> the bug this patch addresses.
>
> I can test this patch using linux-next tree via my tree if you like.

Thanks. Currently, syzbot does not have a reproducer to reproduce and 
verify this issue.

However, you have a test environment to reproduce the problem, and you 
can verify this commit.

Is that correct?

If so, that would be very helpful.


Zhu Yanjun

>
>>
>> Thanks,
>>
>> Zhu Yanjun
>>
>>> It has become some kind of catch all of all kinds of refcounting errors
>>>
>>> [  247.188486][ T6052] unregister_netdevice: waiting for vcan0 to become free. Usage count = 2
>>>
>>> Does this actually change the refcounting around that could fix that?
>>> Looked like no?
>>>
>>> Jason
