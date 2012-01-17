From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH 0/4] add RAW Packet QP type
Date: Tue, 17 Jan 2012 09:08:07 -0600
Message-ID: <4F158ED7.3080405@opengridcomputing.com>
References: <alpine.LRH.2.00.1201171330540.24946@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1201171330540.24946-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On 01/17/2012 05:34 AM, Or Gerlitz wrote:
> The new qp type designated usage is from user-space in Ethernet environments,
> e.g by applications that do TCP/IP offloading. Only processes with the NET_RAW
> capability may open such qp. The name raw packet was selected to resemble the
> similarity to AF_PACKET / SOL_RAW sockets. Applications that use this qp type
> should deal with whole packets, including link level headers.
>
> This series allows to create such QPs and send packets over them. To receive
> packets, flow steering support has to be added to the verbs and low-level
> drivers. Flow Steering is the ability to program the HCA to direct a packet
> which matches a given flow specification to a given QP. Flow specs set by
> applications are typically made of L3 (IP) and L4 (TCP/UDP) based tuples,
> where network drivers typically use L2 based tuples. Core and mlx4 patches
> for flow steering are expected in the coming weeks.

Hey Or,

I think this series should add some new send flags for HW that does checksum offload:

For example, cxgb4 supports these:

enum {                     /* TX_PKT_XT checksum types */
         TX_CSUM_TCP    = 0,
         TX_CSUM_UDP    = 1,
         TX_CSUM_CRC16  = 4,
         TX_CSUM_CRC32  = 5,
         TX_CSUM_CRC32C = 6,
         TX_CSUM_FCOE   = 7,
         TX_CSUM_TCPIP  = 8,
         TX_CSUM_UDPIP  = 9,
         TX_CSUM_TCPIP6 = 10,
         TX_CSUM_UDPIP6 = 11,
         TX_CSUM_IP     = 12,
};

I'm sure mlx4 has this sort of functionality too?

Another form of HW assist is with VLAN insertion/extraction.  The API should provide a way to specify if a VLAN ID 
should be inserted by HW and removed from a packet on ingress (and passed to the app via the CQE).  In fact, we probably 
want a way to associate a VLAN with a RAW QP, maybe as a QP attribute?

Also, on ingress, most hardware can do INET checksum validation, and a way to indicate the results to the application is 
needed.  Perhaps flags in the CQE?  The cxgb4 device provides many fields on a ingress packet completion that would be 
useful for user mode applications including indications of MAC RX errors, protocol length vs packet length mismatches, 
IP version not 4 or 6, and more.  Does mlx4 has these sorts of indications on ingress packet CQEs?

Food for thought.

Steve.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
