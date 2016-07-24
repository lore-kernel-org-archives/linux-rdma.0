From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC ABI V2 8/8] RDMA/mlx5: Add mlx5 initial support of the new
 infrastructure
Date: Sun, 24 Jul 2016 09:18:21 +0300
Message-ID: <cc09ff03-86ae-7f4f-faca-a1402b24c1a7@mellanox.com>
References: <1468941812-32286-1-git-send-email-matanb@mellanox.com>
 <1468941812-32286-9-git-send-email-matanb@mellanox.com>
 <20160720173927.GH21460@obsidianresearch.com>
 <8ffd0f92-2564-cc39-10ab-5db287399e82@mellanox.com>
 <20160721164952.GE19849@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160721164952.GE19849-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 21/07/2016 19:49, Jason Gunthorpe wrote:
> On Thu, Jul 21, 2016 at 02:38:28PM +0300, Matan Barak wrote:
>> On 20/07/2016 20:39, Jason Gunthorpe wrote:
>>> On Tue, Jul 19, 2016 at 06:23:32PM +0300, Matan Barak wrote:
>>>> +DECLARE_UVERBS_TYPE(
>>>> +	mlx5_device,
>>>> +	UVERBS_CTX_ACTION(
>>>> +		DEVICE_ALLOC_CONTEXT, uverbs_get_context, NULL,
>>>> +		&uverbs_get_context_spec,
>>>> +		&UVERBS_ATTR_CHAIN_SPEC(
>>>> +			/*
>>>> +			 * Declared with size 0 as we current provide
>>>> +			 * backward compatibility (0 = variable size)
>>>> +			 */
>>>> +			UVERBS_ATTR_PTR_IN(ALLOC_UCONTEXT_IN, 0),
>>>> +			UVERBS_ATTR_PTR_OUT(ALLOC_UCONTEXT_OUT, 0),
>>>> +			),
>>>> +	),
>>>> +	UVERBS_ACTION(
>>>> +		DEVICE_QUERY, uverbs_query_device_handler, NULL,
>>>> +		&uverbs_query_device_spec,
>>>> +	),
>>>> +);
>>>
>>> The entire point of getting rid of the lists and changing the destruct
>>> ordering was to avoid the need to have this kind of stuff in the
>>> drivers.
>>>
>>> I really don't want to see driver changes to implement the basic
>>> API..
>>>
>>
>> You could declare entire types in a common space (and these two examples
>> qualify for common declarations). However, if one wants to add driver
>> specific arguments for  this command (besides some general arguments which
>> could be driver dependent), it needs to be in a driver specific files.
>>
>> I think this is a good trade-off between driver specific arguments, commands
>> and types while sharing common handlers and command descriptors.
>
> Are you going to fix and test every driver in the kernel?
>
> In the interests of sanity, I think you need to provide a
> straightforward way to retain the status-quo udata, at least as an
> interm step..
>
> I'm not excited to see things start here..

As an interm step, we use udata (see the actual example). By using that, 
these actions could be in a common place. However, IMHO since we 
declared this is a driver specific ABI where each driver could implement 
and use whatever attributes it wants and create new types and actions, I 
don't think we should differentiate between common attributes and driver 
specific attributes (as it's the driver which decides whats common and 
whats not).
Therefore, udata is great as an interm step avoiding changing 
everything, but as a last step it might be better to go with standard 
array of attributes.

>
> Jason
>

Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
