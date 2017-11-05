From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-core v1 0/3] Perform package tests in Travis CI
Date: Sun,  5 Nov 2017 16:44:59 +0200
Message-ID: <20171105144503.32709-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Nicolas Morey-Chaisemartin <nmoreychaisemartin-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Changelog: v0->v1:
 * The "cbuild: Properly create tarball for SuSE" patch was abandoned as
   no one is interested by scripts behavior when being ran by root.
 * Patch "travis: Add RedHat and SuSE rpmbuild support"
   "buildlib/package-build-test" script to skip build tests when being ran
   outside travis (the actual check is whether we are already running inside
   a container or not).
 * In the patch "travis: Test Debian packaging under artful container"
   removed as no longer needed installations: debhelper, dh-systemd, fakeroot

-----------------------------------------------------------------------------

This patchset comes from Alaa and he adds to Travis CI ability
to reuse our cbuild script to build various packages.

The PR is https://github.com/linux-rdma/rdma-core/pull/241

The change to SuSE Tumbleweed wasn't straightforward and can be done as
a followup patch.

Thanks

Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Nicolas Morey-Chaisemartin <nmoreychaisemartin-l3A5Bk7waGM@public.gmane.org>

Alaa Hleihel (3):
  travis: Add RedHat and SuSE rpmbuild support
  buildlib/cbuild: Add Ubuntu artful
  travis: Test Debian packaging under artful container

 .travis.yml                 |  7 ++++---
 buildlib/cbuild             |  7 +++++++
 buildlib/package-build-test | 21 +++++++++++++++++++++
 buildlib/travis-build       | 14 --------------
 4 files changed, 32 insertions(+), 17 deletions(-)
 create mode 100755 buildlib/package-build-test

--
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
