From: "Sagalovitch, Serguei" <Serguei.Sagalovitch-5C7GfCeVMHo@public.gmane.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Date: Thu, 24 Nov 2016 00:40:37 +0000
Message-ID: <SN1PR12MB0703CE07F4878243164299C4FEB70@SN1PR12MB0703.namprd12.prod.outlook.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <CAPcyv4i_5r2RVuV4F6V3ETbpKsf8jnMyQviZ7Legz3N4-v+9Og@mail.gmail.com>
 <75a1f44f-c495-7d1e-7e1c-17e89555edba@amd.com>
 <45c6e878-bece-7987-aee7-0e940044158c@deltatee.com>
 <20161123190515.GA12146@obsidianresearch.com>
 <7bc38037-b6ab-943f-59db-6280e16901ab@amd.com>
 <20161123193228.GC12146@obsidianresearch.com>
 <c2c88376-5ba7-37d1-4d3e-592383ebb00a@amd.com>
 <20161123203332.GA15062@obsidianresearch.com>
 <dd60bca8-0a35-7a3a-d3ab-b95bc3d9b973@deltatee.com>,
 <20161123215510.GA16311@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20161123215510.GA16311-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-CA
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Bridgman,
 John" <John.Bridgman-5C7GfCeVMHo@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "Kuehling,
 Felix" <Felix.Kuehling-5C7GfCeVMHo@public.gmane.org>, "Blinzer, Paul" <Paul.Blinzer-5C7GfCeVMHo@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "Sander,
 Ben" <ben.sander-5C7GfCeVMHo@public.gmane.org>, "Suthikulpanit,
 Suravee" <Suravee.Suthikulpanit-5C7GfCeVMHo@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Deucher,
 Alexander" <Alexander.Deucher-5C7GfCeVMHo@public.gmane.org>, "Koenig,
 Christian" <Christian.Koenig-5C7GfCeVMHo@public.gmane.org>, "Linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <Linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 23, 2016 at 02:11:29PM -0700, Logan Gunthorpe wrote:

> Perhaps I am not following what Serguei is asking for, but I
> understood the desire was for a complex GPU allocator that could
> migrate pages between GPU and CPU memory under control of the GPU
> driver, among other things. The desire is for DMA to continue to work
> even after these migrations happen.

The main issue is to  how to solve use cases when p2p is 
requested/initiated via CPU pointers where such pointers could 
point to non-system memory location e.g.  VRAM.  

It will allow to provide consistent working model for user to deal only
with pointers (HSA, CUDA, OpenCL 2.0 SVM) as well as provide 
performance optimization avoiding double-buffering and extra special code 
when dealing with PCIe device memory.

 Examples are:

 - RDMA Network operations.  RDMA MRs where registered memory 
could be e.g. VRAM.  Currently it is solved using so called PeerDirect  
interface which  is currently out-of-tree and  provided as part of OFED.
- File operations (fread/fwrite) when user wants to transfer file data directly 
to/from e.g. VRAM


Challenges are:
- Because graphics sub-system must support overcomit (at least each 
application/process should independently see all resources) ideally 
such memory should be movable without changing CPU pointer value
as well as "paged-out" supporting "page fault" at least on access from 
CPU.
 - We must co-exist with existing DRM infrastructure, as well as 
support sharing VRAM memory between different processes
- We should be able to deal with large allocations: tens, hundreds of 
MBs or may be GBs.
- We may have PCIe devices where p2p may not work
- Potentially any GPU memory should be supported including 
memory carved out from system RAM (e.g. allocated via
get_free_pages()).


Note:
-  In the case of RDMA MRs life-span of "pinning" 
(get_user_pages"/put_page) may be defined/controlled by 
application not kernel which  may be should 
treated differently as special case. 
  

Original proposal was to create "struct pages" for VRAM memory 
to allow "get_user_pages"  to work transparently similar 
how it is/was done for "DAX Device" case. Unfortunately 
based on my understanding "DAX Device" implementation 
deal only with permanently  "locked" memory  (fixed location) 
unrelated to "get_user_pages"/"put_page" scope  
which doesn't satisfy requirements  for "eviction" / "moving" of 
memory keeping CPU address intact.  

> The desire is for DMA to continue to work
> even after these migrations happen
At least some kind of mm notifier callback to inform about changing 
in location (pre- and post-) similar how it is done for system pages. 
My understanding is that It will not solve RDMA MR issue where "lock" 
could be during the whole  application life but  (a) it will not make 
RDMA MR case worse  (b) should be enough for all other cases for 
"get_user_pages"/"put_page" controlled by  kernel.
