From: "Weiny, Ira" <ira.weiny@intel.com>
Subject: RE: [PATCH v2] avoid race condition between start_xmit and
 cm_rep_handler
Date: Mon, 20 Aug 2018 04:38:44 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E67ED8F13@CRSMSX101.amr.corp.intel.com>
References: <1534541486-16263-1-git-send-email-aaron.s.knister@nasa.gov>
 <20180819172834.GS2796@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180819172834.GS2796@mtr-leonro.mtl.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Aaron Knister <aaron.s.knister@nasa.gov>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "Fleck, John" <john.fleck@intel.com>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: Leon Romanovsky [mailto:leon@kernel.org]
> Sent: Sunday, August 19, 2018 10:29 AM
> To: Aaron Knister <aaron.s.knister@nasa.gov>
> Cc: linux-rdma@vger.kernel.org; stable@vger.kernel.org; Weiny, Ira
> <ira.weiny@intel.com>; Fleck, John <john.fleck@intel.com>
> Subject: Re: [PATCH v2] avoid race condition between start_xmit and
> cm_rep_handler
> 
> On Fri, Aug 17, 2018 at 05:31:26PM -0400, Aaron Knister wrote:
> > Inside of start_xmit() the call to check if the connection is up and
> > the queueing of the packets for later transmission is not atomic which
> > leaves a window where cm_rep_handler can run, set the connection up,
> > dequeue pending packets and leave the subsequently queued packets by
> > start_xmit() sitting on neigh->queue until they're dropped when the
> > connection is torn down. This only applies to connected mode. These
> > dropped packets can really upset TCP, for example,  and cause
> > multi-minute delays in transmission for open connections.
> >
> > Here's the code in start_xmit where we check to see if the connection
> > is up:
> >
> >        if (ipoib_cm_get(neigh)) {
> >                if (ipoib_cm_up(neigh)) {
> >                        ipoib_cm_send(dev, skb, ipoib_cm_get(neigh));
> >                        goto unref;
> >                }
> >        }
> >
> > The race occurs if cm_rep_handler execution occurs after the above
> > connection check (specifically if it gets to the point where it
> > acquires
> > priv->lock to dequeue pending skb's) but before the below code snippet
> > in start_xmit where packets are queued.
> >
> >        if (skb_queue_len(&neigh->queue) < IPOIB_MAX_PATH_REC_QUEUE)
> {
> >                push_pseudo_header(skb, phdr->hwaddr);
> >                spin_lock_irqsave(&priv->lock, flags);
> >                __skb_queue_tail(&neigh->queue, skb);
> >                spin_unlock_irqrestore(&priv->lock, flags);
> >        } else {
> >                ++dev->stats.tx_dropped;
> >                dev_kfree_skb_any(skb);
> >        }
> >
> > The patch re-checks ipoib_cm_up with priv->lock held to avoid this
> > race condition. Since odds are the conn should be up most of the time
> > (and thus the connection *not* down most of the time) we don't hold
> > the lock for the first check attempt to avoid a slowdown from
> > unecessary locking for the majority of the packets transmitted during
> > the connection's life.
> >
> > Signed-off-by: Aaron Knister <aaron.s.knister@nasa.gov>
> 
> If you want this fix in stable@, you will need to provide Fixes line here and
> don't add stable@ in CC-list.


Fixes: b63b70d87741 ("IPoIB: Use a private hash table for path lookup in xmit path")
Cc: stable@vger.kernel.org


> 
> Thanks,
> Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
