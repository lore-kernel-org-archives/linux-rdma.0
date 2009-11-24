From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 7/9] rdma/cm: fix loopback address support
Date: Tue, 24 Nov 2009 14:25:42 -0800
Message-ID: <1E34D9C52BCF4E3E9FB5576484BD6C0B@amr.corp.intel.com>
References: <OF34959131.79AC5DD5-ON88257677.00543B51-88257677.005450AC@us.ibm.com>	 <4B0BA10B.8010207@voltaire.com> <4B0BAD77.8070806@mellanox.co.il>	 <35A21E7711734ABAA1497D924BA7FA9A@amr.corp.intel.com>	 <15ddcffd0911241109m3b93cfdek4e3bc4d73e28dffa@mail.gmail.com>	 <18E034707AEA41A0AB0C0B91C53B4AE2@amr.corp.intel.com> <15ddcffd0911241122o3b4e815cs193fbc19c9c3cb4e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <15ddcffd0911241122o3b4e815cs193fbc19c9c3cb4e-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Or Gerlitz' <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, EWG <Openfabrics-ewg-0P3JtQMG0aQdnm+yROfE0A@public.gmane.org>, "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>okay, got it. I was under the impression that mckey still misses an
>option to get from the user an ipv6 multicast address which isn't all
>zeros nor unmapped, correct? or the -m option will work with both ipv4
>and ipv6 addresses?

The -m and -b options work with IPv4 and IPv6 addresses.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
