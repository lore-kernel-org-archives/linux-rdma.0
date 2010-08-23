From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: IPoIB: Broken IGMP processing
Date: Mon, 23 Aug 2010 13:19:20 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1008231317150.10719@router.home>
References: <alpine.DEB.2.00.1008231210010.9840@router.home> <20100823174110.GK26549@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100823174110.GK26549-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Yossi Etigin <yosefe-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 23 Aug 2010, Jason Gunthorpe wrote:

> Hmmm... What are you trying to access here? I'm guessing it is the
> DGID of the GRH?
>
>         ipoib_ud_skb_put_frags(priv, skb, wc->byte_len);
>         skb_pull(skb, IB_GRH_BYTES);  <-- These are the bytes you want
>         skb_reset_mac_header(skb);  <-- Sets skb_mac_header to skb->head+40
>         skb_pull(skb, IPOIB_ENCAP_LEN);
>
> So, I think you are accessing byte 42, which doesn't seem right? The
> DGID starts in byte 24 from skb->head.
>
> Also, you need to check for IBV_WC_GRH, the 40 bytes are garbage if it
> is not set.

Trying to get the MGID information:

>From http://tools.ietf.org/html/draft-ietf-ipoib-link-multicast-00


7. The IPoIB All-Node Multicast and Broadcast Group

   Once an IB partition is created with link attributes identified for
   an IPoIB link, the network administrator must create a special IB
   multicast group for every node on the IPoIB link to join. This is
   achieved through the creation of "MCGroupRecord" in each IB subnet
   that the IB partition encompasses, as described in section 4 above.

   The MGID will have the P_Key of the IB partition that defines the
   IPoIB link embedded in it. A special signature is also embedded to
   identify the MGID for IPoIB use only. For IPv4 over IB, the signature
   will be "0x401B". For IPv6 over IB, the signature will be "0x601B".

   For an IPv4 subnet, the MGID for this special IB multicast group
   SHALL have the following format:

   |   8    |  4 |  4 |     16 bits     | 16 bits | 48 bits  | 32 bits |
   +--------+----+----+-----------------+---------+----------+---------+
   |11111111|0001|scop|<IPoIB signature>|< P_Key >|00.......0|<all 1's>|
   +--------+----+----+-----------------+---------+----------+---------+



Chu & Kashyap                                                   [Page 7]

draft-ietf-ipoib-link-multicast-00.txt                      January 2002


   For an IPv6 subnet, the format of the MGID SHALL look like this:

   |   8    |  4 |  4 |     16 bits     | 16 bits |       80 bits      |
   +--------+----+----+-----------------+---------+--------------------+
   |11111111|0001|scop|<IPoIB signature>|< P_Key >|000.............0001|
   +--------+----+----+-----------------+---------+--------------------+

   As for the scop bits, if the IPoIB link is fully contained within a
   single IB subnet, the scop bits SHALL be set to 2 (link-local).
   Otherwise the scope will be set higher.

   A MCGroupRecord will be created with all the IPoIB link attributes
   described before, including the link MTU, Q_Key, TClass, FlowLabel,
   and HopLimit. When a node is attached to an IPoIB link identified by
   a P_Key, it must look for a special, all-node multicast/broadcast
   group to join. This is done by constructing the MGID with the link
   P_Key and the IPoIB signature. The node SHOULD always look for a MGID
   of a link-local scope first before attempting one with a greater
   scope.

   Once the right MGID and MCGroupRecord are identified, the local node
   SHOULD use the link MTU recorded in the MCGroupRecord. It MUST accept
   a smaller MTU if one is advertised through the link MTU option of a
   router advertisement [DISC].

   In case the link MTU is greater than the maximum payload size that
   the local HCA can support, the node can not join the IPoIB link and
   operate as an IP node.

   After the right MTU is determined, the local node must join the
   special all-node multicast/broadcast group by calling the SA to
   create a MCMemberRecord corresponding to the MGID. The SA will return
   all the link attributes for the local node to use. The node MUST use
   these attributes in all future multicast operations to the local
   IPoIB link.  The broadcast group for IPv4 will serve to provide a
   broadcast service for protocol like ARP to use.

   In addition to the all-node multicast/broadcast group, an all-router
   multicast group SHOULD be created at link configuration time if an IP
   router will be attached to the link. This is to facilitate IP
   multicast operations described later. A MCGroupRecord for the all-
   router MGID must be created in every IB subnet that the IPoIB link
   encompasses. The format of the all-router MGID will be covered in
   next section.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
