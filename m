From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Date: Fri, 6 Jan 2017 11:26:25 -0700
Message-ID: <20170106182625.GB5724@obsidianresearch.com>
References: <20170105190113.GA12587@obsidianresearch.com>
 <20170105195424.GB2166@redhat.com>
 <20170105200719.GB31047@obsidianresearch.com>
 <20170105201935.GC2166@redhat.com>
 <20170105224215.GA3855@obsidianresearch.com>
 <20170105232352.GB6426@redhat.com>
 <20170106003034.GB4670@obsidianresearch.com>
 <20170106015831.GA2226@gmail.com>
 <f07700d5-211f-d091-2b0b-fbaf03c4a959@amd.com>
 <20170106173722.GB3804@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170106173722.GB3804-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: david1.zhou-5C7GfCeVMHo@public.gmane.org, qiang.yu-5C7GfCeVMHo@public.gmane.org, "'linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "'linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org'" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "Kuehling,
 Felix" <Felix.Kuehling-5C7GfCeVMHo@public.gmane.org>, Serguei Sagalovitch <serguei.sagalovitch-5C7GfCeVMHo@public.gmane.org>, "'linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "'dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org'" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "Koenig,
 Christian" <Christian.Koenig-5C7GfCeVMHo@public.gmane.org>, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, "Deucher,
 Alexander" <Alexander.Deucher-5C7GfCeVMHo@public.gmane.org>, "Sander, Ben" <ben.sander-5C7GfCeVMHo@public.gmane.org>, "Suthikulpanit, Suravee" <Suravee.Suthikulpanit-5C7GfCeVMHo@public.gmane.org>, "'linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jerome Glisse <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Blinzer, Paul" <Paul.Blinzer-5C7GfCeVMHo@public.gmane.org>, "'Linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <Linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 06, 2017 at 12:37:22PM -0500, Jerome Glisse wrote:
> On Fri, Jan 06, 2017 at 11:56:30AM -0500, Serguei Sagalovitch wrote:
> > On 2017-01-05 08:58 PM, Jerome Glisse wrote:
> > > On Thu, Jan 05, 2017 at 05:30:34PM -0700, Jason Gunthorpe wrote:
> > > > On Thu, Jan 05, 2017 at 06:23:52PM -0500, Jerome Glisse wrote:
> > > > 
> > > > > > I still don't understand what you driving at - you've said in both
> > > > > > cases a user VMA exists.
> > > > > In the former case no, there is no VMA directly but if you want one than
> > > > > a device can provide one. But such VMA is useless as CPU access is not
> > > > > expected.
> > > > I disagree it is useless, the VMA is going to be necessary to support
> > > > upcoming things like CAPI, you need it to support O_DIRECT from the
> > > > filesystem, DPDK, etc. This is why I am opposed to any model that is
> > > > not VMA based for setting up RDMA - that is shorted sighted and does
> > > > not seem to reflect where the industry is going.
> > > > 
> > > > So focus on having VMA backed by actual physical memory that covers
> > > > your GPU objects and ask how do we wire up the '__user *' to the DMA
> > > > API in the best way so the DMA API still has enough information to
> > > > setup IOMMUs and whatnot.
> > > I am talking about 2 different thing. Existing hardware and API where you
> > > _do not_ have a vma and you do not need one. This is just
> > > > existing stuff.

> > I do not understand why you assume that existing API doesn't  need one.
> > I would say that a lot of __existing__ user level API and their support in
> > kernel (especially outside of graphics domain) assumes that we have vma and
> > deal with __user * pointers.

+1

> Well i am thinking to GPUDirect here. Some of GPUDirect use case do not have
> vma (struct vm_area_struct) associated with them they directly apply to GPU
> object that aren't expose to CPU. Yes some use case have vma for share buffer.

Lets stop talkind about GPU direct. Today we can't even make VMA
pointing at a PCI bar work properly in the kernel - lets start there
please. People can argue over other options once that is done.

> For HMM plan is to restrict to ODP and either to replace ODP with HMM or change
> ODP to not use get_user_pages_remote() but directly fetch informations from
> CPU page table. Everything else stay as it is. I posted patchset to replace
> ODP with HMM in the past.

Make a generic API for all of this and you'd have my vote..

IMHO, you must support basic pinning semantics - that is necessary to
support generic short lived DMA (eg filesystem, etc). That hardware
can clearly do that if it can support ODP.

Jason
