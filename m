From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Prepared RDMA Tree for 4.7
Date: Sun, 15 May 2016 09:00:05 +0300
Message-ID: <20160515060005.GH11827@leon.nu>
References: <20160512174406.GB11827@leon.nu>
 <9dbc023f-e442-843a-ab68-eec38ca1d6b7@redhat.com>
 <20160513042217.GD11827@leon.nu>
 <9e5233c8-6641-7f6b-3825-1b67eb70c05b@redhat.com>
 <20160514043353.GG11827@leon.nu>
 <f9210e1d-667d-5f62-f1bd-7545a0ff6153@redhat.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LiQwW4YX+w4axhAx"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f9210e1d-667d-5f62-f1bd-7545a0ff6153-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--LiQwW4YX+w4axhAx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 14, 2016 at 09:09:54AM -0400, Doug Ledford wrote:
> On 05/14/2016 12:33 AM, Leon Romanovsky wrote:
> > On Fri, May 13, 2016 at 12:31:55PM -0400, Doug Ledford wrote:
> >=20
> > <snip>
> >=20
> > I had an intent to help you,
>=20
> That's fine.  As I pointed out in my email, I need to know what I'm
> sending to Linus.
>=20
> > So can you please share with us your plans on how-to address the
> > general lack of "communication, transparency and coordination",
> > which is definitely happen here?
>=20
> I could always just artificially limit each release to no more than 100
> patches or something like that.  Then I would have more time per patch
> to be communicative.  But that wouldn't make people happy, it would take
> months and years to get things done.

Most of the patches are fixes and a lot of them one line only. They can
be acknowledged and applied in more timely manner. This will definitely
remove the tension.

For example, I have a build warning fix for hfi1 driver, but I prefer
don't send it till I see their fixes are applied.

>=20
> But you guys are only partially mad at me.  I'm not the sole
> person/group holding you up from getting your way.

You are the one who makes decision, and not other persons/groups.

> For example the LSO
> patches aren't in, and that because they are an API extension that not
> everyone understands what LSO in that context means.  The patch set
> needs more explanation so that others can actually say if it's generic
> enough to meet their needs.

I agree with you and this is why we are posting it on the ML and adjust
the patches to answer on the feedback.

I don't see it is a blocker, but as a part of open discussion to adjust
patches to meet upstream criteria.

> You guys have a ton of features you want to
> get into the kernel, each one being a different sort of hardware
> offload, and while you may have worked with customers to do the initial
> creation, you didn't work with the community on describing them or
> anything else, and you bring them here fully done to your satisfaction,
> and it takes other people time to wrap their head around what they are,
> whether or not they might be usable in their own hardware, and then to
> decide if the design as presented would work for them if they did decide
> to implement it.  Without their input, I'm left in a rather untenable
> position.  And frankly, I'm rather sick of being in that position.

What is wrong with SELinux patches?

>=20
> I'm quickly coming to agree with the results of the collaboration summit
> in that if a patch set implements a new feature in the form of a user
> visible API change (aka, a new flag to create_qp or a change to user
> visible work completions, that sort of thing), then patches will need
> buy in from other vendors before I'll accept them (where buy in means
> they've read it, they've understood it, and they've publicly given their
> Acked-by: line....silence does not equal buy in!).

There are three issues with this request:
1. It is not silence, but readiness to merge, since all feedback is
answered and everything is understandable. LSO patches are great
example for it, if the people don't understand they will ask and will
request to adjust patches accordingly.
2. It will limit ability to move IB stack further and will eliminate
fair competitive market.
3. According to IBTA [1], there are almost no HW vendors in this field.

[1] http://www.infinibandta.org/content/pages.php?pg=3Dproducts_overview

>=20
> --=20
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: 0E572FDD
>=20
>=20



--LiQwW4YX+w4axhAx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXOBBlAAoJEORje4g2clin0nMP/jUMxnE3NpREi4SqU33DPowO
dJ5gWRSFclGXAJQk49Kp0i/4ITxWrKoDRLg0rYVlt5hvk7P7YMAgwKDzBddzZWGj
oDi+4+LvSGguvTq2uDHLDB7Bp6U1nfvvG5YmlMfVfx2ESjVyVhcLMrmksZPUldyc
egSKKVSTYz9ICoSks/BX95c3JHeuEHxxiA5fIgvjJBEdU8z8DGhWE+W3HjROoNwi
Jh9ZXJuOG4ExR2L4IItufbxtoE6KucpfWjpX6Cc4fJivHlvsrYp6s/CuMDq9541q
1lMhccQoGG2/NDDv1jONTwYzilPCOrCa/jZ5rmGKeDC+peHwIE8FM+3t2LhPSJJ5
C9kELyQD75xcf+2LSNCDQX/eThQhmfQ1xZFYIKfnf7fFZBU1mUCBNBq9/ol34Xmx
yVwv29phLRr4slI/0p5iQ3uCbHi/afTCTiZGEm6yGqfD7w4F3I/TCnDXR2Mps7q8
5Y5KBtTvyngd2VPmcp2QhZHWXLNGepWwkhQWitLp/aYy6ALV1Gp9tdxbr6EC1Wm+
SgUkCXPgyLS+1QUKoHd2WbdubYgzp5xP0qMmk366iMaM2i1CN8bsP4Zavw70dtMc
6gv45vq/R6viqj9G/rbCFcecqHaeoTbkrVDCa9zPmjW0aTTrtVtpCzh0KkaKyK3C
UWBBCsp6ZTJ+26ZWQccf
=78EL
-----END PGP SIGNATURE-----

--LiQwW4YX+w4axhAx--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
