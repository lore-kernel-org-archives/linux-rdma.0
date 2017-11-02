From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-core 0/5] Perform package tests in Travis CI
Date: Thu,  2 Nov 2017 18:55:51 +0200
Message-ID: <20171102165556.22105-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Nicolas Morey-Chaisemartin <nmoreychaisemartin-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patchset comes from Alaa and he adds to Travis CI ability
to reuse our cbuild script to build various packages.

The PR is https://github.com/linux-rdma/rdma-core/pull/241

Thanks

Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Nicolas Morey-Chaisemartin <nmoreychaisemartin-l3A5Bk7waGM@public.gmane.org>

Alaa Hleihel (5):
  cbuild: Add udev dependency to package list of SuSE Leap
  cbuild: Properly create tarball for SuSE
  travis: Add RedHat and SuSE rpmbuild support
  buildlib/cbuild: Add Ubuntu artful
  travis: Test Debian packaging under Artful container

 .travis.yml                 |  4 ++++
 buildlib/cbuild             | 27 ++++++++++++++++++++-------
 buildlib/package-build-test | 15 +++++++++++++++
 buildlib/travis-build       | 14 --------------
 4 files changed, 39 insertions(+), 21 deletions(-)
 create mode 100755 buildlib/package-build-test

--
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
