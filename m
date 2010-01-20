From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] rdma_cm: Add support for a new RDMA_PS_LUSTRE Lustre port space
Date: Tue, 19 Jan 2010 17:12:43 -0800
Message-ID: <adaiqax37g4.fsf@roland-alpha.cisco.com>
References: <20100113154952.0f01aa1d@frecb007965>
	<20100113155150.59867f40@frecb007965>
	<7ED07283D76C422C9210FBE7C832731B@amr.corp.intel.com>
	<ada6376ndgs.fsf@roland-alpha.cisco.com>
	<20100114135815.69d5a9a5@frecb007965>
	<ada3a28mwdw.fsf@roland-alpha.cisco.com>
	<20100115084102.2258eba8@frecb007965>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100115084102.2258eba8@frecb007965> (sebastien dugue's message
	of "Fri, 15 Jan 2010 08:41:02 +0100")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 >   Well, without a specific port space, the default for Lustre is to use the
 > TCP port space so you cannot distinguish Lustre traffic from other traffic using
 > that same port space.

I'm still a bit confused.  The problem as I understand it is that Lustre
always uses the same TCP port, so there's no way to apply different QoS
to different types of Lustre traffic.  But if we create a new port space
and don't change the ports that Lustre uses, then there's still no way
to apply different QoS for different Lustre traffic.  So I guess you
need to change the ports used within the new port space -- but then why
can't you just stay in the TCP space but change the ports used?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
