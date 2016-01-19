From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: convert mad to the new CQ API
Date: Tue, 19 Jan 2016 15:42:29 -0500
Message-ID: <569E9FB5.1020004@redhat.com>
References: <1451913359-25074-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="M0MFosWORxbjJBf6qCSCXt1ckf9SBU9n0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1451913359-25074-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--M0MFosWORxbjJBf6qCSCXt1ckf9SBU9n0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 01/04/2016 08:15 AM, Christoph Hellwig wrote:
> This series converts the mad handler to the new CQ API so that
> it ensures fairness in completions intead of starving other
> processes while also greatly simplifying the code.
>=20

Series, using v2 of 2/2, applied.  Thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--M0MFosWORxbjJBf6qCSCXt1ckf9SBU9n0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWnp+1AAoJELgmozMOVy/dYwMQAKGHTsD4GFpEZQrNxqeGsmpD
fSf1sDB8hcKiWzJjGhu2JNc6/nlIPeQsrFHoctap6A5MU+BT5PyP5rZHRXte38l/
tGg4Onr5v49y9V9236ANkYYajlR+zxSnpxzJrTrzqC8u+UoUU4Qh8FHAoSkKhyWf
QiRVHKjq1ctBNI3Aq93hPDPzoPyVPVzr1nig0PN3km4MdRoy4u28SrikCvkP6hBw
FakqlwEjNM0XFLAGBtJ4QlX7i4l3QPPbNI8lQDTVv4nJGjpkgU05r4ZykhWsT1OM
h0lWb355oBs239GeChWqcsWjvyNMq+E4MYXmCAZsDZgUShYCm5HS+gfexqGxDmR/
U8Hq/4+ZNK4TM2vLkyhtxsEo3WmefslMMN2j2YjK3KByI3XtzLcI1M3/mMZ+OJdx
S1XfRB7tIPpEru9qtd1cCRTK3r4iJzVDS8+F8GLHNJF/XykRdOOsy04r/U+ZwLk9
+ntRv4nSoQWFoHMTZ/AMEKXeVkc1iYQZk7QvLoRXIfGVIYlafGskevqStzE/U8xf
wJY80crRv+jjnLHhtuwQX8wB5++eI0X7KZb5jZvsQ68AKVn/0TE+8DHK9gXo9OLT
p/GURcGSFpprFj2wAgy4PACUQsx4Thiq1gukLeBgwH9j5WIUgNXK3xlQGjflEKFP
cfCxH9xZt+D9xNSkye1f
=k0Q8
-----END PGP SIGNATURE-----

--M0MFosWORxbjJBf6qCSCXt1ckf9SBU9n0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
