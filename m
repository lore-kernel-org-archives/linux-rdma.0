From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 00/15] NFS/RDMA patches proposed for 4.1
Date: Fri, 27 Mar 2015 09:17:47 -0500
Message-ID: <AFCD874E-D85C-4788-A409-17906D841C5B@oracle.com>
References: <20150324201849.2311.53599.stgit@manet.1015granger.net> <55145274.203@Netapp.com> <EE7902D3F51F404C82415C4803930ACD5DC3B914@CMEXMB1.ad.emulex.com> <c541888a-6b49-4b9f-98ba-a1d77df1d071@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c541888a-6b49-4b9f-98ba-a1d77df1d071-3RiH6ntJJkOPfaB/Gd0HpljyZtpTMMwT@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Cc: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Meghana Cheripady <Meghana.Cheripady-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Mar 27, 2015, at 12:44 AM, Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org> =
wrote:

>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Devesh Sharma
>> Sent: Friday, March 27, 2015 11:13 AM
>> To: Anna Schumaker; Chuck Lever; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-
>> nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Subject: RE: [PATCH v2 00/15] NFS/RDMA patches proposed for 4.1
>>=20
>> Hi Chuck,
>>=20
>> I have validated these set of patches with ocrdma device, iozone pas=
ses with
>> these.
>=20
>=20
> Thanks to Meghna.

Hi Devesh-

Is there a Tested-by tag that Anna can add to these patches?


>>=20
>> -Regards
>> Devesh
>>=20
>>> -----Original Message-----
>>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
>>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Anna Schumaker
>>> Sent: Friday, March 27, 2015 12:10 AM
>>> To: Chuck Lever; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-nfs-u79uwXL29TasMV2rI37PzA@public.gmane.org=
org
>>> Subject: Re: [PATCH v2 00/15] NFS/RDMA patches proposed for 4.1
>>>=20
>>> Hey Chuck,
>>>=20
>>> I didn't see anything that needs to be fixed up in these patches.  =
Are
>>> they ready for me?
>>>=20
>>> Anna
>>>=20
>>> On 03/24/2015 04:30 PM, Chuck Lever wrote:
>>>> This is a series of client-side patches for NFS/RDMA. In preparati=
on
>>>> for increasing the transport credit limit and maximum rsize/wsize,
>>>> I've re-factored the memory registration logic into separate files=
,
>>>> invoked via a method API.
>>>>=20
>>>> The two main optimizations in v1 of this series have been dropped.
>>>> Sagi Grimberg didn't like the complexity of the solution, and ther=
e
>>>> isn't enough time to rework it, test the new version, and get it
>>>> reviewed before the 4.1 merge window opens. I'm going to prepare
>>>> these for 4.2.
>>>>=20
>>>> Fixes suggested by reviewers have been included before the
>>>> refactoring patches to make it easier to backport them to previous=
 kernels.
>>>>=20
>>>> The series is available in the nfs-rdma-for-4.1 topic branch at
>>>>=20
>>>> git://linux-nfs.org/projects/cel/cel-2.6.git
>>>>=20
>>>> Changes since v1:
>>>> - Rebased on 4.0-rc5
>>>> - Main optimizations postponed to 4.2
>>>> - Addressed review comments from Anna, Sagi, and Devesh
>>>>=20
>>>> ---
>>>>=20
>>>> Chuck Lever (15):
>>>>      SUNRPC: Introduce missing well-known netids
>>>>      xprtrdma: Display IPv6 addresses and port numbers correctly
>>>>      xprtrdma: Perform a full marshal on retransmit
>>>>      xprtrdma: Byte-align FRWR registration
>>>>      xprtrdma: Prevent infinite loop in rpcrdma_ep_create()
>>>>      xprtrdma: Add vector of ops for each memory registration stra=
tegy
>>>>      xprtrdma: Add a "max_payload" op for each memreg mode
>>>>      xprtrdma: Add a "register_external" op for each memreg mode
>>>>      xprtrdma: Add a "deregister_external" op for each memreg mode
>>>>      xprtrdma: Add "init MRs" memreg op
>>>>      xprtrdma: Add "reset MRs" memreg op
>>>>      xprtrdma: Add "destroy MRs" memreg op
>>>>      xprtrdma: Add "open" memreg op
>>>>      xprtrdma: Handle non-SEND completions via a callout
>>>>      xprtrdma: Make rpcrdma_{un}map_one() into inline functions
>>>>=20
>>>>=20
>>>> include/linux/sunrpc/msg_prot.h    |    8
>>>> net/sunrpc/xprtrdma/Makefile       |    3
>>>> net/sunrpc/xprtrdma/fmr_ops.c      |  208 +++++++++++
>>>> net/sunrpc/xprtrdma/frwr_ops.c     |  353 ++++++++++++++++++
>>>> net/sunrpc/xprtrdma/physical_ops.c |   94 +++++
>>>> net/sunrpc/xprtrdma/rpc_rdma.c     |   87 ++--
>>>> net/sunrpc/xprtrdma/transport.c    |   61 ++-
>>>> net/sunrpc/xprtrdma/verbs.c        |  699 +++---------------------=
------------
>>>> net/sunrpc/xprtrdma/xprt_rdma.h    |   90 ++++-
>>>> 9 files changed, 882 insertions(+), 721 deletions(-)  create mode
>>>> 100644 net/sunrpc/xprtrdma/fmr_ops.c  create mode 100644
>>>> net/sunrpc/xprtrdma/frwr_ops.c  create mode 100644
>>>> net/sunrpc/xprtrdma/physical_ops.c
>>>>=20
>>>> --
>>>> Chuck Lever
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-nf=
s"
>>>> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordo=
mo
>>>> info at  http://vger.kernel.org/majordomo-info.html
>>>>=20
>>>=20
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rdm=
a"
>>> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordom=
o
>>> info at http://vger.kernel.org/majordomo-info.html
>> =13  =EC=B9=BB=1C & ~ & =18  +-  =DD=B6=17  w  =CB=9B   m b  kvf   ^=
n r   z =1A  h    &  =1E G   h =03( =E9=9A=8E =DD=A2j"  =1A =1Bm     z
>> =DE=96   f   h   ~ m

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
