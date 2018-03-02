From: Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v2 00/10] Copy Offload in NVMe Fabrics with P2P PCI Memory
Date: Sat, 03 Mar 2018 08:44:12 +1100
Message-ID: <1520027052.4592.60.camel@kernel.crashing.org>
References: <20180228234006.21093-1-logang@deltatee.com>
 <1519876489.4592.3.camel@kernel.crashing.org>
 <1519876569.4592.4.camel@au1.ibm.com>
 <CAPcyv4h7mcFphv3j_vW-CGxXa2pjQgLqpBOLzHuTzAFzygai-Q@mail.gmail.com>
 <1519936477.4592.23.camel@au1.ibm.com>
 <CAPcyv4goHsYytq60ehJUori8Xq+Z0p8dV-8_oRALj244H4YtwQ@mail.gmail.com>
 <2079ba48-5ae5-5b44-cce1-8175712dd395@deltatee.com>
 <43ba615f-a6e1-9444-65e1-494169cb415d@deltatee.com>
 <1519945204.4592.45.camel@au1.ibm.com>
 <595acefb-18fc-e650-e172-bae271263c4c@deltatee.com>
 <1519946734.4592.48.camel@au1.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1519946734.4592.48.camel-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Oliver OHalloran <oliveroh-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, =?ISO-8859-1?Q?J=E9r=F4me?= Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2018-03-02 at 10:25 +1100, Benjamin Herrenschmidt wrote:
> On Thu, 2018-03-01 at 16:19 -0700, Logan Gunthorpe wrote:
> > 
> > On 01/03/18 04:00 PM, Benjamin Herrenschmidt wrote:
> > > We use only 52 in practice but yes.
> > > 
> > > >   That's 64PB. If you use need
> > > > a sparse vmemmap for the entire space it will take 16TB which leaves you
> > > > with 63.98PB of address space left. (Similar calculations for other
> > > > numbers of address bits.)
> > > 
> > > We only have 52 bits of virtual space for the kernel with the radix
> > > MMU.
> > 
> > Ok, assuming you only have 52 bits of physical address space: the sparse 
> > vmemmap takes 1TB and you're left with 3.9PB of address space for other 
> > things. So, again, why doesn't that work? Is my math wrong
> 
> The big problem is not the vmemmap, it's the linear mapping

Allright, so, I think I have a plan to fix this, but it will take a
little bit of time.

Basically the idea is to have firmware pass to Linux a region that's
known to not have anything in it that it can use for the vmalloc space
rather than have linux arbitrarily cut the address space in half.

I'm pretty sure I can always find large enough "holes" in the physical
address space that are outside of both RAM/OpenCAPI/Nvlink and
PCIe/MMIO space. If anything, unused chip IDs. But I don't want Linux
to have to know about the intimate HW details so I'll pass it from FW.

It will take some time to adjust Linux and get updated FW around
though.

Once that's done, I'll be able to have the linear mapping go through
the entire 52-bit space (minus that hole). Of course the hole need to
be large enough to hold a vmemmap for a 52-bit space, so that's about
4TB. So I probably need a hole that's at least 8TB.

As for the mapping attributes, it should be easy for my linear mapping
code to ensure anything that isn't actual RAM is mapped NC.

Cheers,
Ben.
