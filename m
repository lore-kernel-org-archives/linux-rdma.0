Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9465E33F597;
	Fri,  5 Jun 2026 04:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780632213; cv=none; b=i2aedkCDP5Qz+TGfeynA+LEfTzfkG0vYg8WnxXm6NiBCbL+qgOZH7ALO4Za6jiPYW3zDh3tD7ZBcP2qvCzdEprVZROD22g9eebBMHCC8/Qlejo/MpTI3/MXGCOI9IjvJ+uldeUCAVb1W64L5mX3nEwLj/1xXn7EPcO0qiiX0W6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780632213; c=relaxed/simple;
	bh=OANjMFi4kP/bRhSbJ+1yiLW+pPy6GZpY3M5e8T+s8ss=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bMgJ4B2V0ZCG0JtNSbqLWJP3ALCNdKyoTYlWi2F/SFWBfSljnkb02NpkyPmnKVyJXMMy/brvafB7Tz7A+1VTHxx0eKAWekIzQlxf+aPCY8zHY3CAPeEw9eSLTY2IvXujKwKhMDFxvU3gswLqMLH7WSWAjD3vBJK/e0Jj+QA4qiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rvPgAkqq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rvPgAkqq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=prTptCr2IPlJWSLe3kQzyJTLbKMBWIJZlJtJ2pBygAI=; b=rvPgAkqqXZpJ7CtnBaKLfMc23l
	Ax7rKOBbEd6/Tx/rtxJxy1RZVV5rDkKEoFnUacNECKYaHgETtczkbsvneXoBCuooInCnS+5xiwjUm
	QGMYA3ra/3+PjBsx//sG9Fm8oa4ixhfb0iKekqZ2hE2UlKtsGyBPbGDV+vL1bGe3ZjxAvN6uqKfYg
	3JcZTf9HeeMcr+NE5yXxoBG6SFCBE241ipiKOXCokqb5KwmidsvZUKAQZ07u9Rg2GhMuaV3AtaJaE
	IDrwVdz9M8VERsb/tl3/ZpQD7vJsc68iRh2zBU35cnU92aBGiR7awHXKZy9QtawYzxsF7i5yKJshJ
	AoRhlLSQ==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wVLlj-000000003t6-2WQS;
	Fri, 05 Jun 2026 04:02:51 +0000
Message-ID: <fa19f1d2-832b-4b9c-824d-29ae48e4bc2a@infradead.org>
Date: Thu, 4 Jun 2026 21:02:50 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next V2 7/7] devlink: Add eswitch mode boot defaults
To: Mark Bloch <mbloch@nvidia.com>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Jiri Pirko <jiri@resnulli.us>, Simon Horman <horms@kernel.org>,
 Sunil Goutham <sgoutham@marvell.com>, Linu Cherian <lcherian@marvell.com>,
 Geetha sowjanya <gakula@marvell.com>, hariprasad <hkelam@marvell.com>,
 Subbaraya Sundeep <sbhatta@marvell.com>,
 Bharat Bhushan <bbhushan2@marvell.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
 "Borislav Petkov (AMD)" <bp@alien8.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Peter Zijlstra (Intel)" <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Petr Mladek <pmladek@suse.com>,
 Tejun Heo <tj@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Feng Tang <feng.tang@linux.alibaba.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Christian Brauner <brauner@kernel.org>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>, Kees Cook <kees@kernel.org>,
 Marco Elver <elver@google.com>, Eric Biggers <ebiggers@kernel.org>,
 Li RongQing <lirongqing@baidu.com>, "Paul E. McKenney" <paulmck@kernel.org>,
 Ethan Nelson-Moore <enelsonmoore@gmail.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org
References: <20260603193259.3412464-1-mbloch@nvidia.com>
 <20260603193259.3412464-8-mbloch@nvidia.com>
 <d276e842-dd8f-40b7-806b-71572503005e@infradead.org>
 <e4aada53-fb80-41a8-9a8e-d19414f6466b@nvidia.com>
 <909ada9a-a398-4e3f-8ed0-596a1e4bdbfd@infradead.org>
 <91d12ffd-6bd9-4951-8351-655262d44874@nvidia.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <91d12ffd-6bd9-4951-8351-655262d44874@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/4/26 2:49 AM, Mark Bloch wrote:
