From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH libibverbs] Add support for TX/RX checksum offload
Date: Wed, 9 Sep 2015 11:20:14 -0400
Message-ID: <55F04E2E.5050100@redhat.com>
References: <1439826618-3015-1-git-send-email-bodong@mellanox.com>
 <55EA2C3D.2080904@redhat.com>
 <CAJ3xEMheigQt29mmb50PKHsXfx8pXMex+3bgJeobF0JBAjHsNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="euQGuD7J1Ltm24Nn3Xi47Hnh6xftfIwxW"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMheigQt29mmb50PKHsXfx8pXMex+3bgJeobF0JBAjHsNQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--euQGuD7J1Ltm24Nn3Xi47Hnh6xftfIwxW
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 09/05/2015 03:59 PM, Or Gerlitz wrote:
> On Sat, Sep 5, 2015 at 2:41 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
>> On 08/17/2015 11:50 AM, Bodong Wang wrote:
>>> Add a device capability flag IBV_DEVICE_IP_CSUM to denote IPv4 checks=
um
>>> offload support. Devices should set this flag if they support
>>> insertion/verification of IPv4, TCP and UDP checksums on
>>> outgoing/incoming IPv4 packets sent over IB UD or ETH RAW PACKET QPs.=

>>
>> Correct me if I'm wrong, but the only reason this is only supported on=

>> UD and RAW ETH QPs is a matter of current firmware.  There's no reason=

>> it couldn't be supported on RC, right?
>=20
> Doug,
>=20
> The context here is the ability of the user-space RDMA verbs
> infrastructure to serve as the baseline for implementing user-space
> TCP/IP offloads engines.

Fine.

> Such engines would be production worthy in
> open-systems environments mostly when they are inter-operable which
> whatever stack runs on the other end

OK.

> --> they must not put any
> additional bits on the wire

Maybe.  For base level interop, sure, but for enhanced service in a
homogeneous environment, not necessarily true.

> --> RC isn't an option

Not following here Or.  The IPoIB connected mode packet is 4 byte IPoIB
Header followed by whatever header the TCP stack put on the packet
(likely either IPv4 or IPv6).  The same ipoib_hard_header function is
used for both CM and UD connections, the same ipoib_start_xmit() is used
for both CM and UD connections, and we just hand off to the appropriate
send routine when we have our neighbor lookup complete.  Why would you
need new bits on the wire to do a checksum on an RC send and not for a
UD send?

>, so for IPoIB we
> just need an IPoIB UD QP in user space, and for Ethernet RAW PACKET
> QP. This device capability is there  ~10y for IB UD and we just
> naturally extend it to Eth RAW. If/when a vendor comes up with
> supporting csum for RC, we can add another dev cap and say the well
> established API applies on them too, with just a slight modification
> to man pages and such, makes sense?

So if we ever support RC, then any actual users of this API will have
hardcoded which types of QPs are supported into their apps and they will
*all* have to go modify their source code to re-hardcode the types into
their app and recompile.

Alternatively, we write a reasonable API.  One where the types of QPs
are not set in stone, we tell users to query the API to determine if any
given QP supports IP CSUM offloads, and then if we add more QP types in
the future, the apps just automatically work even on the different QP
types (assuming they used those QP types at all) because it was written
to an API that allowed for it.

Face it Or, the API in this patchset is crap.  I totally get why you are
fighting for it so hard.  You already spelled it out: "This device
capability is there  ~10y for IB UD and we just naturally extend it to
Eth RAW".  I can read between the lines.  You have users of the API,
probably some internal and some external, and if I go demanding a proper
API, all of these people have to recode their apps to the new API, and
you'd like to avoid that if possible.  However, if I don't, and then RC
support is added, then they have to recode their apps anyway.  Wouldn't
it be best to just do it right and get it over with?

So, here's the API I'm proposing:

- Add ibv_query_qp_ex
- In new ibv_query_qp_ex struct, extend the ibv_qp_caps struct to add a
flags element
- Define a flag for IP_CSUM_SUPPORTED
- Define IP_CSUM flag for send operations
- Define the API so that IP_CSUM is ignored on all sends if the QP
doesn't support IP_CSUM and only checked on QPs that support it.  This
way other QP types don't suffer a penalty on send to check this and
return EINVAL if its set
- Define the return flags in the wc struct so we can signal that a CSUM
was performed and succeeded

A user app would then basically follow this flow:

ibv_create_qp()
ibv_query_qp()
  check for IP CSUM and cache result
ibv_post_send()
  set IP_CSUM if QP supports it

ibv_poll_cq()
  if qp supports IP_CSUM, check CSUM result in wc

That's what I would like to see for these changes.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--euQGuD7J1Ltm24Nn3Xi47Hnh6xftfIwxW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV8E4uAAoJELgmozMOVy/dbYQP/jzJyUH/mCB4gEgTsdwWvd31
iycNYD6CKxsCZO7/EOn08b7/ruGtRrI+bDtS9+ls+j7unDuUFnayrHlZeFioHqon
X9BkQRmdXPp9CYlkqe6GrZaSCQ71Bmlw3mGPq+Ht6NnKOaVZBLjHN3lIy5yqh3P7
R/ZGVCM3sGmSrA93MiJIJkGTYaV4izzpUIhaD2TiQdMOf4ZGy7g0SomRwPIrI8ek
6XeO0kEpLgOqiwkyvPCllyuII6FhpX0UI8wDVEFcgWeN3oswfR35xgWpQXd/bQzL
nQelRacQ+mUGuEDTYSgc+YTonLq3cPkIviXeseUR41sHlVBtrteNJbvQe47rms/S
j5A8ppENfsFisUPXvFlPxd41FI1k1ZB5PUC/T2kdPUfXrTa2wmpwwXmhQt4Ozqcq
pg79cHtPcNvqYJK7JYcvWBGPRBJTZX2yiDQLZ/j+Dyuc0u66uaCO7WUh5ynZhoTz
PKoW946BPtgZsA8VMqmVMpfT7cOKsSOIoDMgQetQVZj/eLA25Ggxcd2oUhB4VgM5
+NbH+nJYHEHZvtHY4CkefeJwglK5y9eIgOozKvxY8CakoqhOHf1OmvoZemcMtegn
C1J2EJJbm/agT3/2aGQBJNYuIulu7PGmHTDu8ABdD/U3Tom41BNnOpskqquMjf4I
ArhfceJV0vSOt6chm3oA
=W5df
-----END PGP SIGNATURE-----

--euQGuD7J1Ltm24Nn3Xi47Hnh6xftfIwxW--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
