From: Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next v4 05/12] mlxsw: Implement
 ndo_get_port_parent_id()
Date: Wed, 6 Feb 2019 19:04:41 +0000
Message-ID: <20190206190434.GA14340@splinter>
References: <20190206174546.23597-1-f.fainelli@gmail.com>
 <20190206174546.23597-6-f.fainelli@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190206174546.23597-6-f.fainelli@gmail.com>
Content-Language: en-US
Content-ID: <E4EC5A764CE1EA4D9DF8CA9C5BBB1C95@eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>, open list <linux-kernel@vger.kernel.org>, "open list:MELLANOX MLX5 core VPI driver" <linux-rdma@vger.kernel.org>, "open list:NETRONOME ETHERNET DRIVERS" <oss-drivers@netronome.com>, "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>, "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 06, 2019 at 09:45:39AM -0800, Florian Fainelli wrote:
> mlxsw implements SWITCHDEV_ATTR_ID_PORT_PARENT_ID and we want to get rid
> of switchdev_ops eventually, ease that migration by implementing a
> ndo_get_port_parent_id() function which returns what
> switchdev_port_attr_get() would do.
>=20
> Acked-by: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Ido Schimmel <idosch@mellanox.com>
