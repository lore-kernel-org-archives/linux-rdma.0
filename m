From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-4.3] IB/ipoib: add module option for auto-creating
 mcast groups
Date: Wed, 16 Sep 2015 11:03:23 -0600
Message-ID: <20150916170323.GB27294@obsidianresearch.com>
References: <980e8b0a82042d7e5801e02bf16fe72a0bde6759.1441934465.git.dledford@redhat.com>
 <alpine.DEB.2.11.1509110920540.16357@east.gentwo.org>
 <20150911182115.GA546@obsidianresearch.com>
 <55F32E7A.3020105@redhat.com>
 <alpine.DEB.2.11.1509141200020.4192@east.gentwo.org>
 <55F86255.9080508@redhat.com>
 <20150915191159.GB24173@obsidianresearch.com>
 <55F988F1.8000508@redhat.com>
 <alpine.DEB.2.11.1509161058540.22035@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1509161058540.22035-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 16, 2015 at 10:59:50AM -0500, Christoph Lameter wrote:
> On Wed, 16 Sep 2015, Doug Ledford wrote:
> 
> > > Abusing it for send-side is probably the wrong
> > > direction overall.
> >
> > I wouldn't "abuse" it for such, I would suggest adding a proper notion
> > of send-only registrations.
> 
> That is really not necessary for IP traffic. There is no need to track
> these since multicast can be send without subscriptions. So I guess that
> there will not be much support on netdev for such an approach.

InfiniBand is not unique here, eg, long ago proposals for IPoATM had
the same problem. Not sure if there is any other more current networks
that work this way..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
