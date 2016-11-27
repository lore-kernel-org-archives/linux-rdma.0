From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Date: Sun, 27 Nov 2016 16:02:16 +0200
Message-ID: <d9e064a0-9c47-3e41-3154-cece8c70a119@mellanox.com>
References: <20161123190515.GA12146@obsidianresearch.com>
 <7bc38037-b6ab-943f-59db-6280e16901ab@amd.com>
 <20161123193228.GC12146@obsidianresearch.com>
 <c2c88376-5ba7-37d1-4d3e-592383ebb00a@amd.com>
 <20161123203332.GA15062@obsidianresearch.com>
 <dd60bca8-0a35-7a3a-d3ab-b95bc3d9b973@deltatee.com>
 <20161123215510.GA16311@obsidianresearch.com>
 <91d28749-bc64-622f-56a1-26c00e6b462a@deltatee.com>
 <20161124164249.GD20818@obsidianresearch.com>
 <3f2d2db3-fb75-2422-2a18-a8497fd5d70e@amd.com>
 <20161125193252.GC16504@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20161125193252.GC16504-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>
Cc: "Bridgman, John" <John.Bridgman-5C7GfCeVMHo@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "Kuehling,
 Felix" <Felix.Kuehling-5C7GfCeVMHo@public.gmane.org>, Serguei Sagalovitch <serguei.sagalovitch-5C7GfCeVMHo@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "Blinzer,
 Paul" <Paul.Blinzer-5C7GfCeVMHo@public.gmane.org>, "Suthikulpanit,
 Suravee" <Suravee.Suthikulpanit-5C7GfCeVMHo@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Deucher,
 Alexander" <Alexander.Deucher-5C7GfCeVMHo@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Sander, Ben" <ben.sander-5C7GfCeVMHo@public.gmane.org>, "Linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <Linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/25/2016 9:32 PM, Jason Gunthorpe wrote:
> On Fri, Nov 25, 2016 at 02:22:17PM +0100, Christian K=F6nig wrote:
>
>>> Like you say below we have to handle short lived in the usual way, and
>>> that covers basically every device except IB MRs, including the
>>> command queue on a NVMe drive.
>>
>> Well a problem which wasn't mentioned so far is that while GPUs do have a
>> page table to mirror the CPU page table, they usually can't recover from
>> page faults.
>
>> So what we do is making sure that all memory accessed by the GPU Jobs st=
ays
>> in place while those jobs run (pretty much the same pinning you do for t=
he
>> DMA).
>
> Yes, it is DMA, so this is a valid approach.
>
> But, you don't need page faults from the GPU to do proper coherent
> page table mirroring. Basically when the driver submits the work to
> the GPU it 'faults' the pages into the CPU and mirror translation
> table (instead of pinning).
>
> Like in ODP, MMU notifiers/HMM are used to monitor for translation
> changes. If a change comes in the GPU driver checks if an executing
> command is touching those pages and blocks the MMU notifier until the
> command flushes, then unfaults the page (blocking future commands) and
> unblocks the mmu notifier.
I think blocking mmu notifiers against something that is basically
controlled by user-space can be problematic. This can block things like
memory reclaim. If you have user-space access to the device's queues,
user-space can block the mmu notifier forever.

On PeerDirect, we have some kind of a middle-ground solution for pinning
GPU memory. We create a non-ODP MR pointing to VRAM but rely on
user-space and the GPU not to migrate it. If they do, the MR gets
destroyed immediately. This should work on legacy devices without ODP
support, and allows the system to safely terminate a process that
misbehaves. The downside of course is that it cannot transparently
migrate memory but I think for user-space RDMA doing that transparently
requires hardware support for paging, via something like HMM.

...

> I'm hearing most people say ZONE_DEVICE is the way to handle this,
> which means the missing remaing piece for RDMA is some kind of DMA
> core support for p2p address translation..

Yes, this is definitely something we need. I think Will Davis's patches
are a good start.

Another thing I think is that while HMM is good for user-space
applications, for kernel p2p use there is no need for that. Using
ZONE_DEVICE with or without something like DMA-BUF to pin and unpin
pages for the short duration as you wrote above could work fine for
kernel uses in which we can guarantee they are short.

Haggai
