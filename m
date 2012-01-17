From: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 0/4] add RAW Packet QP type
Date: Tue, 17 Jan 2012 15:30:20 +0000
Message-ID: <7C4248CAE043B144B1CD242D2756265305E598@IRSMSX102.ger.corp.intel.com>
References: <alpine.LRH.2.00.1201171330540.24946@ogerlitz.voltaire.com>
 <4F158ED7.3080405@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F158ED7.3080405-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

According VLANs, for RAW QP better solution is allowing inserting VLANs per packet by adding new flags to ib_post_send with special field containing VLAN ID.

On ingress, it would be interesting to see the ingress VLAN in CQE, by introducing a new field and flags indicating VLAN appearance.

As Steve mentioned, the HW checksum offload is necessary also in the API for sending IP fragments. When IP packet is not fragmented it is necessary to send it with L4/L3 sum computed by HW. And when fragments are sent the L3 only csum computation is requested.

Regards,

Mirek


-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Steve Wise
Sent: Tuesday, January 17, 2012 4:08 PM
To: Or Gerlitz
Cc: Roland Dreier; linux-rdma; Christoph Lameter; Liran Liss
Subject: Re: [PATCH 0/4] add RAW Packet QP type


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
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
