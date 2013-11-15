From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] IB/CMA: Initialize hop_limit to a known default macro
 instead of 1 as is done currently.
Date: Fri, 15 Nov 2013 18:58:00 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388D05F2C@ORSMSX109.amr.corp.intel.com>
References: <07f80ed7-7ea4-4c30-afe5-3f9fc7dd37fb@CMEXHTCAS2.ad.emulex.com>,<1828884A29C6694DAF28B7E6B8A8237388D046BC@ORSMSX109.amr.corp.intel.com>
 <7F44EA5110810A40B7DAFB605C41975D2C8AB76A@CMEXMB1.ad.emulex.com>
 <1828884A29C6694DAF28B7E6B8A8237388D05B18@ORSMSX109.amr.corp.intel.com>
 <7F44EA5110810A40B7DAFB605C41975D2C8AB8C4@CMEXMB1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7F44EA5110810A40B7DAFB605C41975D2C8AB8C4-DWYeeINJQrxExQ8dmkPuX0M9+F4ksjoh@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Somnath Kotur <Somnath.Kotur-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Just wondering if it'd scale better if we start off with a known bigger
> default hop limit and set it to 1 only if we know that we are _not_ going
> out of the subnet ?

Let me back up.  If this is doing RDMA over IP, then we're no longer RoCE and more significant changes may be needed throughout the stack.  For example, what does it even mean to have a path record over IP?

> In any case, I'm still trying to understand how best to do what you are
> suggesting i.e take into account the src/dst addresses on different subnets
> , and so far the only piece
> Of code that I could find that does something close to that would be the
> ib_init_ah_from_path() , in particular the snippet (and my comment )below.
> Would you suggest modifying it here?  Is my understanding correct or am I
> missing something ?

I would first look at the network stack to see what it does, but I was suggesting something like this:

if (src and dst IP address are on the same subnet)
	hop_limit = 1;
else
	hop_limit = something else;

But it seems that this sort of change needs to be placed in context of some larger patch set that introduces RoIP (or IBoIP), assuming that's what 'routable RoCE' really is.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
