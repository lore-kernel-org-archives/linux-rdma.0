From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/14] IB/mad: Add support for OPA MAD processing.
Date: Fri, 12 Jun 2015 16:00:15 -0400
Message-ID: <557B3A4F.7090809@redhat.com>
References: <1433615915-24591-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1kC3JIcKFOTVS0AMdmAI7Kg4nh4wRWXgd"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433615915-24591-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1kC3JIcKFOTVS0AMdmAI7Kg4nh4wRWXgd
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 06/06/2015 02:38 PM, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> The following patch series modifies the kernel MAD processing (ib_mad/i=
b_umad)
> and related interfaces to send and receive Intel Omni-Path Architecture=
 MADs on
> devices which support them.
>=20
> OPA MADs share the same common header with IBTA MADs which allows us to=
 share
> most of the MAD processing code.
>=20
> In addition to supporting some IBTA management classes, OPA devices use=
 MADs
> with lengths up to 2K.  These MADs increase the performance of manageme=
nt
> traffic on OPA fabrics.
>=20
> Devices report their support of OPA MADs through the new immutable data=

> capability flag and immutable max mad size.
>=20
> Changes from V1:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> Remove patch:
> 	IB/mad: Create an RMPP Base header
>=20
> Add new patch:
> 	IB/mad cleanup: Clean up function params -- find_mad_agent
>=20
> Address comments from Jason about the idea of a flex array for struct i=
b_mad:
> 	ib_mad does not really allocate struct ib_mads.  Rather it allocates
> 	ib_mad_private objects.  This is where the flex array was more
> 	appropriate.  So this series changes struct ib_mad_private to end in a=

> 	flex array to store MAD data.  Casts are used where appropriate to
> 	IB/OPA mad structures or headers.
>=20
> Minor updates:
> 	Clean up commit messages
> 	Fix/add const and bool usage
> 	Remove inline qualifiers (let complier handle inline)
> 	Add additional Immutable data checks
> 	Change WARN_ON to BUG_ON in drivers
> 	Add out_mad_pkey_index to process_mad in order to maintain the
> 	"constness" of the struct ib_wc parameter.
>=20
>=20
> Ira Weiny (14):
>   IB/mad cleanup: Clean up function params -- find_mad_agent
>   IB/mad cleanup: Generalize processing of MAD data
>   IB/mad: Split IB SMI handling from MAD Recv handler
>   IB/mad: Create a generic helper for DR SMP Send processing
>   IB/mad: Create a generic helper for DR SMP Recv processing
>   IB/mad: Create a generic helper for DR forwarding checks
>   IB/mad: Support alternate Base Versions when creating MADs
>   IB/core: Add ability for drivers to report an alternate MAD size.
>   IB/mad: Convert allocations from kmem_cache to kzalloc
>   IB/mad: Add support for additional MAD info to/from drivers
>   IB/core: Add OPA MAD core capability flag
>   IB/mad: Add partial Intel OPA MAD support
>   IB/mad: Add partial Intel OPA MAD support
>   IB/mad: Add final OPA MAD processing

There haven't been any further technical issues with this patchset.
There is the ongoing argument about usage of node_type, but I think I've
made my opinion on that matter clear.  Changes to the core code to make
CA versus SWITCH operation not rely on node_type can be done as follow
ons to this patch set.  As such, I've picked this up for 4.2.



--1kC3JIcKFOTVS0AMdmAI7Kg4nh4wRWXgd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVezpPAAoJELgmozMOVy/dUGAP/jCxGcYCxpTsdkzrQSvyqvuN
Awu/PcnY66rDSfv2smBTaEvLPFKuNZwFNuqpKFypQi47q3b1e6SmXBAKP+N6I5Ub
WkIJ5817ZObuNG04T46PSp03OnweDSvxJsuxBrrN4lPTpMcgZJGiSRY3fAVDCEuv
05cH/UEO4W6ynLYyDs/N55D7tlPwEyesw6TOI7kB98CAJK0hMXjuqnPz/wVXQvaS
xr1jTM0V3VVFMbg9U2jXgHftHGR7GpMDrWdzwAsH6aZIHjnyPU7euRPZcBTFmrWo
CHO469qlwyOl9WtWGXcz1b4uyhJ4CZQmvih0Ng7ITKIa7BaqzZtZHeje7DqpvyY0
7/6usMfwCRZlbAzjjnBnKKxvhu5/tDey0vBCKX37l/9hveymGpI1PITakiZ/cQQM
3BN3Hj5XYwCQAfMgLcON4y0/DBcWhkVPKttGU0JOVeVjJZ/J+za+opCn/92JMkHI
kP8M1+28fPzTH3a10t5+jwixxAaUpV1EUvpOvnny1nEYOFrNQpYGFJFPA4NPP0rP
+eVv4XXhJwgLA7L1y5T7r09GcXp5Ah1Fp4pUYbforXtZrn82MfHst9dVkDWWBg4f
WFAoIcQXpJHsMH04skWwDqwvxUYP+3n5EdbdLvDAhtbaPp0is25h6n8DCMy7K65M
/vJU8MW7lbgGvLXps+OS
=gEHB
-----END PGP SIGNATURE-----

--1kC3JIcKFOTVS0AMdmAI7Kg4nh4wRWXgd--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
