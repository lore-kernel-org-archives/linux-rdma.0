From: Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Do not turn on carrier  to a non active port
Date: Mon, 21 Sep 2009 12:34:06 +0300
Message-ID: <4AB7488E.6090700@Voltaire.COM>
References: <4AB20C6C.9090005@Voltaire.COM> <adamy4td0zp.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adamy4td0zp.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OpenFabrics General <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Vlad <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
> And by the way, this current patch has a deadlock I think:
> 
>  > @@ -724,6 +724,8 @@ int ipoib_ib_dev_down(struct net_device *dev, int flush)
>  >  	ipoib_dbg(priv, "downing ib_dev\n");
>  >  
>  >  	clear_bit(IPOIB_FLAG_OPER_UP, &priv->flags);
>  > +	cancel_delayed_work(&priv->carrier_on_task);
> 
> ipoib_ib_dev_down() is called with rtnl held but carrier_on_task() does
> rtn_lock().  So if carrier_on_task() is running but about to take the
> rtnl when we try to do cancel_delayed_work() here, then it will wait
> forever.
> 
> I think using lockdep on a new enough kernel (2.6.30 or maybe 2.6.31)
> will report workqueue / timer vs. lock deadlocks.
> 
>  - R.
I may miss this but I don't  see how ipoib_ib_dev_down() is called with rtnl held.
Anyway, the new patch doesn't use delayed work.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
