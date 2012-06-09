From: Vivek Kashyap <kashyapv-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: RE: rsockets and standard socket based TCP benchmarks
Date: Fri, 8 Jun 2012 17:48:42 -0700 (PDT)
Message-ID: <alpine.LRH.2.00.1206081745150.3988@oc4747053027.ibm.com>
References: <4FBD6981.2070502@us.ibm.com>  <1828884A29C6694DAF28B7E6B8A8237346A23C38@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-492050451-1339202923=:3988"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A23C38-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "pradeeps-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org" <pradeeps-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-492050451-1339202923=:3988
Content-Type: TEXT/PLAIN; format=flowed; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Wed, 23 May 2012, Hefty, Sean wrote:

> > netperf
> > - By default netserver forks a child process for each netperf client. As
> > rsockets
> >    doesn't support fork() yet, this doesn't work.
> 
> Btw, fork() is unlikely to work anytime soon, if ever...

rsockets() is a perfect as a wrapper providing Sockets over RDMA, and so is
very attractive. Really nice work.

But to map standard networking applications to rsockets we will run into the
above problem i.e. fork() will not work.  It would be very useful to 
allow for the standard networking paradigm of: bind()->listen()->accept()-
->fork(), and then the server goes back to accept(). That would allow us to 
use rsockets transparently with existing applications.

Is it possible to support fork() for this standard model where the parent
closes its copy of the newly created socket and goes back to waiting on the
original socket in accept, and the child continues with the newly created
socket?

Have you considered some other options to make this happen?

Could we  skip creating the endpoint in raccept(), but actually create the
new endpoint during the frist receive or send? This would then allow the
fork() to occur without the complications with the pinned data.

thoughts?

thanks
         Vivek


--8323328-492050451-1339202923=:3988--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
