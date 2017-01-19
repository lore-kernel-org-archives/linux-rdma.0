From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] [RFC] IB/hfi1: Fix port ordering issue in a multiport
 device
Date: Thu, 19 Jan 2017 10:58:02 -0700
Message-ID: <20170119175802.GB8109@obsidianresearch.com>
References: <148409267200.13402.16060755922068447437.stgit@tstruk-mobl1.ra.intel.com>
 <20170111181042.GC22783@obsidianresearch.com>
 <1484773260.2406.58.camel@redhat.com>
 <20170118210831.GA7590@obsidianresearch.com>
 <1484784989.2406.67.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1484784989.2406.67.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 18, 2017 at 07:16:29PM -0500, Doug Ledford wrote:

> > This is a 'stable device naming' problem, which we have never
> > tried to solve in RDMA.
> 
> No, that would imply they must be hfi1_0 and hfi1_1, when this is not
> the case.  If you had two cards in this system, both dual port, then
> you may be wanting to rename hfi_3 to hfi1_2 and vice versa.  It is a
> relative name problem, not a stable name problem.  We need only reverse
> the order that the ports are probed in, their names are whatever they
> end up being once reversed.

Eh? If *users* expect RDMA names to be meaningful/stable then it *IS*
the stable naming problem. We have never guarenteed stable device
names in RDMA, but it does happen to work out by luck in many cases.

Linux does have a guarentee of PCI driver bind order. For instance
the parallel probe patch series randomizes driver bind order, so any
driver relying on this for 'stable names' is broken.

> > udev is the expected kernel way to solve this. Trying to hack stable
> > names by forcing device bind order is horrible.
> 
> This is a manufacturing defect.  Something I'm sure Intel wants to
> resolve without requiring users to go in and manually name their ports.
>  I have no doubt that they would prefer that the user remain blissfully
> unaware of the issue, all except for the ones that probably reported it
> and already have their system cabled up wrong as a result.

Modern udev models do not require manual naming by users, look at what
netdev is doing to solve this problem these days.

hif_slot#_port# can be generated automatically by udev based on
information from the driver and the BIOS. This is what is being done
for netdev.

That is where we really need to go as well.

As you say, this is a oops on Intels part, so that may be too long
term - so they should solve this temporarily and imperfectly *in their
driver* by assinging RDMA device names manually, eg make it so that
hfiX has X be even for port 0 and X be odd for port 1.

Never any need for any kind of defered binding approach.

> No, mlx5 could have easily hit this too as their ports are separate
> PCI functions.

Sound like intel and mellanox should collaborate on getting udev
stable naming working right for RDMA... They are eventually going to
get burned.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
