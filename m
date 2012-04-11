From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [RFC] [PATCH 0/4] librdmacm: Rsockets API and implementation
Date: Wed, 11 Apr 2012 20:18:40 +0000
Message-ID: <4F85E720.5040307@acm.org>
References: <1828884A29C6694DAF28B7E6B8A82373451ACEEF@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373451ACEEF-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 04/11/12 18:29, Hefty, Sean wrote:

> The following patch set contains an initial implementation of rsockets as
> presented at the 2012 OpenFabrics Workshop.  A copy of that presentation
> is available at:
> 
> 	https://www.openfabrics.org/downloads/rdmacm/rsockets-ofa12.pptx
> 
> and a video of the presentation can be found here:
> 
> 	http://www.youtube.com/watch?v=2IRrXdIsJuU
> 
> For those of you who don't like clicking on links in an email, rsockets
> is a socket-like API layered over verbs.  It is conceptually similar to a
> user space implementation of SDP, except that it uses custom algorithms and
> protocols.
> 
> The source code has been pushed into an rsocket branch in my git tree at:
> 
> 	git://git.openfabrics.org/~shefty/librdmacm.git rsocket
> 
> All comments are welcome, but mostly verbal praise.  Although comments
> on the wire protocol before an official release would be the most useful.


Interesting work. Regarding direct data placement: have the io_submit()
and io_getevents() system calls been considered ? Those are the
foundation of libaio.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
