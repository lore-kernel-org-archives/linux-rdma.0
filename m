From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: fix dangling pointer references to
	ipoib_neigh and ipoib_path
Date: Thu, 25 Feb 2010 15:43:25 -0800
Message-ID: <1267141405.30294.32.camel@chromite.mv.qlogic.com>
References: <1267126142.30294.25.camel@chromite.mv.qlogic.com>
	 <20100225200357.GW29938@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100225200357.GW29938-sJ/iWh9BUns@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arthur Kepner <akepner-sJ/iWh9BUns@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2010-02-25 at 12:03 -0800, Arthur Kepner wrote:
> On Thu, Feb 25, 2010 at 11:29:02AM -0800, Ralph Campbell wrote:
> >  ....
> 
> I haven't looked carefully at the whole patch, but this bit 
> looks wrong:
> 
> > @@ -848,61 +823,112 @@ static void ipoib_neigh_cleanup(struct neighbour *n)
> >  	struct ipoib_neigh *neigh;
> >  	struct ipoib_dev_priv *priv = netdev_priv(n->dev);
> >  	unsigned long flags;
> > -	struct ipoib_ah *ah = NULL;
> > +
> > +	spin_lock_irqsave(&priv->lock, flags);
> >  
> >  	neigh = *to_ipoib_neigh(n);
> > -	if (neigh)
> > -		priv = netdev_priv(neigh->dev);
> > -	else
> > +	if (neigh) {
> 
> Should this be "if (!neigh)" ?
> 
> > +		spin_unlock_irqrestore(&priv->lock, flags);
> >  		return;
> > +	}
> > +	*to_ipoib_neigh(n) = NULL;
> > +	neigh->neighbour = NULL;
> > +

You are correct.    Homer Simpson Doh! :-)
I will send an updated patch after resolving Roland's questions.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
