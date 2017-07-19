From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/rxe: Convert pr_info to pr_warn
Date: Wed, 19 Jul 2017 20:26:13 +0300
Message-ID: <20170719172613.GS3259@mtr-leonro.local>
References: <20170718203539.6777-1-yuval.shaia@oracle.com>
 <20170719060908.GN3259@mtr-leonro.local>
 <CAG9sBKNXfndf8Lxa97Z8Cc=Ntg+=NoZ9-35CbY0X=0f2aXRx8w@mail.gmail.com>
 <20170719075119.GO3259@mtr-leonro.local>
 <20170719110441.GA26265@yuvallap>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/qIPZgKzMPM+y5U5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170719110441.GA26265@yuvallap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--/qIPZgKzMPM+y5U5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 19, 2017 at 02:04:42PM +0300, Yuval Shaia wrote:
> On Wed, Jul 19, 2017 at 10:51:19AM +0300, Leon Romanovsky wrote:
> > On Wed, Jul 19, 2017 at 10:11:50AM +0300, Moni Shoua wrote:
> > > > How this code can be executed? IB/core ensures that port_num is in range.
> > > > You can remove this check.
> > > >
> > > In this case ah_attr can come from the application and a validity
> > > check is necessary.
> >
> > It is a bug if it comes directly without rdma_is_port_valid() check in the
> > IB/core. Currently modify_qp and create_ah are checking it and ensuring that
> > user won't provide illegal port number.
>
> Not sure i see the whole picture but something does not fit, will
> appreciate a guidance here.
>
> 1. Application calls ibv_modify_qp which in turn fills out a cmd object and
> "calls" ib_uverbs.ib_uverbs_modify_qp.
> 2. ib_uverbs_modify_qp copy the cmd from userspace and calls modify_qp.
> 3. modify_qp, among some other stuff, verifies port validity (which prove
> your point) and calls driver's modify_qp hook (in our case rxe_modify_qp).
>
> Is the above correct?
>
> What i do not understand is the check that is done in step #2 since
> port_num is not set when moving from state INIT to state RTR.
> RXE on the other hands validate port_num only when needed (mask &
> IB_QP_AV).
>
> Looks like the check in step #2 is wrong.
> What am i missing here?

Maybe you missing the Mustafa's patch?
https://patchwork.kernel.org/patch/9841241/

Thanks

>
> Yuval
>
> >
> > Thanks
>
>

--/qIPZgKzMPM+y5U5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllvljUACgkQ5GN7iDZy
WKdRWg//ScKZJ/iQ0FwW0S+jCaztatB9Wx5ASfWNseg9iNDJog6aiYkNXAho6dvR
MMIlFjnN0i4K9UCMp60XxVK8nPuY+zeIRUE1RzUHY6RM2h/jiVZSvrrj8DcArEJu
OQ7RETi90ojVMTjOWMn0Y8B+zTFFsprRZFLre0QJRHigkuZlMzUPnyn4I0qBtaXR
mps5VsjUGIk19VtfgVRoNv7QMD6uJ3N9mAH/8RwvYHAUSiwymM/bVLfc4tpV6mMj
9JcX8XnG8orUAPDWVodqQRd9RrAM8z/ZASsxuPaohPKaKhyKOYxR2NNxktOG9pDC
zh8/Krn5hUPLVJX82njFBcBTNgm9S7mnyGMBaJQXeAaJpx5pLec3I9dmB0JlzHI4
HRi04WGD7ACZ5aBIZHWZi1s1BzbonvvnwiELN3uZAIU8r85Vxr3I2dBgDFwDSGdN
MygkTtAeMRXE+NwhXeu6eg0NMMeEzS2zNxhL3yavAbO6vk/+0gA4zCCTCCtanHk+
/uyjVaR5FPo3CLyp8HcnKMV+fGtcvORR0H8e1HxwOHHOlfLJDB7dwuW9r2WDCkKy
qN+EQZd0I5Ryyy3Rhif8hpBfWzROCmg7ZSJlXD2SgaBUYI8YFE1UICWCTcq86ItR
fLW244Y6VDJC19zS/bgd7ImydbY0cvPrSS+dotdb07a3Ix3bhF8=
=xq6U
-----END PGP SIGNATURE-----

--/qIPZgKzMPM+y5U5--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
