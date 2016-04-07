From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] ib_srpt: Add missing ioctx->buf + ->dma alloc_session_cb
 init
Date: Thu, 7 Apr 2016 15:48:27 -0700
Message-ID: <5706E3BB.70302@sandisk.com>
References: <1459794233-19187-1-git-send-email-nab@linux-iscsi.org>
 <5702B503.1060006@sandisk.com>
 <1459809672.10124.18.camel@haakon3.risingtidesystems.com>
 <5702EE56.10503@sandisk.com>
 <1459810708.10124.25.camel@haakon3.risingtidesystems.com>
 <57052BCB.6070405@sandisk.com>
 <1460068300.18732.25.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1460068300.18732.25.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, Sagi Grimberg <sagi@grimberg.me>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On 04/07/2016 03:31 PM, Nicholas A. Bellinger wrote:
>> I will have a look myself into the percpu_ida conversion.
>
> I found a pair of old ConnectX2 in IB mode and I'll be fixing this up
> for v4.6-rc, so don't even bother.

Please make sure that you understand the ib_srpt driver before you try 
to make further modifications to that driver. The patch for percpu_ida 
allocation that is already in v4.6-rc1 introduces namely a severe race 
condition next to the bugs that I had already explained. The proper 
order for session setup is to allocate the send ioctx buffers first and 
after these buffers have been allocated to transition to RTR. You 
changed that order to transition first to RTR and next to allocate the 
send ioctx buffers. By making this change you introduced a race window 
during which any command that is received by the ib_srpt driver will try 
to allocate a send ioctx from a not yet initialized send ioctx ring.

Bart.
