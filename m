From: Markus Stockhausen <markus.stockhausen-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: [RFC/PATCH v3] IPoIB: Leave space in skb linear buffer for IP
 headers
Date: Tue, 09 Apr 2013 21:52:07 +0200
Message-ID: <CD8A3957.57AC%markus.stockhausen@gmx.de>
References: <1365457381-10184-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1365457381-10184-1-git-send-email-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> 
>-    IPOIB_UD_HEAD_SIZE      = IB_GRH_BYTES + IPOIB_ENCAP_LEN,
>+    /* add 128 bytes of tailroom for IP/TCP headers */
>+    IPOIB_UD_HEAD_SIZE      = IB_GRH_BYTES + IPOIB_ENCAP_LEN + 128,

Hello,

the version 3 of the patch finally works. I can see the performance
gains but I cannot feel them (in real life). Here are the results
of my testbed:

Test 1:
netperf/netserver message size 16K

kernel 3.5 default     :  5.1 GBit/s
kernel 3.5 + patch v3  :  7.7 GBit/s
kernel 3.5 + max MTU 3K: 10.8 GBit/s

Test 2:
Disk write performance
VM with disk mounted on IB async NFS server

block size  | default  | patch v3 | max MTU 3K
------------+----------+----------+----------
       1 KB |  10 MB/s |  10 MB/s |  10 MB/s
       2 KB |  20 MB/s |  21 MB/s |  20 MB/s
       4 KB |  40 MB/s |  40 MB/s |  43 MB/s
       8 KB |  68 MB/s |  70 MB/s |  78 MB/s
      16 KB | 105 MB/s | 105 MB/s | 120 MB/s
      32 KB | 150 MB/s | 150 MB/s | 170 MB/s
      64 KB | 200 MB/s | 210 MB/s | 260 MB/s
     128 KB | 270 MB/s | 290 MB/s | 400 MB/s
     256 KB | 300 MB/s | 310 MB/s | 430 MB/s
     512 KB | 305 MB/s | 320 MB/s | 470 MB/s
    1024 KB | 310 MB/s | 325 MB/s | 500 MB/s
    2048 KB | 310 MB/s | 325 MB/s | 510 MB/s
    4096 KB | 370 MB/s | 325 MB/s | 510 MB/s
    8192 KB | 400 MB/s | 325 MB/s | 520 MB/s


As you can see netperf throughput increases while NFS does not
even care about the optimizations. Maybe it does not work well
with fragmented SKBs. The MAX MTU 3K values once again are
forced through a hack inside ipoib_main.c.

For curiosity I changed the block splitting in your v3 patch
from small head with large fragment to large head with small
fragment in this line.

IPOIB_UD_HEAD_SIZE      = IB_GRH_BYTES + IPOIB_ENCAP_LEN + 3072

In my 2044 MTU case this brings the netperf & NFS throughput to
the same levels as the dirty hack. Of course this no longer
reflects a head but equals more or less to something like a
new constant IPOIB_UD_FIXED_SKB_SIZE.

I guess 4K MTU will not see any further gains but avoiding the
skb_pull calls should improve speed as well. Maybe a final
adaption could put the cherry on the cake.

Markus


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
