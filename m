From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/6] Enhanced mode for IPoIB driver
Date: Thu, 6 Apr 2017 08:38:21 +0300
Message-ID: <20170406053821.GC2269@mtr-leonro.local>
References: <20170404191732.31895-1-leon@kernel.org>
 <456a1a5f-26a4-13a6-744c-02679e0fc90b@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3uo+9/B/ebqu+fSQ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <456a1a5f-26a4-13a6-744c-02679e0fc90b-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--3uo+9/B/ebqu+fSQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 05, 2017 at 09:50:59PM -0400, Dennis Dalessandro wrote:
> On 04/04/2017 03:17 PM, Leon Romanovsky wrote:
> > Hi Doug,
> >
> > This patchset mostly comes from Erez with one exception in the first patch.
> >
> > That patch origins from two different commits, first from Niranjana who added
> > RDMA netdev interface and second from Erez who added IPoIB support.
> >
> > During the preparation to submission, I squashed their commits into one
> > and refactored code to allow submission as a standalone topic without creating
> > dependecies between different submissions. This caused to change in author line.
> > I hope that it doesn't really matter and it won't stop you from merging it.
>
> I think that it does indeed matter. The patch was authored by Niranjana it
> should reflect as such. Why not take Niranjana's patch(s), the fact that you
> folded them in seems to mean you at least agree with the patch.

Sure, I agree, but I was supposed to remove all VNIC code from that
patch, which is unrelated to IPoIB.

If Niranjana feels comfortable to be authored on IPoIB code, the
following code will do the trick.

git commit --amend --author "Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>"

Thanks

>
> -Denny

--3uo+9/B/ebqu+fSQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljl1EwACgkQ5GN7iDZy
WKdxRxAAjBmnR7ZQkep29lZ8OeFlheApRlCuZCtEsNxVOyIU3Rmp3I6uf3AAeWeh
umg71vSnYlcn7UpumScTNWQq+KnVBSFkDa/fHwBzmyrtCgbEhPtzrzwXV9gBgBNl
IiGnDcmdrOf8AEnooQ0SGano7PDbkhW6z2wmBku+ERy7oY3W6MJA7ND9BNBmn0AR
1fzszg2FVJFgo3jI7UVlxawzt1OnpqL/x+fk+c9yZN6AaRJ+6b+e7nZStsN2/uQ9
EFw6Llfy7hFsVcPLZ860HeLDCYkhpkyv1/WtKPLBIOBPoKFX+2jScww03xOUQXoQ
R9gGVUSR1MT954HdaJOTTQgd+hXa2sByTgQwgF3/xZjC/l4bhXc1Z3mexMrjCcfu
L7PiiLUdhYU1fqZB4r82CHIuiejQEvPNRsk01lAzMG6/+Dfg0U1AI3wlUFObPtb7
iFjJyg5YM0WKTsQFo/hsu7Sa3hvmvJAVmi22EruoaJc0xkNXPN/ATJcJ2boH6+zg
EESSgU/UiIW4bCswr4ixxDGzqVf0U6mWEoYEvsTQKvZq5/RKWI2rh4OHrwjvyR4c
3qGk5cQOGwVIEbmHw0B9f21UrioEujxohPpanQ5tlXcJjIL/VWxEDlfZ6vJ928Jx
W4wFYga+S48HxccjturEDsELRUDoHVSkh4Aeeq48+axC1Ui1U3Y=
=Yob+
-----END PGP SIGNATURE-----

--3uo+9/B/ebqu+fSQ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
