From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 01/16] xprtrdma: Display IPv6 addresses and port numbers correctly
Date: Mon, 16 Mar 2015 09:34:44 -0700
Message-ID: <AFBFCAA1-06CF-48FE-913A-21720F8FA196@oracle.com>
References: <20150313212517.22783.18364.stgit@manet.1015granger.net> <20150313212641.22783.93522.stgit@manet.1015granger.net> <5504F37A.20803@dev.mellanox.co.il>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5504F37A.20803-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On Mar 14, 2015, at 7:50 PM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> w=
rote:

> On 3/13/2015 11:26 PM, Chuck Lever wrote:
>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>>  net/sunrpc/xprtrdma/transport.c |   47 ++++++++++++++++++++++++++++=
++++-------
>>  net/sunrpc/xprtrdma/verbs.c     |   21 +++++++----------
>>  2 files changed, 47 insertions(+), 21 deletions(-)
>>=20
>> diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/t=
ransport.c
>> index 2e192ba..26a62e7 100644
>> --- a/net/sunrpc/xprtrdma/transport.c
>> +++ b/net/sunrpc/xprtrdma/transport.c
>> @@ -157,12 +157,47 @@ static struct ctl_table sunrpc_table[] =3D {
>>  static struct rpc_xprt_ops xprt_rdma_procs;	/* forward reference */
>>=20
>>  static void
>> +xprt_rdma_format_addresses4(struct rpc_xprt *xprt, struct sockaddr =
*sap)
>> +{
>> +	struct sockaddr_in *sin =3D (struct sockaddr_in *)sap;
>> +	char buf[20];
>> +
>> +	snprintf(buf, sizeof(buf), "%08x", ntohl(sin->sin_addr.s_addr));
>> +	xprt->address_strings[RPC_DISPLAY_HEX_ADDR] =3D kstrdup(buf, GFP_K=
ERNEL);
>> +
>> +	xprt->address_strings[RPC_DISPLAY_NETID] =3D "rdma";
>> +}
>> +
>> +static void
>> +xprt_rdma_format_addresses6(struct rpc_xprt *xprt, struct sockaddr =
*sap)
>> +{
>> +	struct sockaddr_in6 *sin6 =3D (struct sockaddr_in6 *)sap;
>> +	char buf[40];
>> +
>> +	snprintf(buf, sizeof(buf), "%pi6", &sin6->sin6_addr);
>=20
> Don't you prefer %pIS can handle both IPv4/v6 instead of two differen=
t
> routines? or maybe even %pISp can be better?
>=20
>> +	xprt->address_strings[RPC_DISPLAY_HEX_ADDR] =3D kstrdup(buf, GFP_K=
ERNEL);

The string does not contain a presentation address, which is what
we=92d get from %pIS. These are non-standard hexadecimal representation=
s
of the addresses. So, need separate functions for IPv4 and IPv6.

>> +
>> +	xprt->address_strings[RPC_DISPLAY_NETID] =3D "rdma6";
>=20
> Was RPC_DISPLAY_NETID "rdma6" before this patch?

Section 12 of RFC 5666 defines NETIDs for RPC/RDMA with IPv4 and with
IPv6 addressing. I can cite that section in a comment.

Actually, I should define these in include/linux/sunrpc/msg_prot.h
with the other netids, and use the macro instead.

>=20
>> +}
>> +
>> +static void
>>  xprt_rdma_format_addresses(struct rpc_xprt *xprt)
>>  {
>>  	struct sockaddr *sap =3D (struct sockaddr *)
>>  					&rpcx_to_rdmad(xprt).addr;
>> -	struct sockaddr_in *sin =3D (struct sockaddr_in *)sap;
>> -	char buf[64];
>> +	char buf[128];
>> +
>> +	switch (sap->sa_family) {
>> +	case AF_INET:
>> +		xprt_rdma_format_addresses4(xprt, sap);
>> +		break;
>> +	case AF_INET6:
>> +		xprt_rdma_format_addresses6(xprt, sap);
>> +		break;
>> +	default:
>> +		pr_err("rpcrdma: Unrecognized address family\n");
>> +		return;
>> +	}
>>=20
>>  	(void)rpc_ntop(sap, buf, sizeof(buf));
>>  	xprt->address_strings[RPC_DISPLAY_ADDR] =3D kstrdup(buf, GFP_KERNE=
L);
>> @@ -170,16 +205,10 @@ xprt_rdma_format_addresses(struct rpc_xprt *xp=
rt)
>>  	snprintf(buf, sizeof(buf), "%u", rpc_get_port(sap));
>>  	xprt->address_strings[RPC_DISPLAY_PORT] =3D kstrdup(buf, GFP_KERNE=
L);
>>=20
>> -	xprt->address_strings[RPC_DISPLAY_PROTO] =3D "rdma";
>> -
>> -	snprintf(buf, sizeof(buf), "%08x", ntohl(sin->sin_addr.s_addr));
>> -	xprt->address_strings[RPC_DISPLAY_HEX_ADDR] =3D kstrdup(buf, GFP_K=
ERNEL);
>> -
>>  	snprintf(buf, sizeof(buf), "%4hx", rpc_get_port(sap));
>>  	xprt->address_strings[RPC_DISPLAY_HEX_PORT] =3D kstrdup(buf, GFP_K=
ERNEL);
>>=20
>> -	/* netid */
>> -	xprt->address_strings[RPC_DISPLAY_NETID] =3D "rdma";
>> +	xprt->address_strings[RPC_DISPLAY_PROTO] =3D "rdma";
>>  }
>>=20
>>  static void
>> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs=
=2Ec
>> index 124676c..1aa55b7 100644
>> --- a/net/sunrpc/xprtrdma/verbs.c
>> +++ b/net/sunrpc/xprtrdma/verbs.c
>> @@ -50,6 +50,7 @@
>>  #include <linux/interrupt.h>
>>  #include <linux/slab.h>
>>  #include <linux/prefetch.h>
>> +#include <linux/sunrpc/addr.h>
>>  #include <asm/bitops.h>
>>=20
>>  #include "xprt_rdma.h"
>> @@ -424,7 +425,7 @@ rpcrdma_conn_upcall(struct rdma_cm_id *id, struc=
t rdma_cm_event *event)
>>  	struct rpcrdma_ia *ia =3D &xprt->rx_ia;
>>  	struct rpcrdma_ep *ep =3D &xprt->rx_ep;
>>  #if IS_ENABLED(CONFIG_SUNRPC_DEBUG)
>> -	struct sockaddr_in *addr =3D (struct sockaddr_in *) &ep->rep_remot=
e_addr;
>> +	struct sockaddr *sap =3D (struct sockaddr *)&ep->rep_remote_addr;
>>  #endif
>>  	struct ib_qp_attr *attr =3D &ia->ri_qp_attr;
>>  	struct ib_qp_init_attr *iattr =3D &ia->ri_qp_init_attr;
>> @@ -480,9 +481,8 @@ connected:
>>  		wake_up_all(&ep->rep_connect_wait);
>>  		/*FALLTHROUGH*/
>>  	default:
>> -		dprintk("RPC:       %s: %pI4:%u (ep 0x%p): %s\n",
>> -			__func__, &addr->sin_addr.s_addr,
>> -			ntohs(addr->sin_port), ep,
>> +		dprintk("RPC:       %s: %pIS:%u (ep 0x%p): %s\n",
>> +			__func__, sap, rpc_get_port(sap), ep,
>>  			CONNECTION_MSG(event->event));
>>  		break;
>>  	}
>> @@ -491,19 +491,16 @@ connected:
>>  	if (connstate =3D=3D 1) {
>>  		int ird =3D attr->max_dest_rd_atomic;
>>  		int tird =3D ep->rep_remote_cma.responder_resources;
>> -		printk(KERN_INFO "rpcrdma: connection to %pI4:%u "
>> -			"on %s, memreg %d slots %d ird %d%s\n",
>> -			&addr->sin_addr.s_addr,
>> -			ntohs(addr->sin_port),
>> +
>> +		pr_info("rpcrdma: connection to %pIS:%u on %s, memreg %d slots %d=
 ird %d%s\n",
>> +			sap, rpc_get_port(sap),
>>  			ia->ri_id->device->name,
>>  			ia->ri_memreg_strategy,
>>  			xprt->rx_buf.rb_max_requests,
>>  			ird, ird < 4 && ird < tird / 2 ? " (low!)" : "");
>>  	} else if (connstate < 0) {
>> -		printk(KERN_INFO "rpcrdma: connection to %pI4:%u closed (%d)\n",
>> -			&addr->sin_addr.s_addr,
>> -			ntohs(addr->sin_port),
>> -			connstate);
>> +		pr_info("rpcrdma: connection to %pIS:%u closed (%d)\n",
>> +			sap, rpc_get_port(sap), connstate);
>>  	}
>>  #endif
>>=20
>>=20
>=20
> Other than the minors above, Looks good.
>=20
> Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
