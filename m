From: "Petrosyan, Ludwig" <ludwig.petrosyan-T5F83Mi6MZE@public.gmane.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Date: Thu, 26 Oct 2017 15:28:02 +0200 (CEST)
Message-ID: <2068822709.17434955.1509024482956.JavaMail.zimbra@desy.de>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <7f5e0303-f4ea-781a-8dec-74b30990d54f@desy.de>
 <be9f2dee-bb37-9e8f-af72-6ee1127ba8d4@deltatee.com>
 <1381807327.12461494.1508652825239.JavaMail.zimbra@desy.de>
 <063D6719AE5E284EB5DD2968C1650D6DD00A04EA@AcuExch.aculab.com>
 <d61b6829-0515-a809-2a43-c41add4b1594@deltatee.com>
 <1264390131.14701401.1508824699016.JavaMail.zimbra@desy.de>
 <063D6719AE5E284EB5DD2968C1650D6DD00A19B9@AcuExch.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6DD00A19B9-VkEWCZq2GCInGFn1LkZF6NBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: David Laight <David.Laight-ZS65k/vG3HxXrIkS9f7CXA@public.gmane.org>
Cc: Serguei Sagalovitch <Serguei.Sagalovitch-5C7GfCeVMHo@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-pci <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Felix Kuehling <Felix.Kuehling-5C7GfCeVMHo@public.gmane.org>, John Bridgman <John.Bridgman-5C7GfCeVMHo@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Christian Koenig <Christian.Koenig-5C7GfCeVMHo@public.gmane.org>, Ben Sander <ben.sander-5C7GfCeVMHo@public.gmane.org>, Suravee Suthikulpanit <Suravee.Suthikulpanit-5C7GfCeVMHo@public.gmane.org>, Alexander Deucher <Alexander.Deucher-5C7GfCeVMHo@public.gmane.org>, Paul Blinzer <Paul.Blinzer-5C7GfCeVMHo@public.gmane.org>, Linux-media <Linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "David Laight" <David.Laight-ZS65k/vG3HxXrIkS9f7CXA@public.gmane.org>
> To: "Petrosyan, Ludwig" <ludwig.petrosyan-T5F83Mi6MZE@public.gmane.org>, "Logan Gunthorpe" <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
> Cc: "Alexander Deucher" <Alexander.Deucher-5C7GfCeVMHo@public.gmane.org>, "linux-kernel" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma"
> <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvdimm" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, "Linux-media" <Linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
> "dri-devel" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "linux-pci" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "John Bridgman"
> <John.Bridgman-5C7GfCeVMHo@public.gmane.org>, "Felix Kuehling" <Felix.Kuehling-5C7GfCeVMHo@public.gmane.org>, "Serguei Sagalovitch"
> <Serguei.Sagalovitch-5C7GfCeVMHo@public.gmane.org>, "Paul Blinzer" <Paul.Blinzer-5C7GfCeVMHo@public.gmane.org>, "Christian Koenig" <Christian.Koenig-5C7GfCeVMHo@public.gmane.org>,
> "Suravee Suthikulpanit" <Suravee.Suthikulpanit-5C7GfCeVMHo@public.gmane.org>, "Ben Sander" <ben.sander-5C7GfCeVMHo@public.gmane.org>
> Sent: Tuesday, 24 October, 2017 16:58:24
> Subject: RE: Enabling peer to peer device transactions for PCIe devices

> Please don't top post, write shorter lines, and add the odd blank line.
> Big blocks of text are hard to read quickly.
> 

OK this time I am very short. 
peer2peer works

Ludwig
