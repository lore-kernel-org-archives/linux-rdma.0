From: Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next v4 01/12] net: Introduce
	ndo_get_port_parent_id()
Date: Wed, 6 Feb 2019 19:10:56 +0000
Message-ID: <20190206191054.GC14340@splinter>
References: <20190206174546.23597-1-f.fainelli@gmail.com>
	<20190206174546.23597-2-f.fainelli@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <bridge-bounces@lists.linux-foundation.org>
In-Reply-To: <20190206174546.23597-2-f.fainelli@gmail.com>
Content-Language: en-US
Content-ID: <F9E0D70EE9EB1A47BA821502865FCAE1@eurprd05.prod.outlook.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/bridge>,
	<mailto:bridge-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/bridge/>
List-Post: <mailto:bridge@lists.linux-foundation.org>
List-Help: <mailto:bridge-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/bridge>,
	<mailto:bridge-request@lists.linux-foundation.org?subject=subscribe>
Sender: bridge-bounces@lists.linux-foundation.org
Errors-To: bridge-bounces@lists.linux-foundation.org
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>, "open
	list:MELLANOX MLX5 core VPI driver" <linux-rdma@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "moderated
	list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>, open list <linux-kernel@vger.kernel.org>, "open
	list:NETRONOME ETHERNET DRIVERS" <oss-drivers@netronome.com>, "David S. Miller" <davem@davemloft.net>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 06, 2019 at 09:45:35AM -0800, Florian Fainelli wrote:
> In preparation for getting rid of switchdev_ops, create a dedicated NDO
> operation for getting the port's parent identifier. There are
> essentially two classes of drivers that need to implement getting the
> port's parent ID which are VF/PF drivers with a built-in switch, and
> pure switchdev drivers such as mlxsw, ocelot, dsa etc.
>=20
> We introduce a helper function: dev_get_port_parent_id() which supports
> recursion into the lower devices to obtain the first port's parent ID.
>=20
> Convert the bridge, core and ipv4 multicast routing code to check for
> such ndo_get_port_parent_id() and call the helper function when valid
> before falling back to switchdev_port_attr_get(). This will allow us to
> convert all relevant drivers in one go instead of having to implement
> both switchdev_port_attr_get() and ndo_get_port_parent_id() operations,
> then get rid of switchdev_port_attr_get().
>=20
> Acked-by: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Ido Schimmel <idosch@mellanox.com>
