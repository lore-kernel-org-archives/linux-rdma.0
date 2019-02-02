From: Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [RFC net-next 11/13] nfp: Handle SWITCHDEV_PORT_ATTR_GET event
Date: Fri, 1 Feb 2019 19:45:41 -0800
Message-ID: <20190201194541.49754fbf@cakuba.hsd1.ca.comcast.net>
References: <20190201220657.30170-1-f.fainelli@gmail.com>
        <20190201220657.30170-12-f.fainelli@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190201220657.30170-12-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: netdev@vger.kernel.org, Michael Chan <michael.chan@broadcom.com>, "David S. Miller" <davem@davemloft.net>, Derek Chickles <dchickles@marvell.com>, Satanand Burla <sburla@marvell.com>, Felix Manlunas <fmanlunas@marvell.com>, Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Jiri Pirko <jiri@mellanox.com>, Ido Schimmel <idosch@mellanox.com>, Alexandre Belloni <alexandre.belloni@bootlin.com>, Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>, Ioana Radulescu <ruxandra.radulescu@nxp.com>, Ioana Ciornei <ioana.ciornei@nxp.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ivan Vecera <ivecera@redhat.com>, Andrew Lunn <andrew@lunn.ch>, Vivien Didelot <vivien.didelot@gmail.com>, Dirk van der Merwe <dirk.vandermerwe@netronome.c>
List-Id: linux-rdma@vger.kernel.org

On Fri,  1 Feb 2019 14:06:55 -0800, Florian Fainelli wrote:
> Following patches will change the way we communicate getting or setting
> a port's attribute and use a blocking notifier to perform those tasks.
> 
> Prepare nfp to support receiving notifier events targeting
> SWITCHDEV_PORT_ATTR_GET and simply translate that into the existing
> switchdev_ops::switchdev_port_attr_get operation.
> 
> We register a single blocking switchdev notifier for the entire driver
> instance and we differentiate a "net" from a "repr" by comparing the
> network device's netdev_ops with the ones that this driver manages.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks Florian, the code looks good, only nit I have is - could you
move nfp_switchdev_blocking_event() to nfp_port.c and nfp_port.h?
We shouldn't touch nfp_net_common.c here.

In general calling a notifier to get the parent_id (which is the only
thing all these SR-IOV NIC drivers implement) seems a tad heavy.  It's
an immutable, read-only attribute of a port, perhaps we can break it
out?  Could we make it an NDO, perhaps?

That's just my knee jerk reaction, given that NIC drivers don't
implement any of the bridging side of switchdev I may not have a full
appreciation of the abstraction you are building here :)
