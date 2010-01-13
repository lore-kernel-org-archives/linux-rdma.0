From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/3] rdma_cm: Add support for a new RDMA_PS_LUSTRE Lustre port space
Date: Wed, 13 Jan 2010 08:56:30 -0800
Message-ID: <7ED07283D76C422C9210FBE7C832731B@amr.corp.intel.com>
References: <20100113154952.0f01aa1d@frecb007965> <20100113155150.59867f40@frecb007965>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100113155150.59867f40@frecb007965>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'sebastien dugue' <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>  This patch adds a new port space for use by Lustre traffic.
>
>  This, along with patches to OpenSM and Lustre, allow to define a
>specific QoS for lustre.

In general, I don't like the idea of application port spaces for QoS
support.  Can't this be done using port numbers in the existing port
space?

>+	RDMA_PS_LUSTRE = 0x0153,

It looks like this number maps to the VINES protocol.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
