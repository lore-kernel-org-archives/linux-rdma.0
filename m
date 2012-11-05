From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB: fix task hanging on error recovery
Date: Mon, 5 Nov 2012 19:38:55 +0100
Message-ID: <CAJZOPZLnx4or40HHGHEe0y6UDjQ=eJHH2UmfSK1DJG_e0NBfLQ@mail.gmail.com>
References: <1350683896-3928-1-git-send-email-klebers@linux.vnet.ibm.com>
	<50929160.1000109@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A8237346AC5B9F@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346AC5B9F-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Kleber Sacilotto de Souza <klebers-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cascardo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <cascardo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 5, 2012 at 7:21 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>
> > >   drivers/infiniband/core/ucm.c         |    2 +-
> > >   drivers/infiniband/core/ucma.c        |    2 +-
> >
> > On these files, as far as I understand this code from quick looking, I'm
> > not sure on what
> > exactly the completion objects protects, Sean?
>
> These protect against the caller trying to destroy an object that is in
> use.  For example, it handles the case where the user calls 'connect' on a
> given context, then calls 'destroy' on that same context from another
> thread.
>
> We shouldn't need to deal with any timeouts at this level.
>

OK, thanks, this was my thought as well
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
