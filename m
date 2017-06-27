From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: "memory management error" with NFS/RDMA on RoCE
Date: Tue, 27 Jun 2017 11:03:49 -0600
Message-ID: <CAANLjFqLJBXcgUDkB=Giertw8UrHuM342jMPK9ppkd3W6wjJ-Q@mail.gmail.com>
References: <7F0FCF80-DB7B-46F1-BB9A-0B070603DE61@oracle.com>
 <797a43c4-f30d-9deb-a332-c62cbd01be7b@grimberg.me> <2FEEE227-9BCF-4454-A056-3997C1E54686@oracle.com>
 <a82056d7-5685-5b85-8226-c54065e729fe@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a82056d7-5685-5b85-8226-c54065e729fe-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 27, 2017 at 10:08 AM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
>> Hi Sagi-
>>
>>> On Jun 27, 2017, at 5:28 AM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
>>>
>>>
>>>> While running xfstests on an NFS/RDMA mount, I see this in
>>>> the client's /var/log/messages multiple times:
>>>> Jun 22 14:13:45 manet kernel: mlx5_0:dump_cqe:275:(pid 0): dump error
>>>> cqe
>>>> Jun 22 14:13:45 manet kernel: 00000000 00000000 00000000 00000000
>>>> Jun 22 14:13:45 manet kernel: 00000000 00000000 00000000 00000000
>>>> Jun 22 14:13:45 manet kernel: 00000000 00000000 00000000 00000000
>>>> Jun 22 14:13:45 manet kernel: 00000000 08007806 250000cd 024027d3
>>>> Jun 22 14:13:45 manet kernel: rpcrdma: fastreg: memory management
>>>> operation error (6/0x78)
>>>> As far as I can tell the client is able to recover and continue
>>>> the test. However, this error is not supposed to happen in normal
>>>> operation.
>>>> This is with a Mellanox CX4 in RoCEv1 mode, v4.12-rc2.
>>>
>>>
>>> Is this a regression?
>>
>>
>> I can't answer that question with authority, because I just
>> started trying out NFS/RDMA on RoCE with mlx5. But Robert has
>> reported very similar symptoms with iSER on v4.9. It appears
>> to have been around for a while, if these are the same.
>
>
> Is Robert running 4.9 on the initiator side?

Yes, this was 4.9 on the initiator side.
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
