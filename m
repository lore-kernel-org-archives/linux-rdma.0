From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/1] OpenSM: dfsssp - add support for multicast
Date: Fri, 03 May 2013 13:45:25 -0400
Message-ID: <5183F7B5.3010809@dev.mellanox.co.il>
References: <1367496926-6824-1-git-send-email-domke.j.aa@m.titech.ac.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1367496926-6824-1-git-send-email-domke.j.aa@m.titech.ac.jp>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Domke <domke.j.aa@m.titech.ac.jp>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Torsten Hoefler <htor-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/2/2013 8:15 AM, Jens Domke wrote:
> Recent tests on a large system revealed a problem with loops in the multicast routing.
> Using DFSSSP together with the default mcast routing algorithm of OpenSM can
> produce loops in the fabric.
> 
> This patch adds the mcast_build_stree function to the DFSSSP routing algorithm,
> so that DFSSSP is able to calculate the correct mcast forwarding tables for the
> subnet.
> 
> It almost does the same steps as the default mcast routing, except that it
> uses the Dijkstra algorithm to generate the spanning tree instead of using the
> hop count information given by the unicast routing.
> 
> General overview of the algorithm in pseudo-code:
> 1) identify the ports, which are part of the multicast group
> 2) find the 'best' switch (depending on the hop count) for the mcast group,
>    which can be used as a root of the spanning tree
> 3) perform a dijkstra step with the root switch as starting point
>    to generate a spanning tree to all other switches in the subnet
> 4) build the mcast forwarding tables for relevant switches:
>    4.1) select a switch which has mcast member ports connected to it
>    4.2) set the downstream ports for the mcast member ports in the mcft
>    4.3) traverse towards the root of the spanning tree and set up-/downstream
>         ports on this path for all involved switches
>    4.4) goto 4.1 until all switches have been processed
> 
> The same mcast algorithm will be used for SSSP, because SSSP has the potential to
> produce loops in the mcast forwarding table as well.
> 
> Signed-off-by: Jens Domke <domke.j.aa@m.titech.ac.jp>

Thanks. Applied.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
