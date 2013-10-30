From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH RFC v1 00/10] Introduce Signature feature
Date: Wed, 30 Oct 2013 15:20:46 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388CF28A5@ORSMSX109.amr.corp.intel.com>
References: <1382970376-13776-1-git-send-email-sagig@mellanox.com>
 <5270DF90.8000802@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5270DF90.8000802-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The team here enhanced krping to fully cover (and test...) the proposed
> API and driver implementation, its (free) under
> git://beany.openfabrics.org/~sgrimberg/krping.git
> 
> We'd like to see this landing in 3.13 such that the development of the
> upper layers can run for 3.14 and and later kernels. Sagi will postV2
> with the two minor changes that came up in Sean's review of V1, thoughts?

If the upper layers won't be ready until 3.14, why can't these changes go in then?

My biggest issue is that the kernel verbs API is becoming more and more unwieldy, and I have heard requests that even the kernel interfaces need to be easier to use.  The main work request structure used to send a message is around 84 bytes long.  This patch bumps that up another 24 bytes or so.  That's over 100 bytes of control data just to send a message!

Maybe we should rethink the approach of exposing low-level hardware constructs to every distinct feature of every vendor's latest hardware directly to the kernel ULPs. 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
