From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: rdma-ndd shipped by infiniband-diags and rdma-core
Date: Mon, 15 May 2017 07:44:19 +0300
Message-ID: <20170515044419.GW3616@mtr-leonro.local>
References: <1494335693.3752.1.camel@profitbricks.com>
 <20170509175406.GJ10073@mtr-leonro.local>
 <2807E5FD2F6FDA4886F6618EAC48510E67CAA0F6@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bGopQmzlzQgFk3Fg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E67CAA0F6-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "'Hal Rosenstock (hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org)'" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--bGopQmzlzQgFk3Fg
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 15, 2017 at 04:42:14AM +0000, Weiny, Ira wrote:
> >
> > On Tue, May 09, 2017 at 03:14:53PM +0200, Benjamin Drung wrote:
> > > Hi,
> > >
> > > /usr/sbin/rdma-ndd is shipped by infiniband-diags (version 1.6.7-1
> > > in
> > > Debian) and the rdma-core package. This makes both package not
> > > installable in parallel. rdma-ndd should be shipped by only one
> > > source package. If rdma-core is the new upstream for it, please
> > > remove it from infiniband-diags and publish a new release. Otherwise
> > > I cannot add the correctly version Breaks & Replaces to the Debian pa=
ckage.
> >
> > Ira,
> >
> > Didn't you release when you merged rdma-ndd with rdma-core?
>
> Indeed this has been in the plans.
>
> Leon, as I have said in the past I want to move the infiniband-diags to t=
he Linux-rdma github but only after the libibmad merge.
>
> For review I have put my proposed new infiniband-diags (planned v2.0) her=
e:
>
> https://github.com/weiny2/infiniband-diags/tree/master-new
>
> I'd like to have Hal check it out before I push this officially and relea=
se it.
>
> In the meantime Leon can you set me up a repo on Linux-rdma and once we h=
ave settled on the libibmad merge I will push there with a new v2.0 release.

Sure, which name do you want for this repo?

>
> Ira
>
> >
> > Thanks
> >
> > >
> > > --
> > > Benjamin Drung
> > > System Developer
> > > Debian & Ubuntu Developer
> > >
> > > ProfitBricks GmbH
> > > Greifswalder Str. 207
> > > D - 10405 Berlin
> > >
> > > Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
> > > Web:=A0https://www.profitbricks.com
> > >
> > > Sitz der Gesellschaft: Berlin.
> > > Registergericht: Amtsgericht Charlottenburg, HRB 125506B.
> > > Gesch=E4ftsf=FChrer: Achim Weiss.
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> > > in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo
> > > info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--bGopQmzlzQgFk3Fg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkZMiMACgkQ5GN7iDZy
WKeROQ/+May5JdQKmMLFdjOCW8+tWmbokMwUi+tRNlXfE1faYdhU7sfjRR6akfl1
P5AzXBjNpzgz+UDWHMRc42PO25qCyneWsC4FE6V/mKBd/fl8IBoE/iulnKDQ/fv2
hFuwgE2RExU6wuuyCjupkm48eQg+3mv6sWqMJr7M1NhMlKJM26bZloQrZwKNO7Bf
FUmboSUJO9xSDNTWKREZ7UVt7hGXZlVYsdkqrHFLd9PWgWpdud55Fvw8N90JyG1o
ImiP48TJm3NmsAY4e1KaWr9ilmaznCngDG2VVsbhQvGp4fuFEe7n4LeNqhS+CscE
OXH1dmxU4IEGgCQap4fuOMaVaH7OsbHuWUgDSnrkgZllHJR3q5ehVjlEB1ZhbcLZ
feoqLL8YrUdNxLrE+gkPqd+aXRkblfurGR2r/SI4skFU031tLUj+OpXdc8VJn4N3
OObUvE6akCq1Lq9DJBKrnmOh4i9e5wLitkmWEuQBuEnkBWB6/hKM4AumZ9DjAruu
UX1w8ixZnTJDXbdRpQSd5u19P0Nkqqc/LJh0fcWvsGmM7Bqx+1Q7aHxFs30ThgPm
NkamGLoU++USWgJy2tUHa69PqBgsbehKZJzj/Cjlr2JsWUETtiFjuDE0Xd7UFc+4
Hgnx6FR+UeIL3tiSZy5TI8QNZovEyegCZ/jtzhY/QEJuTv6+PVk=
=58MZ
-----END PGP SIGNATURE-----

--bGopQmzlzQgFk3Fg--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
