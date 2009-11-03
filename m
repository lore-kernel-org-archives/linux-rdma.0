From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] librdmacm/mckey: enforce local binding for unmapped	multicast addresses
Date: Tue, 3 Nov 2009 10:11:38 -0800
Message-ID: <BDD23F8A7760479DBA7B9BA77C642476@amr.corp.intel.com>
References: <Pine.LNX.4.64.0911011130140.6591@zuben.voltaire.com> <AB1AB5E171B44E1AA5FAFB87901C69C7@amr.corp.intel.com> <4AF037F7.9080100@voltaire.com> <72E827020C9E497DB3CAA3DD720E9604@amr.corp.intel.com> <20091103172949.GR1966@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091103172949.GR1966-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Or Gerlitz' <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>My feeling is when AF_IB is introduced the hacky overload of AF_INET6
>should be deprecated and MGIDs must be passed in as AF_IB - and some
>ancillary optional data to set the pkey, rate, etc for the join request.

Yes, I expect AF_IB to fix this.

>BTW, the kernel test for 0xFF1-scope-A01B is busted:
>
>(s6_addr32[0]) & 0xFF10A01B) == 0xFF10A01B
>
>I was wondering what that was about. Should have been
>
>(s6_addr32[0]) & 0xFFF0FFFF) == 0xFF10A01B
>
>Right?

The check is wrong and should match the latter.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
