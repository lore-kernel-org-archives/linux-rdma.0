From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 2/6] IB/uverbs: Enable QP creation which is
 associated to underlay QP
Date: Wed, 31 May 2017 07:20:31 +0300
Message-ID: <20170531042031.GG5406@mtr-leonro.local>
References: <20170530071602.8139-1-leon@kernel.org>
 <20170530071602.8139-3-leon@kernel.org>
 <20170530073352.GA1838@nanopsycho>
 <20170530075845.GA5406@mtr-leonro.local>
 <20170530081514.GB1838@nanopsycho>
 <20170530172259.GD5406@mtr-leonro.local>
 <20170530180357.GB24898@nanopsycho>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="w2JjAQZceEVGylhD"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170530180357.GB24898@nanopsycho>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Pirko <jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--w2JjAQZceEVGylhD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 30, 2017 at 08:03:58PM +0200, Jiri Pirko wrote:
> Tue, May 30, 2017 at 07:22:59PM CEST, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org wrote:
> >On Tue, May 30, 2017 at 10:15:14AM +0200, Jiri Pirko wrote:
> >> Tue, May 30, 2017 at 09:58:45AM CEST, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org wrote:
> >> >On Tue, May 30, 2017 at 09:33:52AM +0200, Jiri Pirko wrote:
> >> >> Tue, May 30, 2017 at 09:15:58AM CEST, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org wrote:
> >> >> >From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >> >> >
> >> >> >Enable QP creation which is associated to underlay QP. This comes as a
> >> >> >pre-patch for downstream patches in this series to enable flow steering
> >> >> >from user space application on the underlay IPoIB QP.
> >> >> >
> >> >> >Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >> >> >Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
> >> >> >Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> >> >> >---
> >> >>
> >> >> [...]
> >> >>
> >> >>
> >> >> >diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
> >> >> >index 477d629f539d..422b20456975 100644
> >> >> >--- a/include/uapi/rdma/ib_user_verbs.h
> >> >> >+++ b/include/uapi/rdma/ib_user_verbs.h
> >> >> >@@ -578,7 +578,7 @@ struct ib_uverbs_ex_create_qp {
> >> >> > 	__u32 comp_mask;
> >> >> > 	__u32 create_flags;
> >> >> > 	__u32 rwq_ind_tbl_handle;
> >> >> >-	__u32  reserved1;
> >> >> >+	__u32  associated_qpn;
> >> >>
> >> >> This breaks uapi...
> >> >
> >> >Not really, we are using comp_mask scheme to signal changes/predecessor
> >> >of these structs. Users of this file and structs check comp_mask and
> >> >access new fields only if they are exposed there.
> >> >
> >> >In this case, there are no users of reserved1 and hence it can be
> >> >replace to the new field with corresponding comp_mask flag (IB_QP_CREATE_ASSOC_QPN)
> >> >without worry of breakage.
> >>
> >> I, as an app could include ib_user_verbs.h and do:
> >>
> >> struct ib_uverbs_ex_create_qp something;
> >>
> >> something.reserved1 = 0;
> >>
> >> Than I won't compile, would I?
> >
> >You are right, the good thing that in IB world, there is no direct usage
> >of these files and they are needed for rdma-core (libibverbs) library.
>
> Unfortunatelly, that does not make any difference. UAPI is UAPI...

Yes, it makes. Changes in UAPI are allowed as long they don't break user
space applications. In this case, there are no applications which uses
this reserved fields directly.

Just as an examples of UAPI changes which can break user-space
applications, but don't:

commit 26202873bb51fafdaa51be3e8de7aab9beb49f70
Author: Hans-Christian Noren Egtvedt <egtvedt-BrfabpQBY5qlHtIdYg32fQ@public.gmane.org>
Date:   Sun Feb 26 12:56:39 2017 +0100

    avr32: remove support for AVR32 architecture

commit 1f4407e2548827e3e6e7b943640a2da90c611306
Author: David S. Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Date:   Fri Apr 21 15:59:52 2017 -0400

    net: Remove NET_CORE_BUDGET_USECS from sysctl binary interface.

commit 2611dc1939569718c65ffd59c8fb9ba7474d026c
Author: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Date:   Sat Apr 8 14:34:51 2017 -0400

    Remove compat_sys_getdents64()

commit bf74b20d00b13919db7ae5d1015636e76f56f6ae
Author: David S. Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Date:   Sun Apr 9 14:45:21 2017 -0700

    Revert "rtnl: Add support for netdev event to link messages"

.....

>
>

--w2JjAQZceEVGylhD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkuRI8ACgkQ5GN7iDZy
WKf1mhAAi4RCg5VBtPSu584YioCIQp2yNPZyKbM+h3+Lvn9RwcEf795QH+JswJlj
PCAYwdn3118RloyawMcYKzvuGwc0JG988q9xsaCrFteZqOsaWCIm/481heNteRvS
b5W53e/nmVNqsfltBuJP542nBZnFFbTgwWO6XPNVN+wetw3+S6Ti00l4Xf4Q4mzu
SOyJMx1WqX/mhjW7zC6r2ZiUQOap+s6VtrC3IZPU/Ij1NaEQv3yJeI206rQAvtrT
XzdXQ78+/CalxUqvcnp6Hgv9dij+bcucJkLPSsFIFMZF5v/idAy0u+f8pxcFCJik
jUITpAacmtmZGUTyNpvmDa02OxxjZQKyDm2tIP11XZX7f3D70ErvOcjBypATrcvT
58iegYQ+r1joa2NcUPdDW3BtiygKRvA4oledOTO9hROGc57PC0sSQZNV3yj87SkY
TEEkt+MHLEVythZWKgCg5JlomRgPraq9VSNQEpTtielsEIMbpJFq121uUVI7IrIa
81tIIqjoXu1yWIrM4mRTcSU+L5b1PlFCgBpd4thIwTD/Moo2UnzuyARloLDTF+he
dLN6oMMcjL7ekHsj1lCiIuT9t4scb1py848kXzW6kSe5dxnzTLRZZPdulHVKSX3m
8+iEHMxy0tVVRNsBDrJ1wklcImT8QEl/uO1deuLTv5j2c89k0lM=
=xGwR
-----END PGP SIGNATURE-----

--w2JjAQZceEVGylhD--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
