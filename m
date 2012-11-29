From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: rsockets and fork
Date: Thu, 29 Nov 2012 16:27:06 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346ADAC17@ORSMSX101.amr.corp.intel.com>
References: <1344899557.2101.29.camel@oc1677441337.ibm.com>
	<1828884A29C6694DAF28B7E6B8A8237346A7DB36@ORSMSX101.amr.corp.intel.com>
	<502A9039.4090505@us.ibm.com>
	<1828884A29C6694DAF28B7E6B8A8237346A89125@ORSMSX101.amr.corp.intel.com>
	<1344968289.2101.36.camel@oc1677441337.ibm.com>
	<1828884A29C6694DAF28B7E6B8A8237346A89AEB@ORSMSX101.amr.corp.intel.com>
	<1345239625.1128.20.camel@oc1677441337.ibm.com>
	<1828884A29C6694DAF28B7E6B8A8237346A89F70@ORSMSX101.amr.corp.intel.com>
	<1828884A29C6694DAF28B7E6B8A8237346A89F90@ORSMSX101.amr.corp.intel.com>
	<1828884A29C6694DAF28B7E6B8A8237346A8A7A8@ORSMSX101.amr.corp.intel.com>
	<CAL1RGDW+QSXnfa5yvEsb7XqXMVbVVU6sz7BEKRPmc0tSYi8m9Q@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237346A8ADD4@ORSMSX101.amr.corp.intel.com>
 <CAJZOPZJWzKZ3fjUsbBVA8-Dv+YTajJBStP2VzBw=VrfXHSi=xw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZJWzKZ3fjUsbBVA8-Dv+YTajJBStP2VzBw=VrfXHSi=xw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Was there progress on using rsocket under netperf or fork in general?

Fork support in rsockets is available now, and netperf should work.  It's not generic enough to handle any arbitrary call to fork, but will work if the app does something like this:

listen()
s = accept()
fork(s)
 
> Do you think for the netperf and maybe other uses case of fork rsockets can use
> CM redirect (e.g through the rdma-cm supporting rdma_redirect - within
> the server to bypass the fork limitation?

The last problem I hit into was trying to support vsftp, which called chroot.  Handling chroot requires kernel changes.  But, between fork, fstat, chroot, dup2, epoll, and other calls, a kernel implementation of rsockets (or something similar) looks more appealing for apps that favor full compatibility over performance.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
