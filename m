From: Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 4/5] rds: Add runchecks.cfg for net/rds
Date: Mon, 18 Dec 2017 11:28:05 -0800
Message-ID: <b808c33b-e318-c7d2-80c6-319167d11e01@oracle.com>
References: <cover.630ac8faeeda67bf7a778c158174422042942d08.1513430008.git-series.knut.omang@oracle.com>
 <4dc9b2fc0ddd1eb91d9b8785ae4886c6b08f3ee5.1513430008.git-series.knut.omang@oracle.com>
 <20171216094525.5e9c985c@xeon-e3> <1513448673.4647.45.camel@perches.com>
 <499ec5ae-d1d5-3bb2-8e10-de48283a1c2e@oracle.com>
 <1513476136.31439.96.camel@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1513476136.31439.96.camel-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/16/2017 6:02 PM, Knut Omang wrote:
> On Sat, 2017-12-16 at 12:00 -0800, santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org wrote:
>> On 12/16/17 10:24 AM, Joe Perches wrote:

[...]
>>> Most of these existing messages from checkpatch should
>>> probably be inspected and corrected where possible to
>>> minimize the style differences between this subsystem
>>> and the rest of the kernel.
>>>
>>> For instance, here's a trivial patch to substitute
>>> pr_<level> for printks and a couple braces next to
>>> these substitutions.
>>>
>> Thanks Joe. I actually had a similar patch a while back but
>> since it was lot of churn, and code was already merged,
>> never submitted it and then later forgot about it.
>>
>> Will look into it.
> 
> Please look at my set here first - I have already spent considerable time cleaning up
> stuff while working on this:
> 

Just closing the loop. As discussed, I can use your patches without
any new tool dependency since existing checkpatch.pl already gives
those warnings. I started picking up Joes patch but since you have
changes, can use them instead once you untie them with runcheck.

Regarding the $subject, just re-iterating that I don't want any custom
script for RDS and want to just follow generic guidelines followed by
netdev for all net/* code.

Regards,
Santosh

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
