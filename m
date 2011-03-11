From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH/opensm] Fix SANodeRecord.nodeInfo.localPortNum
Date: Fri, 11 Mar 2011 11:47:13 -0700
Message-ID: <20110311184713.GW22729@obsidianresearch.com>
References: <20110302002941.GA22729@obsidianresearch.com>
 <20110309154744.GV5577@calypso.voltaire.com>
 <20110309171126.GB15419@obsidianresearch.com>
 <20110311093552.GW5577@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110311093552.GW5577-iQai9MGU/dyyaiaB+Ve85laTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > I think the spec is pretty sound on this point. The SA is expected to
> > return SA queries for SMP records that match what is present in the
> > fabric if the requestor did the SMP query itself. The constraints IBA
> > places on a NodeInfo SMP query are such that localPortNum and
> > portGUID must *always* match. You cannot enter on port 1 and query the
> > NodeInfo for port 2 for a CA.

> You are right about this. There is no case I can think of, where
> PortGUID can be different than localPortNum, when it comes to
> CAs. However for switches there is no such coupling. For NodeInfo
> SMP localPortNum can be any port, but the portGUID remain the same.

> All I'm saying is that section 15.2.5.2 or 14.2.5.3 should be more
> clear about the definition of LocalPortNum field when it comes to
> SA.

If you read the spec carefully it is saying that the SA should return
the SMP it would get back from the device if it made the query. Under
that condition the value for localPortNum is pretty clear..

> > So the current SA behavior of returning garbage for localPortNum
> > is essentially returning a NodeInfo that can never be returned by a
> > raw SMP query, which is clearly not aligned with the intent of the spec.

> There is same definition for localPortNum in PortInfoRecord, however the
> correct localPortNum is retrieved. So I guess NodeInfoRecord could act same
> way you suggested.

Hal is correct to point out that PortInfoRecord can return other
localPortNums due to the attribute modifier. Only NodeInfo has the
fixed relationship between port number and portGUID.

> What about using PortInfoRecord to get portGUID<->localPortNumber binding?

That could work, but it is just working around a bug in opensm, and
requires more network traffic. For the application where I found this
bug the SAPortInfoRecord is never retrieved.

> One more minor thing, you defined port_num/match_port_num as unsigned int. I
> think it can be uint8_t, right?

Yes, that is a style choice, it won't affect correctness. Using
'unsigned int' generates slightly better assembly.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
