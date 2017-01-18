From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] [RFC] IB/hfi1: Fix port ordering issue in a multiport
 device
Date: Wed, 18 Jan 2017 14:08:31 -0700
Message-ID: <20170118210831.GA7590@obsidianresearch.com>
References: <148409267200.13402.16060755922068447437.stgit@tstruk-mobl1.ra.intel.com>
 <20170111181042.GC22783@obsidianresearch.com>
 <1484773260.2406.58.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1484773260.2406.58.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 18, 2017 at 04:01:00PM -0500, Doug Ledford wrote:

> OK, sure, as far as the reordering stuff is concerned, all you need to
> do is to make use of the EPROBE_DEFER return option to your PCI probe
> routine.  That way, when you get the probe for the out of order
> port,

EPROBE_DEFER is intended when waiting on other components the driver
may need, not for setting stable names.

This is a 'stable device naming' problem, which we have never tried to
solve in RDMA.

udev is the expected kernel way to solve this. Trying to hack stable
names by forcing device bind order is horrible.

hfi runs smack into this because it is the first scheme to actually
typically operate in a multi-struct ib_device world, which means they
get to solve it properly :\

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
