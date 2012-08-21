From: Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH 5/7] librdmacm/rspreload: Do not block connect when
 supporting fork
Date: Tue, 21 Aug 2012 11:20:58 -0700
Message-ID: <1345573258.31684.16.camel@oc1677441337.ibm.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A8997B@ORSMSX101.amr.corp.intel.com>
	 <1345250413.1128.36.camel@oc1677441337.ibm.com>
	 <1828884A29C6694DAF28B7E6B8A8237346A8A1CF@ORSMSX101.amr.corp.intel.com>
	 <1345571022.31684.13.camel@oc1677441337.ibm.com>
	 <1828884A29C6694DAF28B7E6B8A8237346A8A321@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A8A321-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2012-08-21 at 18:00 +0000, Hefty, Sean wrote:
> > I am seeing another hang with 2 clients doing bi-directional traffic to a
> > server.
> > I am consistently seeing this hang with the attached test programs.
> > 
> > You can start the server using
> >   tcp_server -d -e
> > 
> > and run 2 clients
> >   tcp_client -h <server-ip> -n 10000 -d -e
> > 
> > Can you try it out with your IB setup? If you don't see this hang, then it is
> > possible
> > that the issues i am seeing are RoCE specific.
> 
> After looking into netperf more, I think it is hanging for me.  When running multiple clients simultaneously, any client beyond the first after forking stops sending after 300-400 messages.  I haven't checked how much data had transferred, so it may be the same as what you reported.  I'm debugging this.
> 
> I don't have tcp_client/server installed, so I'll need to get those.  Does the server call fork?

These are my test programs and i attached them to my previous email.
Yes, the server calls fork.

Thanks
Sridhar



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
