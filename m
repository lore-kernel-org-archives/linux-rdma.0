From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [ewg] ibcheckerrors "Port All FAILED" reported
Date: Thu, 6 May 2010 14:08:18 -0700
Message-ID: <20100506140818.60809867.weiny2@llnl.gov>
References: <382A478CAD40FA4FB46605CF81FE39F45685DEAD@orsmsx507.amr.corp.intel.com>
	<20100505180943.a9bbb74e.weiny2@llnl.gov>
	<20100506211124.GH7099@me.iol.unh.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100506211124.GH7099-o14lFNPAa+WKTadZzrrH2Q@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, EWG <Openfabrics-ewg-0P3JtQMG0aQdnm+yROfE0A@public.gmane.org>, "tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 6 May 2010 14:11:24 -0700
Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:

> On 18:09 Wed 05 May     , Ira Weiny wrote:
> > 
> > 14:29:03 > ./perfquery 40 255
> > ./perfquery: iberror: failed: AllPortSelect not supported
> > 
> > It seems there is an issue with the CapabilityMask value...
> > 
> > 14:43:32 > ./perfquery 40 255
> > cap_mask 0x400  <=== my debug output
> > ./perfquery: iberror: failed: AllPortSelect not supported
> > 
> > 14:43:38 > ./saquery CPI 40
> > SA ClassPortInfo:
> > ...
> >                 Capability mask..........0x2602
> > ...
> > 
> > Those don't match because...  perfquery has a bug...
> > 
> > perfquery is issuing a PMA query when it should be issuing a SA query.
> 
> I'm not following. How should it be related to each other SA and PM
> ClassPortInfo(s)?

It's not, I was confused...  :-D

Ira

> 
> Sasha


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
