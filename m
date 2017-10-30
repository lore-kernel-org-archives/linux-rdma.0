From: idanb <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2/2] nvme-rdma: Add remote_invalidation module parameter
Date: Mon, 30 Oct 2017 10:45:12 +0200
Message-ID: <2f9723ae-93f4-aeec-22b0-31634d52b3aa@mellanox.com>
References: <1509295101-14081-1-git-send-email-idanb@mellanox.com>
 <1509295101-14081-3-git-send-email-idanb@mellanox.com>
 <4423f96f-bf42-3603-aa6a-fa259a1d09d1@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4423f96f-bf42-3603-aa6a-fa259a1d09d1-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 10/30/2017 10:11 AM, Sagi Grimberg wrote:
> Idan,
>
>> NVMe over Fabrics in its secure "register_always" mode
>> registers and invalidates the user buffer upon each IO.
>> The protocol enables the host to request the susbsystem
>> to use SEND WITH INVALIDATE operation while returning the
>> response capsule and invalidate the local key
>> (remote_invalidation).
>> In some HW implementations, the local network adapter may
>> perform better while using local invalidation operations.
>
> This is a device quirk and if you want to optimize for this
> you need to expose it via verbs interface. We won't add a module
> parameter for implementation specific stuff.

After our discussion yesterday I was thinking it may be better to hide
it within the nvme host driver while having a messages size threshold for
using send_with_invalidate. To make it device agnostic we will need
to come out with an idea of how to expose such limitation.

>
> Note that we currently need to rework the case where we use local
> invalidates and properly wait for them to complete.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
