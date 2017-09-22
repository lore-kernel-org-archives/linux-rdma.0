From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDMA/qedr: fix build error without ipv6
Date: Fri, 22 Sep 2017 11:57:21 -0400
Message-ID: <1506095841.5172.1.camel@redhat.com>
References: <20170905145935.1578698-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170905145935.1578698-1-arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "Mintz, Yuval" <Yuval.Mintz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-09-05 at 16:59 +0200, Arnd Bergmann wrote:
> When CONFIG_IPV6 disabled, we run into a link error:
> 
> drivers/infiniband/hw/qedr/qedr_iw_cm.o: In function
> `qedr_addr6_resolve.isra.3':
> qedr_iw_cm.c:(.text+0x4e0): undefined reference to
> `ip6_route_output_flags'
> 
> The ipv6 handling code is obviously not needed here, so this
> adds a compile-time check for the Kconfig symbol in all three
> places in the code that decide between ipv4 and ipv6.
> 
> We don't have to worry about a link error wtih QEDR=y/IPV6=m, as
> that configuration is already prohibited by CONFIG_INFINIBAND
> depending on "m || IPV6 != m".
> 
> Fixes: e411e0587e0d ("RDMA/qedr: Add iWARP connection management
> functions")
> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>

Thanks, applied to for-next area.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
