From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 0/9] ibacm: Preparation for supporting different providers
Date: Sun, 23 Mar 2014 13:18:12 -0700
Message-ID: <1395605901-9080-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

In order to support other mechanisms for address and route resolution,
such that those being defined for ibssa (scalable SA), ibacm will be
restructured to support the concept of 'plug-in' providers.  The
existing resolution mechanism will be converted into a provider,
with the management of client requests moving into what will
become the ibacm core.

The following patches prepare the code base for this split in
functionality.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Sean Hefty (9):
  ibacm: Release the refcnt on the correct client
  ibacm: Rename client array
  ibacm: Eliminate strict aliasing compiler warnings
  ibacm: Relocate client refcnt
  ibacm: Record index for source and destination addresses
  ibacm: Change base endpoint name
  ibacm: Reset endpoint state on error
  ibacm: Store the base GID with acm_port
  ibacm: Restructure acm_port_join

 src/acm.c |  175 ++++++++++++++++++++++++++++++++++---------------------------
 1 files changed, 98 insertions(+), 77 deletions(-)

-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
