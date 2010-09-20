From: Irena Gannon <irena-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: RE: [ofw] [patch][tests][perftest] Make the server and client agree
	to	work via IPv4.
Date: Mon, 20 Sep 2010 18:06:22 +0200
Message-ID: <E113D394D7C5DB4F8FF691FA7EE9DB443BF130E03A@MTLMAIL.mtl.com>
References: <E113D394D7C5DB4F8FF691FA7EE9DB443BF12865B9@MTLMAIL.mtl.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25AB78C89D@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25AB78C89D-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Please see below.

Thank you.

-----Original Message-----
From: Hefty, Sean [mailto:sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org] 
Sent: Monday, September 20, 2010 5:31 PM
To: Irena Gannon; ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: RE: [ofw] [patch][tests][perftest] Make the server and client agree to work via IPv4.

> This patch makes the server and client agree to work via IPv4.
> 
> This way the socket connection that is opened in the beginning to exchange
> data does not fail because one of the sides works through IPv4 and the
> other through IPv6.
> 
> 
> 
> Index: D:/Windows/MLNX_VPI/tests/perftest/perftest_resources.c

1. I don't see that this file exists in svn.
[Irena] 	You can see the file in: svn://openib.tc.cornell.edu/gen1/trunk/tests/perftest. It was added in commit 2918.
		 
2. We want to support ipv6.
[Irena]  	The IPv4 is used to open a socket in the beginning of the test just in order to exchange the connection info (lid, qp number) between the sides.
		This choice of IPv4 exists in the ib_XXXX_bw/ib_XXXX_lat tests as well, for example in the function pp_client_connect in the file 						tools\perftests\user\perf_utils.c		


- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
