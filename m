From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 0/3] libibverbs: On-demand paging support
Date: Fri, 4 Sep 2015 17:18:28 -0400
Message-ID: <55EA0AA4.5090406@redhat.com>
References: <1441292199-8371-1-git-send-email-haggaie@mellanox.com>
 <55E9FDA9.3090709@redhat.com> <20150904204244.GA20758@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3TJGjSkEqnUU6VkOJ3tVIdJSvG1t62HRt"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150904204244.GA20758-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3TJGjSkEqnUU6VkOJ3tVIdJSvG1t62HRt
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/04/2015 04:42 PM, Jason Gunthorpe wrote:
> On Fri, Sep 04, 2015 at 04:23:05PM -0400, Doug Ledford wrote:
>> On 09/03/2015 10:56 AM, Haggai Eran wrote:
>>> This series adds userspace support for on-demand paging. The first pa=
tch adds
>>> support for the new extended query device verb. Patch 2 adds the capa=
bility and
>>> interface bits related to on-demand paging, and patch 3 adds example =
code to
>>> the rc_pingpong program to use on-demand paging.
>>
>> I've reviewed this series and I'm OK with it.  However, it's currently=

>> blocked.  We need to fix the API mess that was created when the
>> create/destroy flow verbs were added.  I've gone back through the code=
,
>> and I'm pretty sure I know what Jason's objection to the create/destro=
y
>> flow implementation was.  In particular, we weren't supposed to have t=
his:
>>
>>  struct verbs_context {
>>         /*  "grows up" - new fields go here */
>> +       int (*drv_ibv_destroy_flow) (struct ibv_flow *flow);
>> +       int (*lib_ibv_destroy_flow) (struct ibv_flow *flow);
>> +       struct ibv_flow * (*drv_ibv_create_flow) (struct ibv_qp *qp,
>> +                                                 struct ibv_flow_attr=

>> +                                                 *flow_attr);
>> +       struct ibv_flow * (*lib_ibv_create_flow) (struct ibv_qp *qp,
>> +                                                 struct ibv_flow_attr=

>> +                                                 *flow_attr);
>>
>> There was only supposed to be ibv_create_flow and ibv_destroy_flow, no=
t
>> this silly separate drv/lib versions that just amount to wasted space
>> and confusion.
>>
>> Our choices are: 1) Leave this in place but don't do any more extensio=
ns
>> this way, knowing full well that this is wrong but preserving ABI or
>=20
> We should drop the code so people don't copy it.
>=20
> Replace the one that isn't used with a 'void * __compat_foo_Bar' and
> if necessary have the common setup in ibverbs copy a non-null
> __compat_ into lib_.
>=20
> This will compile-break drivers using the wrong scheme, the driver
> should be changed.
>=20
> Using a new driver with a old verbs means only the flow API doesn't
> work, old driver with new verbs is stil OK. Drop a dependency in the
> mlx4 package. Safe breakage in an obscure scenario..

I like the idea, but in implementing it I found it easy enough to
preserve both forward and backward compatibility.  Proposed patch on
linux-rdma, comments welcome.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--3TJGjSkEqnUU6VkOJ3tVIdJSvG1t62HRt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV6gqkAAoJELgmozMOVy/dDqgP/A/nfTL+z0YcDe5eaohiVFQU
eKEliZ7FzWgDhd3JF1mGtwB6wCsKjGg9Ikp8G3PaoqpSLZ2n4fr/Rw/ZJJmToXrZ
9qY3TNc6E6Gpm77iNSVShkUEk4D/Nj0wbZa6/Sf1uLDemD7bQ+ePrwzc59vjoZiJ
mOY1dr6wB+K/M1+hYkXXr5pKTDlkeHiv8ozUyWRh/8AJ1l0d38EODc6AS9YWFkSp
kbajRkomrDwKziG7XVcGgeusXE0qgmiIqQcoqhTyy2Ngse16Dfqv7bzy101UzTWQ
Ci56MyQ/M6OnyFv0izDI7rbeU5KRrV1gjEf9ZM4UoYxhgAc55wYmFtxON7DrcKLr
XKRfkn67xXWUbIIa6FcT/Lk+ALwrnxBUhaXhNjehMoR/xsDPCEkJ6xrfqlTuSEYp
yJyN+TlUJXLNT/blakzOs8LI8en8zdeEFZV0U2pG+0HGW+stQfHmcRBss939patJ
k6d5laHxAh3YOi+55ZMSvPUIBG5nhBuIvWkh35h6bm9PbEDLX+198kVr9mOQkvmq
OQ5X9eD6B+kkjHKV2W1LKmKxFCNAiit2Ht++rT7YRCCJ/tfKVZcWOl4oGVPdmA7M
+bAaZ2k+kPymm9e0HYiBn9a8YjSpzr5OPWe42LbpZ9kSnq3qbtlJapLYnraQpxpo
rI7GKeXNeOmH5hbscHhW
=e7iA
-----END PGP SIGNATURE-----

--3TJGjSkEqnUU6VkOJ3tVIdJSvG1t62HRt--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
