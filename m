From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: QoS in local SA entity
Date: Thu, 5 Nov 2009 08:40:55 -0800
Message-ID: <9BF1CEFA7F6F44F5B5641065C4914EB5@amr.corp.intel.com>
References: <4AF2C00A.4040808@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AF2C00A.4040808-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Or Gerlitz' <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>I believe we can go also on a middle way, where the SA isn't contacted
>directly using path query for each resolution, but rather "indirectly"
>e.g using a dedicated multicast based protocol.

Yes - I wasn't trying to limit how the SA could 'distribute' QoS information to
the end nodes.  ACM will obtain QoS information from the SA when it joins its
multicast groups.

>So assuming ACM supports AF_INET, using network stack route lookup on
>the destination address / rdma_bind on the source address, etc as we
>discussed, ACM can use the rdma-cm to resolve the pkey, then use this
>pkey the MGID and a management software could tell the SA to use a
>specific SL for MGIDs on this partition. Next, ACM can use this SL in
>the path it generates for the IB connection, makes sense?

ACM is intended to be a service that's used by the librdmacm to resolve address
mappings and routes.  Trying to have ACM use the librdmacm ends up with a
circular dependency.  That's the part I'm trying to avoid.

ACM uses address mappings as defined in an address configuration file (IP ->
device, port, pkey).  The address file can be created using the provided ib_acme
utility, which uses the current system configuration (in an ugly way, but it
works).  I think this provides QoS behavior similar to what you're describing.

At some future point, the ib_acm service can be merged with ib_acme to respond
to dynamic changes in ipoib address mappings, but that's a non-trivial amount of
work and involves changes to the ACM multicast groups.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
