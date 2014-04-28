From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V1] NFS-RDMA: fix qp pointer validation checks
Date: Mon, 28 Apr 2014 11:58:28 +0300
Message-ID: <535E1834.8080601@dev.mellanox.co.il>
References: <014738b6-698e-4ea1-82f9-287378bfec19@CMEXHTCAS2.ad.emulex.com> <E66D006A-0D04-4602-8BF5-6834CACD2E24@oracle.com> <EE7902D3F51F404C82415C4803930ACD3FDEB3B4@CMEXMB1.ad.emulex.com> <BD7B05C0-4733-4DD1-83F3-B30B6B0EE48C@oracle.com> <EE7902D3F51F404C82415C4803930ACD3FDEB3DF@CMEXMB1.ad.emulex.com> <56C87770-7940-4006-948C-FEF3C0EC4ACC@oracle.com> <EE7902D3F51F404C82415C4803930ACD3FDEBD66@CMEXMB1.ad.emulex.com> <5710A71F-C4D5-408B-9B41-07F21B5853F0@oracle.com> <6837A427-B677-4CC7-A022-4FB9E52A3FC6@oracle.com> <EE7902D3F51F404C82415C4803930ACD3FDED915@CMEXMB1.ad.emulex.com> <C689AB91-46F6-4E96-A673-0DE76FE54CC4@oracle.com> <EE7902D3F51F404C82415C4803930ACD3FDEE11F@CMEXMB1.ad.emulex.com> <1bab6615-60c4-4865-a6a0-c53bb1c32341@CMEXHTCAS1.ad.emulex.com> <5358B975.4020207@dev.mellanox.co.i
 l> <B39C0B38-357F-4BDA-BDA7-048BD38853F7@oracle.com> <535CD819.3050508@dev! .mellanox.co.il> <4ACED3B0-CC8B-4F1F-8DB6-6C272AB17C99@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4ACED3B0-CC8B-4F1F-8DB6-6C272AB17C99-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/27/2014 3:37 PM, Chuck Lever wrote:

<SNIP>

>> Why not first create a new id+qp and assign them - and then destroy =
the old id+qp?
>> see SRP related section: ib_srp.x:srp_create_target_ib()
>>
>> Anyway it is indeed important to guarantee that no xmit flows happen=
s concurrently to that,
>> and cleanups are processed synchronously and in-order.
> I posted a patch on Friday that should provide that serialization.
>
>>> 2.  If a QP is present but disconnected, posting LOCAL_INV won=92t =
work.
>>>      That leaves buffers (and page cache pages, potentially) regist=
ered.
>>>      That could be addressed with LINV+FRMR. But...
>>>
>>> 3.  The client should not leave page cache pages registered indefin=
itely.
>>>      Both LINV+FRMR and our current approach depends on having a wo=
rking
>>>      QP _at_ _some_ _point_ =85 but the client simply can=92t depen=
d on that.
>>>      What happens if an NFS server is, say, destroyed by fire while=
 there
>>>      are active client mount points? What if the HCA=92s firmware i=
s
>>>      permanently not allowing QP creation?
>> Again, I don't understand why you can't dereg_mr().
>>
>> How about allocating the FRMR pool *after* the QP was successfully c=
reated/connected (makes sense as the FRMRs are
>> not usable until then), and destroy/cleanup the pool before the QP i=
s disconnected/destroyed. it also makes sense as they
>> must match PDs.
> It=92s not about deregistration, but rather about invalidation, I was
> confused.

OK got it.

> xprt_rdma_free() invalidates and then frees the chunks on RPC chunk
> lists. We just need to see that those invalidations can be successful
> while the transport is disconnected.

They can't be completed though. Can't you just skip invalidation? will=20
be done when FRMR is reused.
Sorry to be difficult, but I still don't understand why invalidation=20
must occur in this case.

> I understand that even in the error state, a QP should allow consumer=
s
> to post send WRs to invalidate FRMRs=85?

Its allowed, they won't execute though (I'll be surprised if they will)=
=2E
AFAIK posting on a QP in error state has only one use-case - post a=20
colored WQE to know that FLUSH errors has ended.

>
> The other case is whether the consumer can _replace_ a QP with a fres=
h
> one, and still have invalidations succeed, even if the transport rema=
ins
> disconnected, once waiting RPCs are awoken.

Which invalidations succeeded and which didn't are known - so I don't=20
see the problem here.
The only thing is the corner case that Steve indicated wrt flush errors=
,=20
but if I recall correctly
posting LINV on an invalidated MR is allowed.

>
> An alternative would be to invalidate all waiting RPC chunk lists on =
a
> transport as soon as the QP goes to error state but before it is
> destroyed, and fastreg the chunks again when waiting RPCs are
> remarshalled.
>
> I think the goals are:
>
>    1.  Avoid fastreg on an FRMR that is already valid
>
>    2.  Avoid leaving FRMRs valid indefinitely (preferably just long e=
nough
>        to execute the RPC request, and no longer)

(1) is a non-issue for INV+FASTREG.
Can you please explain your concern on (2)? is it security (server can=20
keep doing RDMA)?
because you have remote invalidate for that (server can implement=20
SEND+INVALIDATE).

Having said that, I probably don't see the full picture here like you=20
guys so I might be missing some things.

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
