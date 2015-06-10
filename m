From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] IB/ipoib: Scatter-Gather support in connected mode
Date: Wed, 10 Jun 2015 19:02:23 +0300
Message-ID: <20150610160223.GB2546@yuval-lab>
References: <1431338642-22812-1-git-send-email-yuval.shaia@oracle.com>
 <CAAk-MO__VpkfV341o_BVOj_3t2xh+0HNwjQ7kmTYGSsqv3ngug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAk-MO__VpkfV341o_BVOj_3t2xh+0HNwjQ7kmTYGSsqv3ngug-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: john.sobecki-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, christian-x8YiTEMPTCFhl2p70BpVqQ@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 10, 2015 at 04:06:18PM +0300, Erez Shitrit wrote:
> > +               if (unlikely(ipoib_dma_map_tx(priv->ca, tx_req))) {
> > +                       ++dev->stats.tx_errors;
> > +                       dev_kfree_skb_any(skb);
> > +                       return;
> > +               }
> 
> I think you should call  skb_orphan(skb) and skb_dst_drop(skb) before
> queuing the packet for sending.
> (like it done in the else part below)
Thanks Erez.
This is already addressed in v4 (which is currently under test).
> 
> > +               rc = post_send_sg(priv, tx, tx->tx_head &
> > +                                 (ipoib_sendq_size - 1),
> > +                                 skb, tx_req->mapping);
> > +       } else {
> > +               addr = ib_dma_map_single(priv->ca, skb->data, skb->len,
> > +                                        DMA_TO_DEVICE);
> > +               if (unlikely(ib_dma_mapping_error(priv->ca, addr))) {
> > +                       ++dev->stats.tx_errors;
> > +                       dev_kfree_skb_any(skb);
> > +                       return;
> > +               }
> > +
> > +               tx_req->mapping[0] = addr;
> >
> > -       skb_orphan(skb);
> > -       skb_dst_drop(skb);
> > +               skb_orphan(skb);
> > +               skb_dst_drop(skb);
> >
> > -       rc = post_send(priv, tx, tx->tx_head & (ipoib_sendq_size - 1),
> > -                      addr, skb->len);
> > +               rc = post_send(priv, tx, tx->tx_head & (ipoib_sendq_size - 1),
> > +                              addr, skb->len);
> > +       }
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
