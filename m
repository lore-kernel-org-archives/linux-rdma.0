From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [ewg] [ANNOUNCE] OFED 4.8-rc2 release is available
Date: Thu, 4 May 2017 14:17:21 -0600
Message-ID: <20170504201721.GA24298@obsidianresearch.com>
References: <590096A3.5090107@dev.mellanox.co.il>
 <20170427070657.GA13585@infradead.org>
 <20170504084933.GA1359@infradead.org>
 <9C6B67F36DCAFC479B1CF6A967258A8C7E953FA6@ORSMSX115.amr.corp.intel.com>
 <20170504153003.GA854@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB1199FA@ORSMSX109.amr.corp.intel.com>
 <20170504174105.GB20449@obsidianresearch.com>
 <BN6PR11MB139465918AC8DFAAB56030B6B2EA0@BN6PR11MB1394.namprd11.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BN6PR11MB139465918AC8DFAAB56030B6B2EA0-1gF2/dm/6VsyQw8Ag4AtH5PPoyLQLiKMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Grun <grun-WVYJKLFxKCc@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 04, 2017 at 07:07:02PM +0000, Paul Grun wrote:
> >The founding imputus for OFA was to get this RDMA code upstream, so OFA
> >should not be spending their resources supporting non-upstream works.
> 
> That's actually not true.  The founding impetus was to prevent the
> nascent InfiniBand industry from fracturing under the weight of
> multiple software implementations of the verbs semantics described
> in the IB specs.  The solution to that was to provide a single
> software stack provided by the Alliance.

I think you are splitting hairs, from the start alliance members
focused their efforts upstream (eg Roland getting Linus to accept
drivers/infiniband).

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
