From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH v2 rdma-core 0/2] Support writing man pages in markdown
Date: Mon, 12 Feb 2018 20:51:28 -0700
Message-ID: <20180213035130.980-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This is v2 of the earlier series that is substantially reworked based on
comments.

The cmake stuff now supports three modes of operation
 - Building but not installing: pandoc is optional and nothing special has to be done
   eg for people testing 'in place' using ./build.sh
 - Building from the github release .tar.gz: pandoc is optional.
   The github automatic release process includes the built pandoc
   output which is used automatically if pandoc is not available
   [and we need to run this through a -rc cycle to be perfectly sure
    github & travis are working perfectly, I only simulated it with
    cbuild]
 - Building from git and installing: You need to either install
   pandoc (eg from EPEL) or us 'cbuild pkg travis' to produce the
   prebuilt copies and place them in your source tree.

This seems like enough to cover the somewhat conflicting requirements of not
putting generated output into git, while also supporting building on every
distro.

The second patch is greatly chopped down to a subset of md versions that will
not attract style complaints. When this series is applied I will revist the
rest of the .md files that I have already got.

This a PR:
https://github.com/linux-rdma/rdma-core/pull/274

And the original full .md conversion can still be viewed here:

https://github.com/jgunthorpe/rdma-plumbing/tree/pandoc-all

Jason Gunthorpe (2):
  Support writing man pages in MarkDown
  verbs: Switch simpler man pages over to markdown format

 .travis.yml                             |  1 +
 CMakeLists.txt                          | 13 ++++-
 README.md                               |  2 +-
 buildlib/Findpandoc.cmake               | 21 ++++++++
 buildlib/cbuild                         | 46 ++++++++++++++---
 buildlib/github-release                 |  4 +-
 buildlib/pandoc-prebuilt.py             | 37 ++++++++++++++
 buildlib/rdma_functions.cmake           | 51 ++++--------------
 buildlib/rdma_man.cmake                 | 80 +++++++++++++++++++++++++++++
 debian/control                          |  1 +
 libibverbs/man/CMakeLists.txt           | 28 +++++-----
 libibverbs/man/ibv_attach_mcast.3       | 54 -------------------
 libibverbs/man/ibv_attach_mcast.3.md    | 57 +++++++++++++++++++++
 libibverbs/man/ibv_event_type_str.3     | 41 ---------------
 libibverbs/man/ibv_event_type_str.3.md  | 49 ++++++++++++++++++
 libibverbs/man/ibv_fork_init.3          | 69 -------------------------
 libibverbs/man/ibv_fork_init.3.md       | 69 +++++++++++++++++++++++++
 libibverbs/man/ibv_get_device_guid.3    | 26 ----------
 libibverbs/man/ibv_get_device_guid.3.md | 41 +++++++++++++++
 libibverbs/man/ibv_get_device_name.3    | 26 ----------
 libibverbs/man/ibv_get_device_name.3.md | 41 +++++++++++++++
 libibverbs/man/ibv_get_srq_num.3        | 33 ------------
 libibverbs/man/ibv_get_srq_num.3.md     | 45 ++++++++++++++++
 libibverbs/man/ibv_inc_rkey.3           | 33 ------------
 libibverbs/man/ibv_inc_rkey.3.md        | 43 ++++++++++++++++
 libibverbs/man/ibv_query_gid.3          | 34 ------------
 libibverbs/man/ibv_query_gid.3.md       | 44 ++++++++++++++++
 libibverbs/man/ibv_query_pkey.3         | 34 ------------
 libibverbs/man/ibv_query_pkey.3.md      | 45 ++++++++++++++++
 libibverbs/man/ibv_rate_to_mbps.3       | 46 -----------------
 libibverbs/man/ibv_rate_to_mbps.3.md    | 50 ++++++++++++++++++
 libibverbs/man/ibv_rate_to_mult.3       | 47 -----------------
 libibverbs/man/ibv_rate_to_mult.3.md    | 52 +++++++++++++++++++
 libibverbs/man/ibv_req_notify_cq.3      | 44 ----------------
 libibverbs/man/ibv_req_notify_cq.3.md   | 55 ++++++++++++++++++++
 libibverbs/man/ibv_rereg_mr.3           | 77 ----------------------------
 libibverbs/man/ibv_rereg_mr.3.md        | 91 +++++++++++++++++++++++++++++++++
 libibverbs/man/ibv_resize_cq.3          | 43 ----------------
 libibverbs/man/ibv_resize_cq.3.md       | 48 +++++++++++++++++
 redhat/rdma-core.spec                   |  5 ++
 suse/rdma-core.spec                     |  1 +
 41 files changed, 956 insertions(+), 671 deletions(-)
 create mode 100644 buildlib/Findpandoc.cmake
 create mode 100644 buildlib/pandoc-prebuilt.py
 create mode 100644 buildlib/rdma_man.cmake
 delete mode 100644 libibverbs/man/ibv_attach_mcast.3
 create mode 100644 libibverbs/man/ibv_attach_mcast.3.md
 delete mode 100644 libibverbs/man/ibv_event_type_str.3
 create mode 100644 libibverbs/man/ibv_event_type_str.3.md
 delete mode 100644 libibverbs/man/ibv_fork_init.3
 create mode 100644 libibverbs/man/ibv_fork_init.3.md
 delete mode 100644 libibverbs/man/ibv_get_device_guid.3
 create mode 100644 libibverbs/man/ibv_get_device_guid.3.md
 delete mode 100644 libibverbs/man/ibv_get_device_name.3
 create mode 100644 libibverbs/man/ibv_get_device_name.3.md
 delete mode 100644 libibverbs/man/ibv_get_srq_num.3
 create mode 100644 libibverbs/man/ibv_get_srq_num.3.md
 delete mode 100644 libibverbs/man/ibv_inc_rkey.3
 create mode 100644 libibverbs/man/ibv_inc_rkey.3.md
 delete mode 100644 libibverbs/man/ibv_query_gid.3
 create mode 100644 libibverbs/man/ibv_query_gid.3.md
 delete mode 100644 libibverbs/man/ibv_query_pkey.3
 create mode 100644 libibverbs/man/ibv_query_pkey.3.md
 delete mode 100644 libibverbs/man/ibv_rate_to_mbps.3
 create mode 100644 libibverbs/man/ibv_rate_to_mbps.3.md
 delete mode 100644 libibverbs/man/ibv_rate_to_mult.3
 create mode 100644 libibverbs/man/ibv_rate_to_mult.3.md
 delete mode 100644 libibverbs/man/ibv_req_notify_cq.3
 create mode 100644 libibverbs/man/ibv_req_notify_cq.3.md
 delete mode 100644 libibverbs/man/ibv_rereg_mr.3
 create mode 100644 libibverbs/man/ibv_rereg_mr.3.md
 delete mode 100644 libibverbs/man/ibv_resize_cq.3
 create mode 100644 libibverbs/man/ibv_resize_cq.3.md

-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
