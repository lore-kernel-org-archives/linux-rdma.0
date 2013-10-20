From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [Patch v2 1/3] IB/cma: use cached gids
Date: Sun, 20 Oct 2013 08:57:42 +0200
Message-ID: <20131020085742.3deb499a@jpm-OptiPlex-GX620>
References: <cover.1380056994.git.dledford@redhat.com>
	<0dae5249b1f09936a2976ef910c022eecaf9a7fa.1380056994.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0dae5249b1f09936a2976ef910c022eecaf9a7fa.1380056994.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Drier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

ACK.  Looks good!
Very nice catch, Doug!

-Jack

On Tue, 24 Sep 2013 17:16:27 -0400
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> The cma_acquire_dev function was changed by commit 3c86aa70bf67
> to use find_gid_port because multiport devices might have
> either IB or IBoE formatted gids.  The old function assumed that
> all ports on the same device used the same GID format.  However,
> when it was changed to use find_gid_port, we inadvertently lost
> usage of the GID cache.  This turned out to be a very costly
> change.  In our testing, each iteration through each index of
> the GID table takes roughly 35us.  When you have multiple
> devices in a system, and the GID you are looking for is on one
> of the later devices, the code loops through all of the GID
> indexes on all of the early devices before it finally succeeds
> on the target device.  This pathological search behavior combined
> with 35us per GID table index retrieval results in results such
> as the following from the cmtime application that's part of the
> latest librdmacm git repo:
> 
> ib1:
> step              total ms     max ms     min us  us / conn
> create id    :       29.42       0.04       1.00       2.94
> bind addr    :   186705.66      19.00   18556.00   18670.57
> resolve addr :       41.93       9.68     619.00       4.19
> resolve route:      486.93       0.48     101.00      48.69
> create qp    :     4021.95       6.18     330.00     402.20
> connect      :    68350.39   68588.17   24632.00    6835.04
> disconnect   :     1460.43     252.65-1862269.00     146.04
> destroy      :       41.16       0.04       2.00       4.12
> 
> ib0:
> step              total ms     max ms     min us  us / conn
> create id    :       28.61       0.68       1.00       2.86
> bind addr    :     2178.86       2.95     201.00     217.89
> resolve addr :       51.26      16.85     845.00       5.13
> resolve route:      620.08       0.43      92.00      62.01
> create qp    :     3344.40       6.36     273.00     334.44
> connect      :     6435.99    6368.53    7844.00     643.60
> disconnect   :     5095.38     321.90     757.00     509.54
> destroy      :       37.13       0.02       2.00       3.71
> 
> Clearly, both the bind address and connect operations suffer
> a huge penalty for being anything other than the default
> GID on the first port in the system.
> 
> After applying this patch, the numbers now look like this:
> 
> ib1:
> step              total ms     max ms     min us  us / conn
> create id    :       30.15       0.03       1.00       3.01
> bind addr    :       80.27       0.04       7.00       8.03
> resolve addr :       43.02      13.53     589.00       4.30
> resolve route:      482.90       0.45     100.00      48.29
> create qp    :     3986.55       5.80     330.00     398.66
> connect      :     7141.53    7051.29    5005.00     714.15
> disconnect   :     5038.85     193.63     918.00     503.88
> destroy      :       37.02       0.04       2.00       3.70
> 
> ib0:
> step              total ms     max ms     min us  us / conn
> create id    :       34.27       0.05       1.00       3.43
> bind addr    :       26.45       0.04       1.00       2.64
> resolve addr :       38.25      10.54     760.00       3.82
> resolve route:      604.79       0.43      97.00      60.48
> create qp    :     3314.95       6.34     273.00     331.49
> connect      :    12399.26   12351.10    8609.00    1239.93
> disconnect   :     5096.76     270.72    1015.00     509.68
> destroy      :       37.10       0.03       2.00       3.71
> 
> It's worth noting that we still suffer a bit of a penalty on
> connect to the wrong device, but the penalty is much less than
> it used to be.  Follow on patches deal with this penalty.
> 
> Many thanks to Neil Horman for helping to track the source of
> slow function that allowed us to track down the fact that
> the original patch I mentioned above backed out cache usage
> and identify just how much that impacted the system.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
