From: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: IPoIB CM connection establishment protocol question
Date: Thu, 5 Aug 2010 10:25:27 -0700
Message-ID: <3F6F638B8D880340AB536D29CD4C1E1925AC41133A@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Could someone who is OFED IPoIB knowledgeable help me understand which IPoIB side starts the RC connection establishment (Tx REQ) to an ARP unknown remote host?

I tried reading the Linux IPoIB code and realized it's been too many years since writing Linux network drivers (2001) and found myself lost in the bits w.r.t. CM connection mgmt. and ARP handling.

>From limited observation, it looks like the ACTIVE side (ttcp -t) of an IPoIB network connection broadcasts an IB ARP-REQ which indicates CM capability in the IB ARP flags byte.

When the PASSIVE IPoIB (ttcp -r) receives the IB ARP-REQ, it sends back an IB ARP-REPLY which indicates it's CM capability among other items.

Now the confusing part: which IPoIB CM side starts the CM-RC connection establishment?

Does the PASSIVE IPoIB start the RC connection (Tx REQ) prior to sending the IB ARP-REPLY?

Or does the ACTIVE IPoIB side receive the IB ARP-REPLY and then start an ACTIVE RC connection (Tx REQ) now that it knows the remote side is CM capable?

thanks,

stan.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
