From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] IB/srpt: Revert "Convert to percpu_ida tag allocation"
Date: Thu, 7 Apr 2016 16:44:40 -0700
Message-ID: <5706F0E8.5020705@sandisk.com>
References: <57055BC6.7070402@sandisk.com> <5706E548.3080002@sandisk.com>
 <1460072224.18732.67.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460072224.18732.67.camel-XoQW25Eq2zviZyQQd+hFbcojREIfoBdhmpATvIKMPHk@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 04/07/2016 04:37 PM, Nicholas A. Bellinger wrote:
> On Thu, 2016-04-07 at 15:55 -0700, Bart Van Assche wrote:
>> That patch causes the ib_srpt driver to crash as soon as the first
>> SCSI command is received. This means that that patch was untested.
>> Hence revert it. The shortcomings of that patch are as follows:
>> - It makes the ib_srpt driver use I/O contexts allocated by
>>    transport_alloc_session_tags() but it does not initialize these
>>    I/O contexts properly. All the initializations performed by
>>    srpt_alloc_ioctx() are skipped.
>> - It swaps the order of the send ioctx allocation and the transition
>>    to RTR mode which is wrong.
>> - The amount of memory that is needed for I/O contexts is doubled.
>> - srpt_rdma_ch.free_list is no longer used but is not removed.
>>
>> Revert commit 0fd10721fe36 and thereby fix the following kernel crash:
>>
>> kernel BUG at drivers/infiniband/ulp/srpt/ib_srpt.c:1439!
>> invalid opcode: 0000 [#1] SMP
>> Workqueue: target_completion target_complete_ok_work [target_core_mod]
>> RIP: 0010:[<ffffffffa052ef37>]  [<ffffffffa052ef37>] srpt_queue_response+0x437/0x4a0 [ib_srpt]
>> Call Trace:
>>   [<ffffffffa052f009>] srpt_queue_data_in+0x9/0x10 [ib_srpt]
>>   [<ffffffffa04f1ee2>] target_complete_ok_work+0x152/0x2b0 [target_core_mod]
>>   [<ffffffff81071ea7>] process_one_work+0x197/0x480
>>   [<ffffffff810721d9>] worker_thread+0x49/0x490
>>   [<ffffffff8107878a>] kthread+0xea/0x100
>>   [<ffffffff8159b172>] ret_from_fork+0x22/0x40
>>
>> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
>> Cc: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
>
> I've already asked you not to revert the patch [ ... ]

But why not to revert that patch? Your patch was completely untested and 
makes the ib_srpt driver unusable. I think the regular approach for such 
patches is to revert them and to rework these in a later kernel version. 
Linus, please let me know if you disagree.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
