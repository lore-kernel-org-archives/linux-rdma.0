From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] rdma_cm: Add support for a new RDMA_PS_LUSTRE Lustre port space
Date: Thu, 14 Jan 2010 09:25:31 -0800
Message-ID: <ada3a28mwdw.fsf@roland-alpha.cisco.com>
References: <20100113154952.0f01aa1d@frecb007965>
	<20100113155150.59867f40@frecb007965>
	<7ED07283D76C422C9210FBE7C832731B@amr.corp.intel.com>
	<ada6376ndgs.fsf@roland-alpha.cisco.com>
	<20100114135815.69d5a9a5@frecb007965>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100114135815.69d5a9a5@frecb007965> (sebastien dugue's message
	of "Thu, 14 Jan 2010 13:58:15 +0100")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > > I agree.  If setting QoS requires a kernel patch for each application, I
 > > think we've messed up QoS somehow.  There needs to be a way to control
 > > QoS via configuration, rather than rebuilding.
 > 
 >   Right, it's possible via configuration only, but you then cannot separate
 > the different Lustre traffics (MDS and OSS for example).

I guess I don't know enough about Lustre to know why this would be so.
How does creating a new port space for Lustre help with this?  Why can't
one do the same thing in one of the existing port spaces?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
