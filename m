From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V2 00/11] Add RoCE v2 support
Date: Wed, 16 Dec 2015 15:39:16 -0500
Message-ID: <5671CBF4.4060602@redhat.com>
References: <1449150450-13679-1-git-send-email-matanb@mellanox.com>
 <CAG9sBKM7j6w+Gk4PXXO+0mHpFeVaBdeNmr-z9V9fPR562o+kmw@mail.gmail.com>
 <567089F1.30004@redhat.com>
 <CAG9sBKNa4Hd0WVqhZCLeqXjc2zE2h+dBwF6zVgGT0R_Gt1FEwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="v5fFnidt8QUvm39r95REngSSkE7usq9tU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG9sBKNa4Hd0WVqhZCLeqXjc2zE2h+dBwF6zVgGT0R_Gt1FEwA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--v5fFnidt8QUvm39r95REngSSkE7usq9tU
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 12/16/2015 01:56 AM, Moni Shoua wrote:
>> The part that bothers me about this is that this statement makes sense=

>> when just thinking about the spec, as you say.  However, once you
>> consider namespaces, security implications make this statement spec
>> compliant, but still unacceptable.  The spec itself is silent on
>> namespaces.  But, you guys wanted, and you got, namespace support.
>> Since that's beyond spec, and carries security requirements, I think
>> it's fair to say that from now on, the Linux kernel RDMA stack can no
>> longer *just* be spec compliant.  There are additional concerns that
>> must always be addressed with new changes, and those are the namespace=

>> constraint preservation concerns.
>=20
> I can't object to that but I really would like to get an example of a
> security risk.

*This* is exactly the conversation to be having right now.  The
namespace support has been added to the core, and so now we need to
define exactly what the impact of that is for new feature submissions
like this one.  More on that below...

> So far, besides hearing that the way we choose to handle completions
> is wrong, I didn't get a convincing example of how where it doesn't
> work.

Work is too fuzzy of a word to use here.  It could mean "applications
keep running", but that could be contrary to the namespace restrictions
as it may be that the application should *not* have continued to run
when namespace considerations were taken into account.

> Moreover, regarding security, all we wanted is for HW to report
> the L3 protocol (IB, IPv4, or IPv6) in the packet. This is data that
> with some extra CPU cycles can be obtained from the 40 bytes that are
> scattered to the receive bufs anyway. So, if there is a security hole
> it exists from day one of the IB stack and this is not the time we
> should insist on fixing it.

No, not true.  You are implementing RoCEv2 support, which is an entirely
new feature.  So this feature can't have had a security hole since
forever as it has never been in the kernel before now.  The objections
are arising because of the ordering of events.  Specifically, we added
the core namespace support (even though it isn't complete, so far it's
the infrastructure ready for various upper portions of the stack to
start using, but it isn't a complete stack wide solution yet) first, and
so this new feature, which will need to be a part of that namespace
infrastructure that other parts of the IB stack can use, should have its
namespace support already enabled (ideally, but if it didn't, it should
at least have a clear plan for how to enable it in the future).  Jason's
objection is based upon this premise and the fact that a technical
review of the code makes it look like the core namespace infrastructure
becomes less complete, not more, with the inclusion of these patches.

As I understand it, prior to these patches there would always be a 1:1
mapping of GID to gid_index because you would never have duplicate GIDs
in the GID table.  That allowed an easy, definitive 1:1 mapping of GID
to namespace via the existing infrastructure for any received packet [1].=


These patches add the concept of duplicate GIDs that are differentiated
by their RoCE version (also called network type).  So, now, an incoming
packet could match a couple different gid_indexes and we need additional
information to get back to the definitive 1:1 mapping.  The submitted
patches are designed around a lazy resolution of the namespace,
preferring to defer the work of mapping the incoming packet to a unique
namespace until that information is actually needed.  To enable this
lazy resolution, it provides the network_type so that the resolution can
be done.

This is a fair assessment of the current state of things and what these
patches do, yes?

Jason's objections are this:

1)  The lazy resolution is wrong.
2)  The use of network_type as the additional information to get to the
unique namespace is vendor specific cruft that shouldn't be part of the
core kernel API.

Jason's preference would be that the above issues be resolved by
skipping the lazy resolution and instead doing proactive resolution on
receipt of a packet and then probably just pass the namespace around
instead of passing around the information needed to resolve the
namespace.  Or, at a minimum, at least make the information added to the
core API not something vendor specific like network_type, which is a
detail of the Mellanox implementation.

Jason, is this accurate for your position?

If everyone agrees that this is a fair statement of where we stand, then
I'll continue my response.  If not, please correct anything I have wrong
above and I'll take that into my continued response.

1 - Actually, for any received packet with associated IP address
information.  We've only enabled net namespaces for IP connections
between user space applications, for direct IB connections or for kernel
connections there is not yet any namespace support.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--v5fFnidt8QUvm39r95REngSSkE7usq9tU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWccv0AAoJELgmozMOVy/dx4YP/1L47YWyjh+RAwqleHbJGrMU
k1dXUgq7E4yyKeEyJG5nEwCBbI3OrDEc5ssFOnJwzUGZXOtzzTdvF4XJRGne0ZPN
YSKBq/uXP+mECSVYi4xc+0Xjgo46v0yko73zxMqrGP1tbax3w3UWY+VNCrDtqRT1
OrDlw0x5KYKrnqPULnttgaroO+jO1+bxJYILGOF1rDWe3StPEXuM/mlCQjFHrfjR
weZ7hKsckLsXWfM4C2HsM4+T7e6CP3v/7d/IY6J4jLtw7E7epbD8vO+g1wa0O8hA
HxiQZPl4wyeUu7zJAqJ8/XQAGphWG+jIQn237SspIgLvB+R4X4+SJ3pPvF8mbDnk
GiGgIe2E2nAj1bwDn7atV5IrB4p7fkFYQA0M6WZ2CYBOmlMy6PQSJ2N1MHY80zg8
AxDHguqCanPYi450PnNVwLd19iiUKDb2nRmXQHgP3UyrKUNNfc6UCPer2sf9wc8q
7KTjmKCFPkILF+7g+B+wiB9TKXzRPfmW5TmWNZzRK//lJAHy3NHkqCJ1KELR5t3a
53p131aIfldLrqymOO5rV5TLgpOvZ9u8REP/hB8deKUNgJun/8u1Jw6yO6zmNWrA
B5erqYpkaWxuV3hguIvntqNBFpxDhqUj8E7egxiS8owZOQmwkJIaU6TwLfu+LIeq
Zx0PDdXLWzxgY90Gzl/P
=+Cur
-----END PGP SIGNATURE-----

--v5fFnidt8QUvm39r95REngSSkE7usq9tU--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
