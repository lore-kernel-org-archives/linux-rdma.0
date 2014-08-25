From: Vangelis Tasoulas <vangelis-S8y2klWGCOFhl2p70BpVqQ@public.gmane.org>
Subject: Are the PathRecord reserved components really reserved?
Date: Mon, 25 Aug 2014 10:44:33 +0200
Message-ID: <53FAF771.407@simula.no>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="fetWv5k24ndq0JARhPKosgimPmLwsmXMA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fetWv5k24ndq0JARhPKosgimPmLwsmXMA
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello,

I am looking into the OFED code for the component mask bits of the
PathRecord requests and I need some further explanation.

The IB specification in section "15.2.5.16 PathRecord, table 207
PathRecord" defines the first two components as "Reserved". Each one of
them is 32 bits long and the description of the first one is "Reserved"
while the description of the second reserved component is "Offset for
alignment".

However, in the file "include/rdma/ib_sa.h" where the component mask
bits for the Path Records are defined, the 1st and 2nd component are
combined together under the name IB_SA_PATH_REC_SERVICE_ID.


#define IB_SA_PATH_REC_SERVICE_ID   (IB_SA_COMP_MASK( 0) |\
                                     IB_SA_COMP_MASK( 1))


The same definition exists in the OpenSM code in file
"include/iba/ib_types.h"


/* Path Record Component Masks */
#define  IB_PR_COMPMASK_SERVICEID_MSB     (CL_HTON64(((uint64_t)1)<<0))
#define  IB_PR_COMPMASK_SERVICEID_LSB     (CL_HTON64(((uint64_t)1)<<1))
=2E....
=2E....
#define  IB_PR_COMPMASK_SERVICEID (IB_PR_COMPMASK_SERVICEID_MSB | \
                                   IB_PR_COMPMASK_SERVICEID_LSB)


Why are these fields named as "SERVICE_ID"? I would expect something
like IB_SA_PATH_REC_RESERVED_1 and IB_SA_PATH_REC_RESERVED_2 according
to the specs. Are they really reserved or used, and if they are used,
when does this happen?

Vangelis


--fetWv5k24ndq0JARhPKosgimPmLwsmXMA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJT+vd3AAoJEEuGx9KTo03qMncIAKb9LjusI32UMGKMAnwOwau7
IAMFKXeNNQPJ8k2rNfoSDfbsLnAx7ebF28qtaHonH2T7NE/w+IZ8z3v1UYJMP4Cg
fIvDgz2AB0S80/HD7+LJcJ/e8Qrs/hQjyBnTk0g7OIdIG7a42ArLhfFFZMYFC/FT
215iu2K9L1BueDGPap7iY6I4AjFCGkPHeyvkgKa4zRMf7V5VaXDJzRUMWsx3HC4W
yYTFMQmC4ODes0r6gCOJ1nWe6xoCFeltu0B6+0GYCBR2WQO3Lj3LXXQMRfxLbzJT
Asgqwqqz6LEUqKlBHvmMb8W9TLdDr149YXtbrece4fHxewYEs5R8d6dT0+gY4HI=
=FVeu
-----END PGP SIGNATURE-----

--fetWv5k24ndq0JARhPKosgimPmLwsmXMA--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
