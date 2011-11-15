From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: multicast questions
Date: Tue, 15 Nov 2011 18:46:03 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E9AD2E@ORSMSX101.amr.corp.intel.com>
References: <20111115100505.41345ixd637umx8h@celticblues.com>
 <1828884A29C6694DAF28B7E6B8A8237316E9ACEB@ORSMSX101.amr.corp.intel.com>
 <20111115112308.46843g8f74jro6j0@celticblues.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111115112308.46843g8f74jro6j0-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "dev-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org" <dev-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Does the multicast address not have to correspond to a real physical
> address?  Do I need to setup anything in the switch?

It should just be an IP multicast address (224.0.0.0 - 239.255.255.255).  The rdma_cm / SA should configure the switches.  You need the -b option if your multicast tables are not configured to use the IP address assigned to the ipoib device.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
