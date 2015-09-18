From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] IB/core: Add support of checksum capability reporting
 in ib verbs
Date: Thu, 17 Sep 2015 22:39:39 -0400
Message-ID: <55FB796B.2080506@redhat.com>
References: <cover.1442413048.git.bodong@mellanox.com>
 <490a38ab04a96f24500d647392e931c38853ba45.1442413048.git.bodong@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="psXLCQ69JxxuHc6pTWgndb0V1a1dChLDP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <490a38ab04a96f24500d647392e931c38853ba45.1442413048.git.bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bodong Wang <wbd2905-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--psXLCQ69JxxuHc6pTWgndb0V1a1dChLDP
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/16/2015 11:56 AM, Bodong Wang wrote:
> A new filed csum_cap is added to both ib_query_device. It contains two =
members:
> eth_csum_cap and ib_csum_cap, indicates checksum capability of Ethernet=
 and
> Infiniband link layer respectively for different QP types.
>=20
> Current checksum caps use the following enum members:
> - IB_CSUM_SUPPORT_UD: device supports validation/calculation of csum fo=
r UD QP.
> - IB_CSUM_SUPPORT_RAW: device supports validation/calculation of csum f=
or raw QP.
>=20
> Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  include/rdma/ib_verbs.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>=20
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index b0f898e..94dbaee 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -183,6 +183,11 @@ struct ib_cq_init_attr {
>  	u32		flags;
>  };
> =20
> +struct ib_csum_cap_per_link {
> +	uint32_t  eth_csum_cap;
> +	uint32_t  ib_csum_cap;
> +};
> +

I generally don't like to waste this many bits on this little
information.  64 bits total for what only uses 4 bits right now, and
even on the high side would probably only ever use 8 or 12 bits, is
excessive.

That said, it's cleaner and easier to read than something like a double
shift where ib is lower 16 bits, eth is upper 16 bits, so I won't
request you change it, just register my eyebrow raise over the number of
bits used to record so little information.  (In fairness, I thought
about make you shrink it down, but the area of the struct you are adding
this to is currently 64bit aligned and it is reasonably likely that the
next item will need 64bit alignment, so saving bits only to possibly
loose them to alignment is a exercise in futility)

>  struct ib_device_attr {
>  	u64			fw_ver;
>  	__be64			sys_image_guid;
> @@ -229,6 +234,7 @@ struct ib_device_attr {
>  	struct ib_odp_caps	odp_caps;
>  	uint64_t		timestamp_mask;
>  	uint64_t		hca_core_clock; /* in KHZ */
> +	struct ib_csum_cap_per_link csum_cap;
>  };
> =20
>  enum ib_mtu {
> @@ -868,6 +874,10 @@ enum ib_qp_create_flags {
>  	IB_QP_CREATE_RESERVED_END		=3D 1 << 31,
>  };
> =20
> +enum ib_csum_cap_flags {
> +	IB_CSUM_SUPPORT_UD	=3D (1 << IB_QPT_UD),
> +	IB_CSUM_SUPPORT_RAW	=3D (1 << IB_QPT_RAW_PACKET),
> +};
> =20
>  /*
>   * Note: users may not call ib_close_qp or ib_destroy_qp from the even=
t_handler
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--psXLCQ69JxxuHc6pTWgndb0V1a1dChLDP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV+3lrAAoJELgmozMOVy/dsZ0P/001tJRT9Yfb0SLKjKFW8r9l
3oqYJuTNFLO2jJGqGGNPkEzWWBXqzuq/WdZc43JArvqKQ2YhSdThxLyiSSvLTmRl
DB289wGczg1MhExErg4IMfDFylHLOE51fNpjxvl7P7z/6TZ4qeySRmYn1MG2gNG7
W2iaoKIdHFhux2oNxe1YZsozlmHK7TJQl8SZluMpAX85MNqJJm/VIptxb2o+xQNO
S4THiQvrLKU3DtAGrTDHR3Z89ed3oGQzYitH0UsI9He4LKg3sj9LnGbHuZ9AswBx
yNwHjf29/2mAt0ebc6WZjyVqLnh1Szkkx9IXL3y7ulFiBlVvxhFO//Zzr2PpgiBL
cPhOVgIuQKzyVUGwanBHaO6gFTAp0MzVSXuWjVpelEkUomp3+xtwZCsV/Eb18++y
1d0NZC+68kvL0jVEm/1yei3DQREFuwCYLvwf3ni2XTFQn79puVcVg5vWnhZ98AD4
4vwwwEuFx+WzuTV2+1tOxiSVKWCNiWMu2+1fRxr/l+DSqTQkBQDRGPeQsQV814v1
EhZ+xNRkczcJtdI9qon8c72pYL1Hrypzr8x+0Vfz0kqp+cljYSsb8ugsJpdIj047
Al3QJgTW/U9T4fdofCwBiseUrVKQQH6FvpK1NDAXfe8ilpXvZzGBgz/SDMJIs2Gm
pf4yWWV7VYxkNDWFHAnz
=u2im
-----END PGP SIGNATURE-----

--psXLCQ69JxxuHc6pTWgndb0V1a1dChLDP--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
