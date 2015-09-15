From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-4.3] IB/ipoib: add module option for auto-creating
 mcast groups
Date: Tue, 15 Sep 2015 13:11:59 -0600
Message-ID: <20150915191159.GB24173@obsidianresearch.com>
References: <980e8b0a82042d7e5801e02bf16fe72a0bde6759.1441934465.git.dledford@redhat.com>
 <alpine.DEB.2.11.1509110920540.16357@east.gentwo.org>
 <20150911182115.GA546@obsidianresearch.com>
 <55F32E7A.3020105@redhat.com>
 <alpine.DEB.2.11.1509141200020.4192@east.gentwo.org>
 <55F86255.9080508@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55F86255.9080508-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 15, 2015 at 02:24:21PM -0400, Doug Ledford wrote:

> suggesting.  What's more, there are a few difficulties here in that I'm
> fairly certain the core networking layer doesn't have the concept of a
> send-only join, yet we would need it to have such.

The mcast list in the core is soley for listing subscriptions for
inbound - ie receive. Abusing it for send-side is probably the wrong
direction overall.

send-side addressing is always done with the neighbour table. If core
net infrastructure is to be done here it makes alot more sense to
store multicast IP's in the neighbour table and drive the join
lifetime from that side.

[mloop is not the same as IB send-only, IB send only means no receive
at all, from anyone]

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
