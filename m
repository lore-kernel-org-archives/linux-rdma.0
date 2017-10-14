From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 03/13] Attach/detach SoftiWarp to/from network and
 RDMA subsystem
Date: Sat, 14 Oct 2017 09:41:32 +0300
Message-ID: <20171014064132.GT2106@mtr-leonro.local>
References: <20171008130342.GV25829@mtr-leonro.local>
 <20171006122853.16310-1-bmt@zurich.ibm.com>
 <20171006122853.16310-4-bmt@zurich.ibm.com>
 <OF406E95F8.33CF80BB-ON002581B9.00073D6F-002581B9.00081F69@notes.na.collabserv.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="D5tFrmRBv7YOLFOK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <OF406E95F8.33CF80BB-ON002581B9.00073D6F-002581B9.00081F69-8eTO7WVQ4XIsd+ienQ86orlN3bxYEBpz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--D5tFrmRBv7YOLFOK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Oct 14, 2017 at 01:28:43AM +0000, Bernard Metzler wrote:
> -----Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote: -----
>
> >> +
> >> +#define SIW_MAX_IF 12
> >> +static int if_cnt;
> >> +static char *iface_list[SIW_MAX_IF] = {[0 ... (SIW_MAX_IF-1)] =
> >'\0'};
> >> +module_param_array(iface_list, charp, &if_cnt, 0444);
> >> +MODULE_PARM_DESC(iface_list, "Interface list siw attaches to if
> >present");
> >> +
> >> +static bool loopback_enabled = 1;
> >> +module_param(loopback_enabled, bool, 0644);
> >> +MODULE_PARM_DESC(loopback_enabled, "enable_loopback");
> >> +
> >> +LIST_HEAD(siw_devlist);
> >> +
> >> +static int cpu_cnt;
> >> +static char *tx_cpu_list[MAX_CPU] = {[0 ... (MAX_CPU-1)] = '\0'};
> >> +module_param_array(tx_cpu_list, charp, &cpu_cnt, 0444);
> >> +MODULE_PARM_DESC(tx_cpu_list, "List of CPUs siw TX thread shall be
> >bound to");
> >
> >No module parameters please.
> OK. Would you have a pointer which sheds some light on that
> rule? Thank you!
>

It is not rule, but common knowledge exactly as BUG_ON which is not
prohibited, but makes no sense in low level driver code.

The module parameters sometimes make sense, for example in subsystem
level where they can apply to whole devices underneath.

But most of the time, they indicate complete ignorance of users in favor
of easy developer's life.

For people, like me, who doesn't run modules at all, the change in
module parameters require rebuild of initramfs and in more extreme
cases rebuild of SELinux labels.

> >
> >> +
> >> +int default_tx_cpu = -1;
> >> +struct task_struct *qp_tx_thread[MAX_CPU];
> >> +struct crypto_shash *siw_crypto_shash;
> >> +
> >> +static ssize_t show_sw_version(struct device *dev,
> >> +			       struct device_attribute *attr, char *buf)
> >> +{
> >> +	struct siw_dev *sdev = container_of(dev, struct siw_dev,
> >ofa_dev.dev);
> >
> >Please remove "ofa_*" from this code, upstream has nothing to do with
> >OFA.
> OK, sure.
> That came from the fact it felt wired to write an iWarp driver
> and use ib_*. Shall we stick to history and name those things ib
> even if we have now 4 transports, or can we come up with something
> more generic? ofa obviously is not a good idea.

We already have rdma_* notation for not-IB protocols, in long run,
we will remove drivers/infiniband to be drivers/rdma.

Thanks

--D5tFrmRBv7YOLFOK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnhsZsACgkQ5GN7iDZy
WKedERAAx/usQd19PcQlD0E1oeEu84Wg4sjDcif3gfZDrkAZUljZ093Nw+ZBLKGn
YmYIEIDKrpSJW/l8F0NwugvZg8uwjfJ7VOR6TjTt/ZltsmAwvP/2I2+tkTGU+pzB
ISFD4kfRRP9LYPZaMxHX+WrDGCe9Tlyg+OEFqTecXURycoBqXfBgExeoUJxPp+PO
VCNqjKcJ6dlQ13BLnCd6aKgjenNfEgNXM7fomv14ZaK9RZemcLddM3TqPiKkIhoa
1eNh9w5SX27G3snOyWa+oX3O3djAwLmhhijfv2G48qYe6N0k5Ge+e1hvH7ctlm52
Q95pqHSHq4i7byHpDyNMTwokaEK2RELFZ5gtAAGvUCpmj0FWpgtm1qXznQGBlqti
z7dCwcdROndb6s/g/+KcKk3a9UrJtafifrxnZ3Bfir6vBQyNxAo4a4BE9uu3d6eq
aOAKsOSDYHkgibkr0BsCJFzpob4l/wxgiwU9/Ds6DxXTXxxGY9PHfJeZuXMNG5eA
rslDSqQnzjxBp20ShGN5UIH8JKPBjWw1DLzJH8cNqbWlqXtors3UbViNXShGtjKg
1KdRiOcTmRcmv4HZOQjXf8ZZkuogYwP85PuVzuZnLrE/EyAT96Fsr/zA59qeRCZa
Wcg/0ieGQoEwXvhc+hQBWaC4fOduCUKYSdJtcV6PQB65YmXluh0=
=oOmf
-----END PGP SIGNATURE-----

--D5tFrmRBv7YOLFOK--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
