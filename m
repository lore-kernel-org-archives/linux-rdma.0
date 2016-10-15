From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: trivial sparse fixes for rdma-core
Date: Sat, 15 Oct 2016 12:50:41 +0300
Message-ID: <20161015095041.GB25013@leon.nu>
References: <1476381095-20041-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="neYutvxvOLaeuPCA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1476381095-20041-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--neYutvxvOLaeuPCA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 13, 2016 at 07:51:03PM +0200, Christoph Hellwig wrote:
> This is the low hanging fruit in terms of reducing sparse noise before
> looking into endianess and iomem annotations.

Thanks, applied.

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--neYutvxvOLaeuPCA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYAfvxAAoJEORje4g2clinSkYQAI7t/jDlhvU8+FiXHoOFoMEm
lTEqfLbVe/Vx8ZvibV3XgZYD2jZbLw0F279fU6BdF4owL14LFs9jvIVkfweLl9Yf
fujUqV6xbntbEXJsT1pMIuIyloRPucXh4m042xZ8pDSPbrdebGd5IlW/hdt3kaZz
OuWc9f829nLZ9kv8tOBp9F2FHDFzCpy37hkt+cyno0rSB6P1GPqiK1us0879daPo
E0UZW7K6/96JdPF5dqfem4Hn9M8x4hoRY+Lzt7tJWwv7NuW0NsygJzhZpmfwkok6
gNKug+22xHR5DcsDG25w//Lj2kqLyGAEpxIKCdDOqbCzGTHL94rSWm9YVLYLoJCT
n7TWEIegMzEkiEwSlF6chDedlH/7xJMBGIW13GfPK285GyMnBn8SIzdVf+oWWH2Z
gIthLwoanCaRdfJYbgbeCwllnnzhceJ7Y1rT4eEZ3EZh8peGFKRx2VK3mcxOEt9q
IX0njjMY/ym0bCtNswC/gF0k4EXEZ61yD+UNhPToOTWJ+igghH08oWqMXB/Oc4no
8md62en1xUMKJ4Qn0PbaW4ehbQzJScXzNn6KTIJ7PPl6D1nPBRAVtZvN3/iXUzO9
/fbHAYNjPCocOBteAwfQhSX3UEOFPylc7aBk+iCmy4mtf7LnVgXa13Uxikv7uiBk
Whc46Cwz3sNlYR4VJMhU
=TH98
-----END PGP SIGNATURE-----

--neYutvxvOLaeuPCA--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
