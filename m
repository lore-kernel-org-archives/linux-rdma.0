From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 0/5] Add scatter FCS support
Date: Fri, 13 May 2016 16:39:23 -0400
Message-ID: <92e9a494-c363-db42-894c-17d67fe96ecc@redhat.com>
References: <1460902778-5977-1-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WN9NxRmhSq7LWefG7qDPuxHmVixHMRIKX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460902778-5977-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WN9NxRmhSq7LWefG7qDPuxHmVixHMRIKX
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 04/17/2016 10:19 AM, Matan Barak wrote:
> Hi Doug,
>=20
> Frame Check Sequence (FCS) is an error detecting code that terminates
> an Ethernet frame. When using Raw Ethernet, users sometimes want
> to validate the FCS themselves, and therefore it should be scattered
> to the receive buffers.
>=20
> This series adds the above support.
>=20
> The user can control scattering the FCS using Queue-Pair(QP) creation
> flag called IB_QP_CREATE_SCATTER_FCS.
>=20
> Also, to report this new device capability, we had to add a new
> device capability flags in the uverbs response called
> device_cap_flags_ex, since all the current device_cap_flags are
> occupied.
>=20
> device_cap_flags_ex 0-31 bits are identical to the legacy
> device_cap_flags, and the upper 32 bits (32-63 bits) report new
> extended device capabilities.
>=20
> Devices that support scattering the FCS should report it in
> device_cap_flags_ex using IB_DEVICE_RAW_SCATTER_FCS.
>=20
> This patch depends on the mlx5 core shared code that was sent to both
> IB and net trees and was already accepted by Dave Miller:
> net/mlx5: Update mlx5_ifc hardware features
> net/mlx5: Fix mlx5 ifc cmd_hca_cap bad offsets
>=20
> Moreover, this patch conflicts with the LSO series (that will be
> sent soon). The resolution of this conflict is available in
> Mellanox's tree.
>=20
> Thanks,
> Majd and Matan
>=20
> Majd Dibbiny (5):
>   IB/core: Add extended device capability flags
>   IB/core: Add Raw Scatter FCS device capability
>   IB/core: Add Scatter FCS create flag
>   IB/mlx5: Add Scatter FCS support for Raw Packet QP
>   IB/mlx5: Report Scatter FCS device capability when supported
>=20
>  drivers/infiniband/core/uverbs_cmd.c |  8 +++++++-
>  drivers/infiniband/hw/mlx5/main.c    |  4 ++++
>  drivers/infiniband/hw/mlx5/mlx5_ib.h |  1 +
>  drivers/infiniband/hw/mlx5/qp.c      | 20 +++++++++++++++++++-
>  include/rdma/ib_verbs.h              |  2 ++
>  include/uapi/rdma/ib_user_verbs.h    |  1 +
>  6 files changed, 34 insertions(+), 2 deletions(-)
>=20

This patchset is a uAPI extending patchset.  Recently, there has been
talk of requiring a higher level of review and acknowledgment from
various vendors for such patches.  However, in this case, it extends the
QP creation code, which is already an extended function, and it extends
it in a manner consistent with the original extension mechanism.  The
only use visible change is a new bit in a bitmap with plenty of space
free at the moment, and the resulting WC SGE entries will be extended.
The overall patches themselves look fine, the extension was done
appropriately, and this isn't a newly extended API, so I'm OK taking
these as they are.  Applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--WN9NxRmhSq7LWefG7qDPuxHmVixHMRIKX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXNjt7AAoJELgmozMOVy/dMI8P/jkfvo7rxKMpKtsG+VlGjJae
y9dD5QIdUKpxAZDnyInWk/jaycYjtvYFRFpTYg4vAGKZGNsxe4EbkoOdGZbxXUJ6
qOAC2WwONampyoo447iB7uiFUuHcjq8JfSUFh3iBsBag95+g2wTkJVpgxaiaj492
qxhnaJLKBEuqsntwTiiHH5JMka5865e9HJCvgUvRI51p//c5JJp3/lVSYNkW5ABw
GVhUIPiiCh4jW+sC2vzFR84+LZG3pSOGzz79178FIsgMlvaAi2BKc/+v+ZAxSSu3
l/0CY73pq7J7dv35o82INcKLM3+IYgRz6WvP2miYjzsBUYjEO4FTWAiXLLQN7dzv
qgUoxgVUSKr975sfppZKmJfEM5YfgCYrVyGkyK8fNEEETfpzLRyl3mdqyNvcGCPV
rcuY3SrQupjwPKXblvQytfPzoHaj7DhmBHCQ/Z0+WVT89lKYZYqFfd6JRVOmSEyZ
T9ISihmvnenGQMUA9MKtVFZG5kWfF5Q/eMN4VMSYoluT/KJYHbwxVTXI44axcwMp
OgED0vVAIiS5FNn+NpaX/xvUaM1o7ujjlykO5ctUTlkg1Y+MWy3xG/EzmAbXZ7ME
HB3Sdm7+JA4O8JOvAIPbfmMLQim8zGiJ63J46lG73p9kXg2tvQYLUEVOjEly5W/+
hpdyLvd874BTNEJsFhV9
=I2oe
-----END PGP SIGNATURE-----

--WN9NxRmhSq7LWefG7qDPuxHmVixHMRIKX--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
