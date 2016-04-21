From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Testing for RDMA with ib_srp: Failed to map data (-12) with
 max_sectors_kb=4096 and buffered I/O with 4MB writes
Date: Thu, 21 Apr 2016 15:01:22 -0400 (EDT)
Message-ID: <977253912.31054447.1461265282789.JavaMail.zimbra@redhat.com>
References: <559411025.30902774.1461207472544.JavaMail.zimbra@redhat.com> <571918A5.8050504@grimberg.me> <57192078.8030402@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <57192078.8030402-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Bart and Sagi
Thank you for responding.

Bart. whenever you have something you want me to try I will be ready.

Sagi, I can pinpoint the exact failure and get the data you need tonight.
I am at Vault in Christoph's BOF session on NVME fabrics but can access the servers later.

There are two places -ENOMEM can happen in srp_map_finish_fr. I will capture this as well as print the state->nmdesc as Sagi requested.

if (state->fr.next >= state->fr.end) {
                printk("RHDEBUG:ib_srp in srp_map_finish_fr state->fr.next=%p state->fr.end=%p \n",state->fr.next,state->fr.end);
                return -ENOMEM;
        }

and

if (!desc) {
                printk("RHDEBUG: ib_srp failed in srp_fr_pool_get with desc=%p so returns -ENOMEM\n",desc);
                return -ENOMEM;
        }

Thanks!!

Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

----- Original Message -----
From: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
To: "Sagi Grimberg" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Sent: Thursday, April 21, 2016 2:48:24 PM
Subject: Re: Testing for RDMA with ib_srp: Failed to map data (-12) with max_sectors_kb=4096 and buffered I/O with 4MB writes

On 04/21/2016 11:15 AM, Sagi Grimberg wrote:
>> I am still on my quest for getting 4MB buffered writes to be stable to
>> RDMA SRP targets.
>> Lots of testing has been performed here with EDR 100 back to back
>> connections using
>> mellanox ConnectX-4 with mlx5_ib, an dthe ib_srp* drivers on target
>> server and client.
>>
>> In summary:
>>   setting max_sectors_kb=4096 and running DIRECT_IO is solid as a rock
>>   setting max_sectors_kb=2048 and running buffered 4MB writes to an FS
>> on a multipath is rock solid
>>
>>   However:
>>   setting max_sectors_kb=4096 and running buffered I/O sees serious
>> mapping issues.
>>
>>
>> I have isolated the failure and call flow to this
>>
>> srp_queuecommand
>>      srp_map_data(scmnd, ch, req);
>>       srp_map_idb
>>           ret = srp_map_finish_fr(&state, req, ch, 1);
>>
>>
>> The -12 is returned by srp_map_finish_fr() and fed back to fail with
>> ib_srp: Failed to map data (-12)
>
> Can you print out how many FRs we used at this point?
>
> state->nmdesc?

Hello Sagi and Laurence,

Since the SRP initiator can use multiple MRs per I/O it can happen that 
(temporarily) no MRs are available if both max_sectors and the queue 
depth are high enough. I'm working on a patch to prevent that this can 
happen.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
