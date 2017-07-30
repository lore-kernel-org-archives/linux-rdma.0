From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-rc 10/11] Revert "IB/core: Allow QP state transition from
 reset to error"
Date: Sun, 30 Jul 2017 08:17:06 +0300
Message-ID: <20170730051706.GJ13672@mtr-leonro.local>
References: <20170726181232.7363-1-leon@kernel.org>
 <20170726181232.7363-11-leon@kernel.org>
 <49fe625b-cd44-137e-c001-1d85297f4e62@intel.com>
 <fcacf34e-d16f-3d66-2877-be5b5993f296@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="X+8siUETKMkW99st"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <fcacf34e-d16f-3d66-2877-be5b5993f296-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--X+8siUETKMkW99st
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 27, 2017 at 10:57:26AM -0400, Dennis Dalessandro wrote:
> On 7/27/2017 10:52 AM, Dennis Dalessandro wrote:
> > On 7/26/2017 2:12 PM, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > >
> > > The commit ebc9ca43e1d5 ("IB/core: Allow QP state transition from
> > > reset to error")
> > > allowed transition from Reset to Error state for the QPs. This behavior
> > > doesn't follow the IBTA specification 1.3, which in 10.3.1 QUEUE PAIR AND
> > > EE CONTEXT STATES section.
> > >
> > > The quote from the spec:
> > > "An error can be forced from any state, except Reset, with
> > > the Modify QP/EE Verb."
> > >
> > > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > > ---
> > >   drivers/infiniband/core/verbs.c | 1 -
> > >   1 file changed, 1 deletion(-)
> > >
> > > diff --git a/drivers/infiniband/core/verbs.c
> > > b/drivers/infiniband/core/verbs.c
> > > index fb98ed67d5bc..7f8fe443df46 100644
> > > --- a/drivers/infiniband/core/verbs.c
> > > +++ b/drivers/infiniband/core/verbs.c
> > > @@ -895,7 +895,6 @@ static const struct {
> > >   } qp_state_table[IB_QPS_ERR + 1][IB_QPS_ERR + 1] = {
> > >       [IB_QPS_RESET] = {
> > >           [IB_QPS_RESET] = { .valid = 1 },
> > > -        [IB_QPS_ERR] =   { .valid = 1 },
> > >           [IB_QPS_INIT]  = {
> > >               .valid = 1,
> > >               .req_param = {
> > >
> >
> > The diagram from that section clearly shows you can't go from reset to
> > error. However table 91 as in our original commit message says it could
> > go to error from any state. Taking a step back and thinking about it,
> > I'm not sure it really makes sense to be able to go from reset to error
> > anyway. There is nothing that can go wrong until the qp is transitioned
> > out of reset really.
> >
> > Any idea why this patch was never adopted:
> > http://www.spinics.net/lists/linux-rdma/msg07627.html
> >
> > This was during my storage hiatus so I wasn't following things RDMA back
> > then. However this seems like the correct approach to me. Granted that
> > patch would look different as the code has moved around but the same
> > sort of check could go in ipoib_ib_dev_stop_default().
> >
> > -Denny
>
> Ah guess I should have waited until reading the next patch 11/11!
>
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Thanks Dennis,

I agree with you, the spec is really misleading.

--X+8siUETKMkW99st
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAll9a9IACgkQ5GN7iDZy
WKdLtA//QRosJawAiV4XgFJtIfvtTjTRYRnoKOm4c5UdXUtRZX3GobYiSx8+MpOk
+D0abQJIy1Pdqmeoy/2hTLpbGrTkTfGrErc48U/XwEEil28E+TTGT949kKlVcsqo
/ydndwqSY9WHEtT7aC7kuBAeC73ghN/K1EJpWhKn58q/YKvLno1//fvUsAev97ZS
jUqX2+KVRIzHOw6GhIAJgiXv8VVX4we4Pls7EM9B9ZhCVrNg5jYx2PYCcKayfRKX
iPm2Nh+290qLX8QagL9DXfCyByc3boLWFQCrXK/fnZhKbCF/Djnm0erimoVBWHsj
jB3b/37rag5as4P4NT5f2MxciLggjc4B2qh2ZkPpGFdxG6NyG13GLoGeJVOU+T27
BwBz+Gbw60lKNhdtGfZBnnxZ9F5VKoj6AqTMASa53n1HfY538dqYqwiji/6ARA3h
1ywTciw+PRjJst1hTOPGi5Ts0nc8dRTaaRBYRcItOJdN3jvTryg2VywYWCi5GZSG
J4dnFgkxp7bT/hRpjATuI65QpyVVcGokOq1eA/EUrCmpBu43B3McD9ftYDfro2ut
n8KWx+VMKt3HpA7f+U5/mAiyLG3to7gOnJncO3RR7N0Iy4lbkM1T3EZULuW7zzuu
KqyiDaz6bDwi4kzZdTj1zfsJdDNnFeLfnBBPxruo4rPfNNSuQ18=
=XIDq
-----END PGP SIGNATURE-----

--X+8siUETKMkW99st--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
