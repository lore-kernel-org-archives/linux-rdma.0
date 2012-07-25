From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re:  ipoib race in multicast flow (was: IPoIB oops)
Date: Wed, 25 Jul 2012 15:19:09 +0300
Message-ID: <500FE43D.1070107@mellanox.com>
References: <500EBBF0.3020407@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <500EBBF0.3020407-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 24/07/2012 18:14, Yishai Hadas wrote:
>  Just encountered a kernel oops in IPoIB on upstream kernel 3.5 [...] 
> oops happened in ipoib_mcast_join_task.

Roland,

I made a review now on the issue Yishai raised, and took a look on few 
related commits to that area, as you wrote in a77a57a1a "IPoIB: Fix 
deadlock on RTNL in ipoib_stop()" - commit c8c2afe3 "IPoIB: Use rtnl 
lock/unlock when changing  device flags" added a call to rtnl_lock() in 
ipoib_mcast_join_task(), which is run from the ipoib_workqueue, and 
hence we can't flush
the workqueue from the context ipoib_stop is called.

HOWEVER, that very same ipoib_stop() context, which doesn't flush the 
workqueue, calls ipoib_mcast_dev_flush which goes and deletes all the 
multicast entries, and this flow place
now without any synchronization with possible running instances of 
ipoib_mcast_join_task which relate to the SAME ipoib device. Yishai's 
test stepped on the broadcast point being null, but
this race can hold for any group which this device is joined to.

What would you suggest here, change the ipoib_stop flow to apply 
flushing, and doing
rtnl_trylock() instead of rtnl_lock() in ipoib_mcast_join_task() doesn't 
seems to be applicable, hence we don't know who took the lock, arbitrary 
context that wants now to apply changes on the device or the ipoib_stop 
one.

I see that this code is executed unconditionally whenever the mcast task is

>    priv->mcast_mtu = 
> IPOIB_UD_MTU(ib_mtu_enum_to_int(priv->broadcast->mcmember.mtu));
>
>         if (!ipoib_cm_admin_enabled(dev)) {
>                 rtnl_lock();
>                 dev_set_mtu(dev, min(priv->mcast_mtu, priv->admin_mtu));
>                 rtnl_unlock();
>         }

maybe if we go wiser and run it only after actually joining the 
broadcast group
and not each time could help with solving the race? and/or move the code 
that does
the dev_set_mtu call to be executed under another context?

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
