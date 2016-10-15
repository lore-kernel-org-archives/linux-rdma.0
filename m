From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/4] rdma-core infrastructure
Date: Sat, 15 Oct 2016 12:26:19 +0300
Message-ID: <20161015092619.GJ9282@leon.nu>
References: <20161014192136.11731-1-jarod@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Ft0o2zvssPbUStej"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161014192136.11731-1-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Ft0o2zvssPbUStej
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 14, 2016 at 03:21:32PM -0400, Jarod Wilson wrote:
> This is a set of patches to make some minor changes to the stock spec file,
> add a bunch of userspace glue that Red Hat has been shipping on it's own in
> Red Hat Enterprise Linux and Fedora for a while now, and a revised split
> package spec file that we're likely to use in at least RHEL, to preserve the
> current packaging split.

Jarod,

I'm far a way from packaging, so I have very general questions.
1. You mentioned FC, but used glue/redhat/. Is it applicable for Centos?
2. Do  FC and Centos need similar files in structure?
3. Does it make sense to rename glue/ to be packages/ and move debian there?

>
> Jarod Wilson (4):
>   rpm spec: install documentation too
>   glue/redhat: add udev/systemd/etc infrastructure bits
>   glue/redhat: copy stock spec for RH customization
>   glue/redhat/spec: build split rpm packages
>
>  glue/redhat/ibacm.service                |  12 +
>  glue/redhat/iwpmd.service                |  12 +
>  glue/redhat/rdma-core.spec               | 534 +++++++++++++++++++++++++++++++
>  glue/redhat/rdma.conf                    |  25 ++
>  glue/redhat/rdma.cxgb3.sys.modprobe      |   1 +
>  glue/redhat/rdma.cxgb4.sys.modprobe      |   1 +
>  glue/redhat/rdma.fixup-mtrr.awk          | 160 +++++++++
>  glue/redhat/rdma.ifdown-ib               | 183 +++++++++++
>  glue/redhat/rdma.ifup-ib                 | 308 ++++++++++++++++++
>  glue/redhat/rdma.kernel-init             | 262 +++++++++++++++
>  glue/redhat/rdma.mlx4-setup.sh           |  91 ++++++
>  glue/redhat/rdma.mlx4.conf               |  27 ++
>  glue/redhat/rdma.mlx4.sys.modprobe       |   5 +
>  glue/redhat/rdma.mlx4.user.modprobe      |  21 ++
>  glue/redhat/rdma.modules-setup.sh        |  30 ++
>  glue/redhat/rdma.service                 |  15 +
>  glue/redhat/rdma.sriov-init              | 137 ++++++++
>  glue/redhat/rdma.sriov-vfs               |  41 +++
>  glue/redhat/rdma.udev-ipoib-naming.rules |  13 +
>  glue/redhat/rdma.udev-rules              |  18 ++
>  glue/redhat/srp_daemon.service           |  17 +
>  rdma-core.spec                           |   4 +
>  22 files changed, 1917 insertions(+)
>  create mode 100644 glue/redhat/ibacm.service
>  create mode 100644 glue/redhat/iwpmd.service
>  create mode 100644 glue/redhat/rdma-core.spec
>  create mode 100644 glue/redhat/rdma.conf
>  create mode 100644 glue/redhat/rdma.cxgb3.sys.modprobe
>  create mode 100644 glue/redhat/rdma.cxgb4.sys.modprobe
>  create mode 100644 glue/redhat/rdma.fixup-mtrr.awk
>  create mode 100644 glue/redhat/rdma.ifdown-ib
>  create mode 100644 glue/redhat/rdma.ifup-ib
>  create mode 100644 glue/redhat/rdma.kernel-init
>  create mode 100644 glue/redhat/rdma.mlx4-setup.sh
>  create mode 100644 glue/redhat/rdma.mlx4.conf
>  create mode 100644 glue/redhat/rdma.mlx4.sys.modprobe
>  create mode 100644 glue/redhat/rdma.mlx4.user.modprobe
>  create mode 100644 glue/redhat/rdma.modules-setup.sh
>  create mode 100644 glue/redhat/rdma.service
>  create mode 100644 glue/redhat/rdma.sriov-init
>  create mode 100644 glue/redhat/rdma.sriov-vfs
>  create mode 100644 glue/redhat/rdma.udev-ipoib-naming.rules
>  create mode 100644 glue/redhat/rdma.udev-rules
>  create mode 100644 glue/redhat/srp_daemon.service
>
> --
> 2.10.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Ft0o2zvssPbUStej
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYAfY7AAoJEORje4g2clinGSkP/1DQr6hJUPBshYDcPDwA+aXL
NtAnCCGvVwy3wfdlpylH6/TPj6msOuAIxiDjAZYCpqyGWRMRkyaZ2kAjU04Kbw3k
nXAsKnuTwGqv5hnM/gijf1nCzUHIPpVrqsAirUsWWX3vTwZbfeCvCbTYXWvAFyHd
r7AgTlcp4tmfQhTzo9rpur5HtG4PiZJd/gP/dQGJU55NxoJfS8Or57BUiBiLjI4L
1i+bpRB62xSxrLol9ArFNLxXCZQPE/ERpAQ4GzCjNI8SfNatWixEGMK+jBzCGsGn
8TkwjUF3SJ/USgcJ1xYd9i7mvAzD+bZ434fUBvF1BVpb9YfxNMKvc+DLcuoRwxX9
eYeHrERqDEQ0d+oauVsIUrvTekqKYuyvLXso9kXmCmkw+d5OWBPoWC/XysV+CBxE
PwUnqHbdVZJ1rQB3mKvRxn7ubhQXOMfCfIBO0x2e3wTV9pPbHtwX5tlfmR0JMIpW
T4cE+qYslZWH4NRhKmFD2tssD9HGTVzMB3R0A/blP5okGFtfyNlJ+Hy/nOcDNxqu
QV8zk6clXp6QBd+4VvwlHQKHTibRR5Qhxfb2uOuM49Q6IznLoLm5V0W1koeLI4zp
TzO0X8CeT0blCONI8XRuCOlI091ULCmHbq19LZHZWdoUSR+KDJBPHvXdxA6sqC6y
joshehmfXKxzWi52gmco
=Y550
-----END PGP SIGNATURE-----

--Ft0o2zvssPbUStej--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
