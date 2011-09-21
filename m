From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags: ibnetdisc Wrap header for use in C++
 code
Date: Wed, 21 Sep 2011 10:05:14 -0700
Message-ID: <20110921100514.429ac5d2.weiny2@llnl.gov>
References: <20110920104542.9e24c01c.weiny2@llnl.gov>
	<CAO+b5-oy_p1LWm6U8vrKNvNx2kFw-SvizO=9AEeKuU16Sm1skQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-oy_p1LWm6U8vrKNvNx2kFw-SvizO=9AEeKuU16Sm1skQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 21 Sep 2011 03:11:04 -0700
Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:

> On Tue, Sep 20, 2011 at 7:45 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
> > +#ifdef __cplusplus
> > +extern "C" {
> > +#endif
> > +
> > =A0#include <stdio.h>
> > =A0#include <infiniband/mad.h>
> > =A0#include <iba/ib_types.h>
>=20
> It is bad style to surround #include directives with 'extern "C"'.

My bad, thanks for the catch.

Ira

>=20
> Bart.


--=20
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
