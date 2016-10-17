From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 0/8] infiniband: Remove semaphores
Date: Mon, 17 Oct 2016 13:28:01 -0700
Message-ID: <8c560960-5498-57b5-6da6-218b71d9eef9@sandisk.com>
References: <1476721862-7070-1-git-send-email-binoy.jayan@linaro.org>
 <216461f1-3070-c93a-a560-7560a727cb8d@sandisk.com>
 <6244597.a6XMUIxjP0@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6244597.a6XMUIxjP0@wuerfel>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/17/2016 01:06 PM, Arnd Bergmann wrote:
> Using an open-coded semaphore as a replacement is probably just
> the last resort that we can consider once we are down to the
> last handful of users. I haven't looked at drivers/infiniband/
> yet for this, but I believe that drivers/acpi/ is a case for
> which I see no better alternative (the AML bytecode requires
> counting semaphore semantics).

Hello Arnd,

Thanks for the detailed reply. However, I doubt that removing and 
open-coding counting semaphores is the best alternative. Counting 
semaphores are a useful abstraction. I think open-coding counting 
semaphores everywhere counting semaphores are used would be a step back 
instead of a step forward.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
