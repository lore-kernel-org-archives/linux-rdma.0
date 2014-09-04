From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Patches for fine-grained rsocket preloading
Date: Thu, 4 Sep 2014 18:15:26 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237399DC15B4@ORSMSX109.amr.corp.intel.com>
References: <17f3d712c0ef986a2cfe8eb11d99f66d@imap.linux.ibm.com>
 <1828884A29C6694DAF28B7E6B8A8237399DC1580@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237399DC1580-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I didn't follow this.  If rsocket is behaving differently than normal
> sockets, I'm fine updating it so that it matches the desired behavior.  It
> doesn't need to be an option.
> 
> That said, can you provide more details on what the desired behavior
> should be and what rsockets is doing differently?

I did a quick test, and I *think* the difference that you're referring to is this:

Normal sockets:
listen(sX) -> returns success
listen(sX) -> returns success

rsockets
rlisten(rsY) -> returns success
rlisten(rsY) -> fails

Can you confirm that this is the problem you want to address?

If so, then I think a fix to rsockets is needed, rather than trapping this in the preload library.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
