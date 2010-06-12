From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2] RDMA/CMA: fix iWARP adapter TCP port space usage
Date: Fri, 11 Jun 2010 23:22:42 -0600
Message-ID: <20100612052242.GA17793@obsidianresearch.com>
References: <2EFBCAEF10980645BBCFB605689E08E904924CCE42@azsmsx506.amr.corp.intel.com> <4C12A6E8.5040400@opengridcomputing.com> <adamxv1w7cb.fsf@roland-alpha.cisco.com> <20100611224126.GA4630@obsidianresearch.com> <4C12C971.4000909@opengridcomputing.com> <20100612000431.GC4630@obsidianresearch.com> <4C12E073.2040008@opengridcomputing.com> <20100612015652.GA7648@obsidianresearch.com> <4C12EC89.1030305@opengridcomputing.com> <Pine.WNT.4.64.1006112117160.6192@PPWASKIE-MOBL2.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Pine.WNT.4.64.1006112117160.6192-sfjRBClDQW9noNDWh8xLylnYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 11, 2010 at 09:34:44PM -0700, Peter P Waskiewicz Jr wrote:

> The base argument is Dave Miller doesn't like RDMA or iWARP.  I completely 
> respect Dave's opinions, but in this case, I don't think it's his call, 
> since this patch is completely isolated to the IB tree and the RDMA stack. 
> Not including this will directly affect anyone using iWARP with Linux.
> Hopefully those people will chime in at some point, but I'm not sure that 
> will help because the arguments so far against this have been somewhat 
> irrational, and nothing technical-oriented.

My impression of the general netdev argument is that if it touches
sockets it has to have 100% of the behavior and functionality of the
Linux stack. iwarp fails that test.. There is absolutely no way to fix
that - that is rational, technical and not at all 'solution oriented' :)

The only reason iwarp has got as far as it has in the offical tree is
because it piggy backed on IB's 'sandbox' approach to the RDMA
layer. So, if you want to play in that area you have to play by those
rules, and that means staying in the sandbox ..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
