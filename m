From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH 4/6] IB/core: Enhance ib_map_mr_sg()
Date: Wed, 11 May 2016 10:53:59 +0300
Message-ID: <20160511075359.GE25215@leon.nu>
References: <573278D9.4050908@sandisk.com>
 <57327981.4080404@sandisk.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MIdTMoZhcV1D07fI"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <57327981.4080404-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--MIdTMoZhcV1D07fI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 10, 2016 at 05:14:57PM -0700, Bart Van Assche wrote:
> The SRP initiator allows to set max_sectors to a value that exceeds
> the largest amount of data that can be mapped at once with an mlx4
> HCA using fast registration and a page size of 4 KB. Hence modify
> ib_map_mr_sg() such that it can map partial sg-elements. If an
> sg-element has been mapped partially, let the caller know
> which fraction has been mapped by adjusting *sg_offset.
>=20
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> Cc: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> --- a/drivers/infiniband/hw/mlx5/mr.c
> +++ b/drivers/infiniband/hw/mlx5/mr.c
> @@ -1752,10 +1752,11 @@ static int
>  mlx5_ib_sg_to_klms(struct mlx5_ib_mr *mr,
>  		   struct scatterlist *sgl,
>  		   unsigned short sg_nents,
> -		   unsigned int sg_offset)
> +		   unsigned int *sg_offset_p)
>  {

I wonder on which tree are you basing?
In Linus (4.6-rc7) the function signature is different [1], the same
goes for my tree and Doug's for-4.7 branch [2].

[1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/dr=
ivers/infiniband/hw/mlx5/mr.c#n1752
[2] https://github.com/dledford/linux/blob/k.o/for-4.7/drivers/infiniband/h=
w/mlx5/mr.c#L1752

--MIdTMoZhcV1D07fI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXMuUXAAoJEORje4g2clinKvEP/0yzIF2D/XfywF/9iSzJCxKz
7FgRnRp4XVPx6UpjMi+dnTjH7fkdBFAiIBJVtKIuj5KB/bG08Gaf/GgryT3s/eGY
oVsoHyiB1z/VzvM1K8APaqgwbHMjFqsPVAmZ/XrCZMzKzIa3m2yvUuXAh+S9Skg3
pwBoaZyaYy20WVhsh1D80VL7Yu+s56lfBhN1VbsvFxjQAkTMRveV7mjFKHToQwiB
C/uN0GfqhF7v2beLfxwS+CWuTH4bDAfuMg+u5tV1NH6gQQeHAzT3s2VK01N73EJG
PAVQty2dAq54i6zs5S3rl8n0X9+UTw57UGA5uGP1D+uvpMVAw5nH53FVnnyICVrz
BMSoSVHwbrdXyCHPcOi/0LzvmJOCXESz7WiGp9NGdX8fELaLmhQWtzkSd5Pdqyux
SMuimGYhF9Xu842y2EOjy0qNKTxHbauf4jDfhdri5yzyrp3WUEGv3OWFby0xyGj2
SkMZgoQHCjw1cmC0fSSWik03ZF/FtJbmD+FtlAhN28jCvF3wMui7DXOdrw4VfDAh
XOBvtHu7noVMbjw4QxJKeci2EDNDptbWRcgdZEvQsmO5mTliyVhRQ9H33cQMsobF
UvAVFyhc1SpLyy9Hnlsbf0Yhvwc0EX6liAF4cqtQudQfUYGGZSbNXk68th58Ldle
LGJ2sMAaaVJXzhdq/3sc
=wPWB
-----END PGP SIGNATURE-----

--MIdTMoZhcV1D07fI--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
