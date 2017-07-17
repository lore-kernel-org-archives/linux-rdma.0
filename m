From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next V3 1/5] RDMA/netlink: Remove netlink clients
 infrastructure
Date: Mon, 17 Jul 2017 11:16:52 -0400
Message-ID: <df55a95f-03f7-9dd1-dcd3-7dc06910977b@intel.com>
References: <20170627050028.17902-1-leon@kernel.org>
 <20170627050028.17902-2-leon@kernel.org>
 <7285b9b9-360f-5157-1148-1554db2f4a2c@intel.com>
 <20170717145422.GH3259@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170717145422.GH3259-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/17/2017 10:54 AM, Leon Romanovsky wrote:
> On Mon, Jul 17, 2017 at 10:02:07AM -0400, Dennis Dalessandro wrote:
>> On 6/27/2017 1:00 AM, Leon Romanovsky wrote:
>>> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>
>>> RDMA netlink has complicated infrastructure to add and remove netlink
>>> clients to NETLINK_RDMA family. This complicates the code and not in
>>> use because not many clients are available (3 clients) and most of them
>>> (2 clients) are statically compiled together with netlink.c.
>>
>> So here you say there are three clients.
>>
>>> -	struct ibnl_client *cur;
>>> -	struct ibnl_client *nl_client;
>>> +	static const unsigned int max_num_ops[RDMA_NL_NUM_CLIENTS - 1] = {
>>> +				  RDMA_NL_RDMA_CM_NUM_OPS,
>>> +				  RDMA_NL_IWPM_NUM_OPS,
>>> +				  0,
>>> +				  RDMA_NL_LS_NUM_OPS,
>>> +				  0 };
>>>
>>> -	nl_client = kmalloc(sizeof *nl_client, GFP_KERNEL);
>>> -	if (!nl_client)
>>> -		return -ENOMEM;
>>> +	/*
>>> +	 * This BUILD_BUG_ON is intended to catch addition of new
>>> +	 * RDMA netlink protocol without updating the array above.
>>> +	 */
>>> +	BUILD_BUG_ON(RDMA_NL_NUM_CLIENTS != 6);
>>
>> Yet we are checking for 6? Can you elaborate here.
> 
> This check is needed to ensure that the array is properly initialized.
> 
> The clients were exposed in include/uapi/rdma/rdma_netlink.h, in the
> following enum:
> 
>    6 enum {
>    7         RDMA_NL_RDMA_CM = 1,
>    8         RDMA_NL_IWCM,
>    9         RDMA_NL_RSVD,
>   10         RDMA_NL_LS,     /* RDMA Local Services */
>   11         RDMA_NL_I40IW,
>   12         RDMA_NL_NUM_CLIENTS
>   13 };
> 
> First of all it starts from 1, second we have RDMA_NL_RSVD and
> RDMA_NL_NUM_CLIENTS which exposed, but are not real clients, because
> nothing is handled them
> 
> It leads for RDMA_NL_NUM_CLIENTS == 6 and this is why I'm checking for 6.
> 

Makes sense now.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
