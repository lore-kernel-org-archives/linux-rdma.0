From: Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCH 07/12] nfp: Implement ndo_get_port_parent_id()
Date: Mon, 4 Feb 2019 19:49:25 -0800
Message-ID: <20190204194925.7c1f56e2@cakuba.netronome.com>
References: <20190204233633.20421-1-f.fainelli@gmail.com>
 <20190204233633.20421-8-f.fainelli@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20190204233633.20421-8-f.fainelli@gmail.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Alexandre Belloni <alexandre.belloni@bootlin.com>, John Hurley <john.hurley@netronome.com>, "open
 list:NETRONOME ETHERNET DRIVERS" <oss-drivers@netronome.com>, Eric Dumazet <edumazet@google.com>, Ioana Ciornei <ioana.ciornei@nxp.com>, Tyler Hicks <tyhicks@canonical.com>, Ivan Vecera <ivecera@redhat.com>, David Ahern <dsahern@gmail.com>, "open
 list:MELLANOX MLX5 core VPI driver" <linux-rdma@vger.kernel.org>, "moderated
 list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>, Amritha Nambiar <amritha.nambiar@intel.com>, Saeed Mahameed <saeedm@mellanox.com>, Dirk van der Merwe <dirk.vandermerwe@netronome.com>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Petr Machata <petrm@mellanox.com>, Vivien Didelot <vivien.didelot@gmail.com>, Alexander Duyck <alexander.h.duyck@intel.com>, "open
 list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>, Daniel
List-Id: linux-rdma@vger.kernel.org

On Mon,  4 Feb 2019 15:36:28 -0800, Florian Fainelli wrote:
> NFP only supports SWITCHDEV_ATTR_ID_PORT_PARENT_ID, which makes it a
> great candidate to be converted to use the ndo_get_port_parent_id() NDO
> instead of implementing switchdev_port_attr_get().
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Very nice!!  Hopefully nobody hates this approach :)
