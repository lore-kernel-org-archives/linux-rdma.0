From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/3] rdma_cm: Add support for a new RDMA_PS_LUSTRE	Lustre
 port space
Date: Thu, 14 Jan 2010 16:09:43 +0200
Message-ID: <4B4F25A7.6000900@Voltaire.com>
References: <20100113154952.0f01aa1d@frecb007965>	<20100113155150.59867f40@frecb007965>	<7ED07283D76C422C9210FBE7C832731B@amr.corp.intel.com> <20100114134713.01f2bb58@frecb007965>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100114134713.01f2bb58@frecb007965>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

sebastien dugue wrote:
> That can be done with port numbers, except that we cannot separate
> traffic to Lustre MDS and traffic to Lustre OSS 

Looking on these patches and going with you for a minute, I don't see how this patch set serves you to assign a different QoS level (e.g SL) to MDS vs OSS related traffic. Can you elaborate on that a bit?

Sean Hefty wrote:
> Can't this be done using port numbers in the existing port space?

Indeed, Sebastien what prevents you from using the TCP port space, with one port used for MDS traffic and another port for OSS traffic? how does Lustre get ports to listen on, are they well known or you call bind with port zero and use the port allocated by the rdma-cm?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
