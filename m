From: "santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IBcore/CM: Issue DREQ when receiving REQ/REP for stale QP
Date: Sun, 30 Oct 2016 21:52:32 -0700
Message-ID: <d75248c6-39e2-5856-c76f-1598a6d4e2ba@oracle.com>
References: <1477653269-27359-1-git-send-email-hans.westgaard.ry@oracle.com>
 <8df2c90e-8581-4ce8-fd18-92ac57eb6160@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8df2c90e-8581-4ce8-fd18-92ac57eb6160-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Hans Westgaard Ry <hans.westgaard.ry-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hakon Bugge <haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/30/16 2:06 PM, Sagi Grimberg wrote:
>> from "InfiBand Architecture Specifications Volume 1":
>>
>>   A QP is said to have a stale connection when only one side has
>>   connection information. A stale connection may result if the remote CM
>>   had dropped the connection and sent a DREQ but the DREQ was never
>>   received by the local CM. Alternatively the remote CM may have lost
>>   all record of past connections because its node crashed and rebooted,
>>   while the local CM did not become aware of the remote node's reboot
>>   and therefore did not clean up stale connections.
>>
>> and:
>>
>>    A local CM may receive a REQ/REP for a stale connection. It shall
>>    abort the connection issuing REJ to the REQ/REP. It shall then issue
>>    DREQ with "DREQ:remote QPN” set to the remote QPN from the REQ/REP.
>>
>> This patch solves a problem with reuse of QPN. Current codebase, that
>> is IPoIB, relies on a REAP-mechanism to do cleanup of the structures
>> in CM. A problem with this is the timeconstants governing this
>> mechanism; they are up to 768 seconds and the interface may look
>> inresponsive in that period.  Issuing a DREQ (and receiving a DREP)
>> does the necessary cleanup and the interface comes up.
>
> I like this fix, so,
>
Me too and hence suggested Hans to post it on rdma list when
saw this patch in internal review.

> Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
>
> But I think the CM layer still is buggy in this area.
>
> In vol 1 the state transition table specifically states that DREP
> timeouts should move the cm_id to timewait state but the CM doesn't
> seem to maintain response timeouts on disconnect requests. If the
> DREQ happened to fail (send error completion) things are fine, but
> if the DREQ makes it to the peer but it doesn't reply then no one
> will take care of it (i.e. we will never see a TIMEWAIT event from
> this cm_id)...
>
> I recall some debugging session with Hal on this area a ~year ago
> with a new iser target (which didn't reply to DREQs on reboot
> sequences). iser initiator waits for a DISCONNECTED/TIMEWAIT events
> before destroying the cm_id (which never happened because of the
> above). I think I ended up working around that in iser to just go
> ahead and destroy the cm_id after issuing a DREQ (but now I realize
> it was never included so I'll probably dig it up again soon).

There is another fundamental issue with core CM code wrt DREQ
getting dropped. The the mad agent used to send the DREQ is
associated with a port and if this port is down, the IB link
layer will drop that DREQ as per SPEC. Similarly if the destination
port is down where the DREQ is suppose to reach, then the DREQ
gets dropped there too. These dropped CM ids are retried by MAD
agent on same port till the port comes back alive.

Am not sure in your case the ports were going down or not
but it was the case then IIUC, what you are doing for ISER is
still needed (up front destroying the cm id).

Regards,
Santosh


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
