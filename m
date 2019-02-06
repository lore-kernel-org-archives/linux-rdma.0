From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next v4 00/12] net: Introduce
 ndo_get_port_parent_id()
Date: Wed, 06 Feb 2019 13:50:50 -0800 (PST)
Message-ID: <20190206.135050.939253959263316807.davem@davemloft.net>
References: <20190206174546.23597-1-f.fainelli@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190206174546.23597-1-f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: f.fainelli@gmail.com
Cc: netdev@vger.kernel.org, idosch@mellanox.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, oss-drivers@netronome.com, devel@driverdev.osuosl.org, bridge@lists.linux-foundation.org
List-Id: linux-rdma@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Wed,  6 Feb 2019 09:45:34 -0800

> Based on discussion with Ido and feedback from Jakub there are clearly
> two classes of users that implement SWITCHDEV_ATTR_ID_PORT_PARENT_ID:
> 
> - PF/VF drivers which typically only implement return the port's parent
>   ID, yet have to implement switchdev_port_attr_get() just for that
> 
> - Ethernet switch drivers: mlxsw, ocelot, DSA, etc. which implement more
>   attributes which we want to be able to eventually veto in the context
>   of the caller, thus making them candidates for using a blocking notifier
>   chain
> 
> Changes in v4:
 ..

Series applied, thanks Florian.

I'll push this out to net-next after my build tests complete.
