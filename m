From: Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 04/14] PCI/P2PDMA: Clear ACS P2P flags for all devices
 behind switches
Date: Thu, 10 May 2018 15:24:54 -0400
Message-ID: <20180510192454.GC3652@redhat.com>
References: <d70cf286-f7b7-99a5-1042-022506298fed@deltatee.com>
 <20180508205005.GC15608@redhat.com>
 <7FFB9603-DF9F-4441-82E9-46037CB6C0DE@raithlin.com>
 <a1a36f88-fbfb-b5ee-6dcb-5c5bb96132dd@amd.com>
 <4e0d0b96-ab02-2662-adf3-fa956efd294c@deltatee.com>
 <2fc61d29-9eb4-d168-a3e5-955c36e5d821@amd.com>
 <94C8FE12-7FC3-48BD-9DCA-E6A427E71810@raithlin.com>
 <20180510144137.GA3652@redhat.com>
 <B525870A-B25E-46BB-B501-DAA39F1741DC@raithlin.com>
 <20180510131015.4ad59477@w520.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180510131015.4ad59477-DGNDKt5SQtizQB+pC5nmwQ@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 10, 2018 at 01:10:15PM -0600, Alex Williamson wrote:
> On Thu, 10 May 2018 18:41:09 +0000
> "Stephen  Bates" <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org> wrote:    =

> > >    Reasons is that GPU are giving up on PCIe (see all specialize link=
 like
> > >    NVlink that are popping up in GPU space). So for fast GPU inter-co=
nnect
> > >    we have this new links.   =

> > =

> > I look forward to Nvidia open-licensing NVLink to anyone who wants to u=
se it ;-).
> =

> No doubt, the marketing for it is quick to point out the mesh topology
> of NVLink, but I haven't seen any technical documents that describe the
> isolation capabilities or IOMMU interaction.  Whether this is included
> or an afterthought, I have no idea.

AFAIK there is no IOMMU on NVLink between devices, walking a page table and
being able to sustain 80GB/s or 160GB/s is hard to achieve :) I think idea
behind those interconnect is that devices in the mesh are inherently secure
ie each single device is suppose to make sure that no one can abuse it.

GPU with their virtual address space and contextualize program executions
unit are suppose to be secure (a specter like bug might be lurking on those
but i doubt it).

So for those interconnect you program physical address directly in the page
table of the devices and those physical address are un-translated from hard-
ware perspective.

Note that the kernel driver that do the actual GPU page table programming
can do sanity check on value it is setting. So checks can also happens at
setup time. But after that assumption is hardware is secure and no one can
abuse it AFAICT.

> =

> > >    Also the IOMMU isolation do matter a lot to us. Think someone usin=
g this
> > >    peer to peer to gain control of a server in the cloud.  =

> =

> From that perspective, do we have any idea what NVLink means for
> topology and IOMMU provided isolation and translation?  I've seen a
> device assignment user report that seems to suggest it might pretend to
> be PCIe compatible, but the assigned GPU ultimately doesn't work
> correctly in a VM, so perhaps the software compatibility is only so
> deep. Thanks,

Note that each single GPU (in configurations i am aware of) also have a
PCIE link with the CPU/main memory. So from that point of view they very
much behave like a regular PCIE devices. It is just that each GPUs in
the mesh can access each other memory through high bandwidth interconnect.

I am not sure how much is public beyond that, i will ask NVidia to try to
have someone chime in this thread and shed light on this, if possible.

Cheers,
J=E9r=F4me
