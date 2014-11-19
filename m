From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V1 for-next 1/2] IB/uverbs: Enable device removal when
 there are active user space applications
Date: Wed, 19 Nov 2014 10:05:30 +0200
Message-ID: <546C4F4A.1070004@mellanox.com>
References: <1416312682-7899-1-git-send-email-yishaih@mellanox.com>	<1416312682-7899-2-git-send-email-yishaih@mellanox.com>	<546B59E2.2050707@mellanox.com>	<546B72A1.2080403@dev.mellanox.co.il> <CAJ3xEMh5f-qZuYQ30frjUa0ETNxexh2igguxxRm-pVtERCwn-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMh5f-qZuYQ30frjUa0ETNxexh2igguxxRm-pVtERCwn-Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/18/2014 11:42 PM, Or Gerlitz wrote:
> On Tue, Nov 18, 2014 at 6:24 PM, Yishai Hadas<yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>
>> >The IB device pointer is not valid at all spots, for example after the HW
>> >Device was removed, that's why we set this information on the uverbs device.

In 2nd thought, they must be point @ time where it is valid, right? so 
you can query/cache the whole 32bit device caps on that minute and use  
it later.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
