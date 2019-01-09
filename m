From: Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: Re: [PATCH] PCI: Add no-D3 quirk for Mellanox ConnectX-[45]
Date: Wed, 9 Jan 2019 15:53:46 +1100
Message-ID: <06c4612c-8409-ea7d-4f7c-4c010d8ecc01@ozlabs.ru>
References: <20181206041951.22413-1-david@gibson.dropbear.id.au>
 <20181206064509.GM15544@mtr-leonro.mtl.com>
 <20190104034401.GA2801@umbus.fritz.box> <20190105175116.GB14238@ziepe.ca>
 <c1296ee9120a6a04dc75d0fdb2a641c722cb65d6.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <c1296ee9120a6a04dc75d0fdb2a641c722cb65d6.camel@kernel.crashing.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Jason Gunthorpe <jgg@ziepe.ca>, David Gibson <david@gibson.dropbear.id.au>
Cc: Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, sbest@redhat.com, saeedm@mellanox.com, alex.williamson@redhat.com, paulus@samba.org, linux-pci@vger.kernel.org, bhelgaas@google.com, ogerlitz@mellanox.com, linuxppc-dev@lists.ozlabs.org, davem@davemloft.net, tariqt@mellanox.com
List-Id: linux-rdma@vger.kernel.org



On 06/01/2019 09:43, Benjamin Herrenschmidt wrote:
> On Sat, 2019-01-05 at 10:51 -0700, Jason Gunthorpe wrote:
>>
>>> Interesting.  I've investigated this further, though I don't have as
>>> many new clues as I'd like.  The problem occurs reliably, at least on
>>> one particular type of machine (a POWER8 "Garrison" with ConnectX-4).
>>> I don't yet know if it occurs with other machines, I'm having trouble
>>> getting access to other machines with a suitable card.  I didn't
>>> manage to reproduce it on a different POWER8 machine with a
>>> ConnectX-5, but I don't know if it's the difference in machine or
>>> difference in card revision that's important.
>>
>> Make sure the card has the latest firmware is always good advice..
>>
>>> So possibilities that occur to me:
>>>   * It's something specific about how the vfio-pci driver uses D3
>>>     state - have you tried rebinding your device to vfio-pci?
>>>   * It's something specific about POWER, either the kernel or the PCI
>>>     bridge hardware
>>>   * It's something specific about this particular type of machine
>>
>> Does the EEH indicate what happend to actually trigger it?
> 
> In a very cryptic way that requires manual parsing using non-public
> docs sadly but yes. From the look of it, it's a completion timeout.
> 
> Looks to me like we don't get a response to a config space access
> during the change of D state. I don't know if it's the write of the D3
> state itself or the read back though (it's probably detected on the
> read back or a subsequent read, but that doesn't tell me which specific
> one failed).

It is write:

pci_write_config_word(dev, dev->pm_cap + PCI_PM_CTRL, pmcsr);


> 
> Some extra logging in OPAL might help pin that down by checking the InA
> error state in the config accessor after the config write (and polling
> on it for a while as from a CPU perspective I don't knw if the write is
> synchronous, probably not).


Extra logging gives these straight after that write:

nFir:        0000808000000000 0030006e00000000 0000800000000000

PhbSts:      0000001800000000 0000001800000000

Lem:         0000020000088000 42498e367f502eae 0000000000080000

OutErr:      0000002000000000 0000002000000000 0000000000000000
0000000000000000
InAErr:      0000000030000000 0000000020000000 8080000000000000
0000000000000000


Decoded (my fancy script):

nFir:        0000808000000000 0030006e00000000 0000800000000000

 |- PCI Nest Fault Isolation Register(FIR) NestBase+0x00 _BE_ =
0000808000000000h:
 |   [0..63] 00000000 00000000 10000000 10000000 00000000 00000000
00000000 00000000
 |   #16 set: The PHB had a severe error and has fenced the AIB
 |   #24 set: The internal SCOM to ASB bridge has an error
 |   #29..30: Error bit from SCOM FIR engine = 0h
 |- PCI Nest FIR Mask NestBase+0x03 _BE_ = 0030006e00000000h:
 |   [0..63] 00000000 00110000 00000000 01101110 00000000 00000000
00000000 00000000
 |   #10 set: Any PowerBus data hang poll error(Only checked for CI Stores)
 |   #11 set: Any PowerBus command hang error (domestic address range)
 |   #25 set: A command received ack_dead, foreign data hang, or
