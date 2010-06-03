From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] libibverbs 1.1.4 is released
Date: Thu, 03 Jun 2010 15:17:39 -0700
Message-ID: <ada7hmfpxq4.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

libibverbs is a library that allows programs to use RDMA "verbs" for
direct access to RDMA (currently InfiniBand and iWARP) hardware from
userspace.

The new stable release, 1.1.4, is available from

    http://www.openfabrics.org/downloads/verbs/libibverbs-1.1.4.tar.gz

with sha1sum

    8e49c401894ea3fb76920464013850cef50d26c0  libibverbs-1.1.4.tar.gz

I also pushed the latest tree and tag out to kernel.org:

    git://git.kernel.org/pub/scm/libs/infiniband/libibverbs.git

(the name of the tag is libibverbs-1.1.4).

This release has fixes to madvise() error handling and includes the
path record structure definition used by new versions of librdmacm.

The git shortlog since libibverbs 1.1.4 is:

Alex Vainman (4):
      Factor out range handling in ibv_madvise_range()
      Increment node refcount in ibv_madvise_range() only if madvise() succeeds
      Fix incorrect splits/merges in the memory tree when madvise() fails.
      Undo changes in memory range tree when madvise() fails

Hakon Bugge (1):
      Force line-buffering in ibv_asyncwatch

Roland Dreier (5):
      Use proper build dependency version in debian control file
      Update Debian build rules so -dbg package isn't empty
      Debian: Switch to dpkg-source 3.0 format
      Small configure.in modernizations
      Roll libibverbs 1.1.4 release

Sean Hefty (1):
      Add path record definitions to sa.h
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
