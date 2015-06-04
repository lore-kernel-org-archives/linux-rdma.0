From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH for-next 09/10] IB/mlx4: Add timestamp_mask and hca_core_clock
 to query_device
Date: Wed, 3 Jun 2015 19:58:39 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1506031956240.11879@east.gentwo.org>
References: <CAJ3xEMh_g0zBza5HoVZTy9cTRbXqatzvBMAJcRjQhH7Zi=cHAg@mail.gmail.com> <20150527222108.GA7855@obsidianresearch.com> <5566BDE4.50709@mellanox.com> <alpine.DEB.2.11.1505280908001.16142@east.gentwo.org> <20150528162416.GA6515@obsidianresearch.com>
 <alpine.DEB.2.11.1505281212330.1711@east.gentwo.org> <20150528175043.GA10966@obsidianresearch.com> <alpine.DEB.2.11.1505281325150.1794@east.gentwo.org> <20150528195034.GA11182@obsidianresearch.com> <alpine.DEB.2.11.1505281522020.2703@east.gentwo.org>
 <20150528204749.GA12780@obsidianresearch.com> <alpine.DEB.2.11.1505290845040.8178@east.gentwo.org> <1432918170.114391.104.camel@redhat.com> <1828884A29C6694DAF28B7E6B8A82373A8FE2126@ORSMSX109.amr.corp.intel.com> <1432919688.114391.116.camel@redhat.com>
 <alpine.DEB.2.11.1506010635360.25165@east.gentwo.org> <1828884A29C6694DAF28B7E6B8A82373A8FE2688@ORSMSX109.amr.corp.intel.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FE2688-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 1 Jun 2015, Hefty, Sean wrote:

> > We want to have a time stamp when the action is complete and the data is
> > available to the application or the send action is complete and the CQ
> > entry can be reused.
>
> This is what polling the completion from the CQ tells you, independent of t=
> here being a time stamp.

But you may not be polling that frequently. Polling threads may check
multiple sources of events and may also currently executing code to handle
an event. Also there is the problem of the OS interrupting you. All of
these sources of inaccuracy are removed by the timestamp.

That was for inbound. For outbound you do not get a timestamp without this
feature. Typically reclaim of outbound work requeust is delayed quite a
bit and getting a timestamp later does not reflect the actual time the
message was sent.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
