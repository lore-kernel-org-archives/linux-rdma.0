From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v8 00/23] IB/Verbs: IB Management Helpers
Date: Tue, 12 May 2015 16:09:22 -0400
Message-ID: <1431461362.43876.81.camel@redhat.com>
References: <1430830240-32389-1-git-send-email-yun.wang@profitbricks.com>
	 <20150511234910.GA20027@phlsvsds.ph.intel.com>
	 <1431390420.43876.4.camel@redhat.com>
	 <20150512180942.GC15891@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-jdNDAJfcfpvQ5xXeprIs"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150512180942.GC15891-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-jdNDAJfcfpvQ5xXeprIs
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-05-12 at 12:09 -0600, Jason Gunthorpe wrote:
> On Mon, May 11, 2015 at 08:27:00PM -0400, Doug Ledford wrote:
> > On Mon, 2015-05-11 at 19:49 -0400, ira.weiny wrote:
> > > I have run with this series and the only issue I have found is not wi=
th this
> > > patch set directly.
> > >=20
> > > This patch:
> > >=20
> > > >   IB/Verbs: Use management helper rdma_cap_ib_mad()
> > >=20
> > > causes an error when you actually use the port passed from the ib_uma=
d module.
> > > I have a patch to fix that which I found while trying to build on thi=
s series
> > > for the use of a bit mask.
> > >=20
> > > Doug, I don't know what you would like to do for this fix.  I am subm=
itting it
> > > shortly with a new version of the core capability bit patches.  If yo=
u want to
> > > just add it after this series or force Michael to respin with the fix=
?
> >=20
> > As I recall, there was a comment from Or requesting to squash some of
> > the individual patches down, but I no longer have that email in my Inbo=
x
> > to double check.  And it seemed like there was one other review comment
> > not yet addressed.  Do I have that right Michael?  And if so, are you
> > working on a v9?
>=20
> I had asked for better kdocs for the new helpers so new people can
> understand when and where to use them.
>=20
> I've not looked at the series at all for the past few postings.

Michael, please work up an incremental patch to address the kdocs issue.
I've picked up the v8 patchset, and there is no need to respin it, but I
would like to have that kdoc patch before the 4.2 merge window opens.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-jdNDAJfcfpvQ5xXeprIs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVUl3yAAoJELgmozMOVy/dgw4QAJXTOlLpcFQCF4x/Pk5ywafN
LWHUana7EdWBKFZpSblB+Wneka3OWONckBji5fOFlb0MZaMV9jVChJmcr2GoY6jl
53b+QMnXScvz1B6xTbMo6GJpOOUo0QeAjD7cnZkbWwRjAdmZbsJQ9PFqlxRUoMwn
NeXU+IZMeiZwXM/g3/leWZdEKpnZK2pvdsA6Q1IWXz64iHpkjqKn5dFZbOa9LbYd
7WIzg9RWDdU50NFucvfwtdJSAW4oA81V6Z1oO7hES4LAPKHjbvii/VFhr10/E4wN
QPMpDm3kCbH6wjbAikb+saAgJX7k+6rWb5sqlCCpbqP4UD5fGTKrOxd7OkxjkQhq
pyJh3A/Dsge42r45nr+i+oAX9lzmDKzJuFBfcfFjE38wUbUcEYAj48ZOR+1E6vTb
rTEmU7mDxzTK1/Llrx7hKoSc4asTL+JwSpjLpZrsx+DoF01VWt0GQicLFYtzNRVT
nsQ/qfaJ1L82DSSzvyqSvVbW+8PllrCPWEXJlIY+8DbZGY85HCCPuhesu5sESU9j
lapadD0Tw7MJHbuAq41JfpjtCMVBhWEUsFjEBlawvz896XeBVX2LDSr3F18ITAsv
eDE14gnL+lqTZYso4wWvz9bzC8XUTeynxk2Xqre2ppTdQ9AE6BqjdwxzN/eI0y9n
pC2lIQBuiojwDq+hr1s3
=6+4E
-----END PGP SIGNATURE-----

--=-jdNDAJfcfpvQ5xXeprIs--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
