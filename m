From: "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 8/9] ib/addr: simplify resolving IPv4 addresses
Date: Thu, 19 Nov 2009 08:46:49 -0800
Message-ID: <1258649210.11975.34.camel@wilder.ibm.com>
References: <AD17449F0C4E4FE7B20C32412F077C00@amr.corp.intel.com>
	 <4B024258.7070500@Voltaire.com>  <4B055BBA.8020505@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B055BBA.8020505-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Thu, 2009-11-19 at 16:52 +0200, Or Gerlitz wrote:
> > I reviewed patches 1-6 & 8 and they all look fine, I will give the whole series 
> > a try later this week to further validate them
> 

I tested ipv4 and ipv6 address resolution using ucmatose.  All my tests
ran fine.  I tested with patches 1 through 9 on ofed
1.5(OFED-1.5-20091118-0600) on 2.6.30.  Ucmatose was taken from Sean's
librdmacm git (required for ipv6 support).  Here are the tests I ran:

ucmatose
        [-s server_address]
        [-b bind_address]


ipv4 - Local address
----------------------
ucmatose  -s 127.0.0.1
ucmatose  -s 192.168.0.199
ucmatose  -b 192.168.0.199 -s 192.168.0.199

ipv4 - Remote address
----------------------
ucmatose  -s 192.168.0.198
ucmatose  -b 192.168.0.199 -s 192.168.0.198

ipv6 - Local addresses
-----------------------
ucmatose  -s fe80::202:c903:1:28ed%ib0
ucmatose  -s 2001:db8:1234::1
ucmatose  -b fe80::202:c903:1:28ed%ib0 -s fe80::202:c903:1:28ed%ib0
ucmatose  -b 2001:db8:1234::1 -s 2001:db8:1234::1
ucmatose  -b 2001:db8:1234::1 -s fe80::202:c903:1:28ed%ib0
ucmatose  -b fe80::202:c903:1:28ee%ib1 -s 2001:db8:1234::1
ucmatose  -b 2001:db8:1234::10 -s 2001:db8:1234::1

ipv6 - Remote addresses
------------------------
ucmatose  -s 2001:db8:1234::2
ucmatose  -b 2001:db8:1234::1 -s 2001:db8:1234::2
ucmatose  -b fe80::202:c903:1:28ed%ib0 -s 2001:db8:1234::2
ucmatose  -b fe80::202:c903:1:28ee%ib1 -s 2001:db8:1234::2
ucmatose  -s fe80::202:c903:1:1925%ib0
ucmatose  -b 2001:db8:1234::1 -s fe80::202:c903:1:1925%ib0
ucmatose  -b fe80::202:c903:1:28ed%ib0 -s fe80::202:c903:1:1925%ib0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
