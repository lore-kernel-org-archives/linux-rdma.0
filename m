From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/7] libibverbs: Add link layer field port attribute
Date: Wed, 20 Jul 2011 21:08:26 +0300
Message-ID: <CAJZOPZ+HjKiSr=Q6ti9zPfx0YnGXK796xK+Y8fDtLLuM3SnKbA@mail.gmail.com>
References: <alpine.LRH.2.00.1107191223460.5580@ogerlitz.voltaire.com>
	<alpine.LRH.2.00.1107191226210.5580@ogerlitz.voltaire.com>
	<20110719170454.GD18090@obsidianresearch.com>
	<CAJZOPZ+=3jr18x8Uxt73jAfT0bdPhntOez9dyZfmiHOF5REOSw@mail.gmail.com>
	<20110719195020.GE18090@obsidianresearch.com>
	<CAJZOPZ+2S=agGurUC6393e7mqQy4Ob1jaseeoWxeZe2Yu-kCLg@mail.gmail.com>
	<20110719203140.GG18090@obsidianresearch.com>
	<1828884A29C6694DAF28B7E6B8A82373136EFE8F@ORSMSX102.amr.corp.intel.com>
	<20110719213902.GH18090@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110719213902.GH18090-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> The commit comment states the goal is to have new apps see
> IBV_LINK_LAYER_UNSPECIFIED for all possible combinations of old stuff=
 underneath.
> [...]  The problem is with the userspace ABI out of libibverbs. Curre=
nt
> libibverbs does not zero its ib_port_attr structure before returning.

> Build this with Or's patch applied, then run it against libibverbs 1.=
1.5
> =A0struct ibv_port_attr attr;
> =A0attr.link_layer =3D 100;
> =A0ibv_query_port(..,&attr);
> =A0assert(attr.link_layer =3D=3D IBV_LINK_LAYER_UNSPECIFIED); // Fail=
s!

impossible, see below why

> That is an ABI breaking issue that is not dealt with by Or's patch - =
couple choices:
> =A01) Require and document callers using ibv_query_port to zero attr
> =A0 =A0before hand when using link_layer
> =A02) Crank the symbol version on ibv_query_port so dynamic linking=A0=
fails
> =A03) Inline the memset in ibverbs.h:


YES, #3 is what the patch does, and it follows your suggestion!!

+static inline int ___ibv_query_port(struct ibv_context *context,
+                                   uint8_t port_num,
+                                   struct ibv_port_attr *port_attr)
+{
+       port_attr->link_layer =3D IBV_LINK_LAYER_UNSPECIFIED;
+       port_attr->pad =3D 0;
+
+       return context->ops.query_port(context, port_num, port_attr);
+}
+


+#define ibv_query_port(context, port_num, port_attr) \
+       ___ibv_query_port(context, port_num, port_attr)
+

So we are okay now, correct?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
