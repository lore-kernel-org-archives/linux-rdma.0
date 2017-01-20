From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 0/5] Fix "support large inline thresholds"
Date: Fri, 20 Jan 2017 10:17:17 -0800
Message-ID: <367EA1AA-83EF-4772-B369-F14A3AF198F1@oracle.com>
References: <20170113173023.32692.30661.stgit@manet.1015granger.net> <021301d27342$e9f59fb0$bde0df10$@opengridcomputing.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <021301d27342$e9f59fb0$bde0df10$@opengridcomputing.com>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Jan 20, 2017, at 9:30 AM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:
> 
>> 
>> I've received a number of reports that v4.9 commit 655fec6987be
>> ("xprtrdma: Use gathered Send for large inline messages") causes
>> NFS/RDMA mounts to fail for devices that have a small max_sge.
>> 
>> This series addresses that problem.
>> 
>> A much smaller fix was provided initially. It worked for devices
>> with as small as five send SGEs. However, additional research has
>> shown that there is at least one in-tree device that supports only
>> three send SGEs.
>> 
>> The current series should enable NFS/RDMA again on those devices.
>> 
>> 
>> Available in the "nfs-rdma-for-4.10-rc" topic branch of this git repo:
>> 
>> git://git.linux-nfs.org/projects/cel/cel-2.6.git
> 
> Hey Chuck,
> 
> Tests ok on cxgb4.
> 
> Tested-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Thanks. I've also received confirmation that Ram's
device works now, and ocrdma's issue is cleared too.

I'll post a final version of this series on Monday.


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
