From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: QoS in local SA entity: was rdma/cm: support option to allow manually setting IB path
Date: Mon, 2 Nov 2009 10:59:31 -0800
Message-ID: <2EA483054F2D4472B9F57386E463FE33@amr.corp.intel.com>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com>	<A08104C1CF70400F8BEF492AD49C8491@amr.corp.intel.com>	<20091020181458.GD14520@obsidianresearch.com>	<46770152ACA04B6C8AA9497C45AC8FD0@amr.corp.intel.com>	<20091020191404.GH14520@obsidianresearch.com>	<9DFD8E65325F4EE990749EEBE4BC33CA@amr.corp.intel.com>	<20091022004245.GV14520@obsidianresearch.com>	<AE35305D45DB49F591A45DADD822209A@amr.corp.intel.com>	<20091022013542.GX14520@obsidianresearch.com>	<B7E97540810E4A2785FF1FC8CB96F453@amr.corp.intel.com>	<DC0770A17FDC4DACAC0251A3362CE87A@amr.corp.intel.com> <1B115D7248A5404781F001F72A7C591A@amr.corp.intel.com> <4AED347A.1060301@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AED347A.1060301-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Or Gerlitz' <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>Before enhancing the rdma-cm to support the full feature set of the IB
>CM, something which I personally don't see the actual need for (but I
>will be happy to get educated what applications will or can migrate to
>rdma-cm once this is implemented), how about trying to allow for reduced
>QoS scheme also when the entity that resolved this patch didn't
>consulted with the SA?

I think this really needs to be discussed wrt the implementation of the entity
providing the path records.

>IB QoS is based on the query providing the <SGID, DGID, PKEY, SID, TOS>
>tuple and the SA returning a <SLID, DLID, SL, MTU, ....> QoS tuple. Now
>I'd like to see how can we let the application / querying middleware to
>take advantage of the knowledge on what partition it runs and use the SL
>associated with the IPv4 (e.g AF_INET rdma-cm ID's) IPoIB broadcast
>group. This way, one can still program a QoS scheme at the SA which is
>based on partitions.

I think what's needed is a way for the SA to distribute QoS information to the
end nodes, so that the decisions can be made locally.  If someone wants some
sort of dynamic QoS management and is happy using a small cluster, then they can
disable any local SA entities and contact the SA directly.

In the case of ACM, the pkey is embedded in the MGID.  'Something' could tell
the SA to create ACM multicast groups using a specific SL for a given MGID or
pkey in the join request.  That SL would be distributed to the end nodes when
they joined their groups.

>Looking on mckey, the user space code (e.g ACM), could just do rdma_bind
>to an IP address of an IPoIB NIC that uses this partition and then
>rdma_join to an unmapped multicast address which correspond to the
>broadcast group, take the SL and leave the group, makes sense?

The entity that provides the path records cannot depend on calling into the
librdmacm.  The dependency needs to go the other way.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
