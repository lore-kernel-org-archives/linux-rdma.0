From: Jiri Pirko <jiri@resnulli.us>
Subject: Re: [RFC net-next 00/13] Get rid of switchdev_ops
Date: Sat, 2 Feb 2019 16:52:31 +0100
Message-ID: <20190202155231.GD2778@nanopsycho>
References: <20190201220657.30170-1-f.fainelli@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190201220657.30170-1-f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: netdev@vger.kernel.org, Michael Chan <michael.chan@broadcom.com>, "David S. Miller" <davem@davemloft.net>, Derek Chickles <dchickles@marvell.com>, Satanand Burla <sburla@marvell.com>, Felix Manlunas <fmanlunas@marvell.com>, Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Jiri Pirko <jiri@mellanox.com>, Ido Schimmel <idosch@mellanox.com>, Alexandre Belloni <alexandre.belloni@bootlin.com>, Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Ioana Radulescu <ruxandra.radulescu@nxp.com>, Ioana Ciornei <ioana.ciornei@nxp.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ivan Vecera <ivecera@redhat.com>, Andrew Lunn <andrew@lunn.ch>, Vivien Didelot <vivien.didelot@gmail.com>
List-Id: linux-rdma@vger.kernel.org

Fri, Feb 01, 2019 at 11:06:44PM CET, f.fainelli@gmail.com wrote:
>Hi all,
>
>This patch series converts SWITCHDEV_PORT_ATTR_{GET,SET} to use a
>blocking notifier, similar to how SWITCHDEV_PORT_OBJ_{ADD,DEL} has been
>changed recently by Petr.
>
>This was suggested by Ido to help with a particular use case I have
>where I want to be able to veto a switchdev bridge attribute from a
>driver (multicast_snooping).
>
>Please review since I may not have gotten the driver abstraction right,
>especially for mlx5e and nfp since these are *hum* *hum* large drivers.

Looks fine. Thanks!
