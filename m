From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/7] IB/srp: Avoid a cable pull can trigger a kernel crash
Date: Sun, 8 Oct 2017 16:22:24 +0300
Message-ID: <20171008132224.GZ25829@mtr-leonro.local>
References: <20171006214243.11296-1-bart.vanassche@wdc.com>
 <20171006214243.11296-5-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oIKd4Ysag+ysiDHn"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171006214243.11296-5-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--oIKd4Ysag+ysiDHn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 06, 2017 at 02:42:40PM -0700, Bart Van Assche wrote:
> This patch fixes the following kernel crash:
>
> general protection fault: 0000 [#1] PREEMPT SMP
> Workqueue: ib_mad2 timeout_sends [ib_core]
> Call Trace:
>  ib_sa_path_rec_callback+0x1c4/0x1d0 [ib_core]
>  send_handler+0xb2/0xd0 [ib_core]
>  timeout_sends+0x14d/0x220 [ib_core]
>  process_one_work+0x200/0x630
>  worker_thread+0x4e/0x3b0
>  kthread+0x113/0x150
>
> Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

You need Fixes tag for the stable tree.

Thanks

--oIKd4Ysag+ysiDHn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnaJpAACgkQ5GN7iDZy
WKdVARAA0LTW1p4hWBHIwTAXV1GbXf7PT4I9fYNpGhHQ5HyaKnRgz1yEinEXflog
mt3Pz+W9DcF8MpnH8MrtFfVYWuXzwZk/hwzKQewl2BXR3vfIoGpMoWsPyVhlUmZ5
MaJJhD5xUc+MFjosLg21hHslj9SxQW4+3AnDfvotCD/LI63uS7UMWKREh0QeX2xZ
0nuHwDma5QyFBDMoH1kb8dHoMlrfXlmsdqTtF8WrqQgCbcnJNa+azCDmUDerXi6+
E3qi3l5FNNXki+an3WRpfQTZB+IBQaNfBTli5AD++mCwbphHapv2jr5xxN8cCwFb
FtUKEuZuItXdd9/nwnzBbmoOePsVjrLFubJ+ObEg8Yq2WhEzsItoYRXeOy0JhomA
JKtrN2gEmklvV0xRQXrU2yYEUVFMy7XqOZd9ICsqpsBnK0dEhi8nKzKmVyDV5Kdl
OkUdeJCe7LO15KpoVhW6BAcpzMGkP9Z4mznrL6IFXARIGC4UwXbKxedqIh4ghQX9
WFdIN/3/l1pFgaNReE5pfuRAkrQTbDWEHO7+l8zh6UBrusImY7vdUI6Im/4kWNzI
gGWz1ljbwKFl2lHw9YpnDNsdOQvW4pcyCrZeP/LDCnm+IYuk2obLD59kpB7VJMwJ
2sRzokLYF3NBERy1pWAoLK997/5lop8qW+N0uBW/jK+4YjE6Els=
=z/gf
-----END PGP SIGNATURE-----

--oIKd4Ysag+ysiDHn--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
