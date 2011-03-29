From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] man/rdma_notify: document EISCONN errno value
Date: Tue, 29 Mar 2011 22:11:43 +0200
Message-ID: <AANLkTimXedf92NDTOHT_tpZ3ricqGgjzm89__Ks2pSgW@mail.gmail.com>
References: <alpine.LRH.2.00.1103291209520.30460@ogerlitz.voltaire.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25DC7B79F6@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25DC7B79F6-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hefty, Sean wrote:
> thanks - slightly expanded on, but applied

Sean, reading again through the man page, I find the "In most cases,
use of this routine is not necessary, however if connection
establishment is done out of band (such as done through Infiniband),
it's possible to receive data on a QP that is not yet considered
connected.  This routine forces the connection into an established
state in this case in order to handle the rare situation where the
connection never forms on its own." to be somehow confusing, this is
b/c if connection establishment is done out of band, namely not
through the IB CM, then the application doesn't use the RDMA CM nor
the IB CM at all, and will not call into rdma_notify... the rare
situations where this call is needed for apps using the rdma-cm/cm is
when the "data crosses the RTU" that is reaches the application before
the CM got into the established state or before the CM managed to
notify the app on the establish event, or the RTU is lost forever.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
