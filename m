From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] ib_srpt: Add missing ioctx->buf + ->dma alloc_session_cb
 init
Date: Wed, 6 Apr 2016 08:31:23 -0700
Message-ID: <57052BCB.6070405@sandisk.com>
References: <1459794233-19187-1-git-send-email-nab@linux-iscsi.org>
 <5702B503.1060006@sandisk.com>
 <1459809672.10124.18.camel@haakon3.risingtidesystems.com>
 <5702EE56.10503@sandisk.com>
 <1459810708.10124.25.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1459810708.10124.25.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, Sagi Grimberg <sagi@grimberg.me>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On 04/04/2016 03:58 PM, Nicholas A. Bellinger wrote:
> Are you going to verify this patch..?

Hello Nic,

After that the ib_srpt driver has processed a few commands this patch 
also triggers a kernel crash (list corruption). I have a look myself 
into the percpu_ida conversion.

Bart.
