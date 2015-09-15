From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-4.3] IB/ipoib: add module option for auto-creating
 mcast groups
Date: Tue, 15 Sep 2015 13:42:00 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1509151333420.14376@east.gentwo.org>
References: <980e8b0a82042d7e5801e02bf16fe72a0bde6759.1441934465.git.dledford@redhat.com> <alpine.DEB.2.11.1509110920540.16357@east.gentwo.org> <20150911182115.GA546@obsidianresearch.com> <55F32E7A.3020105@redhat.com> <alpine.DEB.2.11.1509141200020.4192@east.gentwo.org>
 <55F86255.9080508@redhat.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55F86255.9080508-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 15 Sep 2015, Doug Ledford wrote:

>
> I actually think this is a step in the right direction, but I think we
> are talking about a layering violation doing it the way you are
> suggesting.  What's more, there are a few difficulties here in that I'm

The function is used in various lower layer processing functions
throughout the network stack. As long as we still have a task context and
a socket accessible this should be fine.


> fairly certain the core
networking layer doesn't have the concept of a
> send-only join, yet we would need it to have such.  If we had three apps

The networking layer supports a setsockopt that can set IP_MULTICAST_LOOP
behavior. The the API is there to properly control this from user space
and thus its possible to join sendonly from user space. Actually we would
need that for the proper implementaiton of sendonly joins at the fabric
level I would think. I can work on making this work properly with the IP
stack.

> do send only sends, we would need to track all three of those sockets as
> being send only socket joins, and then if someone did a full join, we
> would need to automatically upgrade the join, and then if that app with
> the full join left, we would need to gracefully downgrade to send only
> again.  So, I think it would take work at the core level to get this
> right, but I think that's probably the right place to do the work.

Well the IP stack already has to deal with this. See mc_loop option in
the socket field as well as the sk_mc_loop() function in the network
stack.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
