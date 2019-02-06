From: Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next v3 00/12] net: Introduce ndo_get_port_parent_id()
Date: Wed, 6 Feb 2019 07:51:38 +0000
Message-ID: <20190206075136.GA2283@splinter>
References: <20190205235326.14600-1-f.fainelli@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190205235326.14600-1-f.fainelli@gmail.com>
Content-Language: en-US
Content-ID: <388E482218ED4E428D59B4AC8420E216@eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>, open list <linux-kernel@vger.kernel.org>, "open list:MELLANOX MLX5 core VPI driver" <linux-rdma@vger.kernel.org>, "open list:NETRONOME ETHERNET DRIVERS" <oss-drivers@netronome.com>, "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>, "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 05, 2019 at 03:53:14PM -0800, Florian Fainelli wrote:
> Hi all,
>=20
> Based on discussion with Ido and feedback from Jakub there are clearly
> two classes of users that implement SWITCHDEV_ATTR_ID_PORT_PARENT_ID:
>=20
> - PF/VF drivers which typically only implement return the port's parent
>   ID, yet have to implement switchdev_port_attr_get() just for that
>=20
> - Ethernet switch drivers: mlxsw, ocelot, DSA, etc. which implement more
>   attributes which we want to be able to eventually veto in the context
>   of the caller, thus making them candidates for using a blocking notifie=
r
>   chain

Florian, patches look good to me. I'm going to build a kernel with these
patches and run some tests. Will report later today.

Thanks
