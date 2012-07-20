From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: mlx4_ib_create_qp failed - OOM with call trace
Date: Fri, 20 Jul 2012 02:03:11 -0700
Message-ID: <CAG4TOxPihchsdXqAGqAYYnBFm58RpKPJaNTYrErwqNetT21MxQ@mail.gmail.com>
References: <5006BF13.50405@profitbricks.com> <CAL1RGDX6+NZ_ZJ+TLOMBaVdyM0wd6BjCEHwwAYCVODY4Cfkm4Q@mail.gmail.com>
 <50090D1C.6040500@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50090D1C.6040500-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 20, 2012 at 12:47 AM, Sebastian Riemer
<sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org> wrote:
> This is at least something we can implement and test for us as we only
> have modern server systems.

Definitely, just replacing the kmallocs with vmallocs for those wrid arrays
and replacing the corresponding kfree with vfree should cure this issue
for you.  Only 32-bit systems care about vmalloc address space.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
