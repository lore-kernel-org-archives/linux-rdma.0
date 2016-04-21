From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Testing for RDMA with ib_srp: Failed to map data (-12) with
 max_sectors_kb=4096 and buffered I/O with 4MB writes
Date: Thu, 21 Apr 2016 17:18:53 -0400 (EDT)
Message-ID: <1447115127.31067709.1461273533488.JavaMail.zimbra@redhat.com>
References: <559411025.30902774.1461207472544.JavaMail.zimbra@redhat.com> <571918A5.8050504@grimberg.me> <57192078.8030402@sandisk.com> <977253912.31054447.1461265282789.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <977253912.31054447.1461265282789.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Sagi and Bart

DEBUG Log

Started here with NULL for desc, within same second below we see we see nmdesc=0

So its probably what you and Bart think is the issue.
Running out of MR'S maybe.

Many thanks again for your time.


[ 1746.125399] RHDEBUG: ib_srp failed in srp_fr_pool_get with desc=          (null) so returns -ENOMEM
[ 1746.179091] RHDEBUG: ib_srp failed in srp_fr_pool_get with desc=          (null) so returns -ENOMEM
[ 1746.235172] RHDEBUG: ib_srp failed in srp_fr_pool_get with desc=          (null) so returns -ENOMEM

[ 1746.286287] sd 4:0:0:11: [sdf] tag#56 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[ 1746.286289] sd 4:0:0:11: [sdf] tag#56 Sense Key : Illegal Request [current] 
[ 1746.286291] sd 4:0:0:11: [sdf] tag#56 Add. Sense: Invalid field in cdb
[ 1746.286294] sd 4:0:0:11: [sdf] tag#56 CDB: Write(10) 2a 00 00 5f 90 60 00 20 00 00
[ 1746.286295] blk_update_request: critical target error, dev sdf, sector 6262880
[ 1746.286763] blk_update_request: critical target error, dev dm-7, sector 6262880
[ 1746.286766] EXT4-fs warning (device dm-7): ext4_end_bio:315: I/O error -121 writing to inode 12 (offset 0 size 0 starting block 783116)
[ 1746.286768] Buffer I/O error on device dm-7, logical block 782860
[ 1746.286769] Buffer I/O error on device dm-7, logical block 782861
[ 1746.286770] Buffer I/O error on device dm-7, logical block 782862
[ 1746.286771] Buffer I/O error on device dm-7, logical block 782863
[ 1746.286772] Buffer I/O error on device dm-7, logical block 782864
[ 1746.286772] Buffer I/O error on device dm-7, logical block 782865
[ 1746.286773] Buffer I/O error on device dm-7, logical block 782866
[ 1746.286774] Buffer I/O error on device dm-7, logical block 782867
[ 1746.286775] Buffer I/O error on device dm-7, logical block 782868
[ 1746.286775] Buffer I/O error on device dm-7, logical block 782869
[ 1746.286858] EXT4-fs warning (device dm-7): ext4_end_bio:315: I/O error -121 writing to inode 12 (offset 0 size 0 starting block 783372)
[ 1746.286934] EXT4-fs warning (device dm-7): ext4_end_bio:315: I/O error -121 writing to inode 12 (offset 0 size 0 starting block 783628)
[ 1746.286990] EXT4-fs warning (device dm-7): ext4_end_bio:315: I/O error -121 writing to inode 12 (offset 0 size 0 starting block 783884)

Here we see nmdesc=0

[ 1747.149233] RHDEBUG: ib_srp after calling srp_map_finish_fr state->nmdesc=0
[ 1747.189113] RHDEBUG: ib_srp after srp_map_idb ret=-12
[ 1747.218154] scsi host4: ib_srp: Failed to map data (-12)
[ 1747.253729] RHDEBUG: ib_srp failed in srp_fr_pool_get with desc=          (null) so returns -ENOMEM
[ 1747.315717] RHDEBUG: ib_srp failed in srp_fr_pool_get with desc=          (null) so returns -ENOMEM
[ 1747.366814] RHDEBUG: ib_srp after calling srp_map_finish_fr state->nmdesc=0
[ 1747.404441] RHDEBUG: ib_srp after srp_map_idb ret=-12

