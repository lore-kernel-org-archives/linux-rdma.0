From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH, untested] mlx5: Avoid that mlx5_ib_sg_to_klms() overflows
 the klms[] array
Date: Wed, 3 May 2017 02:28:34 +0300
Message-ID: <9112e5a4-e7c0-7098-2aca-691661e427d6@mellanox.com>
References: <8992bd28-667f-94b1-e582-106e6b41aa4b@sandisk.com>
 <438230391.2090966.1493152655709.JavaMail.zimbra@redhat.com>
 <896e9a9e-43b6-7a21-e41b-861e4f795436@mellanox.com>
 <288883138.2280971.1493207257218.JavaMail.zimbra@redhat.com>
 <497950649.2287440.1493209093092.JavaMail.zimbra@redhat.com>
 <16ea1371-84a5-c055-5b0c-fdc6d355276a@mellanox.com>
 <2122831810.2341766.1493213317484.JavaMail.zimbra@redhat.com>
 <1879402127.2348907.1493214625254.JavaMail.zimbra@redhat.com>
 <1477402175.2378198.1493219418826.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477402175.2378198.1493219418826.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 4/26/2017 6:10 PM, Laurence Oberman wrote:
>
>
> ----- Original Message -----
>> From: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> To: "Max Gurtovoy" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Cc: "Leon Romanovsky" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "Doug Ledford"
>> <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Sagi Grimberg" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "Israel Rukshin" <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
>> linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Sent: Wednesday, April 26, 2017 9:50:25 AM
>> Subject: Re: [PATCH, untested] mlx5: Avoid that mlx5_ib_sg_to_klms() overflows the klms[] array
>>
>>
>>
>> ----- Original Message -----
>>> From: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>> To: "Max Gurtovoy" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>> Cc: "Leon Romanovsky" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Bart Van Assche"
>>> <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "Doug Ledford"
>>> <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Sagi Grimberg" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "Israel Rukshin"
>>> <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
>>> linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> Sent: Wednesday, April 26, 2017 9:28:37 AM
>>> Subject: Re: [PATCH, untested] mlx5: Avoid that mlx5_ib_sg_to_klms()
>>> overflows the klms[] array
>>>
>>>
>>>
>>> ----- Original Message -----
>>>> From: "Max Gurtovoy" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>> To: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>> Cc: "Leon Romanovsky" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Bart Van Assche"
>>>> <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "Doug Ledford"
>>>> <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Sagi Grimberg" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "Israel
>>>> Rukshin"
>>>> <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
>>>> linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> Sent: Wednesday, April 26, 2017 8:25:30 AM
>>>> Subject: Re: [PATCH, untested] mlx5: Avoid that mlx5_ib_sg_to_klms()
>>>> overflows the klms[] array
>>>>
>>>>
>>>>
>>>> On 4/26/2017 3:18 PM, Laurence Oberman wrote:
>>>>>
>>>>>
>>>>> ----- Original Message -----
>>>>>> From: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>>>> To: "Max Gurtovoy" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>>>> Cc: "Leon Romanovsky" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Bart Van Assche"
>>>>>> <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "Doug Ledford"
>>>>>> <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Sagi Grimberg" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "Israel
>>>>>> Rukshin" <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
>>>>>> linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>>> Sent: Wednesday, April 26, 2017 7:47:37 AM
>>>>>> Subject: Re: [PATCH, untested] mlx5: Avoid that mlx5_ib_sg_to_klms()
>>>>>> overflows the klms[] array
>>>>>>
>>>>>>
>>>>>>
>>>>>> ----- Original Message -----
>>>>>>> From: "Max Gurtovoy" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>>>>> To: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Leon Romanovsky"
>>>>>>> <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>>>>> Cc: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "Doug Ledford"
>>>>>>> <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Sagi Grimberg"
>>>>>>> <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "Israel Rukshin" <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
>>>>>>> linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>>>> Sent: Wednesday, April 26, 2017 4:31:57 AM
>>>>>>> Subject: Re: [PATCH, untested] mlx5: Avoid that mlx5_ib_sg_to_klms()
>>>>>>> overflows the klms[] array
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> On 4/25/2017 11:37 PM, Laurence Oberman wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>> ----- Original Message -----
>>>>>>>>> From: "Leon Romanovsky" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>>>>>>> To: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
>>>>>>>>> Cc: "Doug Ledford" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Max Gurtovoy"
>>>>>>>>> <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Sagi Grimberg" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>,
>>>>>>>>> "Israel Rukshin" <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Laurence Oberman"
>>>>>>>>> <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>>>>>> Sent: Tuesday, April 25, 2017 1:58:49 PM
>>>>>>>>> Subject: Re: [PATCH, untested] mlx5: Avoid that
>>>>>>>>> mlx5_ib_sg_to_klms()
>>>>>>>>> overflows the klms[] array
>>>>>>>>>
>>>>>>>>> On Mon, Apr 24, 2017 at 03:15:28PM -0700, Bart Van Assche wrote:
>>>>>>>>>> ib_map_mr_sg() can pass an SG-list to .map_mr_sg() that is larger
>>>>>>>>>> than what fits into a single MR. .map_mr_sg() must not attempt to
>>>>>>>>>> map more SG-list elements than what fits into a single MR.
>>>>>>>>>> Hence make sure that mlx5_ib_sg_to_klms() does not write outside
>>>>>>>>>> the MR klms[] array.
>>>>>>>>>>
>>>>>>>>>> Fixes: b005d3164713 ("mlx5: Add arbitrary sg list support")
>>>>>>>>>> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
>>>>>>>>>> Reviewed-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>>>>>>>> Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
>>>>>>>>>> Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>>>>>>>> Cc: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>>>>>>>> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
>>>>>>>>>> ---
>>>>>>>>>>  drivers/infiniband/hw/mlx5/mr.c | 2 +-
>>>>>>>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>>>>>
>>>>>>>>>
>>>>>>>>> Bart,
>>>>>>>>>
>>>>>>>>> Thanks a lot, it indeed looks right.
>>>>>>>>> Acked-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>>>>>>>
>>>>>>>>> Thanks
>>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> Hello Bart, Leon, Max and Israel.
>>>>>>>>
>>>>>>>> I cloned off Barts tree.
>>>>>>>>
>>>>>>>> git clone https://github.com/bvanassche/linux
>>>>>>>> cd linux
>>>>>>>> git checkout block-scsi-for-next
>>>>>>>>
>>>>>>>> I checked all patches were in for this test.
>>>>>>>>
>>>>>>>> a83e404 IB/srp: Reenable IB_MR_TYPE_SG_GAPS
>>>>>>>> dfa5a2b mlx5: Avoid that mlx5_ib_sg_to_klms() overflows the klms[]
>>>>>>>> array
>>>>>>>> f759c80 mlx5: Fix mlx5_ib_map_mr_sg mr lengt
>>>>>>>
>>>>>>> Hi,
>>>>>>> copying Sagi's request from different thread:
>>>>>>>
>>>>>>> "
>>>>>>> Can you please enable srp_add_one debug:
>>>>>>>
>>>>>>> echo "func srp_add_one +p" > /sys/kernel/debug/dynamic_debug/control
>>>>>>>
>>>>>>> In addition apply the following:
>>>>>>> --
>>>>>>> diff --git a/drivers/infiniband/hw/mlx5/mr.c
>>>>>>> b/drivers/infiniband/hw/mlx5/mr.c
>>>>>>> index d9c6c0ea750b..040fbc387e4f 100644
>>>>>>> --- a/drivers/infiniband/hw/mlx5/mr.c
>>>>>>> +++ b/drivers/infiniband/hw/mlx5/mr.c
>>>>>>> @@ -1403,6 +1403,8 @@ mlx5_alloc_priv_descs(struct ib_device *device,
>>>>>>>          int add_size;
>>>>>>>          int ret;
>>>>>>>
>>>>>>> +       WARN_ON_ONCE(ndescs >
>>>>>>> device->attr.max_fast_reg_page_list_len);
>>>>>>> +
>>>>>>>          add_size = max_t(int, MLX5_UMR_ALIGN -
>>>>>>>          ARCH_KMALLOC_MINALIGN,
>>>>>>>          0);
>>>>>>>
>>>>>>>          mr->descs_alloc = kzalloc(size + add_size, GFP_KERNEL);
>>>>>>>
>>>>>>> "
>>>>>>>
>>>>>>> Max.
>>>>>>>
>>>>>>>>
>>>>>>>> Built and tested the kernel.
>>>>>>>>
>>>>>>>> However this issue is not resolved :(
>>>>>>>>
>>>>>>>> [ 2707.931909] scsi host1: ib_srp: failed RECV status WR flushed (5)
>>>>>>>> for
>>>>>>>> CQE ffff8817edca86b0
>>>>>>>> [ 2708.089806] mlx5_0:dump_cqe:262:(pid 20129): dump error cqe
>>>>>>>> [ 2708.121342] 00000000 00000000 00000000 00000000
>>>>>>>> [ 2708.147104] 00000000 00000000 00000000 00000000
>>>>>>>> [ 2708.172633] 00000000 00000000 00000000 00000000
>>>>>>>> [ 2708.198702] 00000000 0f007806 2500002a 14a527d0
>>>>>>>> [ 2732.434127] scsi host1: ib_srp: reconnect succeeded
>>>>>>>> [ 2733.048023] scsi host1: ib_srp: failed RECV status WR flushed (5)
>>>>>>>> for
>>>>>>>> CQE ffff8817ed0a9c30
>>>>>>>>
>>>>>>>> [root@localhost ~]# [ 2746.413277] mlx5_0:dump_cqe:262:(pid 15877):
>>>>>>>> dump
>>>>>>>> error cqe
>>>>>>>> [ 2746.443240] 00000000 00000000 00000000 00000000
>>>>>>>> [ 2746.469323] 00000000 00000000 00000000 00000000
>>>>>>>> [ 2746.495310] 00000000 00000000 00000000 00000000
>>>>>>>> [ 2746.521407] 00000000 0f007806 25000032 003c7ad0
>>>>>>>> [ 2752.445899] scsi host1: ib_srp: reconnect succeeded
>>>>>>>> [ 2752.481835] scsi host1: ib_srp: failed RECV status WR flushed (5)
>>>>>>>> for
>>>>>>>> CQE ffff8817ed0a9cf0
>>>>>>>> [ 2763.267386] mlx5_0:dump_cqe:262:(pid 15877): dump error cqe
>>>>>>>> [ 2763.297826] 00000000 00000000 00000000 00000000
>>>>>>>> [ 2763.323352] 00000000 00000000 00000000 00000000
>>>>>>>> [ 2763.348722] 00000000 00000000 00000000 00000000
>>>>>>>> [ 2763.374681] 00000000 0f007806 2500003a 00084bd0
>>>>>>>>
>>>>>>>> [root@localhost ~]# [ 2769.385203] fast_io_fail_tmo expired for SRP
>>>>>>>> port-1:1 / host1.
>>>>>>>> [ 2769.415956] scsi host1: ib_srp: reconnect succeeded
>>>>>>>> [ 2769.450258] scsi host1: ib_srp: failed RECV status WR flushed (5)
>>>>>>>> for
>>>>>>>> CQE ffff8817ed0a9cf0
>>>>>>>> [ 2780.064627] mlx5_0:dump_cqe:262:(pid 18771): dump error cqe
>>>>>>>> [ 2780.093520] 00000000 00000000 00000000 00000000
>>>>>>>> [ 2780.120067] 00000000 00000000 00000000 00000000
>>>>>>>> [ 2780.145575] 00000000 00000000 00000000 00000000
>>>>>>>> [ 2780.171153] 00000000 0f007806 25000042 000833d0
>>>>>>>> [ 2785.923399] scsi host1: ib_srp: reconnect succeeded
>>>>>>>> [ 2785.957504] scsi host1: ib_srp: failed RECV status WR flushed (5)
>>>>>>>> for
>>>>>>>> CQE ffff8817ed0a9cf0
>>>>>>>> [ 2796.463426] mlx5_0:dump_cqe:262:(pid 18771): dump error cqe
>>>>>>>> [ 2796.495257] 00000000 00000000 00000000 00000000
>>>>>>>> [ 2796.521506] 00000000 00000000 00000000 00000000
>>>>>>>> [ 2796.547640] 00000000 00000000 00000000 00000000
>>>>>>>> [ 2796.573120] 00000000 0f007806 2500004a 00083bd0
>>>>>>>> [ 2802.562578] scsi host1: ib_srp: reconnect succeeded
>>>>>>>> [ 2802.596880] scsi host1: ib_srp: failed RECV status WR flushed (5)
>>>>>>>> for
>>>>>>>> CQE ffff8817ed0a9cf0
>>>>>>>>
>>>>>>>> Regards
>>>>>>>> Laurence
>>>>>>>>
>>>>>>>
>>>>>> Doing this now
>>>>>> Thanks
>>>>>> Laurence
>>>>>
>>>>> Max
>>>>>
>>>>> The Patch is not correct.
>>>>>
>>>>> drivers/infiniband/hw/mlx5/mr.c: In function 'mlx5_alloc_priv_descs':
>>>>> drivers/infiniband/hw/mlx5/mr.c:1406:30: error: 'struct ib_device' has
>>>>> no
>>>>> member named 'attr'
>>>>>   WARN_ON_ONCE(ndescs > device->attr.max_fast_reg_page_list_len);
>>>>>                               ^
>>>>> ./include/asm-generic/bug.h:117:27: note: in definition of macro
>>>>> 'WARN_ON_ONCE'
>>>>>   int __ret_warn_once = !!(condition);   \
>>>>>
>>>>> I think you meant to give me
>>>>>
>>>>> WARN_ON_ONCE(ndescs > ib_device_attr->attr.max_fast_reg_page_list_len);
>>>>>
>>>>> Can you confirm
>>>>
>>>> Hi Laurence,
>>>> should be device->attrs.max_fast_reg_page_list_len.
>>>>
>>>> please check this one that might solve the issue (on top of everything):
>>>>
>>>>
>>>> diff --git a/drivers/infiniband/hw/mlx5/mr.c
>>>> b/drivers/infiniband/hw/mlx5/mr.c
>>>> index b8f9382..063d116 100644
>>>> --- a/drivers/infiniband/hw/mlx5/mr.c
>>>> +++ b/drivers/infiniband/hw/mlx5/mr.c
>>>> @@ -1559,7 +1559,7 @@ struct ib_mr *mlx5_ib_alloc_mr(struct ib_pd *pd,
>>>>                  mr->max_descs = ndescs;
>>>>          } else if (mr_type == IB_MR_TYPE_SG_GAPS) {
>>>>                  mr->access_mode = MLX5_MKC_ACCESS_MODE_KLMS;
>>>> -
>>>> +               MLX5_SET(mkc, mkc, translations_octword_size,
>>>> ALIGN(max_num_sg + 1, 4));
>>>>                  err = mlx5_alloc_priv_descs(pd->device, mr,
>>>>                                              ndescs, sizeof(struct
>>>> mlx5_klm));
>>>>                  if (err)
>>>>
>>>> thanks,
>>>> Max.
>>>>
>>>>>
>>>>> Thanks
>>>>> Laurence
>>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>
>>> Hello Max
>>>
>>> I have the corrected WARN_ON_ONCE patch and the above patch as well as the
>>> rest as it was from Barts tree.
>>>
>>> Still fails.
>>>
>>> For a baseline I can revert
>>> a83e404 IB/srp: Reenable IB_MR_TYPE_SG_GAPS
>>>
>>> Then test again to make sure we are starting from a good place.
>>>
>>> Initiator log
>>>
>>> [  280.481951] scsi host1: ib_srp: failed FAST REG status memory management
>>> operation error (6) for CQE ffff8817d9a881b8
>>> [  301.149106] scsi host1: ib_srp: reconnect succeeded
>>> [  301.280635] scsi host1: ib_srp: failed RECV status WR flushed (5) for
>>> CQE
>>> ffff8817ed32f2f0
>>> [  334.596420] scsi host2: ib_srp: failed RECV status WR flushed (5) for
>>> CQE
>>> ffff8817c592c970
>>> [  334.599689] mlx5_1:dump_cqe:262:(pid 20): dump error cqe
>>> [  334.599691] 00000000 00000000 00000000 00000000
>>> [  334.599692] 00000000 00000000 00000000 00000000
>>> [  334.599692] 00000000 00000000 00000000 00000000
>>> [  334.599693] 00000000 0f007806 2500002d 067b48d0
>>> [  334.599697] scsi host2: ib_srp: failed FAST REG status memory management
>>> operation error (6) for CQE ffff8817c6e30078
>>> [  336.117248] mlx5_0:dump_cqe:262:(pid 130): dump error cqe
>>> [  336.145840] 00000000 00000000 00000000 00000000
>>> [  336.171830] 00000000 00000000 00000000 00000000
>>> [  336.197688] 00000000 00000000 00000000 00000000
>>> [  336.223720] 00000000 0f007806 25000032 005408d0
>>> [  339.712706] fast_io_fail_tmo expired for SRP port-1:1 / host1.
>>> [  341.453634] scsi host1: ib_srp: reconnect succeeded
>>> [  341.481600] mlx5_0:dump_cqe:262:(pid 130): dump error cqe
>>> [  341.482145] scsi host1: ib_srp: failed RECV status WR flushed (5) for
>>> CQE
>>> ffff8817ecaf6970
>>> [  341.559359] 00000000 00000000 00000000 00000000
>>> [  341.585397] 00000000 00000000 00000000 00000000
>>> [  341.610948] 00000000 00000000 00000000 00000000
>>> [  341.637515] 00000000 0f007806 2500003d 000046d0
>>> [  342.297598] sd 1:0:0:9: rejecting I/O to offline device
>>> [  342.297936] sd 1:0:0:9: [sdg] tag#28 FAILED Result:
>>> hostbyte=DID_TRANSPORT_FAILFAST driverbyte=DRIVER_OK
>>> [  342.297941] sd 1:0:0:9: [sdg] tag#28 CDB: Write(10) 2a 00 00 00 40 00 00
>>> 40 00 00
>>> [  342.297943] blk_update_request: recoverable transport error, dev sdg,
>>> sector 16384
>>> [  342.297951] sd 1:0:0:20: [sdar] tag#5 FAILED Result:
>>> hostbyte=DID_TRANSPORT_FAILFAST driverbyte=DRIVER_OK
>>> [  342.297952] sd 1:0:0:20: [sdar] tag#15 FAILED Result:
>>> hostbyte=DID_TRANSPORT_FAILFAST driverbyte=DRIVER_OK
>>> [  342.297956] sd 1:0:0:20: [sdar] tag#5 CDB: Write(10) 2a 00 00 03 c0 00
>>> 00
>>> 40 00 00
>>> [  342.297956] sd 1:0:0:20: [sdar] tag#15 CDB: Write(10) 2a 00 00 2c c0 00
>>> 00
>>> 40 00 00
>>> [  342.297958] blk_update_request: recoverable transport error, dev sdar,
>>> sector 245760
>>> [  342.297959] blk_update_request: recoverable transport error, dev sdar,
>>> sector 2932736
>>> [  342.298119] device-mapper: multipath: Failing path 8:96.
>>> [  342.298266] sd 1:0:0:9: [sdg] tag#29 FAILED Result:
>>> hostbyte=DID_TRANSPORT_FAILFAST driverbyte=DRIVER_OK
>>> [  342.298268] sd 1:0:0:9: [sdg] tag#29 CDB: Write(10) 2a 00 00 00 c0 00 00
>>> 40 00 00
>>> [  342.298269] blk_update_request: recoverable transport error, dev sdg,
>>> sector 49152
>>> [  342.298300] device-mapper: multipath: Failing path 66:176.
>>> [  342.298486] sd 1:0:0:20: [sdar] tag#16 FAILED Result:
>>> hostbyte=DID_TRANSPORT_FAILFAST driverbyte=DRIVER_OK
>>> [  342.298488] sd 1:0:0:20: [sdar] tag#6 FAILED Result:
>>> hostbyte=DID_TRANSPORT_FAILFAST driverbyte=DRIVER_OK
>>> [  342.298489] sd 1:0:0:20: [sdar] tag#16 CDB: Write(10) 2a 00 00 2d 40 00
>>> 00
>>> 40 00 00
>>> [  342.298490] sd 1:0:0:20: [sdar] tag#6 CDB: Write(10) 2a 00 00 04 40 00
>>> 00
>>> 40 00 00
>>> [  342.298491] blk_update_request: recoverable transport error, dev sdar,
>>> sector 2965504
>>> [  342.298492] blk_update_request: recoverable transport error, dev sdar,
>>> sector 278528
>>> [  342.298582] sd 1:0:0:9: [sdg] tag#30 FAILED Result:
>>> hostbyte=DID_TRANSPORT_FAILFAST driverbyte=DRIVER_OK
>>> [  342.298584] sd 1:0:0:9: [sdg] tag#30 CDB: Write(10) 2a 00 00 01 40 00 00
>>> 40 00 00
>>> [  342.298585] blk_update_request: recoverable transport error, dev sdg,
>>> sector 81920
>>> [  342.298889] sd 1:0:0:9: [sdg] tag#31 FAILED Result:
>>> hostbyte=DID_TRANSPORT_FAILFAST driverbyte=DRIVER_OK
>>> [  342.298890] sd 1:0:0:9: [sdg] tag#31 CDB: Write(10) 2a 00 00 01 c0 00 00
>>> 40 00 00
>>> [  342.298891] blk_update_request: recoverable transport error, dev sdg,
>>> sector 114688
>>> [  342.298981] sd 1:0:0:20: [sdar] tag#7 FAILED Result:
>>> hostbyte=DID_TRANSPORT_FAILFAST driverbyte=DRIVER_OK
>>> [  342.298983] sd 1:0:0:20: [sdar] tag#7 CDB: Write(10) 2a 00 00 04 c0 00
>>> 00
>>> 40 00 00
>>> [  342.298985] blk_update_request: recoverable transport error, dev sdar,
>>> sector 311296
>>> [  342.299004] sd 1:0:0:20: [sdar] tag#17 FAILED Result:
>>> hostbyte=DID_TRANSPORT_FAILFAST driverbyte=DRIVER_OK
>>> [  342.299007] sd 1:0:0:20: [sdar] tag#17 CDB: Write(10) 2a 00 00 34 c0 00
>>> 00
>>> 40 00 00
>>> [  342.299009] blk_update_request: recoverable transport error, dev sdar,
>>> sector 3457024
>>> [  342.356353] device-mapper: multipath: Failing path 8:64.
>>> [  342.356489] device-mapper: multipath: Failing path 8:128.
>>> [  342.356628] device-mapper: multipath: Failing path 8:160.
>>> [  342.356699] device-mapper: multipath: Failing path 8:176.
>>> [  342.356767] device-mapper: multipath: Failing path 8:240.
>>> [  342.356834] device-mapper: multipath: Failing path 8:208.
>>> [  342.356900] device-mapper: multipath: Failing path 65:16.
>>> [  342.356967] device-mapper: multipath: Failing path 65:64.
>>> [  342.357035] device-mapper: multipath: Failing path 65:96.
>>> [  342.357103] device-mapper: multipath: Failing path 65:128.
>>> [  342.357169] device-mapper: multipath: Failing path 65:176.
>>> [  342.357237] device-mapper: multipath: Failing path 65:208.
>>> [  342.357303] device-mapper: multipath: Failing path 65:224.
>>> [  342.357371] device-mapper: multipath: Failing path 66:0.
>>> [  342.357454] device-mapper: multipath: Failing path 66:32.
>>> [  342.357521] device-mapper: multipath: Failing path 66:48.
>>> [  342.357647] device-mapper: multipath: Failing path 66:80.
>>> [  342.357714] device-mapper: multipath: Failing path 66:112.
>>> [  342.357781] device-mapper: multipath: Failing path 66:144.
>>> [  342.357936] device-mapper: multipath: Failing path 66:208.
>>> [  342.358019] device-mapper: multipath: Failing path 66:240.
>>> [  342.358115] device-mapper: multipath: Failing path 67:16.
>>> [  342.358183] device-mapper: multipath: Failing path 67:48.
>>> [  342.358264] device-mapper: multipath: Failing path 67:80.
>>> [  342.358359] device-mapper: multipath: Failing path 67:128.
>>> [  342.358442] device-mapper: multipath: Failing path 67:160.
>>> [  342.358594] device-mapper: multipath: Failing path 67:224.
>>> [  342.358671] device-mapper: multipath: Failing path 67:208.
>>> [  350.157728] scsi host2: ib_srp: reconnect succeeded
>>> [  350.189605] mlx5_1:dump_cqe:262:(pid 4756): dump error cqe
>>> [  350.193180] mlx5_1:dump_cqe:262:(pid 1275): dump error cqe
>>> [  350.193182] 00000000 00000000 00000000 00000000
>>> [  350.193182] 00000000 00000000 00000000 00000000
>>> [  350.193183] 00000000 00000000 00000000 00000000
>>> [  350.193183] 00000000 0f007806 25000035 04f569d0
>>> [  350.193187] scsi host2: ib_srp: failed FAST REG status memory management
>>> operation error (6) for CQE ffff8817c6e30078
>>> [  350.412637] 00000000 00000000 00000000 00000000
>>> [  350.436431] 00000000 00000000 00000000 00000000
>>> [  350.461871] 00000000 00000000 00000000 00000000
>>> [  350.487549] 00000000 0f007806 25000032 000843d0
>>>
>>> Target Log
>>>
>>> Thee events happened after the first failures on the initiator
>>>
>>> [ 1111.029847] ib_srpt Received CM TimeWait exit for ch
>>> 0x4f6e72000390fe7c7cfe900300726ed3-49.
>>> [ 1111.078815] ib_srpt Received CM TimeWait exit for ch
>>> 0x4f6e72000390fe7c7cfe900300726ed3-48.
>>> [ 1111.127420] ib_srpt Received CM TimeWait exit for ch
>>> 0x4f6e72000390fe7c7cfe900300726ed3-47.
>>> [ 1111.175801] ib_srpt Received CM TimeWait exit for ch
>>> 0x4f6e72000390fe7c7cfe900300726ed3-46.
>>> [ 1111.223725] ib_srpt Received CM TimeWait exit for ch
>>> 0x4f6e72000390fe7c7cfe900300726ed3-45.
>>> [ 1111.271957] ib_srpt Received CM TimeWait exit for ch
>>> 0x4f6e72000390fe7c7cfe900300726ed3-44.
>>> [ 1111.319494] ib_srpt Received CM TimeWait exit for ch
>>> 0x4f6e72000390fe7c7cfe900300726ed3-43.
>>> [ 1111.365795] ib_srpt Received CM TimeWait exit for ch
>>> 0x4f6e72000390fe7c7cfe900300726ed3-42.
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>> Max
>>
>> These are the parameters all my tests run with.
>> Same as always.
>>
>> [root@localhost modprobe.d]# cat ib_srp.conf
>> options ib_srp cmd_sg_entries=255 indirect_sg_entries=2048
>>
>> I dont set prefer_fr so it defaults to Y
>>
>> [root@localhost parameters]# cat prefer_fr
>> Y
>>
>> I have no settings for mlx5_core, all defaults.
>>
>> Thanks
>> Laurence
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> Max,
>
> Reverting a83e404 IB/srp: Reenable IB_MR_TYPE_SG_GAPS on the same source tree with all esle applied I am stable.
> So clearly we still have issues with IB_MR_TYPE_SG_GAPS.
>
> Thanks
> Laurence
>

Hi Laurence,
I would like to see the prints that Sagi asked in the srp_add_one 
function (echo "func srp_add_one +p" > 
/sys/kernel/debug/dynamic_debug/control) and also prints from 
srp_create_target (echo "func srp_create_target +p" > 
/sys/kernel/debug/dynamic_debug/control).

another patch can help is:

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c 
b/drivers/infiniband/ulp/srp/ib_srp.c
index cee4626..53a67fd 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3387,6 +3387,10 @@ static ssize_t srp_create_target(struct device *dev,
                              sizeof (struct srp_indirect_buf) +
                              target->cmd_sg_cnt * sizeof (struct 
srp_direct_buf);

+       pr_info("sg_tablesize %u mr_pool_size %u mr_per_cmd %u 
indirect_size %u max_iu_len %u max_sectors %u\n",
+               target->sg_tablesize, target->mr_pool_size, 
target->mr_per_cmd, target->indirect_size,
+               target->max_iu_len, target->scsi_host->max_sectors);
+
         INIT_WORK(&target->tl_err_work, srp_tl_err_work);
         INIT_WORK(&target->remove_work, srp_remove_work);
         spin_lock_init(&target->lock);


please add also the SG_GAPS Reenable commit and let's repro it again.
BTW, how many channels are open ?
can you load ib_srp module with ch_count param changes from 4 to 
#num_cpus and let's see when we get to repro it again.

thanks,
Max.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
