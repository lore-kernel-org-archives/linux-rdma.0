From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 16/16] NFS: Enable client side NFSv4.1 backchannel to use other transports
Date: Wed, 7 Oct 2015 10:13:39 -0400
Message-ID: <02E04D2D-3AA6-4A1E-A961-3908FBCDA59F@oracle.com>
References: <20151006142430.11788.42604.stgit@manet.1015granger.net> <20151006150047.11788.65885.stgit@manet.1015granger.net> <CALq1K=+vHf-kyuoUVNcxd7G73jSswCOd83skLVswQSEG5z3LXA@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALq1K=+vHf-kyuoUVNcxd7G73jSswCOd83skLVswQSEG5z3LXA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Oct 7, 2015, at 5:14 AM, Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org> wrote:
>=20
> On Tue, Oct 6, 2015 at 6:00 PM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> =
wrote:
>> Pass the correct backchannel transport class to svc_create_xprt()
>> when setting up an NFSv4.1 backchannel transport.
>>=20
>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>> fs/nfs/callback.c               |   33 +++++++++++++++++++++--------=
----
>> include/linux/sunrpc/xprt.h     |    1 +
>> net/sunrpc/xprtrdma/transport.c |    1 +
>> net/sunrpc/xprtsock.c           |    1 +
>> 4 files changed, 24 insertions(+), 12 deletions(-)
>>=20
>> diff --git a/fs/nfs/callback.c b/fs/nfs/callback.c
>> index 75f7c0a..46ed2c5 100644
>> --- a/fs/nfs/callback.c
>> +++ b/fs/nfs/callback.c
>> @@ -99,15 +99,22 @@ nfs4_callback_up(struct svc_serv *serv)
>> }
>>=20
>> #if defined(CONFIG_NFS_V4_1)
>> -static int nfs41_callback_up_net(struct svc_serv *serv, struct net =
*net)
>> +/*
>> + * Create an svc_sock for the back channel service that shares the
>> + * fore channel connection.
>> + * Returns the input port (0) and sets the svc_serv bc_xprt on succ=
ess
>> + */
>> +static int nfs41_callback_up_net(struct svc_serv *serv, struct net =
*net,
>> +                                struct rpc_xprt *xprt)
>> {
>> -       /*
>> -        * Create an svc_sock for the back channel service that shar=
es the
>> -        * fore channel connection.
>> -        * Returns the input port (0) and sets the svc_serv bc_xprt =
on success
>> -        */
>> -       return svc_create_xprt(serv, "tcp-bc", net, PF_INET, 0,
>> -                             SVC_SOCK_ANONYMOUS);
>> +       int ret =3D -EPROTONOSUPPORT;
>> +
>> +       if (xprt->bc_name)
>> +               ret =3D svc_create_xprt(serv, xprt->bc_name, net, PF=
_INET, 0,
>> +                                     SVC_SOCK_ANONYMOUS);
>> +       dprintk("NFS: svc_create_xprt(%s) returned %d\n",
>> +               xprt->bc_name, ret);
>=20
> Maybe we should convert it to more general and common pr_debug(..)
> interface [1]?
> Despite the fact that the other parts of code already use the dprintk=
 macro.

dprintk in this code is deprecated, and I used it here out
of laziness. I guess the maintainer might prefer a trace point
instead, or even no output.

In any event, converting dprintk to pr_debug() is out of scope
for this patch series.


>> +       return ret;
>> }
>>=20
>> /*
>> @@ -184,7 +191,8 @@ static inline void nfs_callback_bc_serv(u32 mino=
rversion, struct rpc_xprt *xprt,
>>                xprt->bc_serv =3D serv;
>> }
>> #else
>> -static int nfs41_callback_up_net(struct svc_serv *serv, struct net =
*net)
>> +static int nfs41_callback_up_net(struct svc_serv *serv, struct net =
*net,
>> +                                struct rpc_xprt *xprt)
>> {
>>        return 0;
>> }
>> @@ -259,7 +267,8 @@ static void nfs_callback_down_net(u32 minorversi=
on, struct svc_serv *serv, struc
>>        svc_shutdown_net(serv, net);
>> }
>>=20
>> -static int nfs_callback_up_net(int minorversion, struct svc_serv *s=
erv, struct net *net)
>> +static int nfs_callback_up_net(int minorversion, struct svc_serv *s=
erv,
>> +                              struct net *net, struct rpc_xprt *xpr=
t)
>> {
>>        struct nfs_net *nn =3D net_generic(net, nfs_net_id);
>>        int ret;
>> @@ -281,7 +290,7 @@ static int nfs_callback_up_net(int minorversion,=
 struct svc_serv *serv, struct n
>>                        break;
>>                case 1:
>>                case 2:
>> -                       ret =3D nfs41_callback_up_net(serv, net);
>> +                       ret =3D nfs41_callback_up_net(serv, net, xpr=
t);
>>                        break;
>>                default:
>>                        printk(KERN_ERR "NFS: unknown callback versio=
n: %d\n",
> It can be pr_err(..) [1].

It can be, but this patch isn=E2=80=99t changing this line, nor
is it=E2=80=99s purpose to clean up error messages.

It would be better to submit a separate patch to clean
these up, if the maintainer suggests this is something
he will accept.


>=20
>> @@ -364,7 +373,7 @@ int nfs_callback_up(u32 minorversion, struct rpc=
_xprt *xprt)
>>                goto err_create;
>>        }
>>=20
>> -       ret =3D nfs_callback_up_net(minorversion, serv, net);
>> +       ret =3D nfs_callback_up_net(minorversion, serv, net, xprt);
>>        if (ret < 0)
>>                goto err_net;
>>=20
>> diff --git a/include/linux/sunrpc/xprt.h b/include/linux/sunrpc/xprt=
=2Eh
>> index 82c0839..88bae18 100644
>> --- a/include/linux/sunrpc/xprt.h
>> +++ b/include/linux/sunrpc/xprt.h
>> @@ -170,6 +170,7 @@ struct rpc_xprt {
>>        struct sockaddr_storage addr;           /* server address */
>>        size_t                  addrlen;        /* size of server add=
ress */
>>        int                     prot;           /* IP protocol */
>> +       char                    *bc_name;       /* backchannel trans=
port */
>>=20
>>        unsigned long           cong;           /* current congestion=
 */
