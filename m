From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: IB/mlx4: Use EAGAIN error code instead or EINVAL in function
 mlx4_ib_poll_one
Date: Wed, 27 Jul 2016 11:58:00 +0300
Message-ID: <20160727085800.GF4628@leon.nu>
References: <1469607893-10657-1-git-send-email-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kbCYTQG2MZjuOjyn"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1469607893-10657-1-git-send-email-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--kbCYTQG2MZjuOjyn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 27, 2016 at 01:24:51AM -0700, Yuval Shaia wrote:
> Please review the following two patches.
> First patch makes int-return function to a void one as it anyway returns =
0.
> Second patch replace all EINVAL error codes returned from mlx4_ib_poll_one
> to EAGAIN.

Thanks Yuval for taking time to do it.
After your's IPoIB patches, we prepared patch similar to these and
planned to send it after merge window will close.

>=20
> [PATCH 1/2] IB/mlx4: Make function use_tunnel_data return void
> [PATCH 2/2] IB/mlx4: Return EAGAIN for any error in mlx4_ib_poll_one
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--kbCYTQG2MZjuOjyn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXmHeYAAoJEORje4g2clinad4QAJiZyX5PFHkzQuDjc2c5Q0pg
NBu8Vlf5zL0UAzAkq98c0XAP8qw33jCEFv5XXQ1SZt1z4xoNm5I2S6tYNR6cn/Ji
4Uys33DygCh1AuiXQ/I+V7Gp7rw2TAGsKou2YzTDms3WuRpWalbHohnSvbQ8EENx
3OpJdyNm8v2Gi3g/YEuriE783b+b+nbuvARSZJaUQ7CGtrEUgGUexVLCDJGQsvkx
skIzRWi8IfG/uV3q5dncJlbPM4if2haMOTUiQqTct6rQJVy62dnRYdANLMK0yrqs
K6ywdPIQs8bq+nU24NPMxxbXTZf+vVrPC6NR9RbGl4yuL//oo/iLFna2unTH6g+z
BXGoZXc3B77Qov7llRBZZxxiu0pyt1xt2SOgBvdx8fCUycUXgI4sEmQkdg8Zfjry
J2DYW6emRXgDY+clkYOXac5RLCeSLehi2JSlL4x9NTBudv1J1ZUidUKlrKsSdV9H
/m/mJsgQk9boaj0Ylzul0tuQxPbmSt5mUi4FOzM++6aDkn42Zj/fNQwX60jS4CXO
5MGtXc2omlqhCYgcywsSTCkWprjG9xc2cvMj8s4XRWPRtrt0au4fDnvDst8TDaI5
SDKlpuuWRaWi7VUDGO1t/vzEE/ghqyz6DJ0NlpnK9l9hVqM5QO6GpUG5qpohMouE
rwxISrDbIa8Cr/6Wh28G
=HXPq
-----END PGP SIGNATURE-----

--kbCYTQG2MZjuOjyn--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
