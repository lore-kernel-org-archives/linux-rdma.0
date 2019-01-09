From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] PCI: Add no-D3 quirk for Mellanox ConnectX-[45]
Date: Wed, 09 Jan 2019 18:24:00 +1100
Message-ID: <f06efdd89b418ad831ee3a5da766f3f0a584050c.camel@kernel.crashing.org>
References: <20181206041951.22413-1-david@gibson.dropbear.id.au>
 <20181206064509.GM15544@mtr-leonro.mtl.com>
 <20190104034401.GA2801@umbus.fritz.box> <20190105175116.GB14238@ziepe.ca>
 <c1296ee9120a6a04dc75d0fdb2a641c722cb65d6.camel@kernel.crashing.org>
 <06c4612c-8409-ea7d-4f7c-4c010d8ecc01@ozlabs.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <06c4612c-8409-ea7d-4f7c-4c010d8ecc01@ozlabs.ru>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Alexey Kardashevskiy <aik@ozlabs.ru>, Jason Gunthorpe <jgg@ziepe.ca>, David Gibson <david@gibson.dropbear.id.au>
Cc: Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, sbest@redhat.com, saeedm@mellanox.com, alex.williamson@redhat.com, paulus@samba.org, linux-pci@vger.kernel.org, bhelgaas@google.com, ogerlitz@mellanox.com, linuxppc-dev@lists.ozlabs.org, davem@davemloft.net, tariqt@mellanox.com
List-Id: linux-rdma@vger.kernel.org

On Wed, 2019-01-09 at 15:53 +1100, Alexey Kardashevskiy wrote:
> "A PCI completion timeout occurred for an outstanding PCI-E transaction"
> it is.
> 
> This is how I bind the device to vfio:
> 
> echo vfio-pci > '/sys/bus/pci/devices/0000:01:00.0/driver_override'
> echo vfio-pci > '/sys/bus/pci/devices/0000:01:00.1/driver_override'
> echo '0000:01:00.0' > '/sys/bus/pci/devices/0000:01:00.0/driver/unbind'
> echo '0000:01:00.1' > '/sys/bus/pci/devices/0000:01:00.1/driver/unbind'
> echo '0000:01:00.0' > /sys/bus/pci/drivers/vfio-pci/bind
> echo '0000:01:00.1' > /sys/bus/pci/drivers/vfio-pci/bind
> 
> 
> and I noticed that EEH only happens with the last command. The order
> (.0,.1  or .1,.0) does not matter, it seems that putting one function to
> D3 is fine but putting another one when the first one is already in D3 -
> produces EEH. And I do not recall ever seeing this on the firestone
> machine. Weird.

Putting all functions into D3 is what allows the device to actually go
into D3.

Does it work with other devices ? We do have that bug on early P9
revisions where the attempt of bringing the link to L1 as part of the
D3 process fails in horrible ways, I thought P8 would be ok but maybe
not ...

Otherwise, it might be that our timeouts are too low (you may want to
talk to our PCIe guys internally)

Cheers,
Ben.
