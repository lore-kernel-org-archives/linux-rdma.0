From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/rxe: Don't clamp residual length to mtu
Date: Thu, 13 Apr 2017 15:22:00 +0300
Message-ID: <20170413122200.GE1343@mtr-leonro.local>
References: <20170406124944.11074-1-jthumshirn@suse.de>
 <20170413120000.GI6734@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="BI5RvnYi6R4T2M87"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170413120000.GI6734-qw2SdCWA0PpjqqEj2zc+bA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Linux Kernel Mailinglist <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--BI5RvnYi6R4T2M87
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 13, 2017 at 02:00:00PM +0200, Johannes Thumshirn wrote:
> On Thu, Apr 06, 2017 at 02:49:44PM +0200, Johannes Thumshirn wrote:
> > When reading a RDMA WRITE FIRST packet we copy the DMA length from the =
RDMA
> > header into the qp->resp.resid variable for later use. Later in check_r=
key()
> > we clamp it to the MTU if the packet is an  RDMA WRITE packet and has a
> > residual length bigger than the MTU. Later in write_data_in() we subtra=
ct the
> > payload of the packet from the residual length. If the packet happens t=
o have a
> > payload of exactly the MTU size we end up with a residual length of 0 d=
espite
> > the packet not being the last in the conversation. When the next packet=
 in the
> > conversation arrives, we don't have any residual length left and thus s=
et the QP
>
> Hi Moni, Sagi and Max,
>
> Any comments on this?

Hi,

I'm sorry, it looks like this patch failed on the floor. We have
Passover vacation these days and many people are OOO now.

But anyway, I'll remind to Moni.

Thanks

>
> Thanks,
> 	Johannes
>
> --
> Johannes Thumshirn                                          Storage
> jthumshirn-l3A5Bk7waGM@public.gmane.org                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--BI5RvnYi6R4T2M87
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljvbWgACgkQ5GN7iDZy
WKcJnQ/+JGe+MNbiKEOd87V1LZgS++a3nS4WXlZiHpcCWpVvxt1tSyz+EMuOOXYf
ymHfJ4eyDiLg4XuT/6aUcPJCjqD6vVUK04OYxOreCBo6bMEJujyXMIdezAt4d1dg
P7HTqBd09jybNyZUQ/hxwKl5V3JUT7MAOiBlTLVUUay/Zli9K6O8MLu5LXZzRxyS
ByQzOEXBNTiKdhjwimEJx4iAZg6M3A5jCPxT9wwpQ2LAXGyTLnoOMqOnzdYG/E1i
xczfXap2tTQbjRbUd1aYhJAEIpD7kCMfsLPfHHTV8XLTxP9rqAaCFAidTeG3EPwg
myuijV6W6kxfdQN73uEijMRYclRrivTlEcaLwm6JoACsCA6NzfEULfzkVJMMHNbh
uwgfRsj6rOeE1MWBf6SZemEabdwAaX+oKzMUBufdQ2g0WeArf3Xnmzr+CFxOeaIA
2NdaNzzK4oTIbK88ZQ0iLJK42F9LEh6KbutWmd54KzSAg/cDDhayi0ksL7KycIWJ
0LzheEZQ4ycEdOr2QzkkHbX1KjY/yxgE8AUqF7RjYfrLsrLVceaCTZkcpNtCqKVb
sxX/KUmaa9V/OpjntBzeU3MycdQTjC+aUaWKK92lAZHhcQNffaxAf3+LuysnQxHD
IkF1+3Vpi+X46d0Xb0K4STJxDIcBc00eOwtoykSrDq3SI9QnNtE=
=J4F5
-----END PGP SIGNATURE-----

--BI5RvnYi6R4T2M87--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
