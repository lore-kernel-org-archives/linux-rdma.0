From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/cma: use cached gids
Date: Tue, 10 Sep 2013 21:37:49 -0400
Message-ID: <522FC96D.3030206@redhat.com>
References: <681df2ae830b20b81fef0c57c41f3bbce5c8c1cc.1378676509.git.dledford@redhat.com> <CAG4TOxOTPPNdzpNmRkiwsjEcGEoVG1=H2e6YHddXFnAGXHFL6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG4TOxOTPPNdzpNmRkiwsjEcGEoVG1=H2e6YHddXFnAGXHFL6w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09/10/2013 09:17 PM, Roland Dreier wrote:
> On Sun, Sep 8, 2013 at 2:44 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>
>> -                                       ret = find_gid_port(cma_dev->device, &iboe_gid, port);
>> +                                       ret = ib_find_cached_gid(cma_dev->device, &iboe_gid, &found_port, NULL);
> 
> This type of change is kind of unfortunate -- I've been on a
> multi-year quest to get rid of the whole "ib...cached..." set of APIs,

So I was forewarned.

> since the part of the code that handles maintaining that cache is racy
> and hard to get the locking right with.  It would be better if we
> could declare that the device driver's query GID methods had to be
> fast (non-sleeping) and use them directly (and device drivers could
> maintain a cache if they need to, maybe with a library to help them).
> 
> But I guess that's a bigger project than fixing this immediate issue.

There are only two solutions to this that I can see:

1) Don't go to the card
2) Go to the card, but get the entire GID table in one operation (or at
most two if you need one to get the GID table length and then a second
to get the entire GID table in one go)

The current implementation goes to the card once to get the table
length, and then once for each table entry.  That's what's killing us.

Personally, I don't want it ever to go to the card for this sort of
operation.  We should be able to keep the card's idea of GIDs and our
idea of the same in sync.  Getting this right might be hard, but it's
still the right thing to do.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
