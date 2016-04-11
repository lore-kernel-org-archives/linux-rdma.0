From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH] drivers/infiniband/hw/nes/nes_verbs.c: Deinline
 nes_free_qp_mem, save 1072 bytes
Date: Mon, 11 Apr 2016 07:41:48 +0300
Message-ID: <20160411044148.GE20252@leon.nu>
References: <1460141926-13069-1-git-send-email-dvlasenk@redhat.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dFWYt1i2NyOo1oI9"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1460141926-13069-1-git-send-email-dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--dFWYt1i2NyOo1oI9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 08, 2016 at 08:58:42PM +0200, Denys Vlasenko wrote:
> This function compiles to 550 bytes of machine code.
> Three callsites, all in nes_create_qp.

I agree with you, the functions which calls below and after this
function are not optimized for speed and there is no need to inline
this function.

I have two requests from you.
1)
Can you please change title to be more convenient?
[PATCH] drivers/infiniband/hw/nes/nes_verbs.c: Deinline nes_free_qp_mem, save 1072 bytes
--->
[PATCH] IB/nes: Deinline nes_free_qp_mem

2) Add bloat-o-meter output to the commit message.

And after that feel free to add my RB tag.

Reviewed-By: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--dFWYt1i2NyOo1oI9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXCysMAAoJEORje4g2clinOPUP+wcPBBVRVy3qDhpIEiM/Hrwc
Q5tOOMkDwkthb0hfp+POcDX6v8bnjJWhCKSvAbaHWt9zwQxknm4hKxnpgqVqV08z
bOun2au+QmAAute9pd2VeK8Qj+EXQkIPvOURnASj5Ag0q6rnjazbSZwDWNOgg/L5
Rh/3djhBuYPS3uYFDHbiyO0/RmAHAaABtrOj9QB6h2E6XGZEDcn6Vjf0FbLPjWAE
cGBaXUYOdq3qbXdgoQUkk35vyF0eLxouhYief1XZoqP4MHmU36ITxaEELaWNgx6y
zwNBSC9/8QYPjV8hiNxomthzRrHdzmR3H0hUPaNQAJvbhti3xccewY7Rz21+Fumu
LyDOdUFEH0O5c5C7GPzysz7EVxsmZDOm7h9UdDkvjgQTp6dYkJhlsD6Y6l/v0/16
7pLM51G9ynMYQTP9CVmVdRcKyCdo3XPDDnDv8hFYW6l2EtfW33TcYOSpcIihOtwf
kgJrPqMppbUM17p/A5Yeu/n0tZGskctnvKg3EnLe7fKMtcVLbODngdlHl+s1M025
xwdgUHgvtgV16woZEa9bc7XcRYlRYXTl51kkkHXibYibZOPbf7L/66zrRo0zcUev
xXneJpH8uHwFt5vnZvOTbJUmhLnLla9u7psALKQTzh8yIkzG1F5w489FSnZJ8kgm
rGJIlrkju3XLX5zZRwmc
=ZhDh
-----END PGP SIGNATURE-----

--dFWYt1i2NyOo1oI9--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
