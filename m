From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: SRPt oops with 4.5-rc3-ish
Date: Sat, 27 Feb 2016 20:49:34 -0800
Message-ID: <56D27C5E.6090405@sandisk.com>
References: <56C0A6C3.3010903@redhat.com>
 <1456630639.19657.47.camel@haakon3.risingtidesystems.com>
 <56D274F8.9070804@sandisk.com>
 <1456634828.19657.84.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1456634828.19657.84.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 02/27/16 20:47, Nicholas A. Bellinger wrote:
> On Sat, 2016-02-27 at 20:18 -0800, Bart Van Assche wrote:
>> On 02/27/16 19:37, Nicholas A. Bellinger wrote:
>>> This is a fairly recent srpt shutdown regression, right..?
>>
>> Hi Nic,
>>
>> My patch series to make TMR handling synchronous fixes what Doug
>> reported. If you want I can rebase and repost that patch series.
>>
>
> There aren't even any TMRs being processed, so I don't see how that has
> anything to do with it.
>
>>From the logs, this OOPsen is related to some manner of recent srpt
> configfs se_node_acl + se_session active I/O shutdown regression.
>
> So short of sitting down and reproducing myself on v4.5-rc code,
> commit 59fae4de's removal of ib_create_cq() + ib_comp_handler callback
> usage look like a good place to start the investigation.
>
> It would be useful to first find out what changes introduced this
> regression, and how far back Doug is able to reproduce.

As I wrote before, this patch series works 100% stable on top of my most 
recent LIO core patch series, a patch series I have also made available 
on github. So what Doug ran into is a LIO core bug and not an ib_srpt bug.

Bart.
