From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 11/10] svc_rdma: use local_dma_lkey
Date: Tue, 19 Jan 2016 16:01:11 -0500
Message-ID: <569EA417.7060803@redhat.com>
References: <20160107194251.2662.88158.stgit@klimt.1015granger.net>
 <20160108075341.GA24754@infradead.org> <20160108140204.GA27867@fieldses.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="aHGgVN5ixoCplskJQmIPlRGNxUQA89D4K"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160108140204.GA27867-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aHGgVN5ixoCplskJQmIPlRGNxUQA89D4K
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 01/08/2016 09:02 AM, J. Bruce Fields wrote:
> On Thu, Jan 07, 2016 at 11:53:41PM -0800, Christoph Hellwig wrote:
>> We now alwasy have a per-PD local_dma_lkey available.  Make use of tha=
t
>> fact in svc_rdma and stop registering our own MR.
>=20
> Acked-by: J. Bruce Fields <bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>=20
> --b.

Per off-list communication with Bruce, this series has been applied to
my tree.  Thanks.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--aHGgVN5ixoCplskJQmIPlRGNxUQA89D4K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWnqQXAAoJELgmozMOVy/dEykP/0D9Wi882VhDZGb1vGgaKID4
sY+20wQlh3kk2UbhTtzUyFzD+Yx2+hd4ro67slVWJhBakNu3lnHUi8u159jzI1gw
wKtvL26Tk28u8UjgMantB+BR3P4zIGuXZkjNNxeKp3+EYOJos3uaaqc+ATj01hGw
tyLWz5tUoJjszvJ5A78/8YsNvoxthde/osox4+rtHiMSV7KhouQC6s4fEXkw2MKB
NDB5Blk/Eec9A/gqMIkTfk/dhqzwNWsdtIGajlcBEPAvXubtKNUfVG4J9DNu0xN7
Tc7wafu/HrtfVZHVdYQJ0/Y/i51YDFyVu44l2G082qhacMCB3B3Zw0Hpu/4KuvF0
FIWDzgp7fRvUHBlVpiy5vtbPQi0Op0eEfUq00YJpUxcvB5PL0UFWd0FR00JlqEPR
wriHkCYOS327ePc1ZFBtwKDzB344BHNgugUqrrCGbdYU0tussFuFP/HVvz4wGK9Y
rQE6e8k+ympDcpMojLgPfcp1OhvyjimDKnuCjVyDX3ZAkwPUV8PTFviXSey21+i/
QUEnwd2ckAIWPd+IM1RWw6cr+SHPRzFmi7OdwhuaoSN2Ok9O7n7j/It72gLYyWd3
2nQSSpyLrM3vkEQ2Dyv1NUCPPTot19iqDrYs0H1ev7FSFQrR0RL8xtYzxddgmJmY
GcRy49pJT80QBy3tKngU
=bG5H
-----END PGP SIGNATURE-----

--aHGgVN5ixoCplskJQmIPlRGNxUQA89D4K--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
