From: Benjamin Herrenschmidt <benh-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 00/10] Copy Offload in NVMe Fabrics with P2P PCI Memory
Date: Fri, 02 Mar 2018 07:34:37 +1100
Message-ID: <1519936477.4592.23.camel@au1.ibm.com>
References: <20180228234006.21093-1-logang@deltatee.com>
 <1519876489.4592.3.camel@kernel.crashing.org>
 <1519876569.4592.4.camel@au1.ibm.com>
 <CAPcyv4h7mcFphv3j_vW-CGxXa2pjQgLqpBOLzHuTzAFzygai-Q@mail.gmail.com>
Reply-To: benh-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4h7mcFphv3j_vW-CGxXa2pjQgLqpBOLzHuTzAFzygai-Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Oliver OHalloran <oliveroh-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?ISO-8859-1?Q?J=E9r=F4me?= Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2018-03-01 at 11:21 -0800, Dan Williams wrote:
> On Wed, Feb 28, 2018 at 7:56 PM, Benjamin Herrenschmidt
> <benh-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org> wrote:
> > On Thu, 2018-03-01 at 14:54 +1100, Benjamin Herrenschmidt wrote:
> > > On Wed, 2018-02-28 at 16:39 -0700, Logan Gunthorpe wrote:
> > > > Hi Everyone,
> > > 
> > > 
> > > So Oliver (CC) was having issues getting any of that to work for us.
> > > 
> > > The problem is that acccording to him (I didn't double check the latest
> > > patches) you effectively hotplug the PCIe memory into the system when
> > > creating struct pages.
> > > 
> > > This cannot possibly work for us. First we cannot map PCIe memory as
> > > cachable. (Note that doing so is a bad idea if you are behind a PLX
> > > switch anyway since you'd ahve to manage cache coherency in SW).
> > 
> > Note: I think the above means it won't work behind a switch on x86
> > either, will it ?
> 
> The devm_memremap_pages() infrastructure allows placing the memmap in
> "System-RAM" even if the hotplugged range is in PCI space. So, even if
> it is an issue on some configurations, it's just a simple adjustment
> to where the memmap is placed.

But what happens with that PCI memory ? Is it effectively turned into
nromal memory (ie, usable for normal allocations, potentially used to
populate user pages etc...) or is it kept aside ?

Also on ppc64, the physical addresses of PCIe make it so far appart
that there's no way we can map them into the linear mapping at the
normal offset of PAGE_OFFSET + (pfn << PAGE_SHIFT), so things like
page_address or virt_to_page cannot work as-is on PCIe addresses.

Ben.
