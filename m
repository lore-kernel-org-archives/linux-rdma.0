From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 00/10] NFS/RDMA patches for 3.19
Date: Wed, 26 Nov 2014 11:36:05 -0500
Message-ID: <442D7450-449E-4E98-89F6-C3567E599E7B@oracle.com>
References: <20141109010328.8806.5861.stgit@manet.1015granger.net> <5475FEFD.8070302@Netapp.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5475FEFD.8070302-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Nov 26, 2014, at 11:25 AM, Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org> wrote:

> Hi Chuck,
> 
> I've applied these to two different branches - one for the RDMA changes and another for the generic client side changes.  Both have been sent to Trond to be merged with 3.19.

Thanks Anna!

> 
> Anna
> 
> On 11/08/2014 08:14 PM, Chuck Lever wrote:
>> Hi-
>> 
>> This is a set of fixes and clean-ups for xprtrdma. Also available
>> in the nfs-rdma-for-3.19 topic branch at
>> 
>>  git://linux-nfs.org/projects/cel/cel-2.6.git
>> 
>> I've run cthon04, iozone, dbench, multi-process kernel build and
>> xfstests with NFSv3 and NFSv4.0 against a Linux and a Solaris
>> NFS server via RDMA, with all three memory registration modes.
>> 
>> Changes since v1:
>> 
>> - Merged up to v3.18-rc3
>> - Dropped patches that enable NFSv4.1 support for now
>> - CQ completion vector spinning dropped for now
>> - Addressed Anna's review comments
>> - Several bug fixes
>> 
>> ---
>> 
>> Chuck Lever (10):
>>      xprtrdma: Return an errno from rpcrdma_register_external()
>>      xprtrdma: Cap req_cqinit
>>      xprtrdma: unmap all FMRs during transport disconnect
>>      xprtrdma: Refactor tasklet scheduling
>>      xprtrdma: Re-write rpcrdma_flush_cqs()
>>      xprtrdma: Enable pad optimization
>>      xprtrdma: Display async errors
>>      SUNRPC: serialize iostats updates
>>      NFS: SETCLIENTID XDR buffer sizes are incorrect
>>      NFS: Clean up nfs4_init_callback()
>> 
>> 
>> fs/nfs/nfs4client.c             |   31 +++++------
>> fs/nfs/nfs4xdr.c                |   10 ++-
>> include/linux/sunrpc/metrics.h  |    3 +
>> net/sunrpc/stats.c              |   21 +++++--
>> net/sunrpc/xprtrdma/transport.c |    4 +
>> net/sunrpc/xprtrdma/verbs.c     |  114 ++++++++++++++++++++++++++++++++++-----
>> net/sunrpc/xprtrdma/xprt_rdma.h |    6 ++
>> 7 files changed, 146 insertions(+), 43 deletions(-)
>> 
>> --
>> Chuck Lever
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
> 

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
