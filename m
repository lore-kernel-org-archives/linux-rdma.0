From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 0/3] new ib_drain_qp() API
Date: Thu, 11 Feb 2016 10:54:22 -0800
Message-ID: <56BCD8DE.8010505@sandisk.com>
References: <cover.1454969695.git.swise@chelsio.com>
 <010901d16375$1a023210$4e069630$@opengridcomputing.com>
 <011601d1637b$8c01a3e0$a404eba0$@opengridcomputing.com>
 <56BA540B.4040405@sandisk.com>
 <011901d1637d$b5286400$1f792c00$@opengridcomputing.com>
 <012801d16384$f68884f0$e3998ed0$@opengridcomputing.com>
 <56BB11F0.9090203@dev.mellanox.co.il> <56BB4479.8090009@sandisk.com>
 <56BC6686.8030301@dev.mellanox.co.il> <56BCA57A.4000500@sandisk.com>
 <56BCB2C3.9060408@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56BCB2C3.9060408-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: 'Sagi Grimberg' <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 02/11/2016 08:11 AM, Sagi Grimberg wrote:
>> The srp_send_done() function accesses the ch->free_tx list without
>> locking. This is safe because all existing
>> ib_process_cq_direct(ch->send_cq, ...) calls occur while holding
>> ch->lock. The approach suggested above breaks that assumption.
>
> But srp_send_done won't get invoked for the ib_drain_qp post send
> because ->done doesn't point to it, Am I missing something?

Hello Sagi,

If it would be known that the send completion queue is empty then it 
wouldn't be needed to drain the send queue. And if it is not known 
whether or not the send queue is empty then for the SRP driver it is 
possible that calling ib_process_cq_direct() from inside the drain 
function will trigger a call to srp_send_done().

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
