From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 4/4] RDMA/cxgb4: add missing padding at end of struct c4iw_alloc_ucontext_resp
Date: Mon, 5 May 2014 12:01:40 -0500
Message-ID: <006e01cf6883$af467af0$0dd370d0$@opengridcomputing.com>
References: <cover.1399216475.git.ydroneaud@opteya.com>	 <2236129ab4aa1ad1562858f363fb6fef0d6bc93b.1399216475.git.ydroneaud@opteya.com>	 <005401cf6873$9216f6e0$b644e4a0$@opengridcomputing.com> <1399309159.2957.19.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1399309159.2957.19.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Yann Droneaud' <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, 'Steve Wise' <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: 'Roland Dreier' <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> > This chunk doesn't apply.  Not sure why.  I can use -F 6 with patch, but it should apply
> > cleanly. Can you please respin this against 89ca3b8 Linux 3.15-rc4?
> >
> 
> I've hand-edited it before sending, but I've tested it with git am
> against linux-next (as of today).
> 
> Anyway, I'm rolling an updated patchset. Sorry for the inconvenience.
>

No problem.  I hand applied it and tested these 2 + the libcxgb4 changes and they seem to work fine.  
 
Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
