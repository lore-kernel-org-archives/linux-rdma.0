From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 03/13] Attach/detach SoftiWarp to/from network and
 RDMA subsystem
Date: Mon, 25 Dec 2017 12:12:24 +0200
Message-ID: <20171225101224.GB2942@mtr-leonro.local>
References: <20171014064132.GT2106@mtr-leonro.local>
 <20171008130342.GV25829@mtr-leonro.local>
 <20171006122853.16310-1-bmt@zurich.ibm.com>
 <20171006122853.16310-4-bmt@zurich.ibm.com>
 <OF406E95F8.33CF80BB-ON002581B9.00073D6F-002581B9.00081F69@notes.na.collabserv.com>
 <OF663C0801.8471532E-ON002581FE.003B73D6-002581FE.003F2369@notes.na.collabserv.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="kPvmKZRaHW6UEX9w"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <OF663C0801.8471532E-ON002581FE.003B73D6-002581FE.003F2369-8eTO7WVQ4XIsd+ienQ86orlN3bxYEBpz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--kPvmKZRaHW6UEX9w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 22, 2017 at 11:29:38AM +0000, Bernard Metzler wrote:
>
> -----Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote: -----
>
> >To: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
> >From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> >Date: 10/14/2017 08:41AM
> >Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >Subject: Re: [PATCH v2 03/13] Attach/detach SoftiWarp to/from network
> >and RDMA subsystem
> >
> >On Sat, Oct 14, 2017 at 01:28:43AM +0000, Bernard Metzler wrote:
> >> -----Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote: -----
> >>
> >> >> +
> >> >> +#define SIW_MAX_IF 12
> >> >> +static int if_cnt;
> >> >> +static char *iface_list[SIW_MAX_IF] = {[0 ... (SIW_MAX_IF-1)] =
> >> >'\0'};
> >> >> +module_param_array(iface_list, charp, &if_cnt, 0444);
> >> >> +MODULE_PARM_DESC(iface_list, "Interface list siw attaches to if
> >> >present");
> >> >> +
> >> >> +static bool loopback_enabled = 1;
> >> >> +module_param(loopback_enabled, bool, 0644);
> >> >> +MODULE_PARM_DESC(loopback_enabled, "enable_loopback");
> >> >> +
> >> >> +LIST_HEAD(siw_devlist);
> >> >> +
> >> >> +static int cpu_cnt;
> >> >> +static char *tx_cpu_list[MAX_CPU] = {[0 ... (MAX_CPU-1)] =
> >'\0'};
> >> >> +module_param_array(tx_cpu_list, charp, &cpu_cnt, 0444);
> >> >> +MODULE_PARM_DESC(tx_cpu_list, "List of CPUs siw TX thread shall
> >be
> >> >bound to");
> >> >
> >> >No module parameters please.
> >> OK. Would you have a pointer which sheds some light on that
> >> rule? Thank you!
> >>
> >
> >It is not rule, but common knowledge exactly as BUG_ON which is not
> >prohibited, but makes no sense in low level driver code.
> >
> >The module parameters sometimes make sense, for example in subsystem
> >level where they can apply to whole devices underneath.
> >
> >But most of the time, they indicate complete ignorance of users in
> >favor
> >of easy developer's life.
> >
> >For people, like me, who doesn't run modules at all, the change in
> >module parameters require rebuild of initramfs and in more extreme
> >cases rebuild of SELinux labels.
> >
>
> I will try to finish up a new patch set for siw over
> Christmas holidays.
>
> One question I have - what is the recommended way of replacing
> those module parameters, if we need to flexibly parameterize
> things from user land? For the rxe driver, I see the usage of
> module_param_cb, but this probably is not what we want in the
> long run? Would a sysctl be appropriate, or a char device
> (we may need to pass strings like interface names), or configfs?

It looks like "ip" tool can be good fit, or teach ib/core to accept
parameters from rdmatool before actual device exists.

Thanks

>
> Thanks very much!
> Bernard.
>

--kPvmKZRaHW6UEX9w
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpAzwgACgkQ5GN7iDZy
WKf6sQ//WRnGHDtkUAPMkkRNmR/6X7luEQGRnR2BK5tbvf+1crtMyJnNhH5oPdRn
JcZgbo87wzS4K9AW+zZM8ml0BEftDAtlQcuO0VzJxs4sFm1/CN3nqCxEFN4oOJHl
CX1H1BW4IpL5wns3ZxIyBjdqMIrLlAWrWVHahryw3B/jh5Hm0+H4iig53XC0lL+G
HrGk4Q0iZtLaIRWYFTK9CK7Y8wIUEmWKOYLQmPiOW8/lJhJOSS0WmtQgdyo+k/VP
DhiTNB8xRODybXdibqlmZbUTmXHGGNRYS3oQIcvOrmGPfT/sByZLSk85ChBpxB5i
0ETxnZ7SAZ9KXcWvNP4SKIuYXpeoJdibNO3EYBYSzpMA4ng4E23bcOkYmr/Pjj67
ytxiA4EJBfRgP6IQgz7n9roV7TAlw74BYyxi9Qc63NiIYt0+a2vhQJlD1vQwrdfQ
URcbRRNrUFcer376MTel+RSx6UkYF4GydOxNXoouYEuH1zi/C2c7r8d4zj/3YcYk
jkX8Ci3ZIF8EDexAkYeCSu0g1oIty0Qvj2Kq5qvQDUC2STOvb3SbScyRelL6yvTI
u/OBtbIfz4irHcVgov6IcRQZ+Vg5RR3Z7OSITWXhsILFriOMnc0usW0QLQrk2jEs
r2mC6j7dwKA51ioECrHxehpZAxcxvZaUh12zliEcVXBAt8djYvM=
=PDSi
-----END PGP SIGNATURE-----

--kPvmKZRaHW6UEX9w--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
