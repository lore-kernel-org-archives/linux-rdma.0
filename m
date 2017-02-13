From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 8/8] IB/srp: Drain the send queue before destroying a QP
Date: Mon, 13 Feb 2017 08:07:56 +0200
Message-ID: <20170213060756.GN14015@mtr-leonro.local>
References: <20170210235611.3243-1-bart.vanassche@sandisk.com>
 <20170210235611.3243-9-bart.vanassche@sandisk.com>
 <20170212171928.GF14015@mtr-leonro.local>
 <1486930299.2918.5.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="QQNwO3VdVfodZayb"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1486930299.2918.5.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--QQNwO3VdVfodZayb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Feb 12, 2017 at 08:11:53PM +0000, Bart Van Assche wrote:
> On Sun, 2017-02-12 at 19:19 +0200, Leon Romanovsky wrote:
> > On Fri, Feb 10, 2017 at 03:56:11PM -0800, Bart Van Assche wrote:
> > > -static void srp_destroy_qp(struct ib_qp *qp)
> > > +static void srp_destroy_qp(struct srp_rdma_ch *ch, struct ib_qp *qp)
> > >  {
> > > -	ib_drain_rq(qp);
> > > +	spin_lock_irq(&ch->lock);
> > > +	ib_process_cq_direct(ch->send_cq, -1);
> >
> > I see that you are already using "-1" in your code, but the comments in the
> > ib_process_cq_direct states that no new code should use "-1".
> >
> >  61  * Note: for compatibility reasons -1 can be passed in %budget for unlimited
> >  62  * polling.  Do not use this feature in new code, it will be removed soon.
> >  63  */
> >  64 int ib_process_cq_direct(struct ib_cq *cq, int budget)
>
> Although it is possible to avoid passing -1 as 'budget' by passing a number
> that is at least as large as the number of expected completions, it would
> make it harder to verify the SRP initiator driver. So I propose to modify
> the comment above ib_process_cq_direct().

I don't know,
It seems like an easiest approach is to change the comment especially while
SRP is the only one user of this call. However ability to properly calculate
number of expected completions and compare it while doing destroy_qp is
a valuable thing for correctness too.

Thanks

>
> Bart.

--QQNwO3VdVfodZayb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlihTTwACgkQ5GN7iDZy
WKfDKQ/9G8DdY/CDnkshRbpQbu4Ei3K/8e/mBqnuuuXyEA2nOqI0o/JM/Ki7Q+of
o3vRUnNmQhI1MnapHOiZE+ig5vT0pw5Nr+T52MTwHP9sfEnymnhA7wb9dbMIkLXu
sWpmppsduJxuXStk1fNVrlIxje4a3RHtmln2NhWVMYaL3N9US539q0n3wxwtWyAK
iBVaWZIaXHLbmx1sXPSMTOIlxSaI4W+CVO3MJDImSQTaw4OR4W9cSx019fvakBTh
XjoeU9pi/sw9k5FqpvDljfuWryLaZgMxbaKBB2HrQrh03AWJg98wDiFv4sg5fA2y
RqMnEOoziSi/yx9nU6jxK4B2CxgE3btVYmOhcjEdTg2QYPWDUr9L65U4eBMff8wP
vueV+jKEp4z6r3e8oALbqF53ckw8IGMoppSpcLUDl9lsQAIOHR7YSgGQp9kOqbd7
f+V++NFaYrQeBL+1iN/K1+J7O/tbwscICntFc3YjsfPFPuYG7pkURxjfQ83s+sxv
BuA13sQb+T4k+vQPeVYeBojW8HHdXMfEEGZd0v87XSSmIcpF9NPWKId+7P5G2kuU
qD/YDo9CAJYahKddP51pSh4yWre/4Sk17RiymYVw9Dns2EgF5Z8Dn3hEr4kEOTAR
O5XXjW6VjW9AWjy67lXEeDY50Gi0ndX1n8wLRBZs1EXaXdaF0Zw=
=9v7E
-----END PGP SIGNATURE-----

--QQNwO3VdVfodZayb--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
