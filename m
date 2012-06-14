From: "Yann Droneaud" <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: RE: ibv_poll_cq() and wc->byte_len
Date: Thu, 14 Jun 2012 14:39:21 +0200
Message-ID: <b4389bf80441286279cf3aa5f730f4ea.squirrel@webmail.ocsa-data.net>
References: <ede34732991cf26d52569692a20d7ae0.squirrel@webmail.ocsa-data.net>
    <1828884A29C6694DAF28B7E6B8A8237346A31355@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A31355-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

>> In a parallel universe, struct ibv_wc would have a bitmap field
>> indicating
>> which others fields are valid. In this part of the multiverse, a more
>> complete documentation would be welcome. If libmlx4/libmthca behavior is
>> the compliant one, I can provide an updated man page.
>
> The best documentation available regarding expected verbs behavior is the
> IB spec (chapter 11).  For this specific field, see section 11.4.2:
>

Thanks a lot for the link.
Once again, I forgot to go through the IB spec.

Regards

-- 
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
