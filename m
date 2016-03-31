From: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDS: sync congestion map updating
Date: Thu, 31 Mar 2016 10:59:10 +0800
Message-ID: <56FC927E.9090404@oracle.com>
References: <1459328902-31968-1-git-send-email-wen.gang.wang@oracle.com>
 <20160330161952.GA2670@leon.nu> <56FC09D6.7090602@oracle.com>
 <56FC82B7.3070504@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56FC82B7.3070504-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: santosh shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: leon-2ukJVAZIZ/Y@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



=E5=9C=A8 2016=E5=B9=B403=E6=9C=8831=E6=97=A5 09:51, Wengang Wang =E5=86=
=99=E9=81=93:
>
>
> =E5=9C=A8 2016=E5=B9=B403=E6=9C=8831=E6=97=A5 01:16, santosh shilimka=
r =E5=86=99=E9=81=93:
>> Hi Wengang,
>>
>> On 3/30/2016 9:19 AM, Leon Romanovsky wrote:
>>> On Wed, Mar 30, 2016 at 05:08:22PM +0800, Wengang Wang wrote:
>>>> Problem is found that some among a lot of parallel RDS=20
>>>> communications hang.
>>>> In my test ten or so among 33 communications hang. The send=20
>>>> requests got
>>>> -ENOBUF error meaning the peer socket (port) is congested. But=20
>>>> meanwhile,
>>>> peer socket (port) is not congested.
>>>>
>>>> The congestion map updating can happen in two paths: one is in=20
>>>> rds_recvmsg path
>>>> and the other is when it receives packets from the hardware. There=
=20
>>>> is no
>>>> synchronization when updating the congestion map. So a bit=20
>>>> operation (clearing)
>>>> in the rds_recvmsg path can be skipped by another bit operation=20
>>>> (setting) in
>>>> hardware packet receving path.
>>>>

To be more detailed.  Here, the two paths (user calls recvmsg and=20
hardware receives data) are for different rds socks. thus the=20
rds_sock->rs_recv_lock is not helpful to sync the updating on congestio=
n=20
map.

thanks,
wengang
>>>> Fix is to add a spin lock per congestion map to sync the update on=
 it.
>>>> No performance drop found during the test for the fix.
>>>
>>> I assume that this change fixed your issue, however it looks suspic=
ious
>>> that performance wasn't change.
>>>
>> First of all thanks for finding the issue and posting patch
>> for it. I do agree with Leon on performance comment.
>> We shouldn't need locks for map updates.
>>
> Here is the performance data I collected yesterday.
> Settings:
> net.core.rmem_default =3D 4194304
> net.core.wmem_default =3D 262144
> net.core.rmem_max =3D 4194304
> net.core.wmem_max =3D 2097152
>
> test case:  rds-stress -s 192.168.111.16 -q 1m -d 10 -T 300 -t 10
> With 1M size sends, the 10 pending send request is enough to trigger=20
> the congestion on receiver side. And the test last 5 mins.
>
> result is like this:
> without patch:
> 10   2231   2355 4697759.63       0.00       0.00  473.38 19123.89=20
> -1.00  (average)
> receiver
>  10   2356   2231 4698350.06       0.00       0.00  486.28 18537.23=20
> -1.00  (average)
>
> with patch applied:
> sender
> 10   2230   2396 47x.53       0.00       0.00  475.87 31954.35 -1.00 =
=20
> (average)
> receiver
> 10   2396   2230 4738051.76       0.00       0.00  480.85 18408.13=20
> -1.00  (average)
>
> So I don't see performance drops. On a previous test, the test result=
=20
> is reverted that is it's faster when patch not applied, but the=20
> numbers is till 47xxxxx VS 46xxxxx.  So I don't have a very stable=20
> test result. But in average, no obvious performance drop.
>
> Let me try to explain from theory:
> Firstly, No matter the rds_recvmsg path or the hardware receiving dat=
a=20
> path, we have rds_sock->rs_recv_lock (this is not enough to fix our=20
> issue here since there could be many different rds_socks) locked very=
=20
> near before we lock the congestion map.  So the performance drop on=20
> CPU cache refilling is small.
> Secondly, though the problem exist,  the malformed map may be not=20
> happening that frequent especially for this test case, 10 parallel=20
> communication.
>
>> Moreover the parallel receive path on which this patch
>> is based of doesn't exist in upstream code. I have kept
>> that out so far because of similar issue like one you
>> encountered.
> But I don't see how rds_recvmsg path is different from UEK kernels.=20
> Can you explain more here or offline?
>
>>
>> Anyways lets discuss offline about the fix even for the
>> downstream kernel. I suspect we can address it without locks.
>>
> If in normal use we have no performace issue (and before we found=20
> import use case that would hit), I think locking is fine.
> Well, what ideas do you have to prevent using locks? After all we are=
=20
> updating a 8KB bitmap, not a single uint64 or less length variable. N=
o=20
> matter we use lock or not, we need to make sure the bits to update=20
> can't be cached on different CPUs.
>
> thanks,
> wengang
>
>> Reagrds,
>> Santosh
>
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
