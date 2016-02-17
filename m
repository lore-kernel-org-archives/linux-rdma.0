From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 00/21] IB/srpt patches for Linux kernel v4.6
Date: Wed, 17 Feb 2016 11:18:15 -0500
Message-ID: <56C49D47.9010904@redhat.com>
References: <56BCDAAD.7030906@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="EgSA1p5OfAKuDnscmbGUPoGivXadILrQP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56BCDAAD.7030906-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--EgSA1p5OfAKuDnscmbGUPoGivXadILrQP
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 02/11/2016 02:02 PM, Bart Van Assche wrote:
> Hi Doug,
>=20
> This series of patches is what I came up with while testing the most
> recent version of my SCSI target patch series (see also
> http://thread.gmane.org/gmane.linux.scsi.target.devel/10905). This
> includes fixes for ABORT handling and lockups during driver shutdown.
> All review comments that have been posted so far have been addressed in=

> this patch series.
>=20
> Changes compared to v3 of this patch series:
> - Removed node_acl_size member from the srpt_template structure.
>=20
> Changes compared to v2 of this patch series:
> - Moved patch "Simplify srpt_handle_tsk_mgmt()" to the front of this
>   patch series and added a "Cc: stable" tag.
> - Removed the UNKNOWN_TMR definition again from
>   include/target/target_core_base.h.
> - Switched to list_empty_careful() in patch "Use a mutex to protect the=

>   channel list" such that it is no longer needed to introduce RCU in
>   this patch series.
> - Dropped patch "Do not complain about initiator names without leading
>   0x" because it modifies the same code as a pending patch series from
>   Nic.
>=20
> Changes compared to v1 of this patch series:
> - Rebased this patch series on top of kernel v4.5-rc1.
> - As proposed by Alex Estrin, modified patch "Simplify
>   srpt_handle_tsk_mgmt()" such that task management function code
>   validity is now checked by the target core.
> - Added a comment in patch "Simplify channel state management".
> - Changed "return true" into "return 1" in patch "Simplify
>   srpt_shutdown_session()" as suggested by Christoph.
> - Fixed patch "Fix srpt_handle_cmd() error paths" based on the feedback=

>   provided by Sagi.
> - Split patch "Eliminate srpt_find_channel()" in three patches.
> - Left out patch "Fix a rare crash in srpt_close_session()". It is no
>   longer needed because srpt_disconnect_ch() is now called with the
>   sdev mutex held.
> - Added several new patches.
>=20
> The patches in this patch series are:
> 0001-IB-srpt-Simplify-srpt_handle_tsk_mgmt.patch
> 0002-IB-srpt-Add-parentheses-around-sizeof-argument.patch
> 0003-IB-srpt-Remove-struct-srpt_node_acl.patch
> 0004-IB-srpt-Inline-srpt_sdev_name.patch
> 0005-IB-srpt-Inline-srpt_get_ch_state.patch
> 0006-IB-srpt-Introduce-target_reverse_dma_direction.patch
> 0007-IB-srpt-Use-scsilun_to_int.patch
> 0008-IB-srpt-Simplify-channel-state-management.patch
> 0009-IB-srpt-Simplify-srpt_shutdown_session.patch
> 0010-IB-srpt-Fix-srpt_close_session.patch
> 0011-IB-srpt-Fix-srpt_handle_cmd-error-paths.patch
> 0012-IB-srpt-Fix-how-aborted-commands-are-processed.patch
> 0013-IB-srpt-Inline-trivial-CM-callback-functions.patch
> 0014-IB-srpt-Eliminate-srpt_find_channel.patch
> 0015-IB-srpt-Log-private-data-associated-with-REJ.patch
> 0016-IB-srpt-Use-a-mutex-to-protect-the-channel-list.patch
> 0017-IB-srpt-Detect-session-shutdown-reliably.patch
> 0018-IB-srpt-Fix-srpt_write_pending.patch
> 0019-IB-srpt-Log-out-all-initiators-if-a-port-is-disabled.patch
> 0020-IB-srpt-Introduce-srpt_process_wait_list.patch
> 0021-IB-srpt-Fix-wait-list-processing.patch

Modulo the one patch I touched up, the rest looked good.  I've picked
this up for 4.6.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--EgSA1p5OfAKuDnscmbGUPoGivXadILrQP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWxJ1HAAoJELgmozMOVy/dogcQAKNP0YGzRsJxA+FmGo9ouBYd
gFn/Ff405PE4KqkTpu8rGQ2qXBRB4CcvTgX1J0mxL5K/07+yIxL+t4ZkEC/FcQ6Y
/r8srW7wr/UkQQB879kWPhq9YsGykYKso7FQqcN6MYtOuoKct5bioKFUO6UZ5Yol
Bnpl11eo6jvX5WrsJR3LthfSvAmIgLKuav5wXy/apVJqyPosEKfWezHtTp1B+0Qm
hUB7MNPkWByKv58mQ705Rw0lr37SS2/GPA9aishmAtXLId5A8A8m1MDyCOId5DMF
/vhKYGajoIYeBRUDhjcQk+wLzGhWTtxsRmKORPOpmPjeVcXnfQZFglYG0paFvLBp
fcp1Ufnt+j1l4wGyq0FzplSQNDBsDlOBlpCvXrrEXDKRYLE7L2/cD3GxLjuMBZBx
2tPKf+CwAqdQbr+aqzrmy0BgqtsiJCfscJxAkF5dAXM/Gi0GqYkbGXs0z/pX847Y
oyLGKnUHuP6tEMnVbkiZX5Ebr3277Qll4q75x//TiVfZG3wlKcQQpbEvWVrAcmCg
f2LuECxXAdq3LhNqEJOYnPEE9h6DuCSAQkSXfvhNnLFI9HLBMBqtNTONxKqPnXSb
xmqK0f2Y64LlhxgTnCizxLR/K6jR6PfRixRld/cJmzUZ9VUkSFfOY8dQP9jMp26w
F7B86zk70RktRRqWbiVz
=bhp0
-----END PGP SIGNATURE-----

--EgSA1p5OfAKuDnscmbGUPoGivXadILrQP--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
