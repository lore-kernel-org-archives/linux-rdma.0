From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-core 0/2] Create semi-automatic release process
Date: Sun, 29 Jan 2017 16:35:57 +0200
Message-ID: <20170129143559.7654-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug and Jason,

This patchset simplifies the github release process for the rdma-core library.
Once properly installed, it will allow simply issue "git release" command to create
release notes from annotated and signed tags.

Such release notes will be formatted according to the tag context
and will have rdma-core-vX.X.X.tar.gz attached to it with properly
created top-level directory.

Leon Romanovsky (2):
  travis: Simplify travis config
  travis: Upload assets to github release

 .travis.yml              |  86 +++++++++++++++-------------------------
 Documentation/release.md | 100 +++++++++++++++++++++++++++++++++++++++++++++++
 buildlib/github-release  |   8 ++++
 buildlib/travis-build    |  29 ++++++++++++++
 4 files changed, 169 insertions(+), 54 deletions(-)
 create mode 100644 Documentation/release.md
 create mode 100755 buildlib/github-release
 create mode 100755 buildlib/travis-build

--
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
