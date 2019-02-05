From: Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCH 09/12] netdevsim: Implement
	ndo_get_port_parent_id()
Date: Mon, 4 Feb 2019 19:51:26 -0800
Message-ID: <20190204195126.7749ebaa@cakuba.netronome.com>
References: <20190204233633.20421-1-f.fainelli@gmail.com>
	<20190204233633.20421-10-f.fainelli@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <bridge-bounces@lists.linux-foundation.org>
In-Reply-To: <20190204233633.20421-10-f.fainelli@gmail.com>
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
Cc: Andrew Lunn <andrew@lunn.ch>, Alexandre Belloni <alexandre.belloni@bootlin.com>, John Hurley <john.hurley@netronome.com>, "open
	list:NETRONOME ETHERNET DRIVERS" <oss-drivers@netronome.com>, Eric Dumazet <edumazet@google.com>, Ioana Ciornei <ioana.ciornei@nxp.com>, Tyler Hicks <tyhicks@canonical.com>, Ivan Vecera <ivecera@redhat.com>, David Ahern <dsahern@gmail.com>, Ioana Radulescu <ruxandra.radulescu@nxp.com>, "open
	list:MELLANOX MLX5 core VPI driver" <linux-rdma@vger.kernel.org>, "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>, Amritha Nambiar <amritha.nambiar@intel.com>, Saeed Mahameed <saeedm@mellanox.com>, Dirk van der Merwe <dirk.vandermerwe@netronome.com>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Vivien Didelot <vivien.didelot@gmail.com>, Alexander Duyck <alexander.h.duyck@intel.com>, "open
	list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.or>
List-Id: linux-rdma@vger.kernel.org

On Mon,  4 Feb 2019 15:36:30 -0800, Florian Fainelli wrote:
> netdevsim only supports SWITCHDEV_ATTR_ID_PORT_PARENT_ID, which makes it a
> great candidate to be converted to use the ndo_get_port_parent_id() NDO
> instead of implementing switchdev_port_attr_get().
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
