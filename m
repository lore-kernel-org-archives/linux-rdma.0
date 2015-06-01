From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 09/10] IB/mlx4: Add timestamp_mask and hca_core_clock
 to query_device
Date: Mon, 1 Jun 2015 06:39:51 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1506010635360.25165@east.gentwo.org>
References: <CAJ3xEMh_g0zBza5HoVZTy9cTRbXqatzvBMAJcRjQhH7Zi=cHAg@mail.gmail.com> <20150527222108.GA7855@obsidianresearch.com> <5566BDE4.50709@mellanox.com> <alpine.DEB.2.11.1505280908001.16142@east.gentwo.org> <20150528162416.GA6515@obsidianresearch.com>
 <alpine.DEB.2.11.1505281212330.1711@east.gentwo.org> <20150528175043.GA10966@obsidianresearch.com> <alpine.DEB.2.11.1505281325150.1794@east.gentwo.org> <20150528195034.GA11182@obsidianresearch.com> <alpine.DEB.2.11.1505281522020.2703@east.gentwo.org>
 <20150528204749.GA12780@obsidianresearch.com> <alpine.DEB.2.11.1505290845040.8178@east.gentwo.org> <1432918170.114391.104.camel@redhat.com> <1828884A29C6694DAF28B7E6B8A82373A8FE2126@ORSMSX109.amr.corp.intel.com> <1432919688.114391.116.camel@redhat.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432919688.114391.116.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 29 May 2015, Doug Ledford wrote:

> The use case is clear IMO.  It's for financial trading software.  I
> don't think they really care about details like whether it's the start
> or end packet, or completion, or whatever.  They need a tie breaker
> between when they have two different buy or sell orders on the same lot
> of stock.  Any deterministic timing/ordering method will do as long as
> they consistently apply it I think.  And the faster and lower overhead
> the process, the better.  He doesn't really want a timestamp, he merely
> wants a sequence ordering.  But a timestamp is what they are using to
> get him what he needs.
>
> Is that a fair guess Christoph?

We want to have a time stamp when the action is complete and the data is
available to the application or the send action is complete and the CQ
entry can be reused. That is a well defined point and that is how the time
stamps function in the existing implementation. This is an obvious
understanding and its pretty clear.

The time stamp needs to be at the end of the action because the timestamp
is used to:

1. Assess the impact of network processing. This can be compared with
   packet timestamps from capture devices off the wire.
2. Delineate the start of packet processing in software.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
