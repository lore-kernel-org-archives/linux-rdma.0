From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-rc 7/9] IB/mlx5: Add VERBOSITY Kconfig option
Date: Sun, 4 Sep 2016 11:26:04 +0300
Message-ID: <20160904082604.GL21847@leon.nu>
References: <1472371118-8260-1-git-send-email-leon@kernel.org>
 <1472371118-8260-8-git-send-email-leon@kernel.org>
 <55889fa6-51c0-fcf6-7684-9712b82212d6@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="pFpMklMRdxwSC3Yi"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55889fa6-51c0-fcf6-7684-9712b82212d6-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--pFpMklMRdxwSC3Yi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 02, 2016 at 01:52:59PM -0400, Doug Ledford wrote:
> On 8/28/2016 3:58 AM, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > This patch introduces new MLX5_INFINIBAND_VERBOSE Kconfig
> > option to enable the output of dump_wqe() which was never
> > printed.
> >
> > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/mlx5/Kconfig | 6 ++++++
> >  drivers/infiniband/hw/mlx5/qp.c    | 2 +-
> >  2 files changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/infiniband/hw/mlx5/Kconfig b/drivers/infiniband/hw/mlx5/Kconfig
> > index bce263b..789fef4 100644
> > --- a/drivers/infiniband/hw/mlx5/Kconfig
> > +++ b/drivers/infiniband/hw/mlx5/Kconfig
> > @@ -6,3 +6,9 @@ config MLX5_INFINIBAND
> >  	  Mellanox Connect-IB PCI Express host channel adapters (HCAs).
> >  	  This is required to use InfiniBand protocols such as
> >  	  IP-over-IB or SRP with these devices.
> > +
> > +config MLX5_INFINIBAND_VERBOSE
> > +	bool "Enable ConnectX-4/Connect-IB verbosity"
> > +	depends on MLX5_INFINIBAND
> > +	---help---
> > +	  This is a configuration option to enable verbose output to easy debug.
> > diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
> > index 174d09b..67b58f7 100644
> > --- a/drivers/infiniband/hw/mlx5/qp.c
> > +++ b/drivers/infiniband/hw/mlx5/qp.c
> > @@ -3984,7 +3984,7 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
> >  			   get_fence(fence, wr), next_fence,
> >  			   mlx5_ib_opcode[wr->opcode]);
> >  skip_psv:
> > -		if (0)
> > +		if (IS_BUILTIN(CONFIG_MLX5_INFINIBAND_VERBOSE))
> >  			dump_wqe(qp, idx, size);
> >  	}
>
> This patch is just a big old bunch of no.  There is no way I'm sending
> in Kconfig changes in a late -rc.

Totally understandable, it was a combination of bad luck with my faults.
1. This patch was prepared before merge window.
2. Shared code was posted late.
3. The whole series was targeted to be sent for 4.9 and not for RCs.
Yuval's patch caused to change in my plans.

> Further, there is no way I'm sending
> in a Kconfig option for a single debug print function.

The goal of this config option is to preserver this print function which
is extremely useful for debug and development. Currently it is under if(0)
and can be removed by mistake.

> Third, there is
> no way I'm sending in a Kconfig setting for what should be a runtime
> debug switch or something like that.

It is in data-path and I wanted to ensure that no change in performance
will be observed. Dynamic configuration won't allow to achieve it.

Will it be acceptable by you to take this patch for for-next to ensure
no one is removing it by mistake? And i will explore the commonalities
in the different drivers to create common VERBOSE flag for whole
subsystem?

Thanks


>
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: 0E572FDD
>




--pFpMklMRdxwSC3Yi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXy9qcAAoJEORje4g2clinreYP/AxWTWxgolctf3HKLGYOa5PU
1BcxvbWM+z+h4ap30QhPCCage0eo1l1gjDNJUTo8KfrKc7p2Pf16a5ekn7n85SP+
v9hPlPLOrzNnzFbDYnbO+4/mAUTFbWCAGLqMCrGSG6tSABhDYxmWT6EWaIeyfjYZ
AUi6QiD9YfWoB8elJiAe1YOGWhnjBg50bmiPx0kF1Uwoz3A0asksYTz9LzAboPu6
c+ERh5JRaYdKmQyUrQA3xaniw+sYq7OX4RQMfkDgJLbVbBtopTSMEsbqn6WxeWvQ
/TMUGgaR7+iAXEAzrWMJu20NVrlrfbbMET9QlB7p5CzXD4/h7JKAdncOkq7Owplf
smGmmY9povYLoKJH3g6D9CNif6X6vyRw/SNcVmZZVH3bDuk/NiwyDaN/YFBrxblX
IYPZnMWdPwD3LWiqPtEN76yzQYTwKAjQsT9ARl+h6peMeo8vHtgExYYkZgUq2Lzt
nfh5Q90bLm+ZdIj3bzKq18CzZdANhIgD4VA34CDiwMnDoiHVJCXxgERwTVat3qub
V8KzWRcqiU1kvJ8sepCSiYMztGROl2WgACupM2xhEFjbhDruEqKvZH7TcAKH/gqK
VX4yYuSPWy3df7gx4z2Qea2bXlZtjyJUT5tyY8w81yYhlJTEKaM1l4uxAUylvVoU
/InNLwG/EubyrlDZDzta
=vfw/
-----END PGP SIGNATURE-----

--pFpMklMRdxwSC3Yi--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
