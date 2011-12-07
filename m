From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 2/2] rdma/core: Fix sparse errors
Date: Wed, 7 Dec 2011 20:35:42 +0100
Message-ID: <CAO+b5-qnLoX3sGc8Y4t7GCWTy4YKgp_NBe0WAhGNCkbRY3xFYg@mail.gmail.com>
References: <1828884A29C6694DAF28B7E6B8A8237325653870@ORSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237325653870-P5GAC/sN6hlcIJlls4ac1rfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 6, 2011 at 10:15 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wro=
te:
> Fix errors reported by sparse in the rdma core stack. =A0Note that th=
ese
> are real bugs, but don't affect any existing code to the best of my
> knowledge. =A0The mlid issue would only affect kernel users of
> rdma_join_multicast which have the rdma_cm attach/detach its QP.
> There are no current in tree users that do this. (rdma_join_multicast
> may be used called by user space applications, which does not have
> this issue.) =A0And the pkey setting is simply returned as informatio=
nal.
>
> Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
> please queue for 3.3


Maybe cc-ing stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org is appropriate here ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
