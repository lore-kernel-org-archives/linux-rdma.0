From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 0/6] Container build script
Date: Wed, 23 Nov 2016 16:34:58 -0700
Message-ID: <1479944104-19949-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is a revised version of the script I have been using to test builds
across all the distros using docker containers.

It should be very easy to setup, installing docker is fairly trivial these
days on a recent distro.

I found a few mistakes while running through the test matrix, those are
included here as well.

Jason Gunthorpe (6):
  Update C7 build instructions to use ninja from EPEL
  Fix spelling of CMAKE_INSTALL_UDEV_RULESDIR
  Fix RPM building on FC24
  Fix package building on CentOS6
  Avoid rpmbuild warning
  Add a script to run builds in docker containers

 README.md             |  24 +-
 buildlib/cbuild       | 740 ++++++++++++++++++++++++++++++++++++++++++++++++++
 rdma-core.spec        |  15 +-
 redhat/rdma-core.spec |   4 +-
 4 files changed, 770 insertions(+), 13 deletions(-)
 create mode 100755 buildlib/cbuild

-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
