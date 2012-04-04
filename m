From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] Proposal to change Node Description naming scheme for HCA's
Date: Wed, 4 Apr 2012 11:25:16 -0600
Message-ID: <20120404172516.GA24353@obsidianresearch.com>
References: <20120330173908.0abdd264.weiny2@llnl.gov>
 <F93D748CDCC46C42B498F40A38D90369641004@FMSMSX107.amr.corp.intel.com>
 <20120402184545.GA1311@obsidianresearch.com>
 <20120403191442.ce88dc0a.weiny2@llnl.gov>
 <20120404171200.GC20889@obsidianresearch.com>
 <F93D748CDCC46C42B498F40A38D903696420A5@FMSMSX107.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <F93D748CDCC46C42B498F40A38D903696420A5-AtyAts71sc9zLByeVOV5+bfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Heinz, Michael William" <michael.william.heinz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 04, 2012 at 05:17:48PM +0000, Heinz, Michael William wrote:
> I agree that setting it via the network scripts is preferable - if
> we can find a fairly consistent way to do it across distros.

OFED only supports two distros, we don't really need to be
distro-agnostic. At this point it is better to integrate well with
each supported distro and 'do things the distro way'. The OFA
direction is now 'upstream first' and 'better distro collaboration'..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
