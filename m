From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [ofw] [patch][tests][perftest] Make the server and client agree
	to	work via IPv4.
Date: Mon, 20 Sep 2010 08:31:20 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25AB78C89D@orsmsx501.amr.corp.intel.com>
References: <E113D394D7C5DB4F8FF691FA7EE9DB443BF12865B9@MTLMAIL.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E113D394D7C5DB4F8FF691FA7EE9DB443BF12865B9-WQlSmcKwN8Te+A/uUDamNg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Irena Gannon <irena-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

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
2. We want to support ipv6.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
