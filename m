From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/cma: Fix a race condition in iboe_addr_get_sgid()
Date: Sun, 18 Dec 2016 09:10:59 +0200
Message-ID: <CAG9sBKPu=R7ZeRnFD+-8jpiyVDok_MogzSF3H7mpgVZGZ9jX0Q@mail.gmail.com>
References: <811914f1-3bcc-a0a4-e20a-86e8b5853ac7@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <811914f1-3bcc-a0a4-e20a-86e8b5853ac7-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 16, 2016 at 3:39 PM, Bart Van Assche
<bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hello Moni,
>
> Commit 7b85627b9f02 ("IB/cma: IBoE (RoCE) IP-based GID addressing") introduced code that
> dereferences an RCU pointer without using rcu_read_lock(). Can you check whether the patch
> below is the correct way to fix this?
>
> Thanks,
>
> Bart.

Hi Bart
Fix looks good. Thanks

Reviewed-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
