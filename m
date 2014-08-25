From: Vangelis Tasoulas <vangelis-S8y2klWGCOFhl2p70BpVqQ@public.gmane.org>
Subject: Re: Are the PathRecord reserved components really reserved?
Date: Mon, 25 Aug 2014 22:27:28 +0200
Message-ID: <53FB9C30.2000904@simula.no>
References: <53FAF771.407@simula.no> <2807E5FD2F6FDA4886F6618EAC48510E0CAD282C@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="LdDwsJjKuobBqnqOe8Kl0PAuDGjIurq3M"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E0CAD282C-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LdDwsJjKuobBqnqOe8Kl0PAuDGjIurq3M
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Thanks Ira,

I found the corresponding document.

Vangelis

On 08/25/2014 04:49 PM, Weiny, Ira wrote:
>>
>> Hello,
>>
>> I am looking into the OFED code for the component mask bits of the
>> PathRecord requests and I need some further explanation.
>>
>> The IB specification in section "15.2.5.16 PathRecord, table 207 PathR=
ecord"
>> defines the first two components as "Reserved". Each one of them is 32=
 bits
>> long and the description of the first one is "Reserved"
>> while the description of the second reserved component is "Offset for
>> alignment".
>=20
>=20
> The IBTA has published errata to the 1.2.1 specification which includes=
 the use of many reserved fields.
>=20
> I believe these errata are public on their web site.
>=20
> Ira
>=20
>>
>> However, in the file "include/rdma/ib_sa.h" where the component mask b=
its for
>> the Path Records are defined, the 1st and 2nd component are combined
>> together under the name IB_SA_PATH_REC_SERVICE_ID.
>>
>>
>> #define IB_SA_PATH_REC_SERVICE_ID   (IB_SA_COMP_MASK( 0) |\
>>                                      IB_SA_COMP_MASK( 1))
>>
>>
>> The same definition exists in the OpenSM code in file "include/iba/ib_=
types.h"
>>
>>
>> /* Path Record Component Masks */
>> #define  IB_PR_COMPMASK_SERVICEID_MSB
>> (CL_HTON64(((uint64_t)1)<<0))
>> #define  IB_PR_COMPMASK_SERVICEID_LSB     (CL_HTON64(((uint64_t)1)<<1)=
)
>> .....
>> .....
>> #define  IB_PR_COMPMASK_SERVICEID (IB_PR_COMPMASK_SERVICEID_MSB |
>> \
>>                                    IB_PR_COMPMASK_SERVICEID_LSB)
>>
>>
>> Why are these fields named as "SERVICE_ID"? I would expect something l=
ike
>> IB_SA_PATH_REC_RESERVED_1 and IB_SA_PATH_REC_RESERVED_2 according
>> to the specs. Are they really reserved or used, and if they are used, =
when does
>> this happen?
>>
>> Vangelis
>=20



--LdDwsJjKuobBqnqOe8Kl0PAuDGjIurq3M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJT+5w2AAoJEEuGx9KTo03qWREIAKklm/bmgtkIT2BbFSfiwE2I
ML3vl2g6JlaFbSMvQFReb8DzcJlRbfWkYQCoQxUVwpUzApDndW5V4l36au99WTTT
IWjvPQA7173fBfd68C6HoPsjO1q1XCmq382Iq6u1HzOWjfRD+yG85KTyAA4hJqca
Pt0QlXpVBDj4zVedCPF55HZcwIMH9GaCkBdt5cljXhOpqq36qnjz40LyDJMuI0mb
RmMRkjzC45r9cLfo6EikeAdU997s53Z/hISU27gz4f6Zjhizfl44h/uCCl0oVs5e
NvxZkY4rugl7PbVUgBhRJRYRJEmO+wYvnGH05O8hV24OpSULFmxLpniqKsE0T6w=
=9T+n
-----END PGP SIGNATURE-----

--LdDwsJjKuobBqnqOe8Kl0PAuDGjIurq3M--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
