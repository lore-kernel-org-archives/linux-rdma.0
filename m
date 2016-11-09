From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH rdma-next 0/4] Add packet pacing support for IB verbs
Date: Wed, 9 Nov 2016 17:06:52 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB0A7F0A@ORSMSX109.amr.corp.intel.com>
References: <1477909297-14491-1-git-send-email-leon@kernel.org>
 <1828884A29C6694DAF28B7E6B8A82373AB0A7B31@ORSMSX109.amr.corp.intel.com>
 <20161109064009.GE27883@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161109064009.GE27883-2ukJVAZIZ/Y@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> On Tue, Nov 08, 2016 at 05:49:26PM +0000, Hefty, Sean wrote:
> > > When sending from a 10G host to a 1G host, it is easy to overrun
> the
> > > receiver,
> > > leading to packet loss and traffic backing off. Similar problems
> occur
> > > when
> > > a 10G host sends data to a sub-10G virtual circuit, or a 40G host
> > > sending
> > > to a 10G host. Packet pacing could control packet injection rate
> and
> > > reduces
> > > network congestion to maximize throughput & minimize network
> latency.
> >
> > Why isn't the path record data and existing mechanisms sufficient to
> handle this?
> >
> 
> Packet pacing allows different combinations of traffic shaping: per-
> CPU,
> per-flow and their combinations with better and steady QoS requirements
> without involving subnet management.

The patch adds this as a QP attribute, and we already have a rate for that.  I still don't see why the standard mechanisms are insufficient or couldn't be adapted.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
