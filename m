From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: 4.13 ib_mthca NULL pointer dereference with OpenSM
Date: Tue, 31 Oct 2017 03:16:42 +0000
Message-ID: <VI1PR0502MB300860F7C004ABFB01079F53D15E0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <CALpBJjoMLCqzVe5yKp4wCX-X-sH+=zv1QZfMvOWh2Ukh3c2LFg@mail.gmail.com>
 <20171029191114.GO16127@mtr-leonro.local>
 <CALpBJjoJpgR1QB-gzRJLOjGtjK4T2H4EbG1-R+ndodvznWkgwA@mail.gmail.com>
 <20171030071956.GU16127@mtr-leonro.local>
 <CALpBJjqWrXu3b12EG2-AWKwKs9v2q5pTf11rXSy04C-5dGta6A@mail.gmail.com>
 <20171030230156.GA4081@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171030230156.GA4081-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Chris Blake <chrisrblake93-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason,

> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgg-uk2M96/98Pc@public.gmane.org]
> Sent: Monday, October 30, 2017 6:02 PM
> To: Chris Blake <chrisrblake93-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Parav
> Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: Re: 4.13 ib_mthca NULL pointer dereference with OpenSM
>=20
> On Mon, Oct 30, 2017 at 01:39:42PM -0500, Chris Blake wrote:
> > On Mon, Oct 30, 2017 at 2:19 AM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> wrote:
> > >
> > > Can you please try to set CONFIG_SECURITY_INFINIBAND=3Dn and see if i=
t
> > > helps?
> > >
> > > Thanks
> > >
> >
> > Hello Leon,
> >
> > I went ahead and set CONFIG_SECURITY_INFINIBAND=3Dn in my kernel, and s=
o
> > far the issue seems resolved. I will run this for a week or so and
> > will get back to you, but things are looking promising. :)
>=20
> I certainly don't expect this setting to break any drivers..
>
I looked the back trace - happening in freeing ib_free_recv_mad().
It doesn't look a driver issue certainly.

Post_send failure seems to indicate that security enforcement checks likely=
 would have failed on QP0/1.
I tried ib_ipoib and rping with 4.13.10 and ConnectX4 but that didn't help =
with reproduction.
I tried injecting error locally on recv mad, based on suspect and I was abl=
e to crash a host and with below patch I was able to avoid it.

I am yet to review my below patch with Dan as he did most security dev, but=
 I suspect this might be the cause where rmpp list is not initialized and m=
ad processing is continued when security check fails.

Let see if Chris has same issue or different one.

Chris,
Can you try below patch and see if that avoids the crash?

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index f8f53bb..cb91245 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -1974,14 +1974,15 @@ static void ib_mad_complete_recv(struct ib_mad_agen=
t_private *mad_agent_priv,
        unsigned long flags;
        int ret;

+       INIT_LIST_HEAD(&mad_recv_wc->rmpp_list);
        ret =3D ib_mad_enforce_security(mad_agent_priv,
                                      mad_recv_wc->wc->pkey_index);
        if (ret) {
                ib_free_recv_mad(mad_recv_wc);
                deref_mad_agent(mad_agent_priv);
+               return;
        }

-       INIT_LIST_HEAD(&mad_recv_wc->rmpp_list);
        list_add(&mad_recv_wc->recv_buf.list, &mad_recv_wc->rmpp_list);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
