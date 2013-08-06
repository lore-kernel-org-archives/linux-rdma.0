From: Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [PATCH v3.10.y 0/4] IB/IPoIB fixes for SRIOV / cloud environment
Date: Tue, 6 Aug 2013 14:22:43 +0300
Message-ID: <5200DC83.6030903@mellanox.com>
References: <1375778322-24408-1-git-send-email-ogerlitz@mellanox.com> <20130806093837.GC27889@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20130806093837.GC27889@kroah.com>
Sender: stable-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: roland@kernel.org, stable@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 06/08/2013 12:38, Greg KH wrote:
> On Tue, Aug 06, 2013 at 11:38:38AM +0300, Or Gerlitz wrote:
>> Hi Greg,
>>
>> This series contains few fixes to the IB core, mlx4 IB driver and IPoIB.
>>
>> The patches enable working properly with IPoIB devices set over SRIOV
>> Virtual Functions probed to VMs in cloud environment when the cloud
>> management system uses non trivial settings of IB PKEYs (Partition-Keys
>> , sort of Ethernet vlans equivalent).
> That really sounds like a new feature, and not a bugfix, for these devices, right?



Hi Greg,

well... not really

3eac103 IB/mlx4: Use default pkey when creating tunnel QPs
ef5ed41 IB/core: Create QP1 using the pkey index which contains the 
default pkey

are point bug fixes to code in the IB core and mlx4 IB driver which assumed
that the default IB Partition-Key is located in index 0 of the PKEY table,
which isn't necessarily the case in virtualization environments.

3d790a4 IPoIB: Make sure child devices use valid/proper pkeys

is bug fix to the IPoIB driver to make sure we disallow child device
creation with invalid IB PKEY

and finally

c290414 IPoIB: Fix pkey change flow for virtualization environments

is indeed a bit of heavier but is a fix, the text there saying

> IPoIB's required behaviour w.r.t to the pkey used by the device is the following:
>
> - For "parent" interfaces (e.g ib0, ib1, etc) who are created
>    automatically as a result of hot-plug events from the IB core, the
>    driver needs to take whatever pkey vlaue it finds in index 0, and
>    stick to that index.
>
> - For child interfaces (e.g ib0.8001, etc) created by admin directive,
>    the driver needs to use and stick to the value provided during its
>    creation.
>

came to describe the driver design and how it works when the bug doesn't 
trigger,
the patch itself fixes the driver to always work along this design


> I need an agreement from the IB maintainers that this really is stable
> material before I can accept it.

sure, fair enough, just wanted to shed more light on the matter.

Or.
