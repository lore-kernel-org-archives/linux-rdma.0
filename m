From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v3-v6] Add OPA extended LID support
Date: Tue, 15 Aug 2017 10:50:37 +0300
Message-ID: <20170815075037.GN24282@mtr-leonro.local>
References: <1502734663-44224-1-git-send-email-don.hiatt@intel.com>
 <50ff7793-413a-09a6-1805-ca0bce0452a2@intel.com>
 <cd6cd877-659d-8218-abf8-a23905af4f42@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jSXJDi5r/aeatSyx"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cd6cd877-659d-8218-abf8-a23905af4f42-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--jSXJDi5r/aeatSyx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 14, 2017 at 01:12:34PM -0700, Don Hiatt wrote:
> On 8/14/2017 11:36 AM, Don Hiatt wrote:
> >
> >
> > On 8/14/2017 11:17 AM, Don Hiatt wrote:
> > > This patch series primarily increases sizes of variables that hold
> > > lid values from 16 to 32 bits. Additionally, it adds a check in
> > > the IB mad stack to verify a properly formatted MAD when OPA
> > > extended LIDs are used.
> > >
> > > Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > ---
> > >
> > > This is an incremental patch to move from v3 of the 'Add OPA
> > > extended LID support' to v6 of the series.
> > > Changes from v5:
> > > ---------------
> > > * Fixed typo in WARN_ON_ONCE usage in helper functions.
> > > * Actually return be16 in ib_lid_be16() helper function.
> >
> > Sorry, this was meant to go to my email as a test, not to the list. My
> > tests are still running so please
> > hold off on this until I confirm.
> >
> All test completed fine. I think we're good to go.
>
> Leon, if I missed anything else please let me know.

Yeah, you should fix the function below too.
The whole extended LID series did enormous mess with all these lid/slid/dlid.

 88 static inline bool opa_is_extended_lid(u32 dlid, u32 slid)
 89 {
 90         if ((be32_to_cpu(dlid) >=
 91              be16_to_cpu(IB_MULTICAST_LID_BASE)) ||
 92             (be32_to_cpu(slid) >=
 93              be16_to_cpu(IB_MULTICAST_LID_BASE)))
 94                 return true;
 95         else
 96                 return false;
 97 }

It will help a lot, if you break this patch to small steps:
1. Fix existing annotation errors.
2. Change (rename) the ib_lid/ib_slid functions.
3. Add WARN_ON.

Right now, we have potential breakage of compatibility between
big-endian vs. little-endian systems.

Please run smatch and sparse checkers before LID patches and after to
know what else you should fix.

Thanks

--jSXJDi5r/aeatSyx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmSp8wACgkQ5GN7iDZy
WKc9QhAAtExUoANPKrTtAiX6xhsoHZLKnURH6JS+1dNhmxI9vo9jShbA7Et93u3c
Mq/3wEVJA/7IWLam715dlPDyE+xoFtEg1xny0GXhjuhWCGHUL0AyW6LaFM2c4qdQ
X2slovOIYRhq/KguKNgtLkUOqc2JNPN7B7z9AeSGOjPp67mKu8DyCrsjcnfoEd6/
SDbuK9qBRN0EArm6kkogIHNg62qPpA0WTwiIpMGS4Q2XkZXXLP99d1lmzBm5d3pW
cTGVi9mVzbNPKhr/AsKC/i/FP2TwHvOLLDSFYJ3XvXQZx/m8zmxcl3ZAErFXGbND
5HMzz9Q4L/PKM4GDlHHWOIP/sXNxvxuYHrtwSI2wZ3yTbSWXXh2AalGnaXPi0J6Y
Ubk4ljWF5zf0iPLMWlKCaKMFPF2P9TT+HsFH4kA2wGEa9Bp68RnAJ4p6ZnJKqS2L
6FuoNHwcUvDKn7ubF4L6n2q9pXzRVEQp/HSVONdsb7FyMuj5aEQyBFGD9emTtJ2g
Y/sSzeCe6Cl/9gwZs9+7ZHXBQ3dDh73E36pNMij6/nN/MZe8RH7BKtjd06zjYSjZ
CucL9P8qrdA6MMdKEyZt07sPBlyFXS8DgeHYNsuRbcSZ813c5gEw5b3mPsh3ff0w
cEUsE8GMGDuXt8mf0NFPXuubtNGB59DkhRjjwyRBu0CU9mEvVeQ=
=6o3O
-----END PGP SIGNATURE-----

--jSXJDi5r/aeatSyx--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
