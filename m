From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: "memory management error" with NFS/RDMA on RoCE
Date: Tue, 27 Jun 2017 19:08:52 +0300
Message-ID: <a82056d7-5685-5b85-8226-c54065e729fe@grimberg.me>
References: <7F0FCF80-DB7B-46F1-BB9A-0B070603DE61@oracle.com>
 <797a43c4-f30d-9deb-a332-c62cbd01be7b@grimberg.me>
 <2FEEE227-9BCF-4454-A056-3997C1E54686@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2FEEE227-9BCF-4454-A056-3997C1E54686-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> Hi Sagi-
> 
>> On Jun 27, 2017, at 5:28 AM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
>>
>>
>>> While running xfstests on an NFS/RDMA mount, I see this in
>>> the client's /var/log/messages multiple times:
>>> Jun 22 14:13:45 manet kernel: mlx5_0:dump_cqe:275:(pid 0): dump error cqe
>>> Jun 22 14:13:45 manet kernel: 00000000 00000000 00000000 00000000
>>> Jun 22 14:13:45 manet kernel: 00000000 00000000 00000000 00000000
>>> Jun 22 14:13:45 manet kernel: 00000000 00000000 00000000 00000000
>>> Jun 22 14:13:45 manet kernel: 00000000 08007806 250000cd 024027d3
>>> Jun 22 14:13:45 manet kernel: rpcrdma: fastreg: memory management operation error (6/0x78)
>>> As far as I can tell the client is able to recover and continue
>>> the test. However, this error is not supposed to happen in normal
>>> operation.
>>> This is with a Mellanox CX4 in RoCEv1 mode, v4.12-rc2.
>>
>> Is this a regression?
> 
> I can't answer that question with authority, because I just
> started trying out NFS/RDMA on RoCE with mlx5. But Robert has
> reported very similar symptoms with iSER on v4.9. It appears
> to have been around for a while, if these are the same.

Is Robert running 4.9 on the initiator side?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
