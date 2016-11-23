From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Date: Wed, 23 Nov 2016 10:40:47 -0800
Message-ID: <CAPcyv4jsgrsQaeewFedUzcD1XLSQ8vQ5Zyr8EoB_5ORUqmL4nQ@mail.gmail.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <CAPcyv4i_5r2RVuV4F6V3ETbpKsf8jnMyQviZ7Legz3N4-v+9Og@mail.gmail.com>
 <75a1f44f-c495-7d1e-7e1c-17e89555edba@amd.com> <45c6e878-bece-7987-aee7-0e940044158c@deltatee.com>
 <eca737c1-415c-bcd4-80b9-628010638051@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <eca737c1-415c-bcd4-80b9-628010638051@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Logan Gunthorpe <logang@deltatee.com>, Serguei Sagalovitch <serguei.sagalovitch@amd.com>, "Deucher, Alexander" <Alexander.Deucher@amd.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "Kuehling, Felix" <Felix.Kuehling@amd.com>, "Bridgman, John" <John.Bridgman@amd.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "Koenig, Christian" <Christian.Koenig@amd.com>, "Sander, Ben" <ben.sander@amd.com>, "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>, "Blinzer, Paul" <Paul.Blinzer@amd.com>, "Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 23, 2016 at 9:27 AM, Bart Van Assche
<bart.vanassche@sandisk.com> wrote:
> On 11/23/2016 09:13 AM, Logan Gunthorpe wrote:
>>
>> IMO any memory that has been registered for a P2P transaction should be
>> locked from being evicted. So if there's a get_user_pages call it needs
>> to be pinned until the put_page. The main issue being with the RDMA
>> case: handling an eviction when a chunk of memory has been registered as
>> an MR would be very tricky. The MR may be relied upon by another host
>> and the kernel would have to inform user-space the MR was invalid then
>> user-space would have to tell the remote application.
>
>
> Hello Logan,
>
> Are you aware that the Linux kernel already supports ODP (On Demand Paging)?
> See also the output of git grep -nHi on.demand.paging. See also
> https://www.openfabrics.org/images/eventpresos/workshops2014/DevWorkshop/presos/Tuesday/pdf/04_ODP_update.pdf.
>

I don't think that was designed for the case where the backing memory
is a special/static physical address range rather than anonymous
"System RAM", right?

I think we should handle the graphics P2P concerns separately from the
general P2P-DMA case since the latter does not require the higher
order memory management facilities. Using ZONE_DEVICE/DAX mappings to
avoid changes to every driver that wants to support P2P-DMA separately
from typical DMA still seems the path of least resistance.
