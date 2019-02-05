From: Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH 00/12] net: Introduce ndo_get_port_parent_id()
Date: Tue, 5 Feb 2019 07:14:48 +0000
Message-ID: <20190205071445.GA7480@splinter>
References: <20190204233633.20421-1-f.fainelli@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <bridge-bounces@lists.linux-foundation.org>
In-Reply-To: <20190204233633.20421-1-f.fainelli@gmail.com>
Content-Language: en-US
Content-ID: <ECBD11B2DF016D478251E6C06304F55A@eurprd05.prod.outlook.com>
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
Cc: Andrew Lunn <andrew@lunn.ch>, Alexandre Belloni <alexandre.belloni@bootlin.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, John Hurley <john.hurley@netronome.com>, "open list:NETRONOME ETHERNET DRIVERS" <oss-drivers@netronome.com>, Eric Dumazet <edumazet@google.com>, Ioana Ciornei <ioana.ciornei@nxp.com>, Tyler Hicks <tyhicks@canonical.com>, Ivan Vecera <ivecera@redhat.com>, David Ahern <dsahern@gmail.com>, Ioana Radulescu <ruxandra.radulescu@nxp.com>, "open list:MELLANOX MLX5 core VPI driver" <linux-rdma@vger.kernel.org>, "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>, Amritha Nambiar <amritha.nambiar@intel.com>, Saeed Mahameed <saeedm@mellanox.com>, Dirk van der Merwe <dirk.vandermerwe@netronome.com>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Vivien Didelot <vivien.didelot@gmail.com>, Alexander Duyck <alexander.h.duyck@intel.com>open li
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 04, 2019 at 03:36:21PM -0800, Florian Fainelli wrote:
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

Florian, thanks for working on this.

I think you're missing implementation over stacked devices. At least
8021q, bond and team need to implement this ndo as well. For bond and
team we can return an error if not all the slaves have the same parent
ID. It would be consistent with what switchdev_port_attr_get() is doing.
