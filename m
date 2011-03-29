From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] man/rdma_notify: document EISCONN errno value
Date: Tue, 29 Mar 2011 22:16:13 +0200
Message-ID: <AANLkTi=Ba0LrEQ7B5m=T4zahsk04PVNqLdF5MDH6bxur@mail.gmail.com>
References: <alpine.LRH.2.00.1103291209520.30460@ogerlitz.voltaire.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25DC7B79F6@orsmsx501.amr.corp.intel.com>
	<AANLkTimXedf92NDTOHT_tpZ3ricqGgjzm89__Ks2pSgW@mail.gmail.com>
	<AANLkTi=NN4bBnybFxStHjAEdP6ve9OztRpZMLHPXrm5_@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=NN4bBnybFxStHjAEdP6ve9OztRpZMLHPXrm5_-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 29, 2011 at 10:12 PM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Tue, Mar 29, 2011 at 10:11 PM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> use of this routine is not necessary, however if connection
>> establishment is done out of band (such as done through Infiniband),
>
> my mistake, I understand now what you were trying to say by out of
> band, its QP1 which isn't the app QP, sorry for the spam.

So, we should say here "such as done through Infiniband or Infiniband
over Ethernet", which makes me think there are bunch of references to
Infiniband on the librdmacm man pages where for most of them (e.g all
the ones that don't relate to the IB SA), the IB comment would also be
relevant to IBoE, so how we address that, maybe place a comment on the
rdma_cm(7) page instead of changing every page that needs that?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
