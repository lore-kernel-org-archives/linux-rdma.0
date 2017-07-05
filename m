From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Large ib_srp configuration cannot allocate FRM pool space and
 fails map SCSI host
Date: Wed, 5 Jul 2017 11:11:18 -0400
Message-ID: <39327807-356f-a580-87c2-f1ea6bfc13ed@redhat.com>
References: <4ccb9679-db6e-25e7-39ba-eab9186d35a5@redhat.com>
 <5bc4c6ef-fcb4-95bc-ef34-486ebe60aadc@redhat.com>
 <976d654b-2834-6dd9-b8d3-3a628b2a7a77@grimberg.me>
 <a2107e84-0cd9-476d-7ebc-c2012a03b1f2@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a2107e84-0cd9-476d-7ebc-c2012a03b1f2-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 07/03/2017 03:00 PM, Laurence Oberman wrote:
> 
> 
> On 07/02/2017 04:31 AM, Sagi Grimberg wrote:
>>>> Hello
>>>>
>>>> This issue is apparent on RHEL and upstream 4.12-rc5 (that is what 
>>>> was tested)
>>>>
>>>> Customer has a large configuration so I cannot reproduce this so 
>>>> asking if anybody else is aware of this.
>>>>
>>>> We fail in FMR and we then keep incrementing the SCSI host#'s
>>>>
>>>> Jun 20 14:01:42 xxxxxx kernel: fmr_pool: fmr_create failed for FMR 3809
>>>> Jun 20 14:01:42 xxxxxx kernel: fmr_pool: fmr_create failed for FMR 2005
>>>> Jun 20 14:01:42 xxxxxx kernel: scsi host7: ib_srp: FMR pool 
>>>> allocation failed (-12)
>>>> Jun 20 14:01:42 xxxxxx kernel: scsi host8: ib_srp: FMR pool 
>>>> allocation failed (-12)
>>>>
>>>> This repeats over and over.
>>>>
>>>> * 7 pairs of enclosures / each with two controllers
>>>> * Each with an expansion tray
>>>> * Each side on the controller is going to its own IB switch
>>>> * Each node is connected to both switches each running its own 
>>>> subnet manager
>>>>
>>>> Prior versions of RHEL i.e. 7.2 that don't have the newer code that 
>>>> also exists upstream are working.
>>>> Both RHEL7.3 and upstream are affected.
>>>>
>>>> The configuration in place is:
>>>>
>>>> for srp.conf
>>>> a max_sect=65535,max_cmd_per_lun=254,queue_size=254
>>>>
>>>> for ib_srp
>>>> options ib_srp cmd_sg_entries=255 indirect_sg_entries=2048 prefer_fr=N
>>
>> How many fmrs did you end up allocating? what device is this?
> 
> Hello Sagi
> 
> I had them change srp.conf from:
> a max_sect=65535,max_cmd_per_lun=254,queue_size=254
> 
> to:
> a max_sect=4096,max_cmd_per_lun=64,queue_size=128
> 
> Now we can probe all rports and no longer see the disconnects and 
> reconnects and FR allocation failures.
> 
> I guess the changes made to the FMR code upstream which we of course 
> pulled into RHEL 7.3 will exceed allocations with the large rport count 
> this customer has.
> 
> My test-bed is back to back with two mlx5 ports on the server and two on 
> the client so I have been running with
> a max_sect=65535,max_cmd_per_lun=254,queue_size=254
> For a long time now.
> 
> So is this a tuning issue here as I am sure Red Hat, Bart and Mellanox 
> have never tested this above with a 14 port remote array configuration.
> 
> Quite honestly,
> a max_sect=4096,max_cmd_per_lun=64,queue_size=128
> is very reasonable.
> 
> I think I will have them increase max_sect=16384 and we should still 
> have enough space for allocations.
> 
> If you need more specifics like the actual FMR count as its currently 
> configured let me know.
> Simply let me have a list of sysfs variables you want captured.
> 
> Regards
> Laurence
> 

I did not give the device in my last update but had given it before.
This is an mlx4 configuration (cx3)

I expect the same would happen for an mlx5 (cx4) with this number of 
rports and would need to be tuned appropriately.

Thanks
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
