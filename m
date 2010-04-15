From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/4] opensm: added function that dumps PathRecords
Date: Thu, 15 Apr 2010 14:54:37 +0300
Message-ID: <4BC6FE7D.6040501@dev.mellanox.co.il>
References: <4BBDDA1E.7030102@dev.mellanox.co.il>
	<1271283366.4092.145.camel@sale659.sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1255"; format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1271283366.4092.145.camel-mgfCWIlwujvg4c9jKm7R2O1ftBKYq+Ku@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jim,

On 15/Apr/10 01:16, Jim Schutt wrote:
> Hi Yevgeny,
>
> On Thu, 2010-04-08 at 07:29 -0600, Yevgeny Kliteynik wrote:
>> Dumping SL, MTU and Rate for all the
>> non-switch-2-non-switch paths in the subnet.
>>
>> PRs that are dumped:
>>
>>    for every non-switch source port
>>        for every non-switch target LID in the subnet
>>            dump PR between source port and target LID
>>
>> This way number of sources is equal to number of physical
>> non-switch ports in the subnet, and only number of targets
>> depends on LMC that is used.
>>
>> Signed-off-by: Yevgeny Kliteynik<kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>> ---

[snip]
  
>> +		p_node = p_src_port->p_node;
>> +		if (p_node->node_info.node_type == IB_NODE_TYPE_SWITCH)
>> +			return;
>
> -			return;
> +			continue;
>
> Otherwise we stop dumping at the first switch we encounter?

Correct, thanks :)

-- Yevgeny

> -- Jim
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
