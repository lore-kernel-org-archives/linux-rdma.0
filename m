From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH] [libibverbs] Allow 3rd party extensions to verb routines
Date: Thu, 1 Dec 2011 09:47:05 -0800
Message-ID: <CAL1RGDVxfoC1F7EuD56JMspR26ELN1=UGazXN9jJ36+avqHRqQ@mail.gmail.com>
References: <1828884A29C6694DAF28B7E6B8A8237316E8D0DA@ORSMSX101.amr.corp.intel.com>
 <1828884A29C6694DAF28B7E6B8A8237323FC1C38@ORSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237323FC1C38-P5GAC/sN6hlcIJlls4ac1rfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 30, 2011 at 1:38 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wro=
te:
> Have you had a chance to think about this patch? =A0It would be nice =
to have user space xrc support defined to match up with the kernel.

I think this is the right approach -- need to get a big enough chunk
of time to look into the details.

I agree about getting userspace XRC support out there too.  I want to
do a checkpoint release of libibverbs with IBoE support (ie what's in
the tree already) and then get XRC in.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
