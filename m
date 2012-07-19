From: Shlomo Pongartz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH net/for-next V1 1/1] IB/ipoib: break linkage to neighbouring
 system
Date: Thu, 19 Jul 2012 18:02:27 +0300
Message-ID: <50082183.5000402@mellanox.com>
References: <1342703938-29904-1-git-send-email-ogerlitz@mellanox.com> <1342703938-29904-2-git-send-email-ogerlitz@mellanox.com> <alpine.DEB.2.00.1207190938190.28115@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1207190938190.28115-sBS69tsa9Uj/9pzu0YdTqQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 7/19/2012 5:42 PM, Christoph Lameter wrote:
> On Thu, 19 Jul 2012, Or Gerlitz wrote:
>
>> Aged ipoib_neigh instances are deleted by a garbage collection task that runs every
>> 30 seconds and deletes every ipoib_neigh instance that was idle for at least 60
>> seconds. The deletion is safe since the ipoib_neigh instances are protected
>> using RCU and reference count mechanisms.
> Could we have the idle time configurable please? For many use cases we
> want a much longer retention of the neighbors (actually we typically use 4
> hrs).
>
> Also wish we would not run useless code every 30 seconds (create noise
> events especially if its per cpu). Could we only run those events as
> necessary and group the expiration of neighbors to reduce the events?
>
>
Hi,

The garbage collection and stale times follow the default ipv4/6 
neigh.default.gc_yyy
sysctl values, for example

net.ipv4.neigh.default.gc_interval = 30
net.ipv4.neigh.default.gc_stale_time = 60

If given access to these values from IPoIB, we will be happy
to integrate them into that logic

Please clarify what do you mean by group expiration.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
