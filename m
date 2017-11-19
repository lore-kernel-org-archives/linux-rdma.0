From: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC rdma-core 1/5] verbs: Introduce thread domain and its
 related verbs
Date: Sun, 19 Nov 2017 08:43:16 +0200
Message-ID: <CAFgAxU_m=i9kG1h2Rbqe+YtVYpea8-Ez5qvm6dQU4tZPgOUqhA@mail.gmail.com>
References: <1510522903-6838-1-git-send-email-yishaih@mellanox.com>
 <1510522903-6838-2-git-send-email-yishaih@mellanox.com> <20171113195822.GD22610@ziepe.ca>
 <3719edfc-282a-db5b-2474-3cf1355fb301@dev.mellanox.co.il> <20171114191754.GI4263@ziepe.ca>
 <774e2f74-8361-6941-a015-27a2014d8cc9@dev.mellanox.co.il> <20171117184248.GN4276@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171117184248.GN4276-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Alex @ Mellanox" <Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 17, 2017 at 8:42 PM, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> wrote:
> On Wed, Nov 15, 2017 at 11:34:01AM +0200, Yishai Hadas wrote:
>
>> >>ibv_td should expose in verbs.h the 'context' as the inline function
>> >>ibv_alloc_td() needs it to get the verbs_context and call the driver
>> >>function if was set.
>> >
>> >You mean ibv_dealloc_td, OK..
>> >
>> >Related to my other point, ibv_alloc_td should probably accept a
>> >ibv_pd as an argument instead.
>> >
>>
>> Why ibv_alloc_td() should get an ibv_pd ? do you have a typo here ?
>
> No..
>
> Since ibv_alloc_td returns a 'ibv_pd' with additional information, it
> makes no sense to have an API that can return an 'ibv_pd' that is not
> actually a PD.

This new ibv_alloc_td() returns a ibv_td (Thread Domain), and it only
manages the Thread related information

The new ibv_alloc_parent_domain() returns a ibv_pd.
https://www.spinics.net/lists/linux-rdma/msg56891.html
The Parent Domain gets as input the protection domain (i.e. ibv_pd),
thread domain (i.e. ibv_td) and potential other domains in the future
(e.g. loopback).
Here you can claim you want to enforce that a parent domain 'ibv_pd'
will always include a protection domain 'ibv_pd', so that the struct
ibv_pd values are always valid. Just need to update the man page for
that.
Maybe that's the source of the confusion?

> So, all TD's have to be created from a PD, and the concept of a TD
> without a PD should be entirely removed from the API.

I can definitely see an application that wants to do something smart
with it's CQ's, like per thread or NUMA aware logic. While it has many
QPs' which it can't commit to any thread logic.
Here we'll force the user to provide some protection domain while
creating the CQ's with specific TD's. It doesn't have to be so.

Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
