From: "Petrosyan, Ludwig" <ludwig.petrosyan-T5F83Mi6MZE@public.gmane.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Date: Tue, 24 Oct 2017 07:58:19 +0200 (CEST)
Message-ID: <1264390131.14701401.1508824699016.JavaMail.zimbra@desy.de>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com> <7f5e0303-f4ea-781a-8dec-74b30990d54f@desy.de> <be9f2dee-bb37-9e8f-af72-6ee1127ba8d4@deltatee.com> <1381807327.12461494.1508652825239.JavaMail.zimbra@desy.de> <063D6719AE5E284EB5DD2968C1650D6DD00A04EA@AcuExch.aculab.com> <d61b6829-0515-a809-2a43-c41add4b1594@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <d61b6829-0515-a809-2a43-c41add4b1594-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Cc: David Laight <David.Laight-ZS65k/vG3HxXrIkS9f7CXA@public.gmane.org>, Alexander Deucher <Alexander.Deucher-5C7GfCeVMHo@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Linux-media <Linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, linux-pci <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Bridgman <John.Bridgman-5C7GfCeVMHo@public.gmane.org>, Felix Kuehling <Felix.Kuehling-5C7GfCeVMHo@public.gmane.org>, Serguei Sagalovitch <Serguei.Sagalovitch-5C7GfCeVMHo@public.gmane.org>, Paul Blinzer <Paul.Blinzer-5C7GfCeVMHo@public.gmane.org>, Christian Koenig <Christian.Koenig-5C7GfCeVMHo@public.gmane.org>, Suravee Suthikulpanit <Suravee.Suthikulpanit-5C7GfCeVMHo@public.gmane.org>, Ben Sander <ben.sander-5C7GfCeVMHo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Yes I agree it has to be started with the write transaction, according of PCIe standard all write transaction are address routed, and I agree with Logan:
if in write transaction TLP the endpoint address written in header the TLP should not touch CPU, the PCIe Switch has to route it to endpoint.
The idea was: in MTCA system there is PCIe Switch on MCH (MTCA crate HUB) this switch connects CPU to other Crate Slots, so one port is Upstream and others are Downstream  ports, DMA read from CPU is usual write on endpoint side, Xilinx DMA core has two registers Destination Address and Source Address,
device driver to make DMA has to set up these registers,
usually device driver to start DMA read from Board sets Source address as FPGA memory address and Destination address is DMA prepared system address,
in case of testing p2p I set Destination address as physical address of other endpoint.
More detailed:
we have so called pcie universal driver: the idea behind is
1. all pcie configuration staff, find enabled BARs, mapping BARs, usual read/write and common ioctl (get slot number, get driver version ...) implemented in universal driver and EXPORTed.
2. if some system function in new kernel are changed we change it only in universal parts (easy support a big number of drivers )
so the universal driver something like PCIe Driver API
3. the universal driver provides read/writ functions so we have the same device access API for any PCIe device, we could use the same user application with any PCIe device

now. during BARs finding and mapping universal driver keeps pcie endpoint physical address in some internal structures, any top driver may get physical address
of other pcie endpoint by slot number.
in may case during get_resorce the physical address is 0xB2000000, I check lspci -H1 -vvvv -s psie switch port bus address (the endpoint connected to this port, checked by lspci -H1 -t) the same address (0xB200000) is the memory behind bridge, 
I want to make p2p writes to offset 0x40000, so I set DMA destination address 0xB2400000
is something wrong?

thanks for help
regards

Ludwig

----- Original Message -----
From: "Logan Gunthorpe" <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
To: "David Laight" <David.Laight-ZS65k/vG3HxXrIkS9f7CXA@public.gmane.org>, "Petrosyan, Ludwig" <ludwig.petrosyan-T5F83Mi6MZE@public.gmane.org>
Cc: "Alexander Deucher" <Alexander.Deucher-5C7GfCeVMHo@public.gmane.org>, "linux-kernel" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvdimm" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, "Linux-media" <Linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dri-devel" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "linux-pci" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "John Bridgman" <John.Bridgman-5C7GfCeVMHo@public.gmane.org>, "Felix Kuehling" <Felix.Kuehling-5C7GfCeVMHo@public.gmane.org>, "Serguei Sagalovitch" <Serguei.Sagalovitch-5C7GfCeVMHo@public.gmane.org>, "Paul Blinzer" <Paul.Blinzer-5C7GfCeVMHo@public.gmane.org>, "Christian Koenig" <Christian.Koenig-5C7GfCeVMHo@public.gmane.org>, "Suravee Suthikulpanit" <Suravee.Suthikulpanit-5C7GfCeVMHo@public.gmane.org>, "Ben Sander" <ben.sander-5C7GfCeVMHo@public.gmane.org>
Sent: Tuesday, 24 October, 2017 00:04:26
Subject: Re: Enabling peer to peer device transactions for PCIe devices

On 23/10/17 10:08 AM, David Laight wrote:
> It is also worth checking that the hardware actually supports p2p transfers.
> Writes are more likely to be supported then reads.
> ISTR that some intel cpus support some p2p writes, but there could easily
> be errata against them.

Ludwig mentioned a PCIe switch. The few switches I'm aware of support 
P2P transfers. So if everything is setup correctly, the TLPs shouldn't 
even touch the CPU.

But, yes, generally it's a good idea to start with writes and see if 
they work first.

Logan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
