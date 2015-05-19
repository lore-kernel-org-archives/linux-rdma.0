From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mad: Clean up ib_find_send_mad to use only the
 ib_mad_hdr
Date: Tue, 19 May 2015 13:01:08 -0400
Message-ID: <1432054868.3114.67.camel@redhat.com>
References: <CAJ3xEMjtndfHJOh-JSTzaXuXTNrx2wzDkBcS67T6AwFztcckgQ@mail.gmail.com>
	 <20150514173557.GB10941@phlsvsds.ph.intel.com>
	 <555ABF9E.6010502@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-KtJOWPxQIw3cvTOgfgFz"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <555ABF9E.6010502-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-KtJOWPxQIw3cvTOgfgFz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-05-19 at 07:44 +0300, Or Gerlitz wrote:
> On 5/14/2015 8:35 PM, ira.weiny wrote:
> > On Thu, May 14, 2015 at 10:28:45AM +0300, Or Gerlitz wrote:
> >> >On Thu, May 14, 2015 at 2:20 AM,<ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>  wrote:
> >>> > >From: Ira Weiny<ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >>> > >
> >>> > >ib_find_send_mad only needs access to the MAD header.  Change the =
MAD cast.
> >>> > >
> >>> > >Signed-off-by: Ira Weiny<ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >> >
> >> >shorter and clearer subject line please, e.g
> > Sorry, I'll try to keep them brief.
>=20
> this isn't only on being brief,  but rather of being high level and not=
=20
> carrying too many names of functions and variables, looking on the=20
> titles of your 4.2  patches, bunch of them are too long and down to=20
> details instead
> of capturing the proposed change in higher level:
>=20
> 6f430b IB/mad: Add const qualifiers to query only functions
Ok
> 67b3b05 IB/mad: Clean up rcv_has_same_class
Ok
> fcd6ebf IB/mad: Change ib_response_mad signature to take const=20
> ib_mad_hdr rather than ib_mad
IB/mad: Change ib_response_mad signature arguments
> 3b53339 IB/mad: Change validate_mad signature to take const ib_mad_hdr=
=20
> rather than ib_mad
IB/mad: Change validate_mad signature arguments
> b78d28a IB/mad: Clean up comments in smi.c
Ok
> c597eee IB/mad: Rename is_data_mad to is_rmpp_data_mad
Ok
> 81836bc IB/core: Change rdma_protcol_iboe to roce
Ok
> 6f9ab33 IB/core: Convert management helpers to core capability bits
IB/core: Convert core to use bitfield for caps
> 23ceb15 IB/core: Formalize the creation of immutable per port data=20
> within the ib_device object
IB/core: Add per port immutable struct to ib_device
> cb3ed7b IB/user_mad: Fix bug in ib_umad_remove_one when rdma_cap_ib_mad=
=20
> implementation changed
IB/user_mad: Fix buggy usage of port index
> 42997f2 IB/user_mad: Remove local start/end port variable and use the=20
> new common functions
IB/user_mad: Use new start/end port functions
> 0cf18d7 IB/core: Create common start/end port functions
Ok
>=20
> Maybe submit them all again with more proper commit titles? it's not too=
=20
> late, Doug, what's your
> thinking here?

I try to stick within the recommended length of git log subject as
indicated to me by vim when I'm editing my commit messages.  Whatever
happens to fit inside that limit (or at least close to it, I'm not a
real stickler on it) I go with unless you really need to capture some
important detail in the subject.

However, there's no need to resubmit these.  I can always edit the
subjects in place.  Ira are you OK with the changes I made above?

Just to be clear though, to my knowledge, the whole reason for this is
so that git log --oneline will print out pretty output with one commit
per line.  That means the maximum length of these subject messages is
limited by standard terminal width (80 columns) and the selected git
commit hash abbreviation length (which has varied due to the increasing
number of collisions in git hashes and is now set at a standard of 12
characters).  So the proper length 3 years ago and the proper length
today are not the same thing.  What's more, git merge commits almost
*never* fit on a single line due to the length of git urls.  As a
result, our pretty --oneline output is already marred upstream by all
those merges.  So do I prefer commit messages that fit on one line?
Yes.  Will I demand things be resent if they don't?  No.  We've already
lost the war because of those merge commits, winning individual battles
now is nice, but not absolutely necessary.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-KtJOWPxQIw3cvTOgfgFz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVW2xUAAoJELgmozMOVy/dRPoP/iZs20Q+S81P01UbP9J24NtJ
wea3OmYUEVEv6rs5g1iBNGTKs5pnWu6QtZPtliSCQWYo/UgCgEL+GTcMSvdV0qpS
lpoa4x9D3kjjuTJWdvt8fKVeguDUz5YnuhMS2fYKBP1AoWkS/V9cS0vU3ayYod+W
rQCxJurnn8gqYSO2crnF+uCRt+zrtADBqZbR2F1H1CXNTVhMVZQ4Jg7eD3g7PI5P
ZpaY5mrFjAMK6V5fEirTOUk34DameZgE6MVDx2GwLRjrKFaU6w+VszeqUC49t9h/
3HTxCDFagTtyi5SCzNw7b5WCnmv6yXfKmSVwF9KMMRt+19vvXC3X6+XQgt1jv/Lv
EU3K+XYsn+EBkqfS1Lha0WmrA3v/UkqzbdlQxGzuC+lW/zEzFj4ik20AeuDZiHGJ
vGtIubPW7lswggs6p5crLvDcWZh0qiQbgk66GU/u77wxGakgmwN76Ksts/LOuMK2
X09BcOGt6KFNtAlqMk7X1Pocr32fg+rFbZVSsAHNV35+DtWyeLERB/3T2OFcJGwQ
6R9Obrunsov3IwgfzKrwU1yIwh+4OkLp8ZOSYX97FM3OfLt42fWRF73Rkc/WADLU
p2AZ7ud5Fx0cq7hAOfPpJnXeSUIscW8d8FLM98QKZw4ldctDU7Vo4zbQUZoZshF2
R96y+q1zYehh8ffhUXfC
=uKJk
-----END PGP SIGNATURE-----

--=-KtJOWPxQIw3cvTOgfgFz--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
