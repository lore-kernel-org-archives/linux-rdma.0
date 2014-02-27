From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: dapltest and listening endpoints.
Date: Thu, 27 Feb 2014 12:14:57 -0600
Message-ID: <007f01cf33e7$d28de410$77a9ac30$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
References: 
In-Reply-To: 
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> -----Original Message-----
> From: Steve Wise [mailto:swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org]
> Sent: Thursday, February 27, 2014 11:36 AM
> To: 'arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org'
> Cc: 'linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'
> Subject: dapltest and listening endpoints.
> 
> Hey Arlin, I'm trying to clean up the dapl/iwarp/cxgb4 issues, and I'm
> seeing something strange.  Each time I run a transaction test, I see
that
> listening endpoints are leaked or left around by the dapltest server.
> 
> Q: after a completed test, should the dapltest server process have
> destroyed all of its listening endpoints except for the one used to
handle
> the next test?   Or does it maybe keep them around and reuse them?
> 

Ignore this.  My setup was broken. 

Sorry for the noise...

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
