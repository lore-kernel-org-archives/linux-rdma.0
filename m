From: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: Re: [PATCH v1 02/14] xprtrdma: Warn when there are orphaned IB objects
Date: Wed, 6 May 2015 19:52:03 +0530
Message-ID: <CANjDDBg3Ey0DEM3n9PY9VLW+chF0=AJPghYOopo1a9vL3CKzKg@mail.gmail.com>
References: <20150504174626.3483.97639.stgit@manet.1015granger.net>
	<20150504175700.3483.57728.stgit@manet.1015granger.net>
	<CANjDDBicLDb7K=RZB5Gqv+oACaAG8DANJX3ML971jnXd_5KEuQ@mail.gmail.com>
	<963F9850-38D0-4434-88E8-14BC42F74499@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <963F9850-38D0-4434-88E8-14BC42F74499-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 6, 2015 at 6:54 PM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wr=
ote:
> Hi Devesh-
>
> On May 6, 2015, at 7:37 AM, Devesh Sharma <devesh.sharma-1wcpHE2jlwOV7V7JEmyr7g@public.gmane.org=
m> wrote:
>
>> On Mon, May 4, 2015 at 11:27 PM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org=
> wrote:
>>>
>>> Print an error during transport destruction if ib_dealloc_pd()
>>> fails. This is a sign that xprtrdma orphaned one or more RDMA API
>>> objects at some point, which can pin lower layer kernel modules
>>> and cause shutdown to hang.
>>>
>>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>> ---
>>> net/sunrpc/xprtrdma/verbs.c |    4 ++--
>>> 1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verb=
s.c
>>> index 4870d27..0cc4617 100644
>>> --- a/net/sunrpc/xprtrdma/verbs.c
>>> +++ b/net/sunrpc/xprtrdma/verbs.c
>>> @@ -710,8 +710,8 @@ rpcrdma_ia_close(struct rpcrdma_ia *ia)
>>>        }
>>>        if (ia->ri_pd !=3D NULL && !IS_ERR(ia->ri_pd)) {
>>>                rc =3D ib_dealloc_pd(ia->ri_pd);
>>> -               dprintk("RPC:       %s: ib_dealloc_pd returned %i\n=
",
>>> -                       __func__, rc);
>>
>> Should we check for EBUSY explicitly? other then this is an error in
>> vendor specific ib_dealloc_pd()
>
> Any error return means ib_dealloc_pd() has failed, right? Doesn=E2=80=
=99t that
> mean the PD is still allocated, and could cause problems later?

Yes, you are correct, I was thinking ib_dealloc_pd() has a refcount
implemented in the core layer, thus if the PD is used by any resource,
it will always fail with -EBUSY.
=2EWith emulex adapter it is possible to fail dealloc_pd with ENOMEM or
EIO in cases where device f/w is not responding etc. this situation do
not represent PD is actually in use.

>
>
>>> +               if (rc)
>>> +                       pr_warn("rpcrdma: ib_dealloc_pd status %i\n=
", rc);
>>>        }
>>> }
>
> --
> Chuck Lever
> chuck[dot]lever[at]oracle[dot]com
>
>
>



--=20
-Regards
Devesh
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
