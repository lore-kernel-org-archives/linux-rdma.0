From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [ANNOUNCE] New rdma-core release available
Date: Tue, 21 Mar 2017 11:47:49 -0400
Message-ID: <1490111269.2404.5.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

rdma-core version 13 has been released.  This is the first release to
use the new release process (thanks to Leon for this).  Among other
things, we should now have a properly formatted tarball on the release
page at github:

https://github.com/linux-rdma/rdma-core/releases/tag/v13

The properly formatted tarball shows up after a delay period (while
Travis CI does a test build and such).  The old links for the release
that produce wonky tarballs are still there too.  You'll want to use
the link that gives the tarball's name, not one of the links that says
"Source Code" if you want the properly formatted tarball.

Changes in this release are:

    Minor improvements to qedr provider
    Add libpvrdma provider for VMWare rdma virt devices
    Improved RoCE AH creation
    Packet Pacing support
    Various github build system improvements
    Updates to Debian and Red Hat packaging
    Timestamp support in mlx4 provider
    Make the libibverbs/provider interface private
    Clean up headers for improved multi-arch support
    Add Verbs Direct support for mlx5 provider
    Implement new, more specific multi-arch barrier methods
    Update all providers to the modern registration method and remove
    ibv_register_driver entirely
    Switch the code to use gcc endian conversion functions
    Fix an endianness issue in srp_daemon
    Implement a new release mechanism that should create more distro
    friendly tarballs based on the common release tagging format
    Updates to make it possible to run sparse on rdma-core
    Fixes found by running sparse on rdma-core
    Fixes to travis tarball upload script
    Fix to broken cmake test


-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
