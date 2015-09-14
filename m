From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-4.3] IB/ipoib: add module option for auto-creating
 mcast groups
Date: Mon, 14 Sep 2015 12:03:57 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1509141200020.4192@east.gentwo.org>
References: <980e8b0a82042d7e5801e02bf16fe72a0bde6759.1441934465.git.dledford@redhat.com> <alpine.DEB.2.11.1509110920540.16357@east.gentwo.org> <20150911182115.GA546@obsidianresearch.com> <55F32E7A.3020105@redhat.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55F32E7A.3020105-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 11 Sep 2015, Doug Ledford wrote:

> > At a minimum, when the socket that did the send closes the send-only
> > could be de-refed..
>
> If we kept a ref count, but we don't.  Tracking this is not a small change.

We could call ip_mc_join_group() from ipoib_mcast_send() which would join
it at the socket layer. That layer would do the tracking for us and leave the
group when the process terminates. The join would be visible the same way
as if one would have done an explicit setsockopt().

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
