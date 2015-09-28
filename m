From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] Expire sendonly joins (was Re: [PATCH rdma-rc 0/2] Add
 mechanism for ipoib neigh state change notifications)
Date: Mon, 28 Sep 2015 11:10:07 -0600
Message-ID: <20150928171007.GE12415@obsidianresearch.com>
References: <alpine.DEB.2.11.1509170940270.2052@east.gentwo.org>
 <CAJ3xEMg-h+J=cr2ddWvYUGU=MOBk4Aw-KtkeJutATH0Y17dnjg@mail.gmail.com>
 <alpine.DEB.2.20.1509241158420.21198@east.gentwo.org>
 <CAJ3xEMg2qQ3CXrfTrg=gUX2tQRuPnpxA-8PC98GzoF5iz=j5PQ@mail.gmail.com>
 <alpine.DEB.2.20.1509251140200.31792@east.gentwo.org>
 <CAJ3xEMj9kGaM6s+AqBQ_-ZTB_+cgDk3kefhq_O0V3PM120O9yQ@mail.gmail.com>
 <alpine.DEB.2.20.1509271136570.14486@east.gentwo.org>
 <5608282F.1020507@redhat.com>
 <alpine.DEB.2.20.1509272120090.18678@east.gentwo.org>
 <56095E6B.60509@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56095E6B.60509-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 28, 2015 at 11:36:11AM -0400, Doug Ledford wrote:

> > Also broadcast could cause a unecessary reception event on the NICs of
> > machines that have no interest in this traffic.
> 
> This is true.  However, I'm trying to balance between several competing
> issues.  You also stated the revamped multicast code was adding latency
> and dropped packets into the problem space.  Sending over the broadcast
> would help with latency.  However, I have an alternative idea for that...

I think your original idea of broadcast immediately and deferred
optimal mlid lookup is the best *functionally* for every case - only
when you enter the very edge world of caring about timing does it make
any difference.

Christoph's needs would probably be better served by giving some API
to control the mlid cache (ie the neightbour table is already 99% of
the way there). This would let some userspace component pre-load and
fix all relevant data and undesired cache activity simply can't add
jitter.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
