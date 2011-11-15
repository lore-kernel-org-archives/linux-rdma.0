From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: multicast questions
Date: Tue, 15 Nov 2011 21:08:46 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E9ADC5@ORSMSX101.amr.corp.intel.com>
References: <20111115100505.41345ixd637umx8h@celticblues.com>
 <1828884A29C6694DAF28B7E6B8A8237316E9ACEB@ORSMSX101.amr.corp.intel.com>
 <20111115112308.46843g8f74jro6j0@celticblues.com>
 <1828884A29C6694DAF28B7E6B8A8237316E9AD2E@ORSMSX101.amr.corp.intel.com>
 <20111115132322.13706h224483lmwq@celticblues.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111115132322.13706h224483lmwq-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "dev-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org" <dev-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The following are my eth0 IPs
> M1 100.100.100.41
> M2 100.100.100.42
> M3 100.100.100.43
> M4 100.100.100.44
> 
> The following are my ib0 IPs
> M1 100.100.100.141
> M3 100.100.100.143

It looks like you configured your Ethernet and IB networks as being on the same IP network.  (I'm guessing your subnet mask is 255.255.255.0 here.)  If this is the case, you should configure your Ethernet and IB networks to have separate IP networks (and use private IP network addresses unless you really own the 100.100.100 address range).  E.g. put Ethernet on 192.168.0.x / 255.255.255.0 and IB on 192.168.1.x / 255.255.255.0.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
