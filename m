From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 2/5] OpenSM: dfsssp - send multicast forwarding tables
 to switches
Date: Mon, 07 Oct 2013 08:42:57 -0400
Message-ID: <5252AC51.9070404@dev.mellanox.co.il>
References: <1380812586-1583-1-git-send-email-domke.j.aa@m.titech.ac.jp> <1380812586-1583-2-git-send-email-domke.j.aa@m.titech.ac.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1380812586-1583-2-git-send-email-domke.j.aa@m.titech.ac.jp>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Domke <domke.j.aa@m.titech.ac.jp>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Torsten Hoefler <htor-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/3/2013 11:03 AM, Jens Domke wrote:
> Issue: root switch of the mcast spanning tree was ignored.
> When a port of the root switch is part of the mcast group, then
> it won't be processed and non of its ports will be part of
> the resulting mcast forwarding table.
> 
> Fix: remove the test for used_link==NULL, because all switches in
> adj_list should have a used_link set by the prior dijkstra step
> (except the root switch) => test not needed and root switch will
> be included in mcast update.
> 
> Signed-off-by: Jens Domke <domke.j.aa@m.titech.ac.jp>

Thanks. Applied.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
