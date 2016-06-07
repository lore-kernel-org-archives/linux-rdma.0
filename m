From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [RFC] IB/srp: Remove create_workqueue
Date: Tue, 7 Jun 2016 13:00:13 -0700
Message-ID: <dcee0161-3210-0cfb-c0e6-bba7259ad639@sandisk.com>
References: <20160607181617.GA6556@Karyakshetra>
 <f3d26daf-1805-7046-f45b-b8965156d83f@sandisk.com>
 <20160607192106.GY31708@htj.duckdns.org>
 <bdf2c634-a765-eb97-5ca1-583d833b07c7@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <bdf2c634-a765-eb97-5ca1-583d833b07c7@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 06/07/2016 12:56 PM, Bart Van Assche wrote:
> On 06/07/2016 12:21 PM, Tejun Heo wrote:
>> On Tue, Jun 07, 2016 at 11:32:42AM -0700, Bart Van Assche wrote:
>>> On 06/07/2016 11:16 AM, Bhaktipriya Shridhar wrote:
>>>> alloc_workqueue replaces deprecated create_workqueue().
>>>>
>>>> A dedicated workqueue has been used since the workqueue srp_remove_wq with
>>>> workitem &target->remove_work, is a work queue for the SRP target removal.
>>>> WQ_MEM_RECLAIM has been set to ensure forward progress under memory
>>>> pressure.
>>>> Since there are only a fixed number of work items, explicit
>>>> concurrency limit is unnecessary here.
>>>>
>>>> Is the workqueue being used on a memory reclaim path?
>>>> Does it require WQ_MEM_RECLAIM?
>>>
>>> Hello Bhaktipriya,
>>>
>>> srp_remove_wq is used for SRP target port removal work only. This work is
>>> neither queued from inside a shrinker nor by the page writeback code so I
>>> think it is safe to drop WQ_MEM_RECLAIM.
>>
>> It should be able to use system_wq then.
>
> No. I have tried that but that resulted in a deadlock.

See also commit bcc059103591 for the details.

Bart.
