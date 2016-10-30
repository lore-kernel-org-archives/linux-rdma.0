From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH] IBcore/CM: Issue DREQ when receiving REQ/REP for stale QP
Date: Sun, 30 Oct 2016 23:06:33 +0200
Message-ID: <8df2c90e-8581-4ce8-fd18-92ac57eb6160@grimberg.me>
References: <1477653269-27359-1-git-send-email-hans.westgaard.ry@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1477653269-27359-1-git-send-email-hans.westgaard.ry@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Matan Barak <matanb@mellanox.com>, Erez Shitrit <erezsh@mellanox.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Ira Weiny <ira.weiny@intel.com>, Or Gerlitz <ogerlitz@mellanox.com>, Hakon Bugge <haakon.bugge@oracle.com>, Yuval Shaia <yuval.shaia@oracle.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

> from "InfiBand Architecture Specifications Volume 1":
>
>   A QP is said to have a stale connection when only one side has
>   connection information. A stale connection may result if the remote CM
>   had dropped the connection and sent a DREQ but the DREQ was never
>   received by the local CM. Alternatively the remote CM may have lost
>   all record of past connections because its node crashed and rebooted,
>   while the local CM did not become aware of the remote node's reboot
>   and therefore did not clean up stale connections.
>
> and:
>
>    A local CM may receive a REQ/REP for a stale connection. It shall
>    abort the connection issuing REJ to the REQ/REP. It shall then issue
>    DREQ with "DREQ:remote QPN” set to the remote QPN from the REQ/REP.
>
> This patch solves a problem with reuse of QPN. Current codebase, that
> is IPoIB, relies on a REAP-mechanism to do cleanup of the structures
> in CM. A problem with this is the timeconstants governing this
> mechanism; they are up to 768 seconds and the interface may look
> inresponsive in that period.  Issuing a DREQ (and receiving a DREP)
> does the necessary cleanup and the interface comes up.

I like this fix, so,

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>

But I think the CM layer still is buggy in this area.

In vol 1 the state transition table specifically states that DREP
timeouts should move the cm_id to timewait state but the CM doesn't
seem to maintain response timeouts on disconnect requests. If the
DREQ happened to fail (send error completion) things are fine, but
if the DREQ makes it to the peer but it doesn't reply then no one
will take care of it (i.e. we will never see a TIMEWAIT event from
this cm_id)...

I recall some debugging session with Hal on this area a ~year ago
with a new iser target (which didn't reply to DREQs on reboot
sequences). iser initiator waits for a DISCONNECTED/TIMEWAIT events
before destroying the cm_id (which never happened because of the
above). I think I ended up working around that in iser to just go
ahead and destroy the cm_id after issuing a DREQ (but now I realize
it was never included so I'll probably dig it up again soon).
