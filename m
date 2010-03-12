From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V3 0/2] Add support for enhanced atomic operations
Date: Fri, 12 Mar 2010 07:53:35 -0800
Message-ID: <adavdd1a64g.fsf@roland-alpha.cisco.com>
References: <20100310155749.GA25964@vlad-laptop>
	<A27E2E88-63A0-45EE-9A70-F95B2A0C25AD@Sun.com>
	<adaaaueelby.fsf@roland-alpha.cisco.com>
	<BA082DF0-B3C6-4405-B480-F69B0193BF17@Sun.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BA082DF0-B3C6-4405-B480-F69B0193BF17-UdXhSnd/wVw@public.gmane.org> (=?utf-8?Q?=22?=
 =?utf-8?Q?H=C3=A5kon?= Bugge"'s
	message of "Fri, 12 Mar 2010 10:21:57 +0100")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?utf-8?Q?H=C3=A5kon?= Bugge <Haakon.Bugge-UdXhSnd/wVw@public.gmane.org>
Cc: vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > With the proposed patches in place, how do you know if masked atomics
 > are implemented or not? Guess apps need to know this information
 > already on todays HCAs.

>From the patch:

 > @@ -105,6 +105,7 @@ enum ib_device_cap_flags {
 >  	IB_DEVICE_UD_TSO		= (1<<19),
 >  	IB_DEVICE_MEM_MGT_EXTENSIONS	= (1<<21),
 >  	IB_DEVICE_BLOCK_MULTICAST_LOOPBACK = (1<<22),
 > +	IB_DEVICE_MASKED_ATOMIC		= (1<<23),
 >  };

 > Hence, I think it would be cleaner if a new capability,
 > masked_atomic_cap, were introduced, using the original definitions
 > (NONE, HCA, GLOB).

Actually that does seem more orthogonal to me.
-- 
Roland Dreier  <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
