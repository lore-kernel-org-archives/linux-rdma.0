From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-4.3] IB/ipoib: add module option for auto-creating
 mcast groups
Date: Tue, 15 Sep 2015 18:53:34 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1509151852530.15731@east.gentwo.org>
References: <980e8b0a82042d7e5801e02bf16fe72a0bde6759.1441934465.git.dledford@redhat.com> <alpine.DEB.2.11.1509110920540.16357@east.gentwo.org> <20150911182115.GA546@obsidianresearch.com> <55F32E7A.3020105@redhat.com> <alpine.DEB.2.11.1509141200020.4192@east.gentwo.org>
 <55F86255.9080508@redhat.com> <20150915191159.GB24173@obsidianresearch.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150915191159.GB24173-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 15 Sep 2015, Jason Gunthorpe wrote:

> The mcast list in the core is soley for listing subscriptions for
> inbound - ie receive. Abusing it for send-side is probably the wrong
> direction overall.

Ok then a simple approach would be to port timeout logic from
OFED-1.5.X.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
