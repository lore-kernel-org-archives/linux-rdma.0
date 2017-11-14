From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: rdma-core stable releases
Date: Tue, 14 Nov 2017 09:28:17 +0200
Message-ID: <20171114072817.GQ18825@mtr-leonro.local>
References: <CY1PR0701MB2012C57AB3FDE0232D72F70688500@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <20171106182756.GD18802@ziepe.ca>
 <6012d1c3-cd18-25e8-c5ae-3d678142177b@suse.de>
 <54347E5A035A054EAE9D05927FB467F9B61778A9@ORSMSX101.amr.corp.intel.com>
 <20171110202455.GP18825@mtr-leonro.local>
 <20171110211448.GF17451@ziepe.ca>
 <1eba9063-80a4-ad9d-4adf-93770b9ed7c9@suse.de>
 <20171113070856.GZ18825@mtr-leonro.local>
 <BN3PR07MB2578CD2BC31353CA84CE7CD1F82B0@BN3PR07MB2578.namprd07.prod.outlook.com>
 <20171113191311.GG6918@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="LdJ1tWgGI9xhaWs5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171113191311.GG6918-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>, "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Rahman, Ameen" <Ameen.Rahman-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Radzi, Amit" <Amit.Radzi-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--LdJ1tWgGI9xhaWs5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 13, 2017 at 12:13:11PM -0700, Jason Gunthorpe wrote:
> On Mon, Nov 13, 2017 at 08:47:10AM +0000, Amrani, Ram wrote:
>
> > It is logical that ABI version changes won't be supported. As well as new features that affect the ABI.
> > Still, I would like to have the following fix ability -
> > Use a bit in an existing u32, via adding an entry to an existing enum.
> > I can imagine this being used as a feature disable/enable.
>
> No.
>
> No ABI change means no new symbols in the public header files, no
> changes in manual pages and no 'backwards compatible' changes. No
> ABI changes at all.
>
> Only mainline can have ABI changes, and the -stable should be
> completely compatible up and down all stable releases. Compiling
> against 15.9 should continue to load and work with the same feature
> set 100%.

+1
This is the whole idea of -stable branch.

>
> Anything else is madness and people will start to ask for backpointing
> features and other crazy things to -stable.
>
> Jason

--LdJ1tWgGI9xhaWs5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloKmxEACgkQ5GN7iDZy
WKcIFxAA0AZsfXGw4W+vFL+QSy/SDTSag8DtXh4eS0cFW9lrHtcVvt+pOE5e4OvZ
m1VPKRyMWDwaF83dNFlIEwyHfsJ82sAPRWQij7o3Gg8iLamIkUS80p+ilR3Mi8Ha
XPqTko4QhXoSQS6nUjw77yM26zvVX4e0A5zJXf8hqtndmLcRKX8g55x6M5KIDUsU
9DvSvWvW1qVBiDQIJde+Vr1MLYNfHqLHCFhMl+TnGTInoKiTMWSUQPFbnOJ/25N1
Jxusu95gS+17B4KaQF9zxIN5R+OcPtNY/zMbJbMOzXVqjSq0d6Pltekg6v7fznCT
Y6Ac7LGDNeR9UMIE6NRHqD+bx3VjmiejoP6txDdVPQgAiSFzYMc8jXH5wOGGwYfn
7/WA/8h7MwiQXhjhybwK0TaueRLn/soWkmUmihZm2ZL06hCt0Dsx3Ekcpw/XHRK8
DmgeXWv5SLuJAE7kBEaKSGg915EI3ozEuvfA3OFvMvvTvtjDx/IRM0Jp+vwm+4Bi
bHk3xJiYuUJmsBtOLmJ657SL0XBK9cmJEp4XzsfWlB8sCZqHGHd2RrcWvuVlDSgM
IZXBJU2SoECW0E3CmiGKApEAMfCmVITm9qlotdlizdZvTjT5fBtskbGhBVgajtkp
wZHW2Mt6Ujmq3wU3vdqSYcqbij+FgqqRRjw83PwiooLAGG91/VE=
=EMbg
-----END PGP SIGNATURE-----

--LdJ1tWgGI9xhaWs5--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
