From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH RFC 2/9] IB/core: Introduce Signature Verbs API
Date: Tue, 22 Oct 2013 18:20:22 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388CEE286@ORSMSX109.amr.corp.intel.com>
References: <1381851510-17290-1-git-send-email-sagig@mellanox.com>
 <1381851510-17290-3-git-send-email-sagig@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A8237388CE2BFF@ORSMSX109.amr.corp.intel.com>
 <5263D2DE.8010500@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A8237388CEA91E@ORSMSX109.amr.corp.intel.com>
 <52655282.1000505@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A8237388CEE1C7@ORSMSX109.amr.corp.intel.com>
 <5266BA11.6090300@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5266BA11.6090300-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > Would we lose anything making this a new operation for the QP, versus
> trying to hook it into the existing ib_post_send call?
> 
> If I understand correctly you are suggesting making it a verb? Well this
> operation is a fast-path operation - so I guess we will loose it in this
> case.
> Take SCSI for example, for each IO operation submitted by SCSI
> mid-layer, transport layer should perform any protection policy that
> SCSI asked for.
>  From this point of view, signature operation resembles fast
> registration (since the transport does not own the IOP data buffers, so
> it uses fast registration methods).
> That is why we are hooking into ib_post_send.

I'm suggesting multiple calls that can post to the send queue, rather than one call that does a giant switch statement at the beginning based on the opcode.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
