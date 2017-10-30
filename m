From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH 2/2] nvme-rdma: Add remote_invalidation module parameter
Date: Mon, 30 Oct 2017 10:11:54 +0200
Message-ID: <4423f96f-bf42-3603-aa6a-fa259a1d09d1@grimberg.me>
References: <1509295101-14081-1-git-send-email-idanb@mellanox.com>
 <1509295101-14081-3-git-send-email-idanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1509295101-14081-3-git-send-email-idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Idan,

> NVMe over Fabrics in its secure "register_always" mode
> registers and invalidates the user buffer upon each IO.
> The protocol enables the host to request the susbsystem
> to use SEND WITH INVALIDATE operation while returning the
> response capsule and invalidate the local key
> (remote_invalidation).
> In some HW implementations, the local network adapter may
> perform better while using local invalidation operations.

This is a device quirk and if you want to optimize for this
you need to expose it via verbs interface. We won't add a module
parameter for implementation specific stuff.

Note that we currently need to rework the case where we use local
invalidates and properly wait for them to complete.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
