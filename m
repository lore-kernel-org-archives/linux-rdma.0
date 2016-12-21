From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core 0/6] redhat/spec: various fixes and cleanups
Date: Wed, 21 Dec 2016 17:08:34 -0500
Message-ID: <20161221220840.36268-1-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a set of patches to fix up a few things in the Red Hat (Fedora)
rdma-core spec file that came up as part of the Fedora new package review
process, where we're working on getting rdma-core into Fedora in place of
the old split packages.

Fedora package review bug:
  https://bugzilla.redhat.com/show_bug.cgi?id=1404043

Jarod Wilson (6):
  redhat/spec: call it srp_daemon in desc, not srptools
  redhat/spec: improve base package description
  redhat/spec: use fully versioned Requires on base package
  redhat/spec: fix up %post scriptlets
  redhat/spec: clean up rsocket packaging
  redhat/spec: make sure docdir is owned

 redhat/rdma-core.spec | 65 +++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 47 insertions(+), 18 deletions(-)

-- 
2.10.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