> 
> 
> On 04/06/2026 6:53, Randy Dunlap wrote:
>>
>>
>> On 6/3/26 6:16 PM, Mark Bloch wrote:
>>>
>>>
>>> On 03/06/2026 23:06, Randy Dunlap wrote:
>>>> Hi.
>>>>
>>>> On 6/3/26 12:32 PM, Mark Bloch wrote:
>>>>> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
>>>>> index 063c11ca33e5..7af9f2898d92 100644
>>>>> --- a/Documentation/admin-guide/kernel-parameters.txt
>>>>> +++ b/Documentation/admin-guide/kernel-parameters.txt
>>>>> @@ -1264,6 +1264,31 @@ Kernel parameters
>>>>>  	dell_smm_hwmon.fan_max=
>>>>>  			[HW] Maximum configurable fan speed.
>>>>>  
>>>>> +	devlink_eswitch_mode=
>>>>> +			[NET]
>>>>> +			Format:
>>>>> +			[<selector>]:<mode>
>>>>
>>>> It appears (please correct me if I am mistaken) that the '[' and ']'
>>>> above don't mean "optional" but instead they are required characters...
>>>>
>>>>> +
>>>>> +			<selector>:
>>>>> +			* | <handle>[,<handle>...]
>>>>
>>>> while here they mean "optional".
>>>>
>>>> That is confusing (inconsistent). Also, if the square brackets are
>>>> always required around the <selector>, what purpose do they serve?
>>>
>>> Yes, you are right, this is confusing. The outer square brackets are part of
>>> the syntax and are required, while the brackets in "[,<handle>...]" mean that
>>> additional handles are optional.
>>>
>>> I couldn't find a better way to describe this. What I want to say is that the
>>> selector is always wrapped in square brackets. Inside the brackets it can either
>>> be "*" to match all devices, or a comma separated list of handles. If "*" is
>>> not used, then at least one handle has to be provided.
>>>
>>> Maybe it would be clearer to spell it out explicitly, something like:
>>>
>>> Format:
>>>   [<selector>]:<mode>
>>>
>>> The '[' and ']' characters are literal and required.
>>>
>>> <selector>:
>>>   * | <handle>[,<handle>...]
>>>
>>> If '*' is not used, <selector> must contain at least one <handle>.
>>>
>>> Does that sound like a reasonable way to document it?
>>
>> Yes, that helps a little bit. Better than nothing.
>>
>> But why are they required at all?
> 
> Jiri suggested using the square brackets, and I liked that they made the
> selector look like a grouped argument. But if that is too confusing, I can
> also drop them and use a simpler separator, for example:
> 
> 	devlink_eswitch_mode=
> 			[NET]
> 			Format:
> 			<selector>=<mode>
> 
> 			<selector>:
> 			* | <handle>[,<handle>...]
> 
> 			<handle>:
> 			<bus-name>/<dev-name>
> 
> 			Configure default devlink eswitch mode for matching
> 			devlink instances during device initialization.
> 
> 			<mode>:
> 			legacy | switchdev | switchdev_inactive
> 
> 			Examples:
> 			devlink_eswitch_mode=*=switchdev
> 			devlink_eswitch_mode=pci/0000:08:00.0=switchdev
> 			devlink_eswitch_mode=pci/0000:08:00.0,pci/0000:09:00.1=switchdev_inactive
> 
> Does this look better to you?

Yes, that looks much better to me.
But you should do whatever you think is right.

>>>>> +
>>>>> +			<handle>:
>>>>> +			<bus-name>/<dev-name>
>>>>> +
>>>>> +			Configure default devlink eswitch mode for matching
>>>>> +			devlink instances during device initialization.
>>>>> +
>>>>> +			<mode>:
>>>>> +			legacy | switchdev | switchdev_inactive
>>>>> +
>>>>> +			Examples:
>>>>> +			devlink_eswitch_mode=[*]:switchdev
>>>>> +			devlink_eswitch_mode=[pci/0000:08:00.0]:switchdev
>>>>> +			devlink_eswitch_mode=[pci/0000:08:00.0,pci/0000:09:00.1]:legacy
>>>>> +
>>>>> +			See Documentation/networking/devlink/devlink-defaults.rst
>>>>> +			for the full syntax.
>>>>> +
>>>>>  	dfltcc=		[HW,S390]
>>>>>  			Format: { on | off | def_only | inf_only | always }
>>>>>  			on:       s390 zlib hardware support for compression on
>>>>
>>>>
>>>
>>
> 

-- 
~Randy

