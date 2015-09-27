From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RoCE RDMA CM handling after the demux patches
Date: Sun, 27 Sep 2015 11:44:55 +0300
Message-ID: <5607AC87.7070504@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

I noticed that the "Demux IB CM requests in the rdma_cm module" patches,
while intended to only apply to InfiniBand connections, accidentally
also affect RoCE connections. The patches used a query to IPoIB for the
netdev associated with a request, and RoCE devices therefore fail to
answer that query and reject all requests.

The long term solution would probably be to use the new RoCE GID table
cache to find the relevant netdev, but since the patches to expose the
netdev through the GID table API haven't been accepted yet, I'm working
on a patch that will just waive the requirement for a valid netdev on
RoCE devices.

Regards,
Haggai
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
