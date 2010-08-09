From: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: Re: ucma question - backlog limit
Date: Mon, 9 Aug 2010 22:05:45 +0200
Message-ID: <OF3246003B.2B80F29F-ONC125777A.006C2205-C125777A.006E6442@ch.ibm.com>
References: <4C6049EE.1020907@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C6049EE.1020907-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Agreed.

Currently, if running out of backlog, the cm actively
rejects the connection with -ENOMEM back to the provider
(see ucma_event_handler(), and cm_conn_req_handler()).
That should allow the provider to zap the TCP connection,
but its not very productive ;)

Bernard.

Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote on 08/09/2010 08:33:18 PM:

> On 08/09/2010 12:51 PM, Hefty, Sean wrote:
> >> I agree.  I think it should default to say 1024.  Further, I propose
we
> >> make this a sysctl variable such that admins can tweak it as needed.
> >>
> > The default is based on:
> >
> > #define SOMAXCONN       128
> >
> > I have no objection to making it adjustable.
> >
> > - Sean
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma"
in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
>
>
> For TCP, a dropped SYN will cause the peer to retransmit the SYN, and
> the connection will be eventually established.  So a small backlog limit
> is probably ok for TCP.  With iWARP, the connect request is TCP payload
> an on established connection.  So the connection request is transmitted
> and acked at the TCP level by the time the connect request gets dropped
> in the ucma.  What finally happens is the peer times out (after many
> seconds typically) and kills the connection.  Further, a 32 node 256NP
> OpenMPI job will generate > 128 connect requests on some ranks.
>
> So I think its reasonable to up default max value.   I'll post a patch
> to change the max and make it a sysctl variable as well.
>
> Ok?
>
> Steve.
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
