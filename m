From: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Subject: Re: [PATCH 1/3] rdma_cm: Add support for a new RDMA_PS_LUSTRE
 Lustre port space
Date: Thu, 14 Jan 2010 13:47:13 +0100
Message-ID: <20100114134713.01f2bb58@frecb007965>
References: <20100113154952.0f01aa1d@frecb007965>
	<20100113155150.59867f40@frecb007965>
	<7ED07283D76C422C9210FBE7C832731B@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7ED07283D76C422C9210FBE7C832731B-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


  Hi Sean,

On Wed, 13 Jan 2010 08:56:30 -0800
"Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> >  This patch adds a new port space for use by Lustre traffic.
> >
> >  This, along with patches to OpenSM and Lustre, allow to define a
> >specific QoS for lustre.
> 
> In general, I don't like the idea of application port spaces for QoS
> support.  Can't this be done using port numbers in the existing port
> space?

  That can be done with port numbers, except that we cannot separate
traffic to Lustre MDS and traffic to Lustre OSS as can be done with
a target-port-guid.


> 
> >+	RDMA_PS_LUSTRE = 0x0153,
> 
> It looks like this number maps to the VINES protocol.

  Argh, haven't seen that. From what I understand, the low 8 bit are to
be taken from IANA IP protocol ID when bit 8 is 1, but what about when
bit 8 is 0 (as is the case with SDP and IPOIB)?

  Thanks,

  Sebastien.


> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
