From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH, untested] mlx5: Avoid that mlx5_ib_sg_to_klms()
 overflows the klms[] array
Date: Wed, 26 Apr 2017 09:16:40 +0300
Message-ID: <20170426061640.GV14088@mtr-leonro.local>
References: <8992bd28-667f-94b1-e582-106e6b41aa4b@sandisk.com>
 <20170425175849.GS14088@mtr-leonro.local>
 <438230391.2090966.1493152655709.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ibhTSt8h7StI2D+z"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <438230391.2090966.1493152655709.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

--ibhTSt8h7StI2D+z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 25, 2017 at 04:37:35PM -0400, Laurence Oberman wrote:
>
>
> ----- Original Message -----
> > From: "Leon Romanovsky" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > To: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > Cc: "Doug Ledford" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Max Gurtovoy" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Sagi Grimberg" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>,
> > "Israel Rukshin" <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Sent: Tuesday, April 25, 2017 1:58:49 PM
> > Subject: Re: [PATCH, untested] mlx5: Avoid that mlx5_ib_sg_to_klms() overflows the klms[] array
> >
> > On Mon, Apr 24, 2017 at 03:15:28PM -0700, Bart Van Assche wrote:
> > > ib_map_mr_sg() can pass an SG-list to .map_mr_sg() that is larger
> > > than what fits into a single MR. .map_mr_sg() must not attempt to
> > > map more SG-list elements than what fits into a single MR.
> > > Hence make sure that mlx5_ib_sg_to_klms() does not write outside
> > > the MR klms[] array.
> > >
> > > Fixes: b005d3164713 ("mlx5: Add arbitrary sg list support")
> > > Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > > Reviewed-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> > > Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > Cc: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> > > ---
> > >  drivers/infiniband/hw/mlx5/mr.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> >
> > Bart,
> >
> > Thanks a lot, it indeed looks right.
> > Acked-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > Thanks
> >
>
>
> Hello Bart, Leon, Max and Israel.
>
> I cloned off Barts tree.
>
> git clone https://github.com/bvanassche/linux
> cd linux
> git checkout block-scsi-for-next
>
> I checked all patches were in for this test.
>
> a83e404 IB/srp: Reenable IB_MR_TYPE_SG_GAPS
> dfa5a2b mlx5: Avoid that mlx5_ib_sg_to_klms() overflows the klms[] array
> f759c80 mlx5: Fix mlx5_ib_map_mr_sg mr lengt
>
> Built and tested the kernel.
>
> However this issue is not resolved :(
>
> [ 2707.931909] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817edca86b0
> [ 2708.089806] mlx5_0:dump_cqe:262:(pid 20129): dump error cqe
> [ 2708.121342] 00000000 00000000 00000000 00000000
> [ 2708.147104] 00000000 00000000 00000000 00000000
> [ 2708.172633] 00000000 00000000 00000000 00000000
> [ 2708.198702] 00000000 0f007806 2500002a 14a527d0

Parsed version:
	hw_error_syndrome                : 0xf
	hw_syndrome_type                 : 0x0
	vendor_error_syndrome            : 0x78
	syndrome                         : MEMORY_WINDOW_BIND_ERROR (0x6)
	s_wqe_opcode                     : UMR (0x25)
	opcode                           : REQUESTOR_ERROR (0xd)
	cqe_format                       : NO_INLINE_DATA (0x0)
	owner                            : 0x0

Description:
	umr.klm_octoword_count > mkey.mtt_octoword_count

Sagi, Max,
Any idea where can it be?

Thanks

--ibhTSt8h7StI2D+z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkAO0gACgkQ5GN7iDZy
WKe2khAAwNJltf8ikrqAN5PU/xPjvDsMNZcvT9r0JBbIVhnsHXu8URkTsInjDRSX
BZH3xNxuQf7K8l3m1Sv0J6tJGQYWvYBioLTGFEn2PSZ7OhX9BsuzYyXZ5mK2+wpV
EnLYBJ4vfD9rjXs3okadghhsw4Kdib+5kNEHGz/LWa1OU8kdftd6/P8ShoPO/tg5
hrn9xdLGp3WHb8lB4RmJhSaJsSI7xgqxB4k3X0usKl8PgmWQhsT0nVp4v55nhsyv
V+zOlyIimO6N/ytFUL3VPAzghjfFURioZJTZCYr7vnIZTuztGZUlsQeai0Ju6lI2
lJ6MeNR+SMVfWSw5ORmSaHcOg3HEkCueduE9SrjTFYakPHY7YTRfrNJc7VT0RW3L
i0bYomUB+0e+hzbC7jxdJrqcuULHYCKZ3+Wo1+O8rYGQoYpZJYUktM5uQ2trF2FZ
dl0LdrQRsP9LhdDy6C2uWbePh+rAbCMQUqt6SrmefO8X8hfNPHwGJtA2GW1SSL/X
ClZ7HNSDHnIpljN8GbNstbQkijNJB8djubGCfko9F3D0ixrMO7xrI2zIu9jDrybr
gs4bmUDCU65IRISVT4NZvZqDA7RGKrnWDA5gKeFhR0uzi1wYopoFZB8gKkh4pkNd
yTgY/ULJp31/AnX69etQmUwBId3nw/l1ZU9Ez8wbAoOSb90R8gw=
=67Kw
-----END PGP SIGNATURE-----

--ibhTSt8h7StI2D+z--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
