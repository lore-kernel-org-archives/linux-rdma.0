From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Thu, 16 Jul 2015 08:42:53 -0400
Message-ID: <55A7A6CD.4080900@redhat.com>
References: <55A56640.2000206@redhat.com> <CA+55aFzdE94JcGT3aF0+rp-ym6UdMCAcQD2LSCBeedv9dLRfhQ@mail.gmail.com> <20150716075542.GA9093@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="VklRfWCQBDtr18HfG9UwqFkFpbf5SawkV"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150716075542.GA9093-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VklRfWCQBDtr18HfG9UwqFkFpbf5SawkV
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/16/2015 03:55 AM, Christoph Hellwig wrote:
> On Wed, Jul 15, 2015 at 05:07:46PM -0700, Linus Torvalds wrote:
>> Hmm. I've pulled this, but quite frankly, I don't think this was
>> appropriate for post-merge-window. It's not at all obvious that that
>> "rdma_cap_ib_switch helper" thing is a bugfix, and that goes for a few=

>> of the other commits too. Some of them are _clearly_ not actual
>> bug-fixes, but just random commits.
>=20
> rdma_cap_ib_switch isn't even a bug fix, it clearly adds (or shuffles)
> dead code..
>=20

In the 4.2 merge window we added the code that mostly eliminated our
reliance on node_type as anything of value (instead of checking
node_type + link_layer to determine if certain features were supported,
we added a bitmap of the features themselves and now check that bitmap).
 Then I went on PTO for several weeks during the merge window.  While I
was gone, the rdma_cap_ib_switch helper patch was discussed and written
on the mailing list.  When I got back (which was just before the first
rc), it took me a bit of time to get all of the appropriate patches
pulled together and submitted.  I included that code because it was the
last remnant of node_type still in use, was a use that the original
patchset didn't address, and taking it allowed us to go from using
node_type to not using node_type at all in one kernel version instead of
going from using node_type, to using node_type for switches only, to not
using node_type at all across a series of two kernels.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--VklRfWCQBDtr18HfG9UwqFkFpbf5SawkV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVp6bNAAoJELgmozMOVy/ducsQAJis1FxZ+OPg9smcJyBR0DEW
eOk0kTGazgGY2tFdQviBq0u293/Neh8lEa5Pws6M2czCzxjmwy+jdVs2hy5YnT4W
HCms6odfEL+T78OfmJpD/4rG7U5TUPQDgS2JYH9lWD759OyJ3n1rfUasg9fmu77q
tC6OxCYWaE5rj4xGP1pgrghZQXZvxN5wl40ZsHG02IWVpVjp1hphMvD6oi+1Z43Y
KsMECFfWVVEXptWUj+j7qXfalhqDA6cpxBMysWHOrR4D/BWkGvRN98u6UXApcXI2
eu/D7DCa8SK75NzjTSz1Rq+2H4PeNAn2nDEeVGbSAhD73fqpR/q0c2xlXQRb82vF
R6PsiLcb6fvbygSjD1hTTNsSL14YoeAdXn5+QOq/nLrGb15cdW6N4mbS7vYbs17S
CagpOVLnksZx7N7jISxyFSRCjKpuCTleEgOjVmr1cP/4/9ZtJrD6HnW21zP0bK1C
stxEVuH52vmbfTsAg44T47HUZai2RD78dDUJWn5g3w3wdGHApCRzJtRHzNHZjqKW
RsGKIqIBUbrBCKen4bJyHOcCqimwF3gSN+so588M4tWxu7G3I/OxyAOe07xM+vPi
pO9OE/B1NB41OpfJwN0YYjbRMWpIesFJVwAg3yu6T+SpQ/JnXm0kvhulLPIEmj5c
W+wIICbgO+YaMG9EFsqI
=nHaB
-----END PGP SIGNATURE-----

--VklRfWCQBDtr18HfG9UwqFkFpbf5SawkV--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
