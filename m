From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 2/2] IB/mlx5: Enlarge autogroup flow table
Date: Thu, 30 Mar 2017 18:00:40 +0300
Message-ID: <20170330150040.GN20443@mtr-leonro.local>
References: <20170329030901.5772-1-leon@kernel.org>
 <20170329030901.5772-2-leon@kernel.org>
 <1490757621.4362.1.camel@sandisk.com>
 <20170329042320.GJ20443@mtr-leonro.local>
 <1490804090.3551.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Cqq5NadOW2RfLMJ/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1490804090.3551.1.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Cqq5NadOW2RfLMJ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 29, 2017 at 04:15:10PM +0000, Bart Van Assche wrote:
> On Wed, 2017-03-29 at 07:23 +0300, Leon Romanovsky wrote:
> > On Wed, Mar 29, 2017 at 03:20:37AM +0000, Bart Van Assche wrote:
> > > On Wed, 2017-03-29 at 06:09 +0300, Leon Romanovsky wrote:
> > > > -#define MLX5_FS_MAX_TYPES	 10
> > > > -#define MLX5_FS_MAX_ENTRIES	 32000UL
> > > > +#define MLX5_FS_MAX_TYPES	 6
> > > > +#define MLX5_FS_MAX_ENTRIES	 BIT(16)
> > >
> > > Hello Leon and Maor,
> > >
> > > The use of the BIT() macro here looks misleading to me. Elsewhere in the
> > > kernel BIT() is used to represent a bitmask. My understanding is that
> > > MLX5_FS_MAX_ENTRIES is not a bitmask but a value?
> >
> > Hello Bart,
> >
> > I agree with you that the name "MAX_ENTRIES" is misleading. This define
> > MLX5_FS_MAX_ENTRIES is needed to compare num_entries with max_table_size
> > which is represented in BIT() format. The max_table was added in previous
> > patch and we thought that it will be much convenient for the reader to
> > compare the same BIT(..) constructions.
> >
> > If you think that we abused the BIT() macro, let me know and I'll send
> > updated version (without BIT()).
>
> Hello Leon,
>
> It's not that important to me, but does MLX5_FS_MAX_ENTRIES represent a number
> or a bitmask? To me the name "MLX5_FS_MAX_ENTRIES" suggests that it is a number
> and using BIT() suggests that it's a bitmask. This seems contradictory to me.

Down the road, that define is translated to bitmask, and it is hard for me
to categorize it. If we limit ourselves to the upper layer only, it will be a number,
otherwise it will be a bitmask.

>
> Thanks,
>
> Bart.--
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Cqq5NadOW2RfLMJ/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljdHZgACgkQ5GN7iDZy
WKcyxw//Zk07utuwdCOMPB2PvjMMCR9rPh0EZtIspJo1gJU12CtnE0UtSUFnzlUU
aWi0K9YhHsk56A3iC28N85by7yEfWOmNWDWWlj0fjpaHeDVO7x2FRLsIqN9eoAu4
HFPUmN0tmhO3CQRosM3ZwqqFKWPtDgIc0myhYGL17ARDXQ4l5YuU+edsE/y6Jd2R
vTBu8EITE8WbmIZiHSfkYNtSBwsEz/D0E3ZGWc21YsfvjWEBxkRAyI/1ClbMXsN6
KIhlBa9l0lihi/VZCieIY+xpJVGVpss6NEcmY4rQIzqp4cdrtHllJiVRuiU/H70z
yW2wh+YCVG7FJiAbalQgmt/UfPoFY+WXAELfYgi1dRnBTcobzBVY8zA6cyufI5tc
aghkgQN+QO8Fe4a8O8aBSd+NsOwz/v0KsLvg2gYGO0F2q23cvbB1lLBLaO0PVJZt
xfcNuLzC8bXULBsskIJHsAuDJNqi2mXI3Cru1I0tBSLMhMhKVdj4W0EtjvWFdaGd
3t8hcLU+D/KZfLyMyzKFbMh+a3PV2dR8kgj8+R5+Ukx694N3c21NmF1t/nC6w4X+
TDDuI7Dvng6PRFR2aHL6X2WOR+KhsyOlveTrSrUkOnqUjVGVvfMz5kSe8dlyav7T
+Ccx4jT0Mp/dOhwkEEIogJK9MgHlNhB+OpKGP8KdC0k2eBorIi0=
=/KV9
-----END PGP SIGNATURE-----

--Cqq5NadOW2RfLMJ/--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
