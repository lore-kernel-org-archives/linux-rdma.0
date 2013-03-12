From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: v3.7: Unloading ib_ipoib triggers circular locking dependency
 complaint
Date: Tue, 12 Mar 2013 14:57:41 +0100
Message-ID: <513F3455.3030309@acm.org>
References: <50AF67C5.7090200@acm.org> <CAJZOPZJ55dqpOsnP-jbgXRrLZpyRzD2v8pg7pAAWMtWWr-m1FA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZJ55dqpOsnP-jbgXRrLZpyRzD2v8pg7pAAWMtWWr-m1FA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/26/12 09:00, Or Gerlitz wrote:
> On Fri, Nov 23, 2012 at 2:10 PM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
>> Apparently unloading the ib_ipoib kernel module triggers a circular locking
>> dependency complaint. Has anyone already been looking into this ?
>
> Yes, I see that this happens here e.g when doing hot-unplug to the
> underlying HW driver, seems related to the ipoib rtnl ops patches I
> pushed to 3.7 -- will look into this, thanks for bringing this up.
> Does anyone has an idea where the "s_active" lock is defined and what
> is its role?

(replying to an e-mail from a few months ago)

I still see this with kernel 3.8.0. This warning probably means that 
sysfs_remove_dir() is invoked with the rtnl lock held. If so I think 
that this can trigger a deadlock during module removal.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
