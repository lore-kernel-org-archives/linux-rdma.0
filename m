From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/3] target: Fix queue-full callback error signaling
Date: Thu, 30 Mar 2017 21:32:09 -0700
Message-ID: <1490934729.6977.27.camel@haakon3.risingtidesystems.com>
References: <1477891554-26222-1-git-send-email-nab@linux-iscsi.org>
         <20170323053602.GA2323@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20170323053602.GA2323@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: Potnuri Bharat Teja <bharat@chelsio.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, SWise OGC <swise@opengridcomputing.com>, Sagi Grimberg <sagi@grimberg.me>
List-Id: linux-rdma@vger.kernel.org

Hi Bharat & Co,

On Thu, 2017-03-23 at 11:06 +0530, Potnuri Bharat Teja wrote:
> On Monday, October 10/31/16, 2016 at 10:55:51 +0530, Nicholas A. Bellinger wrote:
> >    From: Nicholas Bellinger <nab@linux-iscsi.org>
> Hi Nicholas,
> This patch series fixes the post failures due to Send Queue overflow when
> tested along with Sagi's "iser-target: avoid posting a recv buffer twice", which 
> goes on top of these 3 patches.
> 
> Combined patches series(Nicholas's, Sagi's) works fine.
> Tested with iWARP iser. 
> 
> As these changes are critical for devices with lower sg resources, hoping this 
> series will be queued for next RC.
> 
> Reviewed-by: Potnuri Bharat Teja <bharat@chelsio.com>
> Tested-by: Potnuri Bharat Teja <bharat@chelsio.com>

As mentioned, the original three patches along with Sagi's have been
applied to target-pending/master.

Thank you for your testing and patch review.

I'm still considering if they should be CC'ed for stable, considering
AFAICT they are pretty much a requirement for iser-target to be stable
with iw_cxgb4.  It should be OK to include the series back to v4.1.y
stable, but I'm reviewing the target change again just to be sure.

Also, I've been thinking a bit more about the hung tasks you reported
earlier during session reinstatement + repeated queue full preceding
Sagi's patch here:

http://www.spinics.net/lists/target-devel/msg14868.html

and have some clarity as to what was going on..

The issue is that queue full handling for TFO->write_pending(),
TFO->queue_data_in() and TFO->queue_status failures will retry
indefinitely until they successfully complete, and currently do not
honor se_cmd quiesce that occurs during normal session reinstatement.

Which means that if a fabric driver fails any of these three TFO
callbacks forever, the se_cmd descriptor will never be properly quiesced
back to fabric driver code, resulting in hung tasks you observed while
session shutdown waits for this action to complete.

So as-is, this patch series doesn't address this particular scenario but
doesn't make it any worse either..  ;)

That said, it's fine to merge this series now to allow iser-target +
iw_cxgb4 to function, and I'll be looking into addressing the infinite
queue_full + session reinstatement scenario for target-core in separate
patch series.
