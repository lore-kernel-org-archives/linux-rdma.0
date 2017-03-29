From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH rdma-next 2/2] IB/mlx5: Enlarge autogroup flow table
Date: Wed, 29 Mar 2017 16:15:10 +0000
Message-ID: <1490804090.3551.1.camel@sandisk.com>
References: <20170329030901.5772-1-leon@kernel.org>
         <20170329030901.5772-2-leon@kernel.org>
         <1490757621.4362.1.camel@sandisk.com>
         <20170329042320.GJ20443@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170329042320.GJ20443-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Content-ID: <A23B776D407E2543BC6F7BCCCF6B9F0D-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-03-29 at 07:23 +0300, Leon Romanovsky wrote:
> On Wed, Mar 29, 2017 at 03:20:37AM +0000, Bart Van Assche wrote:
> > On Wed, 2017-03-29 at 06:09 +0300, Leon Romanovsky wrote:
> > > -#define MLX5_FS_MAX_TYPES	 10
> > > -#define MLX5_FS_MAX_ENTRIES	 32000UL
> > > +#define MLX5_FS_MAX_TYPES	 6
> > > +#define MLX5_FS_MAX_ENTRIES	 BIT(16)
> >=20
> > Hello Leon and Maor,
> >=20
> > The use of the BIT() macro here looks misleading to me. Elsewhere in th=
e
> > kernel BIT() is used to represent a bitmask. My understanding is that
> > MLX5_FS_MAX_ENTRIES is not a bitmask but a value?
>=20
> Hello Bart,
>=20
> I agree with you that the name "MAX_ENTRIES" is misleading. This define
> MLX5_FS_MAX_ENTRIES is needed to compare num_entries with max_table_size
> which is represented in BIT() format. The max_table was added in previous
> patch and we thought that it will be much convenient for the reader to
> compare the same BIT(..) constructions.
>=20
> If you think that we abused the BIT() macro, let me know and I'll send
> updated version (without BIT()).

Hello Leon,

It's not that important to me, but does MLX5_FS_MAX_ENTRIES represent a num=
ber
or a bitmask? To me the name "MLX5_FS_MAX_ENTRIES" suggests that it is a nu=
mber
and using BIT() suggests that it's a bitmask. This seems contradictory to m=
e.

Thanks,

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
