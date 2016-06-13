From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: multipath IB/srp fail-over testing lands up in dump stack in
 swiotlb_alloc_coherent()
Date: Mon, 13 Jun 2016 17:07:47 +0300
Message-ID: <20160613140747.GL5408@leon.nu>
References: <19156300.41876496.1465771227395.JavaMail.zimbra@redhat.com>
 <2d316ddf-9a2a-3aba-cf2d-fcdaafbaa848@sandisk.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jtcAeju3WzRmRF+o"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2d316ddf-9a2a-3aba-cf2d-fcdaafbaa848-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--jtcAeju3WzRmRF+o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 12, 2016 at 11:32:53PM -0700, Bart Van Assche wrote:
> On 06/12/2016 03:40 PM, Laurence Oberman wrote:
> >Jun  8 10:12:52 jumpclient kernel: mlx5_core 0000:08:00.1: swiotlb buffe=
r is full (sz: 266240 bytes)
> >Jun  8 10:12:52 jumpclient kernel: swiotlb: coherent allocation failed f=
or device 0000:08:00.1 size=3D266240
>=20
> Hello,
>=20
> I think the above means that the coherent memory allocation succeeded but
> that the test dev_addr + size - 1 <=3D DMA_BIT_MASK(32) failed. Can someo=
ne
> from Mellanox tell us whether or not it would be safe to set
> coherent_dma_mask to DMA_BIT_MASK(64) for the mlx4 and mlx5 drivers?

Bart and Laurence,
We are actually doing it For mlx5 driver.

926 static int mlx5_pci_init(struct mlx5_core_dev *dev, struct  mlx5_priv *=
priv)
<...>
961         err =3D set_dma_caps(pdev);

187 static int set_dma_caps(struct pci_dev *pdev)
<...>
201         err =3D pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
202         if (err) {
203                 dev_warn(&pdev->dev,
204                          "Warning: couldn't set 64-bit consistent PCI D=
MA mask\n");
205                 err =3D pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(=
32));
206                 if (err) {
207                         dev_err(&pdev->dev,
208                                 "Can't set consistent PCI DMA mask, abo=
rting\n");
209                         return err;
210                 }
211         }

118 static inline int pci_set_consistent_dma_mask(struct pci_dev *dev,u64 m=
ask)
119 {
120         return dma_set_coherent_mask(&dev->dev, mask);
121 }

>=20
> Thanks,
>=20
> Bart.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--jtcAeju3WzRmRF+o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXXr4zAAoJEORje4g2clinX1cP/1Vhuujf2S1eiAUBr8yBfcAj
lu5QBK+menzVjp36y3/yHkYSfml4R9Bia4l32nKEsvE6bnV0TtixduhqUNcP5+jU
BMZBbbZzQs1FYDZTrsBsghcsaKcRGjjsOz16rdSDfVYPdw3CE7yIMJp4uNxvVXXg
tuR4Zn3i+ZZpi2wi2tHpeZ+wrSgqZcURz6mtvEOqUiC4LzPUQR4JFHO3ihNghhyU
yGYf8NPAQdUQNvBMIpYP5q+swHxpmp32+/sRiZIaRG0Is6emV+uBQlYtK6z0vsI2
QZaPu9tenEh1umsty+cjdqInzIjpwR1qgD2QfW5wQ/Rl5ntBuWLkzQJL0f3T/MBR
jxr1Vxz0LtNlZ9s0Nbo0dzlNf/+toC20+Uif+oat4c6wrj4XE3EX83z9aKgZ91Uj
ERFwHtfK9ZmEXrldq0RIfwj2DIX/OpaUtY9tOV/II0AUP72skvG9zKjkJOPwP8R8
uZjqJUwsLXtHnlUY24ZzRb9LxKVkyOx2VOqZuN+WCJFwVz/2Rasp6MtelIWhkk/P
XAQiYQxv0SRjmppiqE3eY9vyS9VFWUqHpwJPaOd+AnttF7JU27LXP/PTQVtR+i5k
KiqoYaBK1NsHIgyt0XIPVVajlMz9rpapMlQBxERkKChjG/EGk5X7fDJ5J7iWthYH
+pOkABVq6VBHP2ixRYlN
=H1Uk
-----END PGP SIGNATURE-----

--jtcAeju3WzRmRF+o--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
