From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 7/8] xprtrdma: Split the completion queue
Date: Thu, 17 Apr 2014 22:11:56 +0300
Message-ID: <5350277C.20608@dev.mellanox.co.il>
References: <20140414220041.20646.63991.stgit@manet.1015granger.net> <20140414222323.20646.66946.stgit@manet.1015granger.net> <534E7C1C.5070407@dev.mellanox.co.il> <534E8608.8030801@opengridcomputing.com> <E9B601B5-1984-40D8-914A-DDD1380E8183@oracle.com> <534EA06A.7090200@dev.mellanox.co.il> <FC61F219-ACA2-4CE8-BF02-1B8EE2464639@oracle.com> <534F7D5F.1090908@dev.mellanox.co.il> <A7E4B101-BAF0-480C-95AE-26BB845EE2C3@oracle.com> <003001cf5a4a$1e3f5320$5abdf960$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <003001cf5a4a$1e3f5320$5abdf960$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: 'Linux NFS Mailing List' <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 4/17/2014 5:34 PM, Steve Wise wrote:

<SNIP>
> You could use a small array combined with a loop and a budget count.  So the code would
> grab, say, 4 at a time, and keep looping polling up to 4 until the CQ is empty or the
> desired budget is reached...

Bingo... couldn't agree more.

Poll Arrays are a nice optimization, but large arrays will just burden 
the stack (and might even make things worse in high workloads...)

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
