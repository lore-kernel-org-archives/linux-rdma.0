From: Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net-next v3 11/12] net: dsa: Implement
 ndo_get_port_parent_id()
Date: Wed, 6 Feb 2019 14:27:07 +0100
Message-ID: <20190206132707.GK2189@nanopsycho>
References: <20190205235326.14600-1-f.fainelli@gmail.com>
 <20190205235326.14600-12-f.fainelli@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190205235326.14600-12-f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Ido Schimmel <idosch@mellanox.com>, open list <linux-kernel@vger.kernel.org>, "open list:MELLANOX MLX5 core VPI driver" <linux-rdma@vger.kernel.org>, "open list:NETRONOME ETHERNET DRIVERS" <oss-drivers@netronome.com>, "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>, "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>
List-Id: linux-rdma@vger.kernel.org

Wed, Feb 06, 2019 at 12:53:25AM CET, f.fainelli@gmail.com wrote:
>DSA implements SWITCHDEV_ATTR_ID_PORT_PARENT_ID and we want to get rid
>of switchdev_ops eventually, ease that migration by implementing a
>ndo_get_port_parent_id() function which returns what
>switchdev_port_attr_get() would do.
>
>Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
