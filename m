From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 09/10] IB/mlx4: Add timestamp_mask and hca_core_clock
 to query_device
Date: Thu, 28 May 2015 10:04:04 +0300
Message-ID: <5566BDE4.50709@mellanox.com>
References: <CAJ3xEMgppUPqOFm7L0+fR3z_N2ALZFb+GpSAGvyyNROZoFCUPA@mail.gmail.com>
 <CAJ3xEMinNsQrmQ7atAVkshefBDBQ1HRuGbOT_cJ4RxEj4dWUPA@mail.gmail.com>
 <20150526160624.GA11800@obsidianresearch.com>
 <CAJ3xEMj5qphSq5QQHKPsihuK6StmJ+NHiPbkY-ZVGmpViB1AXA@mail.gmail.com>
 <20150526185315.GF11800@obsidianresearch.com>
 <CAJ3xEMh7JYN8sP5MYdVjH=tqPFURwvD7jVvV0=PBiEn1qEFi2A@mail.gmail.com>
 <20150526220724.GC4502@obsidianresearch.com>
 <CAJ3xEMgdqBnn6hobRJFut6Nyu2pKt40rb46Z3dYx3MaohR2urA@mail.gmail.com>
 <20150527184856.GA16059@obsidianresearch.com>
 <CAJ3xEMh_g0zBza5HoVZTy9cTRbXqatzvBMAJcRjQhH7Zi=cHAg@mail.gmail.com>
 <20150527222108.GA7855@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150527222108.GA7855-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/28/2015 1:21 AM, Jason Gunthorpe wrote:
> exists to support a unique feature of a single hardware vendor that few understand the use case for

Responding in EIM (End In Mind) manner

The use case is very clear, low latency applications using UD or RAW 
PACKET QPs that needs to know the time it takes for different HW/SW 
layers to get their packets through. The verbs version of SO_TIMESTAMP 
and friends (Documentation/networking/timestamping*)-- Christoph, can 
you add some info on common use-cases for this?

I bet that > 20 upstream Eth NIC drivers supports time-stamping, so 
there's no reason that a modern HCA will not support it too.

> It is 11 patches, long, introduces several UAPI changes,

      1  IB/core: Change provider's API of create_cq to be extendible
      2  IB/core: Change ib_create_cq to use struct ib_cq_init_attr
      3  IB/core: Add CQ creation time-stamping flag
      4  IB/core: Extend ib_uverbs_create_cq
      5  IB/core: Add timestamp_mask and hca_core_clock to query_device
      6  IB/core: Pass hardware specific data in query_device
      7  IB/mlx4: Add mmap call to map the hardware clock
      8  IB/mlx4: Support extended create_cq and query_device uverbs
      9  IB/mlx4: Add support for timestamp in cq creation
     10  IB/mlx4: Add timestamp_mask and hca_core_clock to query_device
     11  IB/mlx4: Return hca core clock's offset in query_device 
vendor's data

01-02 just cosmetics that don't add any new functionality
03    adding CQ creation flag to the kernel verbs
04    new uverbs API to extend CQ creation
05    extending uverbs query device to return two more values
06    small fix to missing udata mechanics in uverbs query device
07-11 mlx4 provider side of the CQ setup and clock mmaping to user-space

the core of the review should be around the 03-06 zone, and with experts 
such as
Yann (and you) the uverbs part shouldn't be too complex to review and 
fix if needed.

> does not implement a standardized feature,

This is standard in Eth NIC, return the time-stamp of when the packet 
arrived/sent


> adds new uses of latent kernel functions

ESL I am

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
