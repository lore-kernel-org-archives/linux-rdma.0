From: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 00/13] NFS/RDMA patches for 3.17
Date: Fri, 27 Jun 2014 09:17:47 -0700
Message-ID: <53AD992B.8010009@oracle.com>
References: <20140623223201.1634.83888.stgit@manet.1015granger.net> <007f01cf90c7$802c9210$8085b630$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <007f01cf90c7$802c9210$8085b630$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Passed cthon4, iozone test interoperability test between Linux client and Solaris server, no regressions.

Shirley

On 06/25/2014 03:47 PM, Steve Wise wrote:
> Hey Chuck, 
> 
> I did some testing on this series.  Just 2 nodes, both nfs3 and nfs4 over cxgb4 and mlx4:
> 
> cthon b/g/s 10 iterations
> iozone -a with direct IO and data validation
> fio write and rand-rw testing of large IO/files and 8 threads.
> xfs test suite.
> 
> No regressions seen.
> 
> Tested-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> 
> 
>> -----Original Message-----
>> From: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf
>> Of Chuck Lever
>> Sent: Monday, June 23, 2014 5:39 PM
>> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Subject: [PATCH v1 00/13] NFS/RDMA patches for 3.17
>>
>> The main purpose of this series is to address more connection drop
>> recovery issues by fixing FRMR re-use to make it less likely the
>> client will drop the connection due to a memory operation error.
>>
>> Some other clean-ups and fixes are present as well.
>>
>> See topic branch nfs-rdma-for-3.17 in
>>
>>   git://git.linux-nfs.org/projects/cel/cel-2.6.git
>>
>> I tested with NFSv3 and NFSv4 on all three supported memory
>> registration modes. Used cthon04 and iozone with both Solaris
>> and Linux NFS/RDMA servers. Used xfstests with Linux.
>>
>> ---
>>
>> Chuck Lever (13):
>>       xprtrdma: Fix panic in rpcrdma_register_frmr_external()
>>       xprtrdma: Protect ->qp during FRMR deregistration
>>       xprtrdma: Limit data payload size for ALLPHYSICAL
>>       xprtrdma: Update rkeys after transport reconnect
>>       xprtrdma: Don't drain CQs on transport disconnect
>>       xprtrdma: Unclutter struct rpcrdma_mr_seg
>>       xprtrdma: Encode Work Request opcode in wc->wr_id
>>       xprtrdma: Back off rkey when FAST_REG_MR fails
>>       xprtrdma: Refactor rpcrdma_buffer_put()
>>       xprtrdma: Release FRMR segment buffers during LOCAL_INV completion
>>       xprtrdma: Clean up rpcrdma_ep_disconnect()
>>       xprtrdma: Remove RPCRDMA_PERSISTENT_REGISTRATION macro
>>       xprtrdma: Handle additional connection events
>>
>>
>>  include/linux/sunrpc/xprtrdma.h |    2
>>  net/sunrpc/xprtrdma/rpc_rdma.c  |   77 +++++----
>>  net/sunrpc/xprtrdma/transport.c |   17 +-
>>  net/sunrpc/xprtrdma/verbs.c     |  330 +++++++++++++++++++++++++++------------
>>  net/sunrpc/xprtrdma/xprt_rdma.h |   63 ++++++-
>>  5 files changed, 332 insertions(+), 157 deletions(-)
>>
>> --
>> Chuck Lever
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
