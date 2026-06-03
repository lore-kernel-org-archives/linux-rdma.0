Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7C930276A;
	Wed,  3 Jun 2026 20:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780517226; cv=none; b=IQBhfvJVmNvxkZmtrjfuAFTzYSeRzAMsmI8M4RwVYceRMZK7/l1fBoG9/bh+6f20vUHcae4xLkSi9cOhZT+yrqavihzXv5cRvEPmwRs6o/pycN9gGOFYvx82ZJ8MrZC02PlHlWwvKeiZfc6CPejVfNMyBIPVhI9rsrliyzZnbbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780517226; c=relaxed/simple;
	bh=BA9H6R3Q8M9olF9mGy953/1qfBeeiH1fA14XcTcB7n0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nMGWSuXC/2MnNKAXmU/kwBDMSB0HoxQyYhXYRMIOrxIgya2QPRHnkYrDXP94HGN/lZxey37to1pIRAckBHXZsFCQgvjyPP2qoSgURv969hton2FnTcJS5kZBpWARnY7wstDtsLO2m+0YGYXo6qhEIsJS9KbD57DWJjFRNz1cbss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QiaPGPh3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QiaPGPh3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=1+dWje48khfViclGaERQCi/Gh0wxudHWH/QCF3kZqJw=; b=QiaPGPh3pMGAkZngFffySC7HGP
	2qLjppS0arPQUFZx+kkx8ahTJa/4Fowj2hWCpElZOIL5uCsUp0pjN+P7GwWuR0KB47yC9tu7568iW
	EppUWFzcIA4pdBx4BvyM6mLQZGX6nP13YQrGRq7ar3a+fObk+kDX22iYQPlyl7WzFoKjiuOQi0TUL
	yJf4zsC6L8XHmkFEGt50bcRZ6KjAWobEGLcCgH7JyxC10TUv7OhWl1QGT6sngdHqZbc9yFGDROvOl
	31B510tKcJ7BWSf/iiGttgsy4bhxfpGDeVHQSfMAekHpFQdna69xAL3rNFpJ/6NuDt84jKVlCMDYC
	+cg0O5Sw==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wUrr2-0000000Fn3z-41XE;
	Wed, 03 Jun 2026 20:06:21 +0000
Message-ID: <d276e842-dd8f-40b7-806b-71572503005e@infradead.org>
Date: Wed, 3 Jun 2026 13:06:18 -0700
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
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260603193259.3412464-8-mbloch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi.

On 6/3/26 12:32 PM, Mark Bloch wrote:
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 063c11ca33e5..7af9f2898d92 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -1264,6 +1264,31 @@ Kernel parameters
>  	dell_smm_hwmon.fan_max=
>  			[HW] Maximum configurable fan speed.
>  
> +	devlink_eswitch_mode=
> +			[NET]
> +			Format:
> +			[<selector>]:<mode>

It appears (please correct me if I am mistaken) that the '[' and ']'
above don't mean "optional" but instead they are required characters...

> +
> +			<selector>:
> +			* | <handle>[,<handle>...]

while here they mean "optional".

That is confusing (inconsistent). Also, if the square brackets are
always required around the <selector>, what purpose do they serve?

> +
> +			<handle>:
> +			<bus-name>/<dev-name>
> +
> +			Configure default devlink eswitch mode for matching
> +			devlink instances during device initialization.
> +
> +			<mode>:
> +			legacy | switchdev | switchdev_inactive
> +
> +			Examples:
> +			devlink_eswitch_mode=[*]:switchdev
> +			devlink_eswitch_mode=[pci/0000:08:00.0]:switchdev
> +			devlink_eswitch_mode=[pci/0000:08:00.0,pci/0000:09:00.1]:legacy
> +
> +			See Documentation/networking/devlink/devlink-defaults.rst
> +			for the full syntax.
> +
>  	dfltcc=		[HW,S390]
>  			Format: { on | off | def_only | inf_only | always }
>  			on:       s390 zlib hardware support for compression on


-- 
~Randy

