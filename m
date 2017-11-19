From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH RFC rdma-core 1/5] verbs: Introduce thread domain and its
 related verbs
Date: Sun, 19 Nov 2017 08:32:19 -0700
Message-ID: <20171119153219.GZ4276@ziepe.ca>
References: <1510522903-6838-1-git-send-email-yishaih@mellanox.com>
 <1510522903-6838-2-git-send-email-yishaih@mellanox.com>
 <20171113195822.GD22610@ziepe.ca>
 <3719edfc-282a-db5b-2474-3cf1355fb301@dev.mellanox.co.il>
 <20171114191754.GI4263@ziepe.ca>
 <774e2f74-8361-6941-a015-27a2014d8cc9@dev.mellanox.co.il>
 <20171117184248.GN4276@ziepe.ca>
 <CAFgAxU_m=i9kG1h2Rbqe+YtVYpea8-Ez5qvm6dQU4tZPgOUqhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFgAxU_m=i9kG1h2Rbqe+YtVYpea8-Ez5qvm6dQU4tZPgOUqhA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Alex @ Mellanox" <Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 19, 2017 at 08:43:16AM +0200, Alex Rosenbaum wrote:

> This new ibv_alloc_td() returns a ibv_td (Thread Domain), and it only
> manages the Thread related information

Yes, sorry, my bad. I didn't read this carefully, you are right, it is
this the API I was thinking about:

> The new ibv_alloc_parent_domain() returns a ibv_pd.
> https://www.spinics.net/lists/linux-rdma/msg56891.html

So I'd like to see:

  struct ibv_parent_domain_init_attr {
-         struct ibv_pd *pd; /* referance to a protection domain, or NULL */
+         struct ibv_pd *pd; /* referance to a protection domain, can not be NULL */

> > So, all TD's have to be created from a PD, and the concept of a TD
> > without a PD should be entirely removed from the API.
> 
> I can definitely see an application that wants to do something smart
> with it's CQ's, like per thread or NUMA aware logic. While it has many
> QPs' which it can't commit to any thread logic.
> Here we'll force the user to provide some protection domain while
> creating the CQ's with specific TD's. It doesn't have to be so.

When we revise the CQ api it can directly accept a TD object, so there
is no need for it to use the 'parent domain' version of the PD.

And even if we did use the PD for consistency, it doesn't hurt at all
to pass in a PD&TD to the CQ object and then have the CQ ignore the
PD portion.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
