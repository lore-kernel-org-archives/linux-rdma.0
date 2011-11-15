From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: multicast questions
Date: Tue, 15 Nov 2011 17:29:03 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E9ACEB@ORSMSX101.amr.corp.intel.com>
References: <20111115100505.41345ixd637umx8h@celticblues.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111115100505.41345ixd637umx8h-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "dev-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org" <dev-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> When I try to run mckey I get the following return:
> 
> for the server
> 
> sudo mckey -m 100.100.100.100 -b 100.100.100.100
>     mckey: starting server
>     getaddinfo failed - invalid hostname or IP address
>     test complete
>     return status -3
> 
> I get similar msgs when starting client.
> 
> I guess I am not sure what valid arguments are.
> 
> Should the argument following -m be the ip of the IB interface on the
> server machine?
> What would be valid argument for the -M argument?
> Can the argument following -m and -b be the same?

The -m argument should be a multicast address.  Try 224.0.0.1, or something along those lines.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
