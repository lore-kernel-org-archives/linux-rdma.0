From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [oss-security] CVE Request: Linux: IB/security: Restrict use of the write() interface'
Date: Wed, 11 May 2016 20:12:32 -0400
Message-ID: <20160512001231.GB27943@phlsvsds.ph.intel.com>
References: <20160507042232.GA5286@eldamar.local> <1462823339.4268.54.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1462823339.4268.54.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: oss-security-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Red Hat Security Response Team <secalert-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ben Hutchings <benh-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, May 09, 2016 at 09:48:59PM +0200, Yann Droneaud wrote:
> Hi,
>=20
>=20
> As a workaround, I would suggest that systems which do not require
> (userspace) RDMA/Infiniband to blacklist/remove the following modules=
:
>=20
> =A0 rdma_ucm
> =A0 ib_uverbs
> =A0 ib_ucm
> =A0=A0ib_umad

NOTE: AFAICT ib_umad is not vulnerable as it uses correct write/read se=
mantics.
However, if you are disabling the other modules you probably have no us=
e for
ib_umad either.

Ira

>=20
> For example, adds the following in /etc/modprobe.d/blacklist.conf
>=20
> =A0 blacklist rdma_ucm
> =A0 blacklist ib_uverbs
> =A0 blacklist ib_ucm
> =A0 blacklist ib_umad
>=20
> Those building their own kernel might want to disable, if not already=
,
>=20
> =A0 CONFIG_INFINIBAND_USER_ACCESS,=A0
> =A0 CONFIG_INFINIBAND_USER_MAD,
> =A0 CONFIG_INFINIBAND_ADDR_TRANS
>=20
> (Unfortunately the last one will also disable those features:
> =A0 iSCSI Extensions for RDMA (iSER)
> =A0 iSCSI Extensions for RDMA (iSER) target support
> =A0 RDS over Infiniband and iWARP
> =A0 9P RDMA Transport (Experimental)
> =A0 RPC-over-RDMA transport
> =A0 =A0 (which actually disable NFSoRDMA))
>=20
> Regards.
>=20
> --=A0
> Yann Droneaud
> OPTEYA
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