Link_chk_abort from the foreign interface
 |   #26 set: Any PowerBus command hang error (foreign address range)
 |   #28 set: Error bit from BARS SCOM engines, Nest domain
 |   #29..30: Error bit from SCOM FIR engine = 3h/[0..1] 11
 |- PCI Nest FIR WOF (“Who's on First”) NestBase+0x08 _BE_ =
0000800000000000h:
 |   [0..63] 00000000 00000000 10000000 00000000 00000000 00000000
00000000 00000000
 |   #16 set: The PHB had a severe error and has fenced the AIB
 |   #29..30: Error bit from SCOM FIR engine = 0h
 |
PhbSts:      0000001800000000 0000001800000000

 |- 0x0120 Processor Load/Store Status Register _BE_ = 0000001800000000h:
 |   [0..63] 00000000 00000000 00000000 00011000 00000000 00000000
00000000 00000000
 |   #27 set: One of the PHB3’s error status register bits is set
 |   #28 set: One of the PHB3’s first error status register bits is set
 |- 0x0110 DMA Channel Status Register _BE_ = 0000001800000000h:
 |   [0..63] 00000000 00000000 00000000 00011000 00000000 00000000
00000000 00000000
 |   #27 set: One of the PHB3’s error status register bits is set
 |   #28 set: One of the PHB3’s first error status register bits is set
 |
Lem:         0000020000088000 42498e367f502eae 0000000000080000

 |- 0xC00 LEM FIR Accumulator Register _BE_ = 0000020000088000h:
 |   [0..63] 00000000 00000000 00000010 00000000 00000000 00001000
10000000 00000000
 |   #22 set: CFG Access Error
 |   #44 set: PCT Timeout Error
 |   #48 set: PCT Unexpected Completion
 |- 0xC18 LEM Error Mask Register = 42498e367f502eaeh
 |- 0xC40 LEM WOF Register _BE_ = 0000000000080000h:
 |   [0..63] 00000000 00000000 00000000 00000000 00000000 00001000
00000000 00000000
 |   #44 set: PCT Timeout Error
 |
OutErr:      0000002000000000 0000002000000000 0000000000000000
0000000000000000
 |- 0xD00 Outbound Error Status Register _BE_ = 0000002000000000h:
 |   [0..63] 00000000 00000000 00000000 00100000 00000000 00000000
00000000 00000000
 |   #26 set: CFG Address/Enable Error
 |- 0xD08 Outbound First Error Status Register _BE_ = 0000002000000000h:
 |   [0..63] 00000000 00000000 00000000 00100000 00000000 00000000
00000000 00000000
 |   #26 set: CFG Address/Enable Error
 |
InAErr:      0000000030000000 0000000020000000 8080000000000000
0000000000000000
 |- 0xD80 InboundA Error Status Register _BE_ = 0000000030000000h:
 |   [0..63] 00000000 00000000 00000000 00000000 00110000 00000000
00000000 00000000
 |   #34 set: PCT Timeout
 |   #35 set: PCT Unexpected Completion
 |- 0xD88 InboundA First Error Status Register _BE_ = 0000000020000000h:
 |   [0..63] 00000000 00000000 00000000 00000000 00100000 00000000
00000000 00000000
 |   #34 set: PCT Timeout
 |- 0xDC0 InboundA Error Log Register 0 = 8080000000000000h


"A PCI completion timeout occurred for an outstanding PCI-E transaction"
it is.

This is how I bind the device to vfio:

echo vfio-pci > '/sys/bus/pci/devices/0000:01:00.0/driver_override'
echo vfio-pci > '/sys/bus/pci/devices/0000:01:00.1/driver_override'
echo '0000:01:00.0' > '/sys/bus/pci/devices/0000:01:00.0/driver/unbind'
echo '0000:01:00.1' > '/sys/bus/pci/devices/0000:01:00.1/driver/unbind'
echo '0000:01:00.0' > /sys/bus/pci/drivers/vfio-pci/bind
echo '0000:01:00.1' > /sys/bus/pci/drivers/vfio-pci/bind


and I noticed that EEH only happens with the last command. The order
(.0,.1  or .1,.0) does not matter, it seems that putting one function to
D3 is fine but putting another one when the first one is already in D3 -
produces EEH. And I do not recall ever seeing this on the firestone
machine. Weird.


-- 
Alexey
