From: Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH] mlx4_en: show device's port used
Date: Tue, 25 May 2010 09:55:47 -0700
Message-ID: <adaaarnzzsc.fsf@roland-alpha.cisco.com>
References: <20100525135548.GA12749@mtldesk030.lab.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20100525135548.GA12749@mtldesk030.lab.mtl.com> (Eli Cohen's
	message of "Tue, 25 May 2010 16:55:48 +0300")
Sender: netdev-owner@vger.kernel.org
To: Eli Cohen <eli@mellanox.co.il>
Cc: davem@davemloft.net, netdev@vger.kernel.org, Linux RDMA list <linux-rdma@vger.kernel.org>, yevgenyp@mellanox.co.il
List-Id: linux-rdma@vger.kernel.org

 > Add a sysfs file under /sys/class/net/<ethx> to show the port number within the
 > device that this network interface is using. This is needed as ConnectX devices
 > have two ports and it is useful to know which port the ethernet devices uses.

How do other multi-port ethernet devices handle this?  Seems that the
cleanest way to handle this would be to add a place for drivers to set
the port number, and export it to userspace in generic code (so everyone
does it the same way).
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
