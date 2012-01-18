From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/4] IB/mlx4: add Raw Packet QP support
Date: Wed, 18 Jan 2012 23:11:34 +0200
Message-ID: <CAJZOPZL-NyT7_p5mwQV8cCTAOvpFONnAcRtsj80s==O9F3s6Dg@mail.gmail.com>
References: <alpine.LRH.2.00.1201171330540.24946@ogerlitz.voltaire.com>
	<alpine.LRH.2.00.1201171338430.26871@ogerlitz.voltaire.com>
	<1828884A29C6694DAF28B7E6B8A823732DC04E97@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823732DC04E97-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 18, 2012 at 8:47 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wro=
te:
>> + =A0 =A0 MLX4_RAW_QP_MTU =A0 =A0 =A0 =A0 =3D 7,

> Is there any special meaning for MTU 7 that should be standardized in=
 ib_verbs.h?
> In other places, the code uses IB_MTU_4096 (5):

nope, its the ConnectX firmware that dictates this value for RAW QPs,
same for the msgmax
being 31.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
