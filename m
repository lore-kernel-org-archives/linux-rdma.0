From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 02/10] xprtrdma: Cap req_cqinit
Date: Sun, 9 Nov 2014 16:43:44 -0500
Message-ID: <9C2B7BB4-B378-4225-BBD1-2B0F58D70342@oracle.com>
References: <20141109010328.8806.5861.stgit@manet.1015granger.net> <20141109011420.8806.1849.stgit@manet.1015granger.net> <545F3E46.9040703@dev.mellanox.co.il>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <545F3E46.9040703-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Nov 9, 2014, at 5:13 AM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wr=
ote:

> On 11/9/2014 3:14 AM, Chuck Lever wrote:
>> Recent work made FRMR registration and invalidation completions
>> unsignaled. This greatly reduces the adapter interrupt rate.
>>=20
>> Every so often, however, a posted send Work Request is allowed to
>> signal. Otherwise, the provider's Work Queue will wrap and the
>> workload will hang.
>>=20
>> The number of Work Requests that are allowed to remain unsignaled is
>> determined by the value of req_cqinit. Currently, this is set to the
>> size of the send Work Queue divided by two, minus 1.
>>=20
>> For FRMR, the send Work Queue is the maximum number of concurrent
>> RPCs (currently 32) times the maximum number of Work Requests an
>> RPC might use (currently 7, though some adapters may need more).
>>=20
>> For mlx4, this is 224 entries. This leaves completion signaling
>> disabled for 111 send Work Requests.
>>=20
>> Some providers hold back dispatching Work Requests until a CQE is
>> generated.  If completions are disabled, then no CQEs are generated
>> for quite some time, and that can stall the Work Queue.
>>=20
>> I've seen this occur running xfstests generic/113 over NFSv4, where
>> eventually, posting a FAST_REG_MR Work Request fails with -ENOMEM
>> because the Work Queue has overflowed. The connection is dropped
>> and re-established.
>=20
> Hey Chuck,
>=20
> As you know, I've seen this issue too...
> Looking into this is definitely on my todo list.
>=20
> Does this happen if you run a simple dd (single request-response infl=
ight)?

Hi Sagi-

I typically run dbench, iozone, and xfstests when preparing patches for
upstream. The generic/113 test I mention in the patch description is th=
e
only test where I saw this issue. I expect single-thread won=92t drive
enough Work Queue activity to push the provider into WQ overflow.

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
