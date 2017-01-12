From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Date: Thu, 12 Jan 2017 15:35:07 -0700
Message-ID: <8bda88d4-1e7c-7889-7d20-1a0eb43de31a@deltatee.com>
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
 <20170106182625.GB5724@obsidianresearch.com>
 <2a148b6e-86bc-4c4d-2f22-d733e2cc94cc@deltatee.com>
 <d5a72e1e5f6d606697dc0027f073fd87.squirrel@webmail.raithlin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <d5a72e1e5f6d606697dc0027f073fd87.squirrel-2RFepEojUI2m/tTznewQxVaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
Cc: david1.zhou-5C7GfCeVMHo@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, "'linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "'linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org'" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "Kuehling,
 Felix" <felix.kuehling-5C7GfCeVMHo@public.gmane.org>, Serguei Sagalovitch <serguei.sagalovitch-5C7GfCeVMHo@public.gmane.org>, "Blinzer,
 Paul" <paul.blinzer-5C7GfCeVMHo@public.gmane.org>, "'linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "'dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org'" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "Sander,
 Ben" <ben.sander-5C7GfCeVMHo@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, qiang.yu-5C7GfCeVMHo@public.gmane.org, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Suthikulpanit,
 Suravee" <suravee.suthikulpanit-5C7GfCeVMHo@public.gmane.org>, "'linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Deucher,
 Alexander" <alexander.deucher-5C7GfCeVMHo@public.gmane.org>, Jerome Glisse <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Koenig, Christian" <christian.koenig-5C7GfCeVMHo@public.gmane.org>, "'Linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 11/01/17 09:54 PM, Stephen Bates wrote:
> The iopmem patchset addressed all the use cases above and while it is not
> an in kernel API it could have been modified to be one reasonably easily.
> As Logan states the driver can then choose to pass the VMAs to user-space
> in a manner that makes sense.

Just to clarify: the iopmem patchset had one patch that allowed for
slightly more flexible zone device mappings which ought to be useful for
everyone.

The other patch (which was iopmem proper) was more of an example of how
the zone_device memory _could_ be exposed to userspace with "iopmem"
hardware that looks similar to nvdimm hardware. Iopmem was not really
useful, in itself, for NVMe devices and it was never expected to be
useful for GPUs.

Logan
