From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/7] Add mlx5 direct verbs
Date: Thu, 2 Feb 2017 15:15:39 +0200
Message-ID: <3a26c94b-b61d-3e1b-8a63-4fece9d7d9c8@dev.mellanox.co.il>
References: <1485446182-5109-1-git-send-email-yishaih@mellanox.com>
 <782c31cb-e247-1094-955f-2766f9c66cbd@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <782c31cb-e247-1094-955f-2766f9c66cbd-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2/2/2017 10:52 AM, Sagi Grimberg wrote:
>
>> This patchset from Leon adds direct access to mlx5 devices.
>>
>> The libibverbs API is an abstract API. It is agnostic to any underlying
>> provider specific implementation. While this abstraction has the
>> advantage of
>> user applications portability it has a performance penalty. For some
>> applications optimizing performance is more important than portability.
>>
>> The mlx5 direct verbs API introduced in this patchset is intended for
>> such
>> applications. It exposes mlx5 specific low level data path
>> (send/receive/completion) operations, allowing the application to
>> bypass the
>> libibverbs data path API.
>
> Yishai and Leon this is good stuff !!

Thanks Sagi for pointing on, it's really appreciated.

> Couple of comments:
>
> - The user of this is pretty intimate with the driver, which makes a
>   somewhat strange combo of having both ibv_ and mlx5dv_ API. I
>   understand that it can inflate the the implementation, but perhaps
>   for completeness we can have also the control plane API as well (even
>   as a trampoline to the generic equivalent where it's useless).
>
>   The rational here is that extended features that needs allocation
>   flags can be contained to mlx5 and not pollute/inflate the generic
>   verbs implementation.

This series opens the door for optimizing the data path flows by 
exposing the internal driver stuff that is required in the general data 
path flow. It enables an application to optimize its own specific flow 
without considering the general case which involves branches that are 
not relevant to its use case.

Re control path:
Extending control path for driver specific configuration is really 
something that exists in our plans. It may be achieved by extending the 
above direct channel in a second phase with some extra APIs or by 
introducing some vendor channel mechanism to enable that on top of 
current control verbs. I believe that triggering that will be some 
feature request or a specific need that will come from the 
field/customers that will require this functionality.

> - This brings me to the next step of this. What is still missing is
>   how we allow the user to have more control and information about how
>   his db records (namely UARs) are allocated

Are you referring to some specific information that exists in mlx5 
driver which was not exposed by the direct API ? please have a look in 
dv.h for mlx5dv_init_obj and in mlx5 driver code and let us know if we 
missed something useful, we can add it.

Please consider that the above API was introduced with some extension 
mechanism (i.e. comp_mask) so that we can extend it in the future 
without breaking compatibility with applications that will use it.

>. How does the user know if he needs to protect the DB write?

Once an application uses the direct flow the locking scheme is fully 
managed by itself. We don't expect mixed flows in the data path for both 
direct/non-direct access by same application.

 > Is it BF?

This information is based on mlx5dv_qp->bf->size, in case of 0 it's not 
a BF. Please note that as part of V1 we plan to introduce a man page for 
mlx5 direct verbs which may point on that, in addition to other notes 
that I pointed on above.

>   How can the user ask for more UARs than originally allocated to it by the kernel?
>   The user of this can really use an API that allows more control
>   of this area.

This is some functionality that currently doesn't exist even in the 
*non* direct mode. It should be considered as some feature request 
regardless the above series. Please note that moving forward with this 
series and concept opens the door to give such an API which is some 
vendor specific more quickly and easily.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
