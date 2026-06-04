Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA1B36AF6;
	Thu,  4 Jun 2026 03:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780545215; cv=none; b=EBGr1VdxSIkpYdULwb6po/bKGLL7JvPMYLexL3OoYWSlMqk/8cxZJXcBbQkZZSEcMOy6jv9j/l8p+2WqLrNwh4QTL/losNtr3MhmX0pCgLlWVZhAZnlWL9gjAzZ4VegeRvnzGBfvVhS0+xj2sUkAVLB7n5PczpCc/CwFvk7vWuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780545215; c=relaxed/simple;
	bh=IbZDDiI4sTfVViCQqvDWqR5n0xj8Bma7tEQ4mXxqk+U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HXOkC95jUPfIDaIx6F3nSUsyGXcmZg+CR3Lng1k98XYmCM81/dtpYHFusr43V6cZV5FgkOWUfgCv6mj0TjR0yiA2sqz0qDhdpoIa9CPkRznPNVphbjzgvBXn1otg7r42/tmYJ2I1QNv2F9rSyiEDD/WPviKfNZq4l2bOP2+CivA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EFzE3fkC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EFzE3fkC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=Iec0mp4Rj6DxjXTpBzeIIYyiPjr/Gr+gA3QOICt7QLY=; b=EFzE3fkCvWzZTurHZYxYoyFRXZ
	jIWGeP+cEbt+zs2lr46uyaGr4yvCNptPMvuS0YdvFNFWrsxkezfvt7SiCxm9o9EcpSPwLMx67HpCd
	cTQuAnS9GYuHsFi5+TAYmiGeHXQp7cZ63xj5aeWSXGav1Pr26HcxP2a42asdqjHcZO6wOmCyeXpyn
	SjV0rpN62g3ZM19xsK8bHeC61GNmdQMbe9WoRhrfF+Uf4eYLr4CREqlzxYYDydP5x276pyf0r45DG
	S3m6e+nJWyjFIEU8Qia9yaT+lVHCw20KcveBSNw3VmYrCD5J/29cm9D6cyUCYvFHkzzvuoe7ZNVjI
	b4K2TiFQ==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wUz8g-0000000G7yt-3Wso;
	Thu, 04 Jun 2026 03:53:02 +0000
Message-ID: <909ada9a-a398-4e3f-8ed0-596a1e4bdbfd@infradead.org>
Date: Wed, 3 Jun 2026 20:53:00 -0700
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
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <e4aada53-fb80-41a8-9a8e-d19414f6466b@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/3/26 6:16 PM, Mark Bloch wrote:
> 
> 
> On 03/06/2026 23:06, Randy Dunlap wrote:
>> Hi.
>>
>> On 6/3/26 12:32 PM, Mark Bloch wrote:
>>> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
>>> index 063c11ca33e5..7af9f2898d92 100644
>>> --- a/Documentation/admin-guide/kernel-parameters.txt
>>> +++ b/Documentation/admin-guide/kernel-parameters.txt
>>> @@ -1264,6 +1264,31 @@ Kernel parameters
>>>  	dell_smm_hwmon.fan_max=
>>>  			[HW] Maximum configurable fan speed.
>>>  
>>> +	devlink_eswitch_mode=
>>> +			[NET]
>>> +			Format:
>>> +			[<selector>]:<mode>
>>
>> It appears (please correct me if I am mistaken) that the '[' and ']'
>> above don't mean "optional" but instead they are required characters...
>>
>>> +
>>> +			<selector>:
>>> +			* | <handle>[,<handle>...]
>>
>> while here they mean "optional".
>>
>> That is confusing (inconsistent). Also, if the square brackets are
>> always required around the <selector>, what purpose do they serve?
> 
> Yes, you are right, this is confusing. The outer square brackets are part of
> the syntax and are required, while the brackets in "[,<handle>...]" mean that
> additional handles are optional.
> 
> I couldn't find a better way to describe this. What I want to say is that the
> selector is always wrapped in square brackets. Inside the brackets it can either
> be "*" to match all devices, or a comma separated list of handles. If "*" is
> not used, then at least one handle has to be provided.
> 
> Maybe it would be clearer to spell it out explicitly, something like:
> 
> Format:
>   [<selector>]:<mode>
> 
> The '[' and ']' characters are literal and required.
> 
> <selector>:
>   * | <handle>[,<handle>...]
> 
> If '*' is not used, <selector> must contain at least one <handle>.
> 
> Does that sound like a reasonable way to document it?

Yes, that helps a little bit. Better than nothing.

But why are they required at all?

>>> +
>>> +			<handle>:
>>> +			<bus-name>/<dev-name>
>>> +
>>> +			Configure default devlink eswitch mode for matching
>>> +			devlink instances during device initialization.
>>> +
>>> +			<mode>:
>>> +			legacy | switchdev | switchdev_inactive
>>> +
>>> +			Examples:
>>> +			devlink_eswitch_mode=[*]:switchdev
>>> +			devlink_eswitch_mode=[pci/0000:08:00.0]:switchdev
>>> +			devlink_eswitch_mode=[pci/0000:08:00.0,pci/0000:09:00.1]:legacy
>>> +
>>> +			See Documentation/networking/devlink/devlink-defaults.rst
>>> +			for the full syntax.
>>> +
>>>  	dfltcc=		[HW,S390]
>>>  			Format: { on | off | def_only | inf_only | always }
>>>  			on:       s390 zlib hardware support for compression on
>>
>>
> 

-- 
~Randy

