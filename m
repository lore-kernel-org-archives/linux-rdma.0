From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Date: Fri, 25 Nov 2016 14:18:46 -0700
Message-ID: <20161125211846.GA22521@obsidianresearch.com>
References: <20161123193228.GC12146@obsidianresearch.com>
 <c2c88376-5ba7-37d1-4d3e-592383ebb00a@amd.com>
 <20161123203332.GA15062@obsidianresearch.com>
 <dd60bca8-0a35-7a3a-d3ab-b95bc3d9b973@deltatee.com>
 <20161123215510.GA16311@obsidianresearch.com>
 <91d28749-bc64-622f-56a1-26c00e6b462a@deltatee.com>
 <20161124164249.GD20818@obsidianresearch.com>
 <3f2d2db3-fb75-2422-2a18-a8497fd5d70e@amd.com>
 <20161125193252.GC16504@obsidianresearch.com>
 <a98185d9-ffb1-6469-4272-2d1222600825@vodafone.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a98185d9-ffb1-6469-4272-2d1222600825-ANTagKRnAhcb1SvskN2V4Q@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <deathsimple-ANTagKRnAhcb1SvskN2V4Q@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "Kuehling,
 Felix" <Felix.Kuehling-5C7GfCeVMHo@public.gmane.org>, Serguei Sagalovitch <serguei.sagalovitch-5C7GfCeVMHo@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "Blinzer,
 Paul" <Paul.Blinzer-5C7GfCeVMHo@public.gmane.org>, "Sander, Ben" <ben.sander-5C7GfCeVMHo@public.gmane.org>, "Suthikulpanit, Suravee" <Suravee.Suthikulpanit-5C7GfCeVMHo@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Deucher,
 Alexander" <Alexander.Deucher-5C7GfCeVMHo@public.gmane.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, "Linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <Linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 25, 2016 at 09:40:10PM +0100, Christian K=F6nig wrote:

> We call this "userptr" and it's just a combination of get_user_pages() on
> command submission and making sure the returned list of pages stays valid
> using a MMU notifier.

Doesn't that still pin the page?

> The "big" problem with this approach is that it is horrible slow. I mean
> seriously horrible slow so that we actually can't use it for some of the
> purposes we wanted to use it.
> =

> >The code moving the page will move it and the next GPU command that
> >needs it will refault it in the usual way, just like the CPU would.
> =

> And here comes the problem. CPU do this on a page by page basis, so they
> fault only what needed and everything else gets filled in on demand. This
> results that faulting a page is relatively light weight operation.
>
> But for GPU command submission we don't know which pages might be accessed
> beforehand, so what we do is walking all possible pages and make sure all=
 of
> them are present.

Little confused why this is slow? So you fault the entire user MM into
your page tables at start of day and keep track of it with mmu
notifiers?

> >This might be much more efficient since it optimizes for the common
> >case of unchanging translation tables.
> =

> Yeah, completely agree. It works perfectly fine as long as you don't have
> two drivers trying to mess with the same page.

Well, the idea would be to not have the GPU block the other driver
beyond hinting that the page shouldn't be swapped out.

> >This assumes the commands are fairly short lived of course, the
> >expectation of the mmu notifiers is that a flush is reasonably prompt
> =

> Correct, this is another problem. GFX command submissions usually don't t=
ake
> longer than a few milliseconds, but compute command submission can easily
> take multiple hours.

So, that won't work - you have the same issue as RDMA with work loads
like that.

If you can't somehow fence the hardware then pinning is the only
solution. Felix has the right kind of suggestion for what is needed -
globally stop the GPU, fence the DMA, fix the page tables, and start
it up again. :\

> I can easily imagine what would happen when kswapd is blocked by a GPU
> command submission for an hour or so while the system is under memory
> pressure :)

Right. The advantage of pinning is it tells the other stuff not to
touch the page and doesn't block it, MMU notifiers have to be able to
block&fence quickly.

> I'm thinking on this problem for about a year now and going in circles for
> quite a while. So if you have ideas on this even if they sound totally
> crazy, feel free to come up.

Well, it isn't a software problem. From what I've seen in this thread
the GPU application requires coherent page table mirroring, so the
only full & complete solution is going to be to actually implement
that somehow in GPU hardware.

Everything else is going to be deeply flawed somehow. Linux just
doesn't have the support for this kind of stuff - and I'm honestly not
sure something better is even possible considering the hardware
constraints....

This doesn't have to be faulting, but really anything that lets you
pause the GPU DMA and reload the page tables.

You might look at trying to use the IOMMU and/or PCI ATS in very new
hardware. IIRC the physical IOMMU hardware can do the fault and fence
and block stuff, but I'm not sure about software support for using the
IOMMU to create coherent user page table mirrors - that is something
Linux doesn't do today. But there is demand for this kind of capability..

Jason
