From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 for-next 0/4] Support SendOnlyFullMember join
Date: Mon, 16 May 2016 11:45:34 -0400
Message-ID: <8e7686fa-de3e-1a92-1168-528909eb4019@redhat.com>
References: <1463401694-19247-1-git-send-email-erezsh@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="CJ2d5iwEcJMJ3SjX7Rs1B7HeA7XouJ9Vu"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1463401694-19247-1-git-send-email-erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CJ2d5iwEcJMJ3SjX7Rs1B7HeA7XouJ9Vu
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/16/2016 08:28 AM, Erez Shitrit wrote:
> There are four types of multicast join: FullMember, NonMember,
> SendOnlyNonMember and SendOnlyFullMember.
>=20
> This patch-set introduces the ability to send multicast join requests o=
f
> type SendOnlyFullMember (until now only the first three types were
> supported).
> Host that sends such join request, does not require a multicast
> subscription and will still send properly, and in addition will not get=

> other multicast packets from that group.
>=20
> It adds a new SA query (for classport_info) to check that the sm
> supports sending such requests and it modifies multicast processing in
> the IB/core module to handle SendOnlyFullMember multicast join requests=
=2E
>=20
> In addition, the patch set modifies IPoIB so that if the sm does suppor=
t
> SendOnlyFullMember join requests, IPoIB will send such a request when
> joining a sendonly multicast group.

What testing has this series received?


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--CJ2d5iwEcJMJ3SjX7Rs1B7HeA7XouJ9Vu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXOeseAAoJELgmozMOVy/dOi8QAMLWbi60GlBRY06y0FljlXYq
wCD13eBkQeUqPLgbhh2DcVFkEY3Lrw67CSstfQpdXkxFddWKWn+UZw8KV6X1WPl5
UXLLXb3p6lhL7PsqwZ9dc7YtoKiIHEo0uAImgOxjxAwNJxSrEzSuV6o4SOZDZrRB
drszSYus24MIIIGlIoNAS6Y2QQk9jABuGNrfTdNvATFtcnWpmU/MjzYTrttMnrqA
eDslkUiika8a5g/L0v4ueUqTpXzV9f8orEhOxA/sBiGqx/FNkG0AyXV9np19tTzq
Ine+v6igHGUdcCCw2w8k4R6kxV0hukRwgSuMR3DydH/NkwUH2Q9tZanZAGBA2MOE
pY2zeJRyn35RTtsFg71GxXGgrXWfwAWl64wtKtSQ3jbLJOfUQQpAfndQhALCXkt5
NwP2HcCD9vlBiJis81Mq1VXfe0Q4I+lBG3zaWeIb9IqX8jajrSYSeYFOrZKroXTo
1YzshoIv0hVtqzJg5gcWGTQ04EwzArb+bXR38z5MtT+51XgAioxe4eJXG35C8qBq
ByXWDjU3LnMCMADK1M/keu5ST8DFWDqsu2MzN6IyouW3k5b/F56Fk5g28TuLibp7
2BMr6+eGYCmbkDO6EdXJAaM8qxDmo6LIQ03JsnL699Hl2griDWo/CGtLMKnQ4Lh7
b8v5a8eOOEUHTKs3K/uO
=9ELh
-----END PGP SIGNATURE-----

--CJ2d5iwEcJMJ3SjX7Rs1B7HeA7XouJ9Vu--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
