From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: librdmacm 1.0.18  + more
Date: Mon, 3 Feb 2014 19:12:09 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388D185E9@ORSMSX109.amr.corp.intel.com>
References: <52EDE0FB.5090208@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52EDE0FB.5090208-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I just noted you've tagged librdmacm  1.0.18 last week, but there was no
> "announce" email, was it just forgotten or something is stillmissing there?

I was waiting for a note from Vlad that he had pulled it into OFED, and that it was working fine.
 
> Also, on a related note, I saw there a commit saying that udaddy will
> not support the IB port space anymore. Does rpingsupport native IB
> addressing? if not, what would it take to get that done? or the same
> arguments under which you didn't want udaddyto go there apply for rping
> too?

I don't believe that rping does, but it could be made to.  The core problem with udaddy comes from this check in rdma_create_id():

	qp_type = (ps == RDMA_PS_IPOIB || ps == RDMA_PS_UDP) ?
		  IBV_QPT_UD : IBV_QPT_RC;

so IB port space support issues are specific to UD QPs (or, non-RC QPs).

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
