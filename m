From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH/opensm] Fix SANodeRecord.nodeInfo.localPortNum
Date: Wed, 9 Mar 2011 12:07:14 -0700
Message-ID: <20110309190714.GR22729@obsidianresearch.com>
References: <20110302002941.GA22729@obsidianresearch.com>
 <20110309154744.GV5577@calypso.voltaire.com>
 <20110309171126.GB15419@obsidianresearch.com>
 <AANLkTimu0RxDbbjiRsni4gdmanvp_eaWA=xFoH9P8qZP@mail.gmail.com>
 <20110309183441.GB25229@obsidianresearch.com>
 <AANLkTikjrO_Uga2v4H6fWBXOuUNw=scka3rjRyRuOyHV@mail.gmail.com>
 <20110309184022.GC25229@obsidianresearch.com>
 <AANLkTim_4=d-PnyoMVdJ1z4Emu+QafwQPqp+wLJi=AMB@mail.gmail.com>
 <20110309185118.GD25229@obsidianresearch.com>
 <AANLkTimfEYU4+U_-QpvwAxYK-bLDfFiO6WJcshe-vF5h@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTimfEYU4+U_-QpvwAxYK-bLDfFiO6WJcshe-vF5h-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 09, 2011 at 02:00:16PM -0500, Hal Rosenstock wrote:

> >> >> IBA 1.2.1 v1 p.830 line 9 the otherwise sentence.
> >> >
> >> > That is talking about PortInfo. NodeInfo does not support that
> >> > attribute modifier language, my patch affects SANodeRecord.
> >>
> >> My bad :-( I was thinking of PortInfoRecord, not NodeRecord, for some reason...
> >
> > No worries, what do you think about my patch, does it align with what
> > IBA intends?
> 
> Yes from my brief scan/understanding of what it's trying to
> accomplish. I haven't probed/analyzed the actual fix itself. I guess
> LocalPortNum in NodeRecord was not so important to anyone before now.

Right, plus this only comes up if you connect both ports on a HCA into
the same subnet, otherwise opensm works correctly..

Alex?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
