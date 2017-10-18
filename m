From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/5] RDMA core, mlx5 fixes and refactoring for
 4.15
Date: Wed, 18 Oct 2017 11:02:18 -0400
Message-ID: <1508338938.46071.71.camel@redhat.com>
References: <20171016052812.28802-1-leon@kernel.org>
         <20171016054225.GC2106@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171016054225.GC2106-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-10-16 at 08:42 +0300, Leon Romanovsky wrote:
> On Mon, Oct 16, 2017 at 08:28:07AM +0300, Leon Romanovsky wrote:
> > 
> > Jérémy Lefaure (1):
> >   IB/mlx5: Use ARRAY_SIZE
> > 
> > Parav Pandit (4):
> >   IB: Let ib_core resolve destination mac address
> >   IB/core: Fix unable to change lifespan entry for hw_counters
> >   IB/core: Fix use workqueue without WQ_MEM_RECLAIM
> >   IB/core: Take into account optional UDR, XRC headers and
> > mandatory
> >     ICRC for RoCE MTU
> 
> Doug,
> Sorry, please drop this series, I missed one patch, it should be 6
> patches and not 5.

Done.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
