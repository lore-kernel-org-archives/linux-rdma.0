From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: CFP: RDMA Microconference - Call for presentations
Date: Mon, 24 Jul 2017 10:10:01 +0300
Message-ID: <20170724071001.GN3259@mtr-leonro.local>
References: <20170615050305.GF17846@mtr-leonro.local>
 <20170720040739.GU3259@mtr-leonro.local>
 <aa1dc549-ce54-d5b7-00e6-0fe07a5f3736@intel.com>
 <VI1PR0502MB3008B5B0E8C0D48FD77C0FEFD1A70@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="On39KRpqOYGa2XmA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <VI1PR0502MB3008B5B0E8C0D48FD77C0FEFD1A70-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--On39KRpqOYGa2XmA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 20, 2017 at 05:15:40PM +0000, Parav Pandit wrote:
>
>
> > -----Original Message-----
> > From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> > owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Dennis Dalessandro
> > Sent: Thursday, July 20, 2017 11:03 AM
> > To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>; RDMA mailing list <linux-
> > rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> > Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>;
> > Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>; Liran Liss
> > <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Matan Barak
> > <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Subject: Re: CFP: RDMA Microconference - Call for presentations
> >
> > On 7/20/2017 12:07 AM, Leon Romanovsky wrote:
> > > REMINDER !!!!!!!
> > >
> > > On Thu, Jun 15, 2017 at 08:03:05AM +0300, Leon Romanovsky wrote:
> > >> Hi All,
> > >>
> > >> We want to point your attention to the following [1] announcement
> > >> that RDMA microconference is accepted into LPC 2017.
> > >>
> > >> This is a call for presentations for the 2nd RDMA microconference
> > >> which will be held on September 13-15 in Los Angeles, CA. The event
> > >> is intended to gather developers of the RDMA stack and the main
> > >> intent is to provide room for discussion between developers with focus on
> > resolving things.
> > >>
> > >> If you are interested to present, please submit a proposal to
> > >> leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org and/or to Linux RDMA mailing list
> > >> linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org before August 14th, 2017, at 23:59 EST.
> >
> > >
> > >
> >
> > Have exchanged a separate email thread with Leon. I am planning to attend and
> > present for a discussion on how we can add statistics to RDMA Tool. This will
> > focus on device related counters and how an architecture could look that is easy
> > to add more counters and have different counters across devices without
> > requiring a lot of updates to the user space tool.
> >
>
> I haven't synced with Leon yet, nor I have followed any past rdmatool discussion actively for statistics.
> So feel free to ignore my comment.

There were no discussion about it yet :)

>
> Having ethtool style mechanism that allows device related counters is good starting point instead of reinventing a new mechanism.
> Probably a good starting point to follow existing mechanism via 3 similar callbacks get_strings(), get_sset_count(), get_ethtool_stats().
> May be such 3 callbacks for rdamtool from ibdev.

AFAIK, (may be wrong here) the ethtool requires to allocate memory in advance.
It works not bad for small systems, but in large installations with many PF-VF
counters, it starts to be unusable due to out-of-memory failures.

Thanks

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--On39KRpqOYGa2XmA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAll1nUkACgkQ5GN7iDZy
WKcDrRAAqilOM+WZPDnmg4aMINYZ+e4joDEVDIl1O2qEuPBOWepXY9Hb7uQCDXlu
FWTpu4PTYX0CawK5fGCmI59dtFW6+J3o6nMc+120Z6HQwfGQo+mlA/ZV92fc+fJ4
NqtFHZbCsmhpyh8govtXrBdcg6CWa4l+kobGQuQ+7zFnrfU9V6vn61MQ3METxL5R
FlW2jZSa/yYSMOZJToM6tCtSVEhGEJIJdh+3gLaxNnywQX0Gep5/2+weXlXK966j
Cw1sSF8dGstXcJNT3YxPJD9MWA9y1enCg5NuQ1DX3pUl48OkYA7lTRv6fzd9PVKo
qGbUDNFEFzb719qiHyaD4ifpQqnH4gh6evjbii0vD9FFe4V7ZkPOHhwjGATYqIbu
+/a6Iw8bzBk1IwVLKYnJRUQ7+VeqcqbDLk77g663+pDXsY048xakk1ga1k7xrkzd
Q8Sn7RMkb0nxNI2RcdJHp9wRgIDcYKOP4/0eKHDlTgDSJwhuqDJVj5sZMi1/sWmv
AVG8iaPrwy8KPlO5Ao3sbbG7xU4qIgjb3cmn6zJGYclo3uwO2krTAkg+WYpadzuV
UN4RNzpQXRrZ9wwsVW31vPA0fzoi87u31F8wsi5tHNzTTIGdPbWLe/6pyYaHvskl
w1Z6uxdwqQcvcRREmQUfr80HivzG4kZc0hAlw08/Dtz/lW1pDXw=
=0ZTc
-----END PGP SIGNATURE-----

--On39KRpqOYGa2XmA--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
