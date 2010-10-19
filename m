From: Jonathan Rosser <jonathan.rosser-gjMux1o1B1/QXOPxS62xeg@public.gmane.org>
Subject: Re: [PATCH] librdmacm: Do not modify =?utf-8?b?cXBfaW5pdF9hdHRy?= in =?utf-8?b?cmRtYV9nZXRfcmVxdWVzdA==?=
Date: Tue, 19 Oct 2010 08:28:03 +0000 (UTC)
Message-ID: <loom.20101019T101203-293@post.gmane.org>
References: <loom.20101018T140608-776@post.gmane.org> <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7EFD851@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hefty, Sean <sean.hefty@...> writes:

> I added a while(1) loop to rdma_server to allow clients to connected
> repeatedly, and this worked for me.  Jonathan, can you see if this
> works for your testing as well?  If so, I'll commit.

Yesterday I tried setting attr->send/recv_cq = NULL in rdma_get_request() which 
fixes the bug in a somewhat ugly manner. Passing a copy of the attributes is a 
much tidier solution, and your patch works for me.

Many Thanks,
Jonathan.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
