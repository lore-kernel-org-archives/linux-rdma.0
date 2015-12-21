From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/2] IB multicast cleanup patches V2
Date: Mon, 21 Dec 2015 08:42:52 -0600
Message-ID: <20151221144252.575119561@linux.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

V1->V2
 - Add Reviewed by's for first patch from Ira Weiny
 - Change name of ipoib_check_mcast_sendonly() to
	ipoib_check_and_add_mcast_sendonly() as requested by Ira

This patchset cleans up the code a bit after the last round of multicast
patches related to the sendonly join logic. Some of the bits of code
landed in ipoib_main.c instead of ipoib_multicast.c.

- Move the multicastbits into that file so that everything is neatly together
- Reduce the number of functions exported from ipoib_multicast.c

This patchset can be retrieved from a git repo on kernel.org via

git pull git://git.kernel.org/pub/scm/linux/kernel/git/christoph/rdma.git cleanup

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
