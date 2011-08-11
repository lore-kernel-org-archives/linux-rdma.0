From: Rolf Manderscheid <rvm-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] ibsim: support LID portions of directed-route SMPs
Date: Thu, 11 Aug 2011 15:27:07 -0600
Message-ID: <4E44492B.6080101@obsidianresearch.com>
References: <E1QpTpp-00026I-7p@rvml.edm.orcorp.ca> <20110809145018.GA2056@calypso.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110809145018.GA2056-iQai9MGU/dze+A/uUDamNg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Alex,
> route_MAD() breaks the LID route support.

I think the change to route_MAD() is sound, there's no change in
behaviour for LID-routed packets.  The path argument is expected to be
NULL in the case of a LID routed MAD, which causes an early
return, but this is only an optimization.  Even if you forget to pass
in a NULL path (which I did in one case as you pointed out!), the
path->cnt will be zero for LID routed MADs which causes the
direct_route_*_MAD() functions to just return the same port that was
passed in, so it works either way.  I tested this with some simple
topologies, running opensm and then doing a perfquery to each
simulated node.  I also used python-rdma with a new python simulator
client which is the motivation for this patch.  Without this change,
python-rdma exposes the missing handling of leading and/or trailing LIDs
in directed-route SMPs.  I'll send an updated patch which passes a
NULL path for LID-routed packets at the second call site.

     Rolf
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
