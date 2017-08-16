From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v3-v6] Add OPA extended LID support
Date: Wed, 16 Aug 2017 09:07:59 +0300
Message-ID: <20170816060759.GE24282@mtr-leonro.local>
References: <1502734663-44224-1-git-send-email-don.hiatt@intel.com>
 <50ff7793-413a-09a6-1805-ca0bce0452a2@intel.com>
 <cd6cd877-659d-8218-abf8-a23905af4f42@intel.com>
 <8d3d0a5a-df5e-b023-ec7c-f83e47a22f00@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gKaPnVNVpyX08bAX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8d3d0a5a-df5e-b023-ec7c-f83e47a22f00-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--gKaPnVNVpyX08bAX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 15, 2017 at 01:40:22PM -0700, Don Hiatt wrote:
>
>
> On 8/14/2017 1:12 PM, Don Hiatt wrote:
> > On 8/14/2017 11:36 AM, Don Hiatt wrote:
> > >
> > >
> > > On 8/14/2017 11:17 AM, Don Hiatt wrote:
> > > > This patch series primarily increases sizes of variables that hold
> > > > lid values from 16 to 32 bits. Additionally, it adds a check in
> > > > the IB mad stack to verify a properly formatted MAD when OPA
> > > > extended LIDs are used.
> > > >
> > > > Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > ---
> > > >
> > > > This is an incremental patch to move from v3 of the 'Add OPA
> > > > extended LID support' to v6 of the series.
> > > > Changes from v5:
> > > > ---------------
> > > > * Fixed typo in WARN_ON_ONCE usage in helper functions.
> > > > * Actually return be16 in ib_lid_be16() helper function.
> > >
> > > Sorry, this was meant to go to my email as a test, not to the list.
> > > My tests are still running so please
> > > hold off on this until I confirm.
> > >
> > All test completed fine. I think we're good to go.
> >
> > Leon, if I missed anything else please let me know.
> >
> > Thanks,
> >
> > don
> >
> I did not get this email respond but saw it on the mailing list so pasted it
> in to respond)
>
> >Yeah, you should fix the function below too.
> >The whole extended LID series did enormous mess with all these
> lid/slid/dlid.
> >
> > 88 static inline bool opa_is_extended_lid(u32 dlid, u32 slid)
> > 89 {
> > 90         if ((be32_to_cpu(dlid) >=
> > 91              be16_to_cpu(IB_MULTICAST_LID_BASE)) ||
> > 92             (be32_to_cpu(slid) >=
> > 93              be16_to_cpu(IB_MULTICAST_LID_BASE)))
> > 94                 return true;
> > 95         else
> > 96                 return false;
> > 97 }
> >
> >It will help a lot, if you break this patch to small steps:
> >1. Fix existing annotation errors.
> >2. Change (rename) the ib_lid/ib_slid functions.
> >3. Add WARN_ON.
> >
> >Right now, we have potential breakage of compatibility between
> >big-endian vs. little-endian systems.
> >
> >Please run smatch and sparse checkers before LID patches and after to
> >know what else you should fix.
> >
> > Thanks
>
> This patch series sat on the mailing list for over two months since the your
> last
> request. It then got merged in and an incremental patch was asked for.
>
> I've been trying to address your concerns but since this patch is going in
> as an
> incremental  patch I do not see how breaking it up as requested is required.
>
> If Doug would like to pull the entire series then I'll break the patches up.
>
> As of now, with this patch the endian-ness issues have been resolved, or are
> you
> saying they are not?
>

My complains are not related to the fact that this patch series was
posted to the mailing list a long time ago and merged - it is completely OK.

My complains are due to the fact that the whole community work is built
on trust and we (me and I saw Doug said the same) expect from the
developers doing at least sanity checks before sending their patches.

The MINIMAL set from random developers of those sanity checks are: checkpatch,
builds without warnings, runs of smatch and sparse.

For my submissions, I'm relying on results from verification team
and personally checks boots together with simple ping-pong.

I skipped some of this checks once and we saw disaster (the patch to check
legal values for the port), but those LIDs changes did much more - broke
RoCE, RoCE multicast and port in AH in addition to big-little endianness
mess.

So the bottom-line, please don't expect from us to do your homework and
filter the warnings.

Before the LIDs patches, the RDMA tree had less than 100 smatch warnings,
after the LIDs patches, we have more than 200 such warnings.

Thanks

--gKaPnVNVpyX08bAX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmT4T8ACgkQ5GN7iDZy
WKeowA/9ETPfNjsyd0nbA6YWBUxyUogLvPJyO3gVetb0gKvHOOE/Qe1fhwcgB/P7
W5J9OE3VhtSdNpBvS6nLG2EfKaaZst3PtdUEFX6x4t29TsDgJ0bPRXXmPS2w5tBV
tUHbfPsMx8I14+zQ2LacVeDolk3B2LPmbnBSkmzIdzHybsUKlvOIzkA6WrXHAVPH
49XRsuwzSqefnGZD6jC33gGrHrmoO3dnK3iK9/wVZF2pS590waHMFRUFvokfNWk+
ni/JyXmO4LljYllzWhFMKVakRwUdo+bR/gh612muAjpqsOiU/KFwRzS5C1iXzT4M
T1l+TgkvDcM1QyJ8V2+u+XQTi/CmIYBw7VqVb1hHSU5lA/qnEkb2+GmlMjCElr38
TjZpTEiWOQfMeoNJjwcVJdMxClVghYRG9NlRqB/Zdi8TbK7yFTXWgEvopluDXjEZ
MRUhHrVcJVmMYqy4rvxgc0CfnaPPxJPeJuFKnEeE+d3GwtMUeRYy918O19HaZroz
38FO75nUHtwEi/hz6aI1aKBRFRwzUlFG77d4NXU2MEtrK7r0fLHbx4zxa5k8A2yU
ZqGEynQdfv6OaZvH/9JNLgSMpPyf0d6+s2TqT/mYFMeJ4pcP6k09oBTqcavhP2Nd
YTYOjkzzbAiA+n6LxWRtmp/dsCdBlnbe8zn2N5wH8Zd3u0l59AM=
=HsNk
-----END PGP SIGNATURE-----

--gKaPnVNVpyX08bAX--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
