From: Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: Re: [PATCH] PCI: Add no-D3 quirk for Mellanox ConnectX-[45]
Date: Wed, 9 Jan 2019 19:20:43 +1100
Message-ID: <0c8a9f73-82e7-2d8d-e490-2b6539c531ee@ozlabs.ru>
References: <20181206041951.22413-1-david@gibson.dropbear.id.au>
 <20181206064509.GM15544@mtr-leonro.mtl.com>
 <20190104034401.GA2801@umbus.fritz.box> <20190105175116.GB14238@ziepe.ca>
 <c1296ee9120a6a04dc75d0fdb2a641c722cb65d6.camel@kernel.crashing.org>
 <06c4612c-8409-ea7d-4f7c-4c010d8ecc01@ozlabs.ru>
 <f06efdd89b418ad831ee3a5da766f3f0a584050c.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <f06efdd89b418ad831ee3a5da766f3f0a584050c.camel@kernel.crashing.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Jason Gunthorpe <jgg@ziepe.ca>, David Gibson <david@gibson.dropbear.id.au>
Cc: Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, sbest@redhat.com, saeedm@mellanox.com, alex.williamson@redhat.com, paulus@samba.org, linux-pci@vger.kernel.org, bhelgaas@google.com, ogerlitz@mellanox.com, linuxppc-dev@lists.ozlabs.org, davem@davemloft.net, tariqt@mellanox.com
List-Id: linux-rdma@vger.kernel.org



On 09/01/2019 18:24, Benjamin Herrenschmidt wrote:
> On Wed, 2019-01-09 at 15:53 +1100, Alexey Kardashevskiy wrote:
>> "A PCI completion timeout occurred for an outstanding PCI-E transaction"
>> it is.
>>
>> This is how I bind the device to vfio:
>>
>> echo vfio-pci > '/sys/bus/pci/devices/0000:01:00.0/driver_override'
>> echo vfio-pci > '/sys/bus/pci/devices/0000:01:00.1/driver_override'
>> echo '0000:01:00.0' > '/sys/bus/pci/devices/0000:01:00.0/driver/unbind'
>> echo '0000:01:00.1' > '/sys/bus/pci/devices/0000:01:00.1/driver/unbind'
>> echo '0000:01:00.0' > /sys/bus/pci/drivers/vfio-pci/bind
>> echo '0000:01:00.1' > /sys/bus/pci/drivers/vfio-pci/bind
>>
>>
>> and I noticed that EEH only happens with the last command. The order
>> (.0,.1  or .1,.0) does not matter, it seems that putting one function to
>> D3 is fine but putting another one when the first one is already in D3 -
>> produces EEH. And I do not recall ever seeing this on the firestone
>> machine. Weird.
> 
> Putting all functions into D3 is what allows the device to actually go
> into D3.
> 
> Does it work with other devices ?

Works fine with on the very same garrison:

0009:07:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5719
Gigabit Ethernet PCIe (rev 01)
0009:07:00.1 Ethernet controller: Broadcom Corporation NetXtreme BCM5719
Gigabit Ethernet PCIe (rev 01)

Bizarre.

> We do have that bug on early P9
> revisions where the attempt of bringing the link to L1 as part of the
> D3 process fails in horrible ways, I thought P8 would be ok but maybe
> not ...

> Otherwise, it might be that our timeouts are too low (you may want to
> talk to our PCIe guys internally)

This increases "Outbound non-posted transactions timeout configuration"
from 16ms to 1s and does not help anyway:


diff --git a/hw/phb3.c b/hw/phb3.c
index 38b8f46..cb14909 100644
--- a/hw/phb3.c
+++ b/hw/phb3.c
@@ -4065,7 +4065,7 @@ static void phb3_init_utl(struct phb3 *p)
        /* Init_82: PCI Express port control
         * SW283991: Set Outbound Non-Posted request timeout to 16ms (RTOS).
         */
-       out_be64(p->regs + UTL_PCIE_PORT_CONTROL,
0x8588007000000000);
+       out_be64(p->regs + UTL_PCIE_PORT_CONTROL,
0x858800d000000000);

-- 
Alexey
