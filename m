From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] rdma_cm: Add support for a new RDMA_PS_LUSTRE Lustre port space
Date: Wed, 13 Jan 2010 09:04:19 -0800
Message-ID: <ada6376ndgs.fsf@roland-alpha.cisco.com>
References: <20100113154952.0f01aa1d@frecb007965>
	<20100113155150.59867f40@frecb007965>
	<7ED07283D76C422C9210FBE7C832731B@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7ED07283D76C422C9210FBE7C832731B-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org> (Sean
	Hefty's message of "Wed, 13 Jan 2010 08:56:30 -0800")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: 'sebastien dugue' <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > In general, I don't like the idea of application port spaces for QoS
 > support.  Can't this be done using port numbers in the existing port
 > space?

I agree.  If setting QoS requires a kernel patch for each application, I
think we've messed up QoS somehow.  There needs to be a way to control
QoS via configuration, rather than rebuilding.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
