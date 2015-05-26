From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 00/16] NFS/RDMA patches proposed for 4.2
Date: Tue, 26 May 2015 11:37:37 -0400
Message-ID: <46639D36-E0C0-4201-B1BE-9E1775F03277@oracle.com>
References: <20150511174401.31263.79596.stgit@manet.1015granger.net> <1432654106.28905.111.camel@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432654106.28905.111.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On May 26, 2015, at 11:28 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Mon, 2015-05-11 at 14:02 -0400, Chuck Lever wrote:
>> I'd like these patches to be considered for merging upstream. This
>> patch series includes:
>> 
>>  - JIT allocation of rpcrdma_mw structures
>>  - Break-up of rb_lock
>>  - Reduction of how many rpcrdma_mw structs are needed per transport
>> 
>> These are pre-requisites for increasing the RPC slot count and
>> r/wsize on RPC/RDMA transports, and provide scalability benefits
>> even on their own. And:
>> 
>>  - A generic transport fault injector
>> 
>> This is useful to discover regressions in logic that handles
>> transport reconnection.
>> 
>> You can find these in my git repo in the "nfs-rdma-for-4.2" topic
>> branch. See:
>> 
>>  git://git.linux-nfs.org/projects/cel/cel-2.6.git
> 
> I assume you are planning on this going in through the nfs tree.  As
> such, I'm planning on removing this patchset from the linux-rdma
> patchworks site.

Yes, patches to net/sunrpc/xprtrdma/ will typically go through
Anna or Bruce. I post to linux-rdma for review of RDMA-related
changes.

> However, I'll add this for the series:
> 
> Reviewed-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Thanks, I will post a refresh today.

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