>>        unsigned long           cwnd;           /* congestion window =
*/
>> diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/t=
ransport.c
>> index 845278e..c60bbc8 100644
>> --- a/net/sunrpc/xprtrdma/transport.c
>> +++ b/net/sunrpc/xprtrdma/transport.c
>> @@ -337,6 +337,7 @@ xprt_setup_rdma(struct xprt_create *args)
>>        /* Ensure xprt->addr holds valid server TCP (not RDMA)
>>         * address, for any side protocols which peek at it */
>>        xprt->prot =3D IPPROTO_TCP;
>> +       xprt->bc_name =3D "rdma-bc";
>>        xprt->addrlen =3D args->addrlen;
>>        memcpy(&xprt->addr, sap, xprt->addrlen);
>>=20
>> diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
>> index 3084163..d82d00b 100644
>> --- a/net/sunrpc/xprtsock.c
>> +++ b/net/sunrpc/xprtsock.c
>> @@ -2858,6 +2858,7 @@ static struct rpc_xprt *xs_setup_tcp(struct xp=
rt_create *args)
>>        transport =3D container_of(xprt, struct sock_xprt, xprt);
>>=20
>>        xprt->prot =3D IPPROTO_TCP;
>> +       xprt->bc_name =3D "tcp-bc";
>>        xprt->tsh_size =3D sizeof(rpc_fraghdr) / sizeof(u32);
>>        xprt->max_payload =3D RPC_MAX_FRAGMENT_SIZE;
>>=20
>=20
> [1] https://lwn.net/Articles/487437/

=E2=80=94
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
