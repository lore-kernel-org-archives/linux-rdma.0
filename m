From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Date: Thu, 5 Jan 2017 15:42:15 -0700
Message-ID: <20170105224215.GA3855@obsidianresearch.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <20170105183927.GA5324@gmail.com>
 <20170105190113.GA12587@obsidianresearch.com>
 <20170105195424.GB2166@redhat.com>
 <20170105200719.GB31047@obsidianresearch.com>
 <20170105201935.GC2166@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170105201935.GC2166-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
 Felix" <Felix.Kuehling-5C7GfCeVMHo@public.gmane.org>, "Sagalovitch,
 Serguei" <Serguei.Sagalovitch-5C7GfCeVMHo@public.gmane.org>, "'linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "'dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org'" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "Koenig,
 Christian" <Christian.Koenig-5C7GfCeVMHo@public.gmane.org>, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, "Deucher,
 Alexander" <Alexander.Deucher-5C7GfCeVMHo@public.gmane.org>, "Sander, Ben" <ben.sander-5C7GfCeVMHo@public.gmane.org>, "Suthikulpanit, Suravee" <Suravee.Suthikulpanit-5C7GfCeVMHo@public.gmane.org>, "'linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jerome Glisse <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Blinzer, Paul" <Paul.Blinzer-5C7GfCeVMHo@public.gmane.org>, "'Linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <Linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 05, 2017 at 03:19:36PM -0500, Jerome Glisse wrote:

> > Always having a VMA changes the discussion - the question is how to
> > create a VMA that reprensents IO device memory, and how do DMA
> > consumers extract the correct information from that VMA to pass to the
> > kernel DMA API so it can setup peer-peer DMA.
> 
> Well my point is that it can't be. In HMM case inside a single VMA
> you
[..]

> In the GPUDirect case the idea is that you have a specific device vma
> that you map for peer to peer.

[..]

I still don't understand what you driving at - you've said in both
cases a user VMA exists.

>From my perspective in RDMA, all I want is a core kernel flow to
convert a '__user *' into a scatter list of DMA addresses, that works no
matter what is backing that VMA, be it HMM, a 'hidden' GPU object, or
struct page memory.

A '__user *' pointer is the only way to setup a RDMA MR, and I see no
reason to have another API at this time.

The details of how to translate to a scatter list are a MM subject,
and the MM folks need to get 

I just don't care if that routine works at a page level, or a whole
VMA level, or some combination of both, that is up to the MM team to
figure out :)

> a page level. Expectation here is that the GPU userspace expose a special
> API to allow RDMA to directly happen on GPU object allocated through
> GPU specific API (ie it is not regular memory and it is not accessible
> by CPU).

So, how do you identify these GPU objects? How do you expect RDMA
convert them to scatter lists? How will ODP work?

> > We have MMU notifiers to handle this today in RDMA. Async RDMA MR
> > Invalidate like you see in the above out of tree patches is totally
> > crazy and shouldn't be in mainline. Use ODP capable RDMA hardware.
> 
> Well there is still a large base of hardware that do not have such
> feature and some people would like to be able to keep using those.

Hopefully someone will figure out how to do that without the crazy
async MR invalidation.

Jason
