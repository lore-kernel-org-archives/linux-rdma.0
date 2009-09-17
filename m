From: Roland Dreier <rdreier@cisco.com>
Subject: [ofa-general] Re: [PATCH] IB/ipoib: Do not turn on carrier to a non
	active port
Date: Thu, 17 Sep 2009 08:50:18 -0700
Message-ID: <adamy4td0zp.fsf@cisco.com>
References: <4AB20C6C.9090005@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <general-bounces@lists.openfabrics.org>
In-Reply-To: <4AB20C6C.9090005@Voltaire.COM> (Moni Shoua's message of "Thu, 17
	Sep 2009 13:16:12 +0300")
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/general>
List-Post: <mailto:general@lists.openfabrics.org>
List-Help: <mailto:general-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=subscribe>
Sender: general-bounces@lists.openfabrics.org
Errors-To: general-bounces@lists.openfabrics.org
To: Moni Shoua <monis@Voltaire.COM>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, OpenFabrics General <general@lists.openfabrics.org>
List-Id: linux-rdma@vger.kernel.org

And by the way, this current patch has a deadlock I think:

 > @@ -724,6 +724,8 @@ int ipoib_ib_dev_down(struct net_device *dev, int flush)
 >  	ipoib_dbg(priv, "downing ib_dev\n");
 >  
 >  	clear_bit(IPOIB_FLAG_OPER_UP, &priv->flags);
 > +	cancel_delayed_work(&priv->carrier_on_task);

ipoib_ib_dev_down() is called with rtnl held but carrier_on_task() does
rtn_lock().  So if carrier_on_task() is running but about to take the
rtnl when we try to do cancel_delayed_work() here, then it will wait
forever.

I think using lockdep on a new enough kernel (2.6.30 or maybe 2.6.31)
will report workqueue / timer vs. lock deadlocks.

 - R.
