From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [bug report] IB/rxe: Unblock loopback by moving skb_out increment
Date: Thu, 22 Dec 2016 15:54:43 +0300
Message-ID: <20161222125443.GA17758@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: andrew.boyer-8PEkshWhKlo@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Andrew Boyer,

This is a semi-automatic email about new static checker warnings.

The patch d38eb801aa14: "IB/rxe: Unblock loopback by moving skb_out 
increment" from Nov 23, 2016, leads to the following Smatch complaint:

drivers/infiniband/sw/rxe/rxe_net.c:458 send()
	 warn: variable dereferenced before check 'pkt->qp' (see line 441)

drivers/infiniband/sw/rxe/rxe_net.c
   440		nskb->destructor = rxe_skb_tx_dtor;
   441		nskb->sk = pkt->qp->sk->sk;
                           ^^^^^^^^^
Dereference.

   442	
   443		if (av->network_type == RDMA_NETWORK_IPV4) {
   444			err = ip_local_out(dev_net(skb_dst(skb)->dev), nskb->sk, nskb);
   445		} else if (av->network_type == RDMA_NETWORK_IPV6) {
   446			err = ip6_local_out(dev_net(skb_dst(skb)->dev), nskb->sk, nskb);
   447		} else {
   448			pr_err("Unknown layer 3 protocol: %d\n", av->network_type);
   449			kfree_skb(nskb);
   450			return -EINVAL;
   451		}
   452	
   453		if (unlikely(net_xmit_eval(err))) {
   454			pr_debug("error sending packet: %d\n", err);
   455			return -EAGAIN;
   456		}
   457	
   458		if (pkt->qp)
                    ^^^^^^^

New check.

   459			atomic_inc(&pkt->qp->skb_out);
   460		kfree_skb(skb);

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
