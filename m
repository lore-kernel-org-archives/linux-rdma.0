From: Hariprasad S <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: Unable to establish rdma connection, breaks rdma basic functionality
Date: Wed, 6 Jan 2016 04:43:45 +0000
Message-ID: <26E3F92EC670BD429DB5CB319D773C13C4452BD0@nice.asicdesigners.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: SWise OGC <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Nirranjan Kirubaharan <nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Hi Doug,

I am trying to rping server, but it fails when bound to any address other then IF_ANY.
# rping -s -a 102.1.1.129 -C1 -p 9999 -vd
created cm_id 0x23d7800
rdma_bind_addr: No such file or directory
destroy cm_id 0x23d7800

If bound to IF_ANY address, server starts but client fails to establish connection.
# rping -s -C1 -p 9999 -vvvd
created cm_id 0xc34800
rdma_bind_addr successful
rdma_listen

And the commit which introduced this regression is

commit abae1b71dd37bab506b14a6cf6ba7148f4d57232
Author: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date:   Thu Oct 15 18:38:49 2015 +0300

    IB/cma: cma_validate_port should verify the port and netdevice

    Previously, cma_validate_port searched for GIDs in IB cache and then
    tried to verify the found port. This could fail when there are
    identical GIDs on both ports. In addition, netdevice should be taken
    into account when searching the GID table.
    Fixing cma_validate_port to search only the relevant port's cache
    and netdevice.

    Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
    Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org


The bug is easily reproducible with latest rc and breaks basic rdma functionality.
Since 4.4 is already in -rc8, can we have a quick fix.

Thanks,
Hari--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
