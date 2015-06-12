From: Carol Soto <clsoto-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] IB/ucm: ib_ucm_release_dev clears wrong bit if devnum
 is greater than IB_UCM_MAX_DEVICES
Date: Fri, 12 Jun 2015 15:24:39 -0500
Message-ID: <557B4007.7020301@linux.vnet.ibm.com>
References: <1434038801-6513-1-git-send-email-clsoto@linux.vnet.ibm.com> <557B3C23.9090403@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <557B3C23.9090403-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 6/12/2015 3:08 PM, Doug Ledford wrote:
> On 06/11/2015 12:06 PM, clsoto-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org wrote:
>> From: Carol L Soto <clsoto-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>>
>> ib_ucm_release_dev clears wrong bit if devnum is greater than IB_UCM_MAX_DEVICES.
>>
>> Signed-off-by: Carol L Soto <clsoto-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> ---
>>   drivers/infiniband/core/ucm.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
>> index f2f6393..e2fd085 100644
>> --- a/drivers/infiniband/core/ucm.c
>> +++ b/drivers/infiniband/core/ucm.c
>> @@ -1193,6 +1193,7 @@ static int ib_ucm_close(struct inode *inode, struct file *filp)
>>   	return 0;
>>   }
>>   
>> +static DECLARE_BITMAP(overflow_map, IB_UCM_MAX_DEVICES);
>>   static void ib_ucm_release_dev(struct device *dev)
>>   {
>>   	struct ib_ucm_device *ucm_dev;
>> @@ -1202,7 +1203,7 @@ static void ib_ucm_release_dev(struct device *dev)
>>   	if (ucm_dev->devnum < IB_UCM_MAX_DEVICES)
>>   		clear_bit(ucm_dev->devnum, dev_map);
>>   	else
>> -		clear_bit(ucm_dev->devnum - IB_UCM_MAX_DEVICES, dev_map);
>> +		clear_bit(ucm_dev->devnum - IB_UCM_MAX_DEVICES, overflow_map);
>>   	kfree(ucm_dev);
>>   }
>>   
>> @@ -1226,7 +1227,6 @@ static ssize_t show_ibdev(struct device *dev, struct device_attribute *attr,
>>   static DEVICE_ATTR(ibdev, S_IRUGO, show_ibdev, NULL);
>>   
>>   static dev_t overflow_maj;
>> -static DECLARE_BITMAP(overflow_map, IB_UCM_MAX_DEVICES);
>>   static int find_overflow_devnum(void)
>>   {
>>   	int ret;
>>
> This doesn't look right to me.  In particular, you are creating a bitmap
> and clearing bits, but I never see that bitmap get any bits set.  So,
> are you overflowing on the set routine and you just didn't bother to fix
> that?
I just moved the declaration of the bitmap before ib_ucm_release_dev to 
be able to compile. This bitmap is used in ib_ucm_add_one
in the case of devnum > IB_UCM_MAX_DEVICES. The error path in 
ib_ucm_add_one did the clear bit correctly but not the
ib_ucm_release_dev function. We saw an issue when using SRIOV. The case 
was that user has 2 Mellanox SRIOV cards and just did an
unbind/bind a VF that was using a ib ucm device with devnum greater than 
32. We saw this warning
WARNING: at fs/sysfs/dir.c:31
May 31 14:04:11 powerkvm1-lp1 kernel: NIP [c000000000368958] 
sysfs_warn_dup+0x88/0xc0
May 31 14:04:11 powerkvm1-lp1 kernel: LR [c000000000368954] 
sysfs_warn_dup+0x84/0xc0
May 31 14:04:11 powerkvm1-lp1 kernel: Call Trace:
May 31 14:04:11 powerkvm1-lp1 kernel: [c000002e6bdbf510] 
[c000000000368954] sysfs_warn_dup+0x84/0xc0 (unreliable)
May 31 14:04:11 powerkvm1-lp1 kernel: [c000002e6bdbf590] 
[c000000000368fcc] sysfs_do_create_link_sd.isra.2+0x15c/0x170
May 31 14:04:11 powerkvm1-lp1 kernel: [c000002e6bdbf5e0] 
[c0000000005aebb8] device_add+0x2f8/0x6f0
May 31 14:04:11 powerkvm1-lp1 kernel: [c000002e6bdbf690] 
[d00000001f5c2a48] ib_ucm_add_one+0x288/0x378 [ib_ucm]
May 31 14:04:11 powerkvm1-lp1 kernel: [c000002e6bdbf730] 
[d00000001cef7468] ib_register_device+0x508/0x5b0 [ib_core]
May 31 14:04:11 powerkvm1-lp1 kernel: [c000002e6bdbf830] 
[d000000019baba88] mlx4_ib_add+0x918/0x1320 [mlx4_ib]
May 31 14:04:11 powerkvm1-lp1 kernel: [c000002e6bdbf950] 
[d000000019b32d10] mlx4_add_device+0x70/0x120 [mlx4_core]
May 31 14:04:11 powerkvm1-lp1 kernel: [c000002e6bdbf990] 
[d000000019b3304c] mlx4_register_device+0x9c/0xf0 [mlx4_core]
May 31 14:04:11 powerkvm1-lp1 kernel: [c000002e6bdbf9d0] 
[d000000019b38844] mlx4_load_one+0x1254/0x1600 [mlx4_core]
May 31 14:04:11 powerkvm1-lp1 kernel: [c000002e6bdbfad0] 
[d000000019b39210] mlx4_init_one+0x620/0x770 [mlx4_core]
May 31 14:04:11 powerkvm1-lp1 kernel: [c000002e6bdbfba0] 
[c0000000004fdf6c] local_pci_probe+0x6c/0x130
May 31 14:04:11 powerkvm1-lp1 kernel: [c000002e6bdbfc30] 
[c0000000000e5548] work_for_cpu_fn+0x38/0x60
May 31 14:04:11 powerkvm1-lp1 kernel: [c000002e6bdbfc60] 
[c0000000000ea518] process_one_work+0x198/0x470
May 31 14:04:11 powerkvm1-lp1 kernel: [c000002e6bdbfcf0] 
[c0000000000eaf0c] worker_thread+0x37c/0x5a0
May 31 14:04:11 powerkvm1-lp1 kernel: [c000002e6bdbfd80] 
[c0000000000f1f90] kthread+0x110/0x130
May 31 14:04:11 powerkvm1-lp1 kernel: [c000002e6bdbfe30] 
[c000000000009660] ret_from_kernel_thread+0x5c/0x7c

the warning was due to it was trying to create ib ucm device with devnum 
0 but that was in use already by another device. With the patch
I created, then I do not see the warning.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
