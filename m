From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [ANNOUNCE] libibverbs 1.1.8 is released
Date: Mon,  5 May 2014 12:19:36 -0700
Message-ID: <1399317576-19155-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

libibverbs is a library that allows programs to use RDMA "verbs" for
direct access to RDMA (currently InfiniBand and iWARP) hardware from
userspace.

The new stable release, 1.1.8, is available from

    http://www.openfabrics.org/downloads/verbs/libibverbs-1.1.8.tar.gz

with sha1sum

    df1afc6f368f4ad4c7a74d270591fc79db875b2b  libibverbs-1.1.8.tar.gz

I also pushed the latest tree and tag out to kernel.org:

    git://git.kernel.org/pub/scm/libs/infiniband/libibverbs.git

(the name of the tag is libibverbs-1.1.8).

The main new features in this release are: generic infrastructure for
"verbs extensions", support for XRC, and support for flow steering.

The git shortlog since libibverbs 1.1.7 is:

Jay Sternberg (1):
      Add XRC sample application

Jeff Squyres (1):
      Use IBV_SEND_INLINE in example pingpong programs

Matan Barak (1):
      Add general definitions to support uverbs extensions

Or Gerlitz (1):
      Add receive flow steering support

Roland Dreier (2):
      Update maintainer now that I'm a DD
      Roll libibverbs 1.1.8 release

Sean Hefty (5):
      Introduce XRC domains (XRCDs)
      Add support for XRC SRQs
      Add support for XRC QPs
      Add ibv_open_qp() for XRC receive QPs
      XRC man pages

Upinder Malhi \(umalhi\) (1):
      Add support for usNIC nodes and transports

Yishai Hadas (2):
      Infrastructure to support verbs extensions
      Fix XRC sample application (ibv_xsrq_pingpong) issues
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
