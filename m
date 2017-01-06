From: Serguei Sagalovitch <serguei.sagalovitch-5C7GfCeVMHo@public.gmane.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Date: Thu, 5 Jan 2017 19:41:26 -0500
Message-ID: <26f86650-5302-0df2-9b51-dd967f3e5a7b@amd.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <20170105183927.GA5324@gmail.com>
 <20170105190113.GA12587@obsidianresearch.com>
 <20170105195424.GB2166@redhat.com>
 <20170105200719.GB31047@obsidianresearch.com>
 <20170105201935.GC2166@redhat.com>
 <20170105224215.GA3855@obsidianresearch.com>
 <20170105232352.GB6426@redhat.com>
 <20170106003034.GB4670@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170106003034.GB4670-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: david1.zhou-5C7GfCeVMHo@public.gmane.org, qiang.yu-5C7GfCeVMHo@public.gmane.org, "'linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "'linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org'" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "Kuehling,
 Felix" <Felix.Kuehling-5C7GfCeVMHo@public.gmane.org>, "'linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "'dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org'" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "Koenig,
 Christian" <Christian.Koenig-5C7GfCeVMHo@public.gmane.org>, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, "Deucher,
 Alexander" <Alexander.Deucher-5C7GfCeVMHo@public.gmane.org>, "Sander, Ben" <ben.sander-5C7GfCeVMHo@public.gmane.org>, "Suthikulpanit, Suravee" <Suravee.Suthikulpanit-5C7GfCeVMHo@public.gmane.org>, "'linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jerome Glisse <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Blinzer, Paul" <Paul.Blinzer-5C7GfCeVMHo@public.gmane.org>, "'Linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <Linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2017-01-05 07:30 PM, Jason Gunthorpe wrote:
> ........ but I am opposed to
> the idea we need two API paths that the *driver* has to figure out.
> That is fundamentally not what I want as a driver developer.
>
> Give me a common API to convert '__user *' to a scatter list and pin
> the pages.
Completely agreed. IMHO there is no sense to duplicate the same logic
everywhere as well as  trying to find places where it is missing.

Sincerely yours,
Serguei Sagalovitch