[ 1747.422980] sd 5:0:0:3: [sdac] tag#94 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[ 1747.422982] sd 5:0:0:3: [sdac] tag#94 Sense Key : Illegal Request [current] 
[ 1747.422985] sd 5:0:0:3: [sdac] tag#94 Add. Sense: Invalid field in cdb
[ 1747.422987] sd 5:0:0:3: [sdac] tag#94 CDB: Write(10) 2a 00 00 66 a6 60 00 20 00 00
[ 1747.422990] blk_update_request: critical target error, dev sdac, sector 6727264
[ 1747.423239] blk_update_request: critical target error, dev dm-7, sector 6727264
[ 1747.423243] EXT4-fs warning (device dm-7): ext4_end_bio:315: I/O error -121 writing to inode 12 (offset 0 size 0 starting block 841164)
[ 1747.423309] EXT4-fs warning (device dm-7): ext4_end_bio:315: I/O error -121 writing to inode 12 (offset 0 size 0 starting block 841420)
[ 1747.423371] EXT4-fs warning (device dm-7): ext4_end_bio:315: I/O error -121 writing to inode 12 (offset 0 size 0 starting block 841676)
[ 1747.423432] EXT4-fs warning (device dm-7): ext4_end_bio:315: I/O error -121 writing to inode 12 (offset 0 size 0 starting block 841932)
[ 1747.953434] scsi host4: ib_srp: Failed to map data (-12)

[ 1747.999729] RHDEBUG: ib_srp failed in srp_fr_pool_get with desc=          (null) so returns -ENOMEM
[ 1748.053065] RHDEBUG: ib_srp failed in srp_fr_pool_get with desc=          (null) so returns -ENOMEM

[ 1748.110745] sd 5:0:0:3: [sdac] tag#64 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[ 1748.158964] sd 5:0:0:3: [sdac] tag#64 Sense Key : Illegal Request [current] 
[ 1748.200248] sd 5:0:0:3: [sdac] tag#64 Add. Sense: Invalid field in cdb
[ 1748.230859] sd 4:0:0:11: [sdf] tag#45 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[ 1748.230860] sd 4:0:0:11: [sdf] tag#45 Sense Key : Illegal Request [current] 
[ 1748.230862] sd 4:0:0:11: [sdf] tag#45 Add. Sense: Invalid field in cdb
[ 1748.230864] sd 4:0:0:11: [sdf] tag#45 CDB: Write(10) 2a 00 00 6d 79 38 00 20 00 00
[ 1748.230866] blk_update_request: critical target error, dev sdf, sector 7174456
[ 1748.230876] blk_update_request: critical target error, dev dm-7, sector 7174456
[ 1748.230880] EXT4-fs warning (device dm-7): ext4_end_bio:315: I/O error -121 writing to inode 12 (offset 0 size 0 starting block 897063)
[ 1748.230947] EXT4-fs warning (device dm-7): ext4_end_bio:315: I/O error -121 writing to inode 12 (offset 0 size 0 starting block 897319)
[ 1748.624368] sd 5:0:0:3: [sdac] tag#64 CDB: Write(10) 2a 00 00 70 a0 00 00 20 00 00
[ 1748.667421] blk_update_request: critical target error, dev sdac, sector 7380992
[ 1748.709431] blk_update_request: critical target error, dev dm-7, sector 7380992

[ 1748.756266] RHDEBUG: ib_srp failed in srp_fr_pool_get with desc=          (null) so returns -ENOMEM
[ 1748.819296] RHDEBUG: ib_srp failed in srp_fr_pool_get with desc=          (null) so returns -ENOMEM
[ 1748.875344] RHDEBUG: ib_srp failed in srp_fr_pool_get with desc=          (null) so returns -ENOMEM
[ 1748.929943] RHDEBUG: ib_srp failed in srp_fr_[

Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

----- Original Message -----
From: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "Sagi Grimberg" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Sent: Thursday, April 21, 2016 3:01:22 PM
Subject: Re: Testing for RDMA with ib_srp: Failed to map data (-12) with max_sectors_kb=4096 and buffered I/O with 4MB writes

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
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
