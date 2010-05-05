From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/3] ib/iser: remove buggy back-pointer setting
Date: Thu, 6 May 2010 00:14:46 +0300
Message-ID: <t2v15ddcffd1005051414ga07c3d27j7ab10a56bff5795d@mail.gmail.com>
References: <Pine.LNX.4.64.1005051726110.29957@zuben.voltaire.com>
	 <Pine.LNX.4.64.1005051730170.29957@zuben.voltaire.com>
	 <4BE1AFF4.30600@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BE1AFF4.30600-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org> wrote:
> Or Gerlitz wrote:

>> since iscsi connection objects are recycled, on the time the transport  connection
>> (e.g iser's ib connection) is released it is illegal to touch the iscsi connection tied to the
>> transport back-pointer, as it may already point to a different transport connection

> I agree on it being a bug

Mike,

So we both agree its a bug, good. Now, with these patches
ep_disconnected isn't blocking any more till the disconnect event is
delivered but rather only till all posted sends and receives are
flushed. Once I started to do that, I was hitting the bug! e.g if I
take a path/port down and then after few seconds UP, before the
session recovery timeout, the session's iscsi connection was
successfully recycled and bounded to an newly allocated ib connection
/ ep. When the disconnect event was finally arriving, the old ib
connection was NULL-ifying the ib_conn pointer
from iscsi_conn->iser_conn and the when iscsid was attempting to send
a PDU (e.g NOP) through the new connection, I got a crash.

> but do you remember why that was added to iscsi_iser_conn_destroy originally?
> I later moved it to iser_conn_release in commit
>  b40977d95fb3a1898ace6a7d97e4ed1a33a440a4 but I think Erez had added that null
> and some checks for it being null for a specific bug. I am not 100% sure. Look in the git logs
> to make sure. I will check them too when I get some more time.

okay, I'll look on the git logs, but I think there's a good chance it
was just sitting there, not added at some point, we'll see.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
