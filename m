From: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/8] IPoIB: fix mcast_dev_flush/mcast_restart_task race
Date: Wed, 3 Sep 2014 12:45:44 -0700
Message-ID: <CABgxfbFGtBMTycvsH3xUCDD0xx03Tcz3PMO6EqP=8Q4u3rk6sQ@mail.gmail.com>
References: <cover.1407885724.git.dledford@redhat.com>
	<e1dbcfc25d8930b281aad12699ebf8fa82485b0e.1407885724.git.dledford@redhat.com>
	<CABgxfbHDuUrdHuLJT2oD07Cy3Ys4_rj-bJ6eR=9+uv0CuPH7_Q@mail.gmail.com>
	<CABgxfbGJOdmAn1sokEtisDdnA=r_4mfP=PfqZVsP0cd_oL50dA@mail.gmail.com>
	<1409767614.26762.7.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1409767614.26762.7.camel-v+aXH1h/sVwpzh8Nc7Vzg+562jBIR2Zt@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 3, 2014 at 11:06 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Sat, 2014-08-30 at 08:39 -0700, Wendy Cheng wrote:
>> On Fri, Aug 29, 2014 at 2:53 PM, Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> > On Tue, Aug 12, 2014 at 4:38 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> >> Our mcast_dev_flush routine and our mcast_restart_task can race against
>> >> each other.  In particular, they both hold the priv->lock while
>> >> manipulating the rbtree and while removing mcast entries from the
>> >> multicast_list and while adding entries to the remove_list, but they
>> >> also both drop their locks prior to doing the actual removes.  The
>> >> mcast_dev_flush routine is run entirely under the rtnl lock and so has
>> >> at least some locking.  The actual race condition is like this:
>> >>
>> >> Thread 1                                Thread 2
>> >> ifconfig ib0 up
>> >>   start multicast join for broadcast
>> >>   multicast join completes for broadcast
>> >>   start to add more multicast joins
>> >>     call mcast_restart_task to add new entries
>> >>                                         ifconfig ib0 down
>> >>                                           mcast_dev_flush
>> >>                                             mcast_leave(mcast A)
>> >>     mcast_leave(mcast A)
>> >>
>> >> As mcast_leave calls ib_sa_multicast_leave, and as member in
>> >> core/multicast.c is ref counted, we run into an unbalanced refcount
>> >> issue.  To avoid stomping on each others removes, take the rtnl lock
>> >> specifically when we are deleting the entries from the remove list.
>> >

[snip] ..

>> However, isn't that the remove_list a local list on the caller's stack
>> ? .. and  the original list entry moving (to remove_list) is protected
>> by the spin lock (priv->lock), it is unlikely that the
>> ib_sa_free_multicast() can operate on the same entry ?
>
> Yes, you're right.  I had it in my mind that the remove_list was part of
> the ipoib private dev, not local on the stack.  So you are right that we
> could probably get away with removing the rtnl lock there (although it
> would need to be in a later patch than the one you are reviewing
> here...here there would still be a race between the restart task and the
> downing of the interface because they all still share the same work
> queue, but once we switch to the per device work queues in patch #6,
> this can happen in parallel safely with the flush task I think).
>

Yep, that local "remove_list" is easy to miss.

BTW, you might want to modify the text description of this patch to
make your point clear.

-- Wendy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
