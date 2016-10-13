From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: =?utf-8?B?44CQRm9yIGhlbHDjgJEgc29t?= =?utf-8?Q?e?= tips for
 upstream the userspace driver code of hns_roce
Date: Thu, 13 Oct 2016 12:36:59 +0300
Message-ID: <20161013093659.GA9282@leon.nu>
References: <57FF414A.3000200@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="uT8OcDz013Sgpw/5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <57FF414A.3000200-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linuxarm <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--uT8OcDz013Sgpw/5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 13, 2016 at 04:09:46PM +0800, oulijun wrote:
> Hi, Doug Ledford
>    Now, I am preparing for upstreaming the userspace driver code of hns_roce.  But, we have
> some difficulty how to upstream it. for example,
>    i) which branch of ofed should we upstream ?
>    ii) if want to upstream the userspace driver of hns_roce successfully, how we should do?
>
>   Can you give me some guides?

Hi Lijun,

Our main library for all user-space stack is located at github [1].
Please see similar question from Ram [2] and Jason's response [3] to it.

[1] github.com/linux-rdma/rdma-core
[2[ http://marc.info/?l=linux-rdma&m=147574131706820&w=2
[3] http://marc.info/?l=linux-rdma&m=147577168016989&w=2

Thanks.

>
> thanks
> Lijun Ou
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--uT8OcDz013Sgpw/5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX/1W6AAoJEORje4g2clinsf8P/ii6LmYB+mlhgkf7TJ4zv5uc
FfHWvdHGNalJR+hFhYrn7/UfzDbwyOsHVHlRkmqKpwTsVlonYHDQX7FJwNljG4XR
drdsibb/Uh+cJFRFaJDsutzMQae5uBSCNyVpptuqnaYKgeog7nEXz3nUo7JbtzX5
VQDsJejCEp7YiXJGvaCbQkX+4VIGKS9Ve5azXQZhL39f/3OxCJgqDNe3UdfnV/Bx
HnqrQK7jCV4EGSW7Z7ZSGzeEze6ZnHLG3TlckHRvwfFhOl2Vym1cz4v2IJrcxTfy
a9XdA+CghMKmyaPk72k3glOUCUDal3v0yrWsYlPYAqKO0HcHT01N3eHusBsn+Hwx
jH1IbyipTxldPdA8o5YoNadEcbFVqPgbZb+Ir7fdxIKwRYndaiprpNq7iK6S7bo1
vLAvfk7fVOhZ/F6tGx4V6Y33pPB6j0KctcOCUW4u7vOTEQK3QZBpRh+uF7ZPHl6Q
RIievBN8Np6Iyn3/Hy/HpEHQXX6nxwOlfKftmAgny84HU8P8A14aNhhq+V1SSuQT
XotSi47lbJQJAegiNhBU3uxtyqfS7auoprRIDBiDr9nR5XAIoR4F1jkxiqePNT6g
2Sqf3EVekG82+69ZCB9UXN3CI5aAczAi7aXfyf6iGM6/A10XNdXd+4itCv1Ublei
QcTpK+ZcV9WG90al5J2G
=OnrD
-----END PGP SIGNATURE-----

--uT8OcDz013Sgpw/5--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
