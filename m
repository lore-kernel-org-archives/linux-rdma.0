From: Sumeet Lahorani <Sumeet.Lahorani-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: root owned writeable files under /sys
Date: Wed, 09 Jun 2010 00:20:24 -0700
Message-ID: <4C0F40B8.8060000@oracle.com>
References: <4C082598.8000809@oracle.com>	<4C0B2B24.6020304@Voltaire.com>	<4C0BC819.1060201@oracle.com> <AANLkTikpFbgHyXoeQQt5wU4WkpbXQnqXUYRoy718qSuW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikpFbgHyXoeQQt5wU4WkpbXQnqXUYRoy718qSuW-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


You are right. The mlx4_port* files are world writeable in ofed 1.4.2 
but not in 1.5.1.

static int mlx4_init_port_info(struct mlx4_dev *dev, int port)
{
        struct mlx4_port_info *info = &mlx4_priv(dev)->port[port];
        struct attribute attr = {.name = info->dev_name,
                                        .mode =  S_IWUGO | S_IRUGO};

- Sumeet

Eli Cohen wrote:
> I don't understand why mlx4_port1 and mlx4_port2 have world write
> permissions on your system. I can't see this from the sources nor from
> installing ofed-1.5.1 on my system. I agree though that the
> permissions for port_trigger and clear_diag should be changed. We'll
> push a fix to OFED 1.5.2.
>
> On Sun, Jun 6, 2010 at 7:08 PM, Sumeet Lahorani
> <Sumeet.Lahorani-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>   
>> Thanks. I realized that my earlier find command didn't capture all the files
>> I was looking for. After your patch, the following still need to be
>> addressed (all are mlx4 files)
>>
>> # find /sys -type f -perm -222
>> /sys/class/infiniband/mlx4_0/diag_counters/clear_diag
>> /sys/devices/pci0000:00/0000:00:04.0/0000:13:00.0/port_trigger
>> /sys/devices/pci0000:00/0000:00:04.0/0000:13:00.0/mlx4_port2
>> /sys/devices/pci0000:00/0000:00:04.0/0000:13:00.0/mlx4_port1
>>
>> - Sumeet
>>
>> Or Gerlitz wrote:
>>     
>>> Sumeet Lahorani wrote:
>>>
>>>       
>>>> I see the following files created under /sys which are world writeable
>>>> /sys/class/net/ib0/delete_child
>>>> /sys/class/net/ib0/create_child
>>>> At least the create_child & delete_child files appear to be dangerous to
>>>> leave as world writeable because they result in resources allocations.
>>>>
>>>>         
>>> Yes, this looks bad. The below patch fixes that, I tested it on 2.6.35-rc1
>>>
>>> [PATCH] make ipoib child entries non-world writable
>>>
>>> Sumeet Lahorani <sumeet.lahorani-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> reported that the ipoib child
>>> entries are world writable, fix them to be root only writable
>>>
>>> Signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
>>>
>>> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c
>>> b/drivers/infiniband/ulp/ipoib/ipoib_main.c
>>> index df3eb8c..b4b2257 100644
>>> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
>>> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
>>> @@ -1163,7 +1163,7 @@ static ssize_t create_child(struct device *dev,
>>>        return ret ? ret : count;
>>>  }
>>> -static DEVICE_ATTR(create_child, S_IWUGO, NULL, create_child);
>>> +static DEVICE_ATTR(create_child, S_IWUSR, NULL, create_child);
>>>  static ssize_t delete_child(struct device *dev,
>>>                            struct device_attribute *attr,
>>> @@ -1183,7 +1183,7 @@ static ssize_t delete_child(struct device *dev,
>>>        return ret ? ret : count;
>>>  }
>>> -static DEVICE_ATTR(delete_child, S_IWUGO, NULL, delete_child);
>>> +static DEVICE_ATTR(delete_child, S_IWUSR, NULL, delete_child);
>>>  int ipoib_add_pkey_attr(struct net_device *dev)
>>>  {
>>>
>>>       
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>     

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
