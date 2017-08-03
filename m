From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: RDMA mini-summit during LPC 2017
Date: Thu, 3 Aug 2017 08:20:49 +0300
Message-ID: <20170803052049.GG13672@mtr-leonro.local>
References: <20170403180820.GS20443@mtr-leonro.local>
 <20170404062141.GA8886@lst.de>
 <alpine.DEB.2.20.1704041016260.23821@east.gentwo.org>
 <1501642385.2800.2.camel@wdc.com>
 <20170802034102.GU13672@mtr-leonro.local>
 <1501710141.16387.1.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="YNEMMPJXay2VNSoy"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1501710141.16387.1.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "ram.amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org" <ram.amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org" <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--YNEMMPJXay2VNSoy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 02, 2017 at 09:42:24PM +0000, Bart Van Assche wrote:
> On Wed, 2017-08-02 at 06:41 +0300, Leon Romanovsky wrote:
> > On Wed, Aug 02, 2017 at 02:53:05AM +0000, Bart Van Assche wrote:
> > > On Tue, 2017-04-04 at 10:17 -0500, Christoph Lameter wrote:
> > > > On Tue, 4 Apr 2017, Christoph Hellwig wrote:
> > > > > unfortunately LPC is at the same time as SNIA SDC, so I won't be able
> > > > > to make it.
> > > >
> > > > Well jet over from SFO to LAX late Thursday or so and join us on Friday.
> > >
> > > I plan to attend the RDMA mini-summit.
> >
> > Thanks Bart,
> >
> > Will you be able to drive topics raised by Sagi?
> >
> >  1. Adding NUMA hints to *all* rdma resources.
> >  2. SRQ sizing. No one knows what is a correct SRQ size.
> >  3. Adaptive interrupt moderation.
> >  4. Striding receive queue in core API
> >
> > IMHO, 1 and 3 have right audience during the conference.
> >
> > http://wiki.linuxplumbersconf.org/2017:rdma#proposed_schedule_tentative
>
> Hello Leon,
>
> If someone can help me with taking notes during the discussion I can drive one
> of these topics. Personally I'm most interested in [1] and [4].

4 is also fine, Liran, Tzahi and Jason will be at that minisummit, so
I'm sure that it will lead to a fruitful discussion.

Regarding notes, It is my lesson-learned from the previous year.
My initial thoughts were to bring sound recorder, record everything,
convert to the notes with Mechanical Turk [1] and post it here after
internal review.

[1] https://www.mturk.com/mturk/welcome

>
> Best regards,
>
> Bart.

--YNEMMPJXay2VNSoy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmCsrEACgkQ5GN7iDZy
WKcrsw/7BOv6QsfDAc67hWZKLYpMSMIXDPZW/thE0vGZrDWkp1PRQ2lh/FXhkhxI
qCmDWnEeljlAn2aWmyKrwbJPojs9BZepilQ1n4+NatgLczfL3h7WySq87ccG3Q0a
RGxoc4dYfaHb3q9+rl5Qr9DDLxEYOcEx5qJPiZaMsQFv1AbRS13KBMeo9qdqXB0m
VYkwJ4JqE1d+3OffMZkFFflfsKRnWX6zTUMTSGahdUehAdWIsm2iIR8V7qCMYGLW
Xb9EWA3uIeabRdi/vow5qGddZst3Z6tqQFfGw4yKIH4RDHcJncnLmg/2iUPUU4Ss
LPz1kG3Ev8O1pvVFXO1nEVFaUutp3uLs7wwPwSoIX/r0n69js4Pji4i0SJpdRq5F
hIVNc5J9OC8gJMAz2WgLX8g+PByyxny27BmA9hOHMuqw+b+//5WKFC5Fnf+7D8vh
r0CmdbDIJjabzWccTKlJpGHhboCng47AV28vkn6U4EUCITnshKq+ORmGtD0u3Z3h
LCUpTH2Fr1tePXMET+u79y79OrIFC5R4WmqofgR9dgmqNDqoHHKuuqvlpj7YtDup
KXNlinCpj5o1CZF4pVIqbpko5SePNmrJ+koKBIU7daqHrp3rlr8EAqrSBt+lQgho
iXOZa/VrWwoGjfGPinK0/ETWTHma9grS4PLdZOWRf0NJAZk49Ys=
=ZIjq
-----END PGP SIGNATURE-----

--YNEMMPJXay2VNSoy--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
