From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] iw_cxgb4: add INFINIBAND_ADDR_TRANS dependency
Date: Thu, 31 May 2018 00:40:54 +0200
Message-ID: <CAK8P3a3HZXTR60ua=cjBHnB5FWWKve9F-JqcNwn0ujks+=FsNg@mail.gmail.com>
References: <20180530215826.1343234-1-arnd@arndb.de> <20180530220405.GH30754@ziepe.ca>
 <0be4e0fb-8d8e-b337-fc8d-550c90829d8c@opengridcomputing.com>
 <20180530222520.GJ30754@ziepe.ca> <d2472443-3ae6-63f4-59ad-d6367b837038@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d2472443-3ae6-63f4-59ad-d6367b837038@opengridcomputing.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Steve Wise <swise@chelsio.com>, Doug Ledford <dledford@redhat.com>, Yuval Shaia <yuval.shaia@oracle.com>, linux-rdma <linux-rdma@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 31, 2018 at 12:29 AM, Steve Wise
<swise@opengridcomputing.com> wrote:
>
>
> On 5/30/2018 5:25 PM, Jason Gunthorpe wrote:
>> On Wed, May 30, 2018 at 05:10:35PM -0500, Steve Wise wrote:
>>>
>>> On 5/30/2018 5:04 PM, Jason Gunthorpe wrote:
>>>> On Wed, May 30, 2018 at 11:58:18PM +0200, Arnd Bergmann wrote:
>>>>> The newly added fill_res_ep_entry function fails to link if
>>>>> CONFIG_INFINIBAND_ADDR_TRANS is not set:
>>>>>
>>>>> drivers/infiniband/hw/cxgb4/restrack.o: In function `fill_res_ep_entry':
>>>>> restrack.c:(.text+0x3cc): undefined reference to `rdma_res_to_id'
>>>>> restrack.c:(.text+0x3d0): undefined reference to `rdma_iw_cm_id'
>>>>>
>>>>> This adds a Kconfig dependency for the driver.
>>>>>
>>>>> Fixes: 116aeb887371 ("iw_cxgb4: provide detailed provider-specific CM_ID information")
>>>>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>>>>>  drivers/infiniband/hw/cxgb4/Kconfig | 1 +
>>>>>  1 file changed, 1 insertion(+)
>>>> Oh, I think we need to solve this with maybe a header fill null stub
>>>> instead..
>>>>
>>>> We don't want to disable drivers just because a user interface is
>>>> disabled.
>>>>
>>> Why does CONFIG_INFINIBAND_ADDR_TRANS disable building rdma_cm.ko? That
>>> is not correct.
>> That seems like a reasonable thing to do..
> rdma_ucm.ko is for usermode users, rdma_cm.ko is for kernel users, and
> is required for iwarp drivers.  It seems rdma_cm.ko is not being
> compiled if ADDR_TRANS is not set.
>
>
>> But why does it break the compile? Those functions are in cma.c...
>>
>> Jason
>
> Indeed, why. :)
>
> Perhaps this line is wrong in drivers/infiniband/core/Makefile:
>
> infiniband-$(CONFIG_INFINIBAND_ADDR_TRANS)      := rdma_cm.o
>
> I don't understand the rules in that Makefile.

You need to look at these three lines:

infiniband-$(CONFIG_INFINIBAND_ADDR_TRANS)      := rdma_cm.o

obj-$(CONFIG_INFINIBAND) +=             ib_core.o ib_cm.o iw_cm.o \
                                        $(infiniband-y)

rdma_cm-y :=                    cma.o

cma.o is built into rdma_cm.ko if both CONFIG_INFINIBAND_ADDR_TRANS
and CONFIG_INFINIBAND are enabled. The first line is just another
syntax for writing

ifdef CONFIG_INFINIBAND_ADDR_TRANS
obj-$(CONFIG_INFINIBAND) += rdma_cm.o
endif

        Arnd
