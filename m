From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/3] ib core: Make device counter infrastructure dynamic
Date: Wed, 18 May 2016 15:11:07 -0600
Message-ID: <20160518211107.GB21331@obsidianresearch.com>
References: <alpine.DEB.2.20.1605161203010.26453@east.gentwo.org>
 <db1bf3dd-20b1-3f2f-eaa3-25e5e8aff35b@redhat.com>
 <alpine.DEB.2.20.1605161238560.10085@east.gentwo.org>
 <102cd100-55f7-fa85-cd75-ba0db5b9fa34@redhat.com>
 <alpine.DEB.2.20.1605170918080.9956@east.gentwo.org>
 <3e9a3e19-58cb-c25f-89a1-f0e51df562d8@redhat.com>
 <20160517170027.GC19976@obsidianresearch.com>
 <bc83cc75-aa2e-6fc6-e1c6-a0190b972013@redhat.com>
 <20160518172542.GA15516@obsidianresearch.com>
 <12e991bc-aa9b-a8b0-3cd4-b56d58a44d60@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <12e991bc-aa9b-a8b0-3cd4-b56d58a44d60-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, alonvi-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, May 18, 2016 at 02:11:27PM -0400, Doug Ledford wrote:
> On 05/18/2016 01:25 PM, Jason Gunthorpe wrote:
> > Why would people manually use sysfs? A netlink interface would be
> > accompanied by a tool. I don't schlep around in sysfs for netdev, I
> > use 'ip -s link show'
> 
> And how are you going to get RNR Retries from an IB device with
> that?

We don't have a netlink tool for rdma devices yet, I'm imagining that
as part of adding netlink bulk access.

> that happen, I save the age in jiffies when they are taken.  That could
> be used to provide their timestamp and give meaningful time context to
> the counter.  They simply don't when you are reading the files in sysfs.

Why do all this weird work to solve a problem we don't even have?
netlink is the way to get bulk stats out of devices, that is what
netdev does, overkilling sysfs seems unnecessary...

JAson
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
