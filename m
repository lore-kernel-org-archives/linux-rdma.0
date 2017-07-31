From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [rdma-rc 08/14] RDMA/mlx4: Avoid potential derefence warning
Date: Mon, 31 Jul 2017 15:11:30 +0000
Message-ID: <1501513888.2466.3.camel@wdc.com>
References: <20170731070924.7193-1-leon@kernel.org>
         <20170731070924.7193-9-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170731070924.7193-9-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Content-ID: <C9F72718C4826F4C86428046695381CB-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-07-31 at 10:09 +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> The smatch complains about possible dereference, it is unclear from
> source how it can occur, since in case of failure to find/allocate
> group, the acquire_group() will return error.
>=20
> Avoid the following error, by changing IS_ERR() to be IS_ERR_OR_NULL().
>=20
> drivers/infiniband/hw/mlx4/mcg.c:964 mlx4_ib_mcg_multiplex_handler() erro=
r:
> 	potential null dereference 'group'.  (acquire_group returns null)

Hello Leon,

I agree with you that it's not clear from the source code how acquire_group=
()
could return null. My proposal is to drop this patch and to report this as =
a
bug to the smatch author (Dan Carpenter). I don't think it makes sense to
modify kernel code that is fine because a tool (smatch) reports a false pos=
itive.

Thanks,

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
