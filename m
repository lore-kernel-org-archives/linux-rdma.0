From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 1/1] RDMA/core: Fixes for port mapper client registration
Date: Thu, 16 Oct 2014 14:46:50 -0500
Message-ID: <005101cfe979$edec8890$c9c599b0$@opengridcomputing.com>
References: <20141016161954.GA23268@TENIKOLO-MOBL2>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141016161954.GA23268@TENIKOLO-MOBL2>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Roland Dreier' <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Tatyana Nikolova
> Sent: Thursday, October 16, 2014 11:20 AM
> To: Roland Dreier
> Cc: john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: [PATCH 1/1] RDMA/core: Fixes for port mapper client registration
> 
> IWPM_REG_CLIENT and IWPM_PREV_REG_CLIENT are added:
> 
> IWPM_REG_CLIENT is a client, registered with the user
> space port mapper daemon, available at the time of the
> client register pid request.
> IWPM_PREV_REG_CLIENT is a client, which has been IWPM_REG_CLIENT
> before the user space port mapper daemon is stopped.
> After restarting the port mapper, IWPM_PREV_REG_CLIENTs provide
> their mapping info to the port mapper daemon and
> they are allowed to send remove mapping requests aftewards.
> 


Hey Tatyana,

Nit:  "aftewards" is misspelled.

Doesn't this feature require provider support?  It seems like this patch really doesn't do anything yet.

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
