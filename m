From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Further thoughts on uAPI
Date: Tue, 26 Apr 2016 08:58:13 -0600
Message-ID: <20160426145813.GB24104@obsidianresearch.com>
References: <20160420012526.GA25508@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB044043@ORSMSX109.amr.corp.intel.com>
 <AM3PR05MB141161876D5CA05B1993D20CB1610@AM3PR05MB1411.eurprd05.prod.outlook.com>
 <571F78F9.8010401@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <571F78F9.8010401-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, OFVWG <ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 26, 2016 at 10:19:37AM -0400, Doug Ledford wrote:
> For certain operations that have lots of optional items (work requests
> for one, work completions for another)

FWIW, I think we had a general consensus to take a different approach.

Basically, the 'common' uAPI does not care about micro-performance.

Drivers have to implement hardware-specific driver calls to micro-optimize
their own high speed paths, and that would be done specifically with a
single hardware in mind.

This is already done by the majority of drivers for wc/wr processing
(IIRC, only qib calls to the kernel for this)

If we do provide a common wr/wc API then it can just be designed
inefficiently around the netlink attribute architecture, uncaring
about performance because nothing should use it. I'd prefer not to
implement it at all...

This same basic idea flows over to other parts, eg if a driver has
special support for a specific work load (say fast creation of IB UD
AHs) then it can have a high speed driver-specific call to do that
work completely micro-optimized using data formed *exactly* the way
the hardware needs.

> base struct plus the length of all optional structs, and the order of
> the optional structs matches their bit order from lowest to highest in
> the magic element.  It's not quite as free form as the patches for
> timestamp support were, but still allows the structs some flexibility in
> what is included and what isn't.

Mellanox has a patch series that tries to do exactly this for the wc
in libibverbs - it is quite ugly, and the the benchmarks showed worse
performance compared to the current technique.

For the reasons above I would prefer to stick entirely with the
netlink attribute format or very similar as the main mechanism.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
