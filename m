From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] Proposal to change Node Description naming scheme for HCA's
Date: Mon, 2 Apr 2012 12:45:45 -0600
Message-ID: <20120402184545.GA1311@obsidianresearch.com>
References: <20120330173908.0abdd264.weiny2@llnl.gov>
 <F93D748CDCC46C42B498F40A38D90369641004@FMSMSX107.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <F93D748CDCC46C42B498F40A38D90369641004-AtyAts71sc9zLByeVOV5+bfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Heinz, Michael William" <michael.william.heinz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bob Ciotti <Bob.Ciotti-NSQ8wuThN14@public.gmane.org>, James Silva <jsilva-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 02, 2012 at 03:27:35PM +0000, Heinz, Michael William wrote:

> Any ideas on how we could solve the hostname problem while we're
> changing the description?

The node description needs to be set from the DCHP notifier script
chain (eg /etc/network/if-up.d/ on Debian) and also from a udev rule
triggered on device insertion.

It should probably not be set from the openibd script..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
