From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [RFC] Proposal to change Node Description naming scheme for
 HCA's
Date: Tue, 3 Apr 2012 19:14:42 -0700
Message-ID: <20120403191442.ce88dc0a.weiny2@llnl.gov>
References: <20120330173908.0abdd264.weiny2@llnl.gov>
	<F93D748CDCC46C42B498F40A38D90369641004@FMSMSX107.amr.corp.intel.com>
	<20120402184545.GA1311@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120402184545.GA1311-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Heinz, Michael William" <michael.william.heinz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bob Ciotti <Bob.Ciotti-NSQ8wuThN14@public.gmane.org>, James Silva <jsilva-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2 Apr 2012 12:45:45 -0600
Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> On Mon, Apr 02, 2012 at 03:27:35PM +0000, Heinz, Michael William wrote:
> 
> > Any ideas on how we could solve the hostname problem while we're
> > changing the description?
> 
> The node description needs to be set from the DCHP notifier script
> chain (eg /etc/network/if-up.d/ on Debian) and also from a udev rule
> triggered on device insertion.

Jason, I'm confused.  Do you mean DHCP?

It seems are you indicating you would like to see if[up/down] bring ports up/down like they do for IP?

On my ubuntu box (the closest thing I have to Debian) it looks like ifupdown owns /etc/network/if-up.d and that is not specific to DHCP.  I don't think DHCP should be required for IB.

Using udev to set this __seems__ like a better idea although I have not prototyped it.

> 
> It should probably not be set from the openibd script..

I agree there might be better ways but I am not sure I follow your proposal.  Furthermore, I don't know that a start up script of some sort is all that evil.

Finally, I think Michael brings up a good point about which package should own any such scripts.

Ira

> 
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
