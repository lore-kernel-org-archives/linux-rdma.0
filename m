From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 0/13] IB-mgmt: Port madeye to userspace
Date: Mon, 8 Nov 2010 07:53:24 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B83D6B54@orsmsx501.amr.corp.intel.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B837B38B@orsmsx501.amr.corp.intel.com>
	<4CD26E04.3060408@voltaire.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25B837B65F@orsmsx501.amr.corp.intel.com>
	<4CD2DFD3.7040900@Voltaire.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25B837B857@orsmsx501.amr.corp.intel.com>
 <4CD7CD7B.2020003@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CD7CD7B.2020003-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> so the usage of mad snooping would be for cache invalidations, I wonder
> if registering on GID/MGID IN/OUT traps be sufficient for the same purpose?

That requires registration with the SA.  The intent is to avoid using a centralized service when possible.  Otherwise, we end up with all nodes registering for a trap, the SA needing to notify all nodes of in/out of service, and all nodes updating their caches at the same time.  The CM timeout approach avoids this; the only nodes that need to update their caches are ones which are actively trying to connect to a specific node.

Consider a case where one or more nodes are removed from an MPI run.  (Maybe the software on the nodes are being updated.)  Relying on traps would require SA communication to and from all nodes, even though the nodes won't be used.  Additionally, once the nodes go back online, their path information may not have changed, so none of the work was even needed.

The focus of this patch is on thousands to tens of thousands of nodes.  At that scale, the likelihood of a node going up/down at any given point is high.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
