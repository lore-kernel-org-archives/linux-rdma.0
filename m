From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/7] IB/srpt: Change default behavior from using SRQ to
 not using SRQ
Date: Tue, 10 Oct 2017 18:44:39 +0300
Message-ID: <20171010154439.GE2106@mtr-leonro.local>
References: <20171006214243.11296-1-bart.vanassche@wdc.com>
 <20171006214243.11296-4-bart.vanassche@wdc.com>
 <20171008100317.GR25829@mtr-leonro.local>
 <1507568205.46071.46.camel@redhat.com>
 <1507568492.2674.11.camel@wdc.com>
 <20171010041423.GJ1252@mtr-leonro.local>
 <9443ec1f-0acd-9fa3-4621-a29085d2c606@redhat.com>
 <20171010150018.GC2106@mtr-leonro.local>
 <1507648402.46071.53.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="VdOwlNaOFKGAtAAV"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1507648402.46071.53.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--VdOwlNaOFKGAtAAV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 10, 2017 at 11:13:22AM -0400, Doug Ledford wrote:
> On Tue, 2017-10-10 at 18:00 +0300, Leon Romanovsky wrote:
> > On Tue, Oct 10, 2017 at 10:34:19AM -0400, Doug Ledford wrote:
> > > On 10/10/2017 12:14 AM, Leon Romanovsky wrote:
> > > >
> > Doug,
> > But my question was "when" and not "how". When should I set this
> > parameter to true?
>
> Whenever you want.  When do you set the maximum TCP window size to 4MB?
>  If you have an issue with things being one way, you try another.
> Things like this are system specific and often there is no universal
> answer, especially since the answer here could very easily depend on
> things like how many targets you are connecting to, how fast those
> targets are, etc.

Bart clearly mentioned disadvantages of XRQ and left me wonder why user
needs to enable it anyway. This is what I'm asking and this is what I'm
hoping to see in the commit message.

I know little about SRP and by asking the questions, I'm trying to fill
the gaps.

>
> > >
> > > > In the commit message, you mentioned disadvantages of using SRQ
> > > > is a
> > > > default and among them - locks contention, which can be changed
> > > > in the
> > > > future. Won't it mean that users stuck with current default,
> > > > because
> > > > change of default will "break" their scripts?
> > >
> > > No, it won't.  If you change the default, you don't remove the
> > > variable,
> > > you just change what its setting is.  Then existing modprobe.d
> > > files
> > > become redundant, but nothing breaks.  People that don't want the
> > > new
> > > setting add a new file to the modprobe.d directory to change the
> > > option.
> >
> > Not accurate, now I won't set any parameter because I'm relying on
> > the
> > fact that the default is without SRQ. Once the default will be
> > changed,
> > it will break my assumption.
>
> So?  Your assumptions are never a reason to prevent ongoing
> development.  By this argument, we would never have been able to turn
> on SCSI Multi-queue by default because when it was first added to the
> kernel it was off by default and people might have made an assumption
> that we would later break when we turned it on by default.

I'm not fully understand the example, The transition to MQ was long
process and one of the difficulties was requirement to smoothly transit
all devices in such way that users won't be affected. This is why it was
disabled by default.

Thanks

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>

--VdOwlNaOFKGAtAAV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnc6ucACgkQ5GN7iDZy
WKf/EhAAuivTn2IE7O20NbcLj71YO1+jgMbKPiIoEQMQqffEwwZfnu6qv9cSDUQv
mqKssroOaWud+JM8csLDvs0mFNj2NHGBAqq2XMjL6Gses/ILzsxM2CnjPygEM8ly
9hnHlu8TuLwHuhYk8/fsbkZ6lXn1OH43wHok5yVWZkYYfAyMR2zJADvFAnek/BR4
bdR/LVCmRsGbtWQB0H3N5UtSyNxc69GOTGp76u1YtF//PDpsvh9OTWFE2RdpE1Xg
djRpk7n6ds8fZUF2ILP7xR5YmTC9O5ZyCGdWwDfyziYlPkf0h2TCZzbmtQNfON/y
sV7dcuL7GSbY6NqdenW/pu1/g9RlozfQ9jQ6qH/u+LUvVWqZMjesPrd7WL++nDZY
wi+kS4w1piClfI5S2x+6qZSbpwdR88hq9c+Ah1PP6ZzlAQanKZd6ZRoXwIVN91tF
pKRhy1IEHtKYS0Dmvsn5i1leC46Hg7QrXiUgEdl4XJ2QtjcSF4/wFkK+/A7yblus
xlwl/M9bIyCLR7Ujb7VN19nBOnTGDD+/JNXxeWcN1Yd4Ck7XXBN35GgD3idHIiGD
x4z3LVx2EF2UOnc4daqRJPmL+xSQWJx/cE2Xti7wq6TFRO/Ji4JORxlP/nS2mXUW
8/8tXfqeR/qrSiY1ox0lliOcG3Gv3hH7AZ7U0XwkTLMZH5XeDVI=
=sGZd
-----END PGP SIGNATURE-----

--VdOwlNaOFKGAtAAV--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
