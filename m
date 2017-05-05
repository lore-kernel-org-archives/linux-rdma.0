From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [ANNOUNCE] New rdma-core release available
Date: Thu, 04 May 2017 20:04:29 -0400
Message-ID: <1493942669.3041.244.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The first -rc of the rdma-core-14 package, rdma-core-14-rc1, is now
available at the normal place.

https://github.com/linux-rdma/rdma-core/releases

Version 14-rc1

@dledford dledford released this 11 minutes ago

Updates since version 13

    Various packaging updates for Debian and Red Hat
    libqedr provider fixes
    addition of libbnxt_re provider
    man page additions for librdmacm
    sparse fixes
    fix for srp_daemon and certain subnet managers
    aarch64 build fixes
    support for more types of flow specs
    clean up srp_daemon's use of mad packets, use libibumad instead of
    self coding needed items
    mlx5 CQE compression support
    scatter FCS support for raw ETH QPs
    cvlan support
    report raw packets caps during query device

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
