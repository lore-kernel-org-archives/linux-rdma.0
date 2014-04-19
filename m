From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 7/8] xprtrdma: Split the completion queue
Date: Sat, 19 Apr 2014 12:31:29 -0400
Message-ID: <593D9BFA-714E-417F-ACA0-05594290C4D1@oracle.com>
References: <20140414220041.20646.63991.stgit@manet.1015granger.net> <20140414222323.20646.66946.stgit@manet.1015granger.net> <534E7C1C.5070407@dev.mellanox.co.il> <534E8608.8030801@opengridcomputing.com> <E9B601B5-1984-40D8-914A-DDD1380E8183@oracle.com> <534EA06A.7090200@dev.mellanox.co.il> <FC61F219-ACA2-4CE8-BF02-1B8EE2464639@oracle.com> <534F7D5F.1090908@dev.mellanox.co.il> <A7E4B101-BAF0-480C-95AE-26BB845EE2C3@oracle.com> <003001cf5a4a$1e3f5320$5abdf960$@opengridcomputing.com> <5350277C.20608@dev.mellanox.co.il>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5350277C.20608-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Sagi-

On Apr 17, 2014, at 3:11 PM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> On 4/17/2014 5:34 PM, Steve Wise wrote:
> 
> <SNIP>
>> You could use a small array combined with a loop and a budget count.  So the code would
>> grab, say, 4 at a time, and keep looping polling up to 4 until the CQ is empty or the
>> desired budget is reached...
> 
> Bingo... couldn't agree more.
> 
> Poll Arrays are a nice optimization,

Typically, a provider's poll_cq implementation takes the CQ lock
using spin_lock_irqsave().  My goal of using a poll array is to
reduce the number of times the completion handler invokes
spin_lock_irqsave / spin_unlock_irqsave pairs when draining a
large queue.

> but large arrays will just burden the stack (and might even make things worse in high workloads...)


My prototype moves the poll array off the stack and into allocated
storage.  Making that array as large as a single page would be
sufficient for 50 or more ib_wc structures on a platform with 4KB
pages and 64-bit addresses.

The xprtrdma completion handler polls twice:

  1.  Drain the CQ completely

  2.  Re-arm

  3.  Drain the CQ completely again

So between steps 1. and 3. a single notification could handle over
100 WCs, if we were to budget by draining just a single array's worth
during each step. (Btw, I'm not opposed to looping while polling
arrays. This is just an example for discussion).

As for budgeting itself, I wonder if there is a possibility of losing
notifications.  The purpose of re-arming and then draining again is to
ensure that any items queued after step 1. and before step 2. are
captured, as by themselves they would never generate an upcall
notification, IIUC.

When the handler hits its budget and returns, xprtrdma needs to be
invoked again to finish draining the completion queue. How is that
guaranteed?

-- 
Chuck Lever
chuck[dot]lever[at]oracle[dot]com




--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
