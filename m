From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] avoid race condition between start_xmit and
 cm_rep_handler
Date: Thu, 16 Aug 2018 16:27:51 -0600
Message-ID: <20180816222751.GC10507@ziepe.ca>
References: <1534379842-1215-1-git-send-email-aaron.s.knister@nasa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1534379842-1215-1-git-send-email-aaron.s.knister@nasa.gov>
Sender: stable-owner@vger.kernel.org
To: "Aaron S. Knister" <aknister@discover.nccs.nasa.gov>
Cc: linux-rdma@vger.kernel.org, stable@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, John Fleck <john.fleck@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 15, 2018 at 08:37:22PM -0400, Aaron S. Knister wrote:
> Inside of start_xmit() the call to check if the connection is up and the
> queueing of the packets for later transmission is not atomic which
> leaves a window where cm_rep_handler can run, set the connection up,
> dequeue pending packets and leave the subsequently queued packets by
> start_xmit() sitting on neigh->queue until they're dropped when the
> connection is torn down. This only applies to connected mode. These
> dropped packets can really upset TCP, for example,  and cause
> multi-minute delays in transmission for open connections.
> 
> I've got a reproducer available if it's needed.
> 
> Here's the code in start_xmit where we check to see if the connection
> is up:
> 
>        if (ipoib_cm_get(neigh)) {
>                if (ipoib_cm_up(neigh)) {
>                        ipoib_cm_send(dev, skb, ipoib_cm_get(neigh));
>                        goto unref;
>                }
>        }

Agree with Leon on the locking. Find a more elegant way to write
this.

> The race occurs if cm_rep_handler execution occurs after the above
> connection check (specifically if it gets to the point where it acquires
> priv->lock to dequeue pending skb's) but before the below code snippet
> in start_xmit where packets are queued.
> 
>        if (skb_queue_len(&neigh->queue) < IPOIB_MAX_PATH_REC_QUEUE) {
>                push_pseudo_header(skb, phdr->hwaddr);
>                spin_lock_irqsave(&priv->lock, flags);
>                __skb_queue_tail(&neigh->queue, skb);
>                spin_unlock_irqrestore(&priv->lock, flags);
>        } else {
>                ++dev->stats.tx_dropped;
>                dev_kfree_skb_any(skb);
>        }

Somehow I think the spinlock should be held across the skb_queue_len as
well. Right?

I wonder if the 'neigh->ah' has the same racing problem and needs the
same fixing:

	} else if (neigh->ah) {
		neigh_refresh_path(neigh, phdr->hwaddr, dev);
	}

??

Have a feeling that needs a READ_ONCE to be correct...
 
Jason
