From: Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next v4 12/12] net: Get rid of
 SWITCHDEV_ATTR_ID_PORT_PARENT_ID
Date: Wed, 6 Feb 2019 19:10:09 +0000
Message-ID: <20190206191001.GB14340@splinter>
References: <20190206174546.23597-1-f.fainelli@gmail.com>
 <20190206174546.23597-13-f.fainelli@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190206174546.23597-13-f.fainelli@gmail.com>
Content-Language: en-US
Content-ID: <45077B349C70DE4D981148D775C01A65@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>, open list <linux-kernel@vger.kernel.org>, "open list:MELLANOX MLX5 core VPI driver" <linux-rdma@vger.kernel.org>, "open list:NETRONOME ETHERNET DRIVERS" <oss-drivers@netronome.com>, "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>, "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 06, 2019 at 09:45:46AM -0800, Florian Fainelli wrote:
> Now that we have a dedicated NDO for getting a port's parent ID, get rid
> of SWITCHDEV_ATTR_ID_PORT_PARENT_ID and convert all callers to use the
> NDO exclusively. This is a preliminary change to getting rid of
> switchdev_ops eventually.
>=20
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Ido Schimmel <idosch@mellanox.com>
