From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH, untested] mlx5: Avoid that mlx5_ib_sg_to_klms() overflows
 the klms[] array
Date: Wed, 26 Apr 2017 15:25:30 +0300
Message-ID: <16ea1371-84a5-c055-5b0c-fdc6d355276a@mellanox.com>
References: <8992bd28-667f-94b1-e582-106e6b41aa4b@sandisk.com>
 <20170425175849.GS14088@mtr-leonro.local>
 <438230391.2090966.1493152655709.JavaMail.zimbra@redhat.com>
 <896e9a9e-43b6-7a21-e41b-861e4f795436@mellanox.com>
 <288883138.2280971.1493207257218.JavaMail.zimbra@redhat.com>
 <497950649.2287440.1493209093092.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <497950649.2287440.1493209093092.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 4/26/2017 3:18 PM, Laurence Oberman wrote:
>
>
> ----- Original Message -----
>> From: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> To: "Max Gurtovoy" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Cc: "Leon Romanovsky" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "Doug Ledford"
>> <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Sagi Grimberg" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "Israel Rukshin" <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
>> linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Sent: Wednesday, April 26, 2017 7:47:37 AM
>> Subject: Re: [PATCH, untested] mlx5: Avoid that mlx5_ib_sg_to_klms() overflows the klms[] array
>>
>>
>>
>> ----- Original Message -----
>>> From: "Max Gurtovoy" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>> To: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Leon Romanovsky"
>>> <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>> Cc: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "Doug Ledford"
>>> <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Sagi Grimberg"
>>> <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "Israel Rukshin" <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
>>> linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> Sent: Wednesday, April 26, 2017 4:31:57 AM
>>> Subject: Re: [PATCH, untested] mlx5: Avoid that mlx5_ib_sg_to_klms()
>>> overflows the klms[] array
>>>
>>>
>>>
>>> On 4/25/2017 11:37 PM, Laurence Oberman wrote:
>>>>
>>>>
>>>> ----- Original Message -----
>>>>> From: "Leon Romanovsky" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>>> To: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
>>>>> Cc: "Doug Ledford" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Max Gurtovoy"
>>>>> <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Sagi Grimberg" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>,
>>>>> "Israel Rukshin" <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Laurence Oberman"
>>>>> <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>> Sent: Tuesday, April 25, 2017 1:58:49 PM
>>>>> Subject: Re: [PATCH, untested] mlx5: Avoid that mlx5_ib_sg_to_klms()
>>>>> overflows the klms[] array
>>>>>
>>>>> On Mon, Apr 24, 2017 at 03:15:28PM -0700, Bart Van Assche wrote:
>>>>>> ib_map_mr_sg() can pass an SG-list to .map_mr_sg() that is larger
>>>>>> than what fits into a single MR. .map_mr_sg() must not attempt to
>>>>>> map more SG-list elements than what fits into a single MR.
>>>>>> Hence make sure that mlx5_ib_sg_to_klms() does not write outside
>>>>>> the MR klms[] array.
>>>>>>
>>>>>> Fixes: b005d3164713 ("mlx5: Add arbitrary sg list support")
>>>>>> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
>>>>>> Reviewed-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>>>> Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
>>>>>> Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>>>> Cc: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>>>> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
>>>>>> ---
>>>>>>  drivers/infiniband/hw/mlx5/mr.c | 2 +-
>>>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>
>>>>>
>>>>> Bart,
>>>>>
>>>>> Thanks a lot, it indeed looks right.
>>>>> Acked-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>>>
>>>>> Thanks
>>>>>
>>>>
>>>>
>>>> Hello Bart, Leon, Max and Israel.
>>>>
>>>> I cloned off Barts tree.
>>>>
>>>> git clone https://github.com/bvanassche/linux
>>>> cd linux
>>>> git checkout block-scsi-for-next
>>>>
>>>> I checked all patches were in for this test.
>>>>
>>>> a83e404 IB/srp: Reenable IB_MR_TYPE_SG_GAPS
>>>> dfa5a2b mlx5: Avoid that mlx5_ib_sg_to_klms() overflows the klms[] array
>>>> f759c80 mlx5: Fix mlx5_ib_map_mr_sg mr lengt
>>>
>>> Hi,
>>> copying Sagi's request from different thread:
>>>
>>> "
>>> Can you please enable srp_add_one debug:
>>>
>>> echo "func srp_add_one +p" > /sys/kernel/debug/dynamic_debug/control
>>>
>>> In addition apply the following:
>>> --
>>> diff --git a/drivers/infiniband/hw/mlx5/mr.c
>>> b/drivers/infiniband/hw/mlx5/mr.c
>>> index d9c6c0ea750b..040fbc387e4f 100644
>>> --- a/drivers/infiniband/hw/mlx5/mr.c
>>> +++ b/drivers/infiniband/hw/mlx5/mr.c
>>> @@ -1403,6 +1403,8 @@ mlx5_alloc_priv_descs(struct ib_device *device,
>>>          int add_size;
>>>          int ret;
>>>
>>> +       WARN_ON_ONCE(ndescs > device->attr.max_fast_reg_page_list_len);
>>> +
>>>          add_size = max_t(int, MLX5_UMR_ALIGN - ARCH_KMALLOC_MINALIGN, 0);
>>>
>>>          mr->descs_alloc = kzalloc(size + add_size, GFP_KERNEL);
>>>
>>> "
>>>
>>> Max.
>>>
>>>>
>>>> Built and tested the kernel.
>>>>
>>>> However this issue is not resolved :(
>>>>
>>>> [ 2707.931909] scsi host1: ib_srp: failed RECV status WR flushed (5) for
>>>> CQE ffff8817edca86b0
>>>> [ 2708.089806] mlx5_0:dump_cqe:262:(pid 20129): dump error cqe
>>>> [ 2708.121342] 00000000 00000000 00000000 00000000
>>>> [ 2708.147104] 00000000 00000000 00000000 00000000
>>>> [ 2708.172633] 00000000 00000000 00000000 00000000
>>>> [ 2708.198702] 00000000 0f007806 2500002a 14a527d0
>>>> [ 2732.434127] scsi host1: ib_srp: reconnect succeeded
>>>> [ 2733.048023] scsi host1: ib_srp: failed RECV status WR flushed (5) for
>>>> CQE ffff8817ed0a9c30
>>>>
>>>> [root@localhost ~]# [ 2746.413277] mlx5_0:dump_cqe:262:(pid 15877): dump
>>>> error cqe
>>>> [ 2746.443240] 00000000 00000000 00000000 00000000
>>>> [ 2746.469323] 00000000 00000000 00000000 00000000
>>>> [ 2746.495310] 00000000 00000000 00000000 00000000
>>>> [ 2746.521407] 00000000 0f007806 25000032 003c7ad0
>>>> [ 2752.445899] scsi host1: ib_srp: reconnect succeeded
>>>> [ 2752.481835] scsi host1: ib_srp: failed RECV status WR flushed (5) for
>>>> CQE ffff8817ed0a9cf0
>>>> [ 2763.267386] mlx5_0:dump_cqe:262:(pid 15877): dump error cqe
>>>> [ 2763.297826] 00000000 00000000 00000000 00000000
>>>> [ 2763.323352] 00000000 00000000 00000000 00000000
>>>> [ 2763.348722] 00000000 00000000 00000000 00000000
>>>> [ 2763.374681] 00000000 0f007806 2500003a 00084bd0
>>>>
>>>> [root@localhost ~]# [ 2769.385203] fast_io_fail_tmo expired for SRP
>>>> port-1:1 / host1.
>>>> [ 2769.415956] scsi host1: ib_srp: reconnect succeeded
>>>> [ 2769.450258] scsi host1: ib_srp: failed RECV status WR flushed (5) for
>>>> CQE ffff8817ed0a9cf0
>>>> [ 2780.064627] mlx5_0:dump_cqe:262:(pid 18771): dump error cqe
>>>> [ 2780.093520] 00000000 00000000 00000000 00000000
>>>> [ 2780.120067] 00000000 00000000 00000000 00000000
>>>> [ 2780.145575] 00000000 00000000 00000000 00000000
>>>> [ 2780.171153] 00000000 0f007806 25000042 000833d0
>>>> [ 2785.923399] scsi host1: ib_srp: reconnect succeeded
>>>> [ 2785.957504] scsi host1: ib_srp: failed RECV status WR flushed (5) for
>>>> CQE ffff8817ed0a9cf0
>>>> [ 2796.463426] mlx5_0:dump_cqe:262:(pid 18771): dump error cqe
>>>> [ 2796.495257] 00000000 00000000 00000000 00000000
>>>> [ 2796.521506] 00000000 00000000 00000000 00000000
>>>> [ 2796.547640] 00000000 00000000 00000000 00000000
>>>> [ 2796.573120] 00000000 0f007806 2500004a 00083bd0
>>>> [ 2802.562578] scsi host1: ib_srp: reconnect succeeded
>>>> [ 2802.596880] scsi host1: ib_srp: failed RECV status WR flushed (5) for
>>>> CQE ffff8817ed0a9cf0
>>>>
>>>> Regards
>>>> Laurence
>>>>
>>>
>> Doing this now
>> Thanks
>> Laurence
>
> Max
>
> The Patch is not correct.
>
> drivers/infiniband/hw/mlx5/mr.c: In function 'mlx5_alloc_priv_descs':
> drivers/infiniband/hw/mlx5/mr.c:1406:30: error: 'struct ib_device' has no member named 'attr'
>   WARN_ON_ONCE(ndescs > device->attr.max_fast_reg_page_list_len);
>                               ^
> ./include/asm-generic/bug.h:117:27: note: in definition of macro 'WARN_ON_ONCE'
>   int __ret_warn_once = !!(condition);   \
>
> I think you meant to give me
>
> WARN_ON_ONCE(ndescs > ib_device_attr->attr.max_fast_reg_page_list_len);
>
> Can you confirm

Hi Laurence,
should be device->attrs.max_fast_reg_page_list_len.

please check this one that might solve the issue (on top of everything):


diff --git a/drivers/infiniband/hw/mlx5/mr.c 
b/drivers/infiniband/hw/mlx5/mr.c
index b8f9382..063d116 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1559,7 +1559,7 @@ struct ib_mr *mlx5_ib_alloc_mr(struct ib_pd *pd,
                 mr->max_descs = ndescs;
         } else if (mr_type == IB_MR_TYPE_SG_GAPS) {
                 mr->access_mode = MLX5_MKC_ACCESS_MODE_KLMS;
-
+               MLX5_SET(mkc, mkc, translations_octword_size, 
ALIGN(max_num_sg + 1, 4));
                 err = mlx5_alloc_priv_descs(pd->device, mr,
                                             ndescs, sizeof(struct 
mlx5_klm));
                 if (err)

thanks,
Max.

>
> Thanks
> Laurence
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
