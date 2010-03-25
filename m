From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] [PATCH 5/22 v2] [for 2.6.36] rdma/cm: update port	reservation to support AF_IB
Date: Thu, 25 Mar 2010 15:40:35 -0700
Message-ID: <C70579E21917462C89AAEAE3C225A58B@amr.corp.intel.com>
References: <2F3826558E79459EAD2A457A604221C1@amr.corp.intel.com> <012F7D9E5E97445E9100EF170212AEE7@amr.corp.intel.com> <7451BD1514874F3E987E55040776EECC@amr.corp.intel.com> <20100325202924.GO29129@obsidianresearch.com> <AC26D518E7AE4BE6BA3BDFC11480F8DB@amr.corp.intel.com> <20100325220435.GP29129@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100325220435.GP29129-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>Does this early association with the port space have any effect?

Doing it early versus later - no.  Doing it at all - yes.

>I would be inclined to ditch the port space concept entirely for
>AF_IB. Just ignore the input parameter and always base the selection
>on the SID region. It is confusing to that there are two ways to
>specify the same thing.

The address family is not sufficient to determine the desired port space.  For
example, AF_INET is usable for RDMA_PS_TCP and RDMA_PS_UDP.

>Is there any reason the port space has to be known when the cm_id is
>created but before bind?

No - but it is still required for transport neutrality.  rdma_create_id() simply
stores the value.

So... the port space could be specified during rdma_bind_addr and
rdma_resolve_addr instead of rdma_create_id, with the port space being
determined based on the sid/mask if AF_IB, rather than given directly.  That
seems more complex to me than just specifying it up front when rdma_create_id is
called.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
