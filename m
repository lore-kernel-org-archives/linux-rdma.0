From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v2 for-next 5/7] IB/mlx4: Add IB counters table
Date: Fri, 25 Dec 2015 09:50:13 -0500
Message-ID: <567D57A5.2050908@dev.mellanox.co.il>
References: <1444909482-17113-1-git-send-email-eranbe@mellanox.com>
 <1444909482-17113-6-git-send-email-eranbe@mellanox.com>
 <567BC52B.4030801@dev.mellanox.co.il> <567BCA3F.7050502@mellanox.com>
 <567BCBF8.30006@dev.mellanox.co.il> <567BE756.9050005@mellanox.com>
 <CAAKD3BBsv8Qe=RZvCTOa=0kuSAqYetx4NOok_Tcp5xtUz+Ggtw@mail.gmail.com>
 <CAAKD3BB5-hUC=0bDqxXxuag9TPqQEeMD74paHrAMOc-MsQwEow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAKD3BB5-hUC=0bDqxXxuag9TPqQEeMD74paHrAMOc-MsQwEow-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/24/2015 11:09 AM, Matan Barak wrote:
> On Thu, Dec 24, 2015 at 4:07 PM, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>> On Thu, Dec 24, 2015 at 2:38 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>>> On 12/24/2015 12:42 PM, Sagi Grimberg wrote:
>>>>
>>>>
>>>>>> This patch seems to generate a list corruption [1] when I test
>>>>>> with Doug's for-4.5 tree. Eran, care to take a look at this?
>>>>>
>>>>>
>>>>> This patch is part from a series that was introduced in 4.3-rc1 [1],
>>>>
>>>>
>>>> Then something else broke it. Can people check their patches on doug's
>>>> tree? At the moment it's unusable...
>>>
>>
>> Leon and I have checked Doug's tree with mlx4_ib disabled and we
>> didn't encounter any error.
>> We ran ucmatose over IB connection (in mlx5) and it worked flawlessly.
>>
>>>
>>> Yes, I checked the branch up to commit 882f3b3 "Merge branches
>>> '4.5/Or-cleanup' and '4.5/rdma-cq' into k.o/for-4.5" and it works (rping,
>>> ibv_rc_pingpong over top of mlx4 VPI)
>>>
> 
> Regarding mlx4, Eran and I analyzed it. We didn't test that, but it
> seems like the bug is introduced in the 64bit counters test. Here's a
> proposal:
> 
> diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
> index 539040f..8da3c83 100644
> --- a/drivers/infiniband/core/sysfs.c
> +++ b/drivers/infiniband/core/sysfs.c
> @@ -714,11 +714,12 @@ err:
>   * Figure out which counter table to use depending on
>   * the device capabilities.
>   */
> -static struct attribute_group *get_counter_table(struct ib_device *dev)
> +static struct attribute_group *get_counter_table(struct ib_device *dev,
> +                                          int port_num)
>  {
>         struct ib_class_port_info cpi;
> 
> -   if (get_perf_mad(dev, 0, IB_PMA_CLASS_PORT_INFO,
> + if (get_perf_mad(dev, port_num, IB_PMA_CLASS_PORT_INFO,
>                                 &cpi, 40, sizeof(cpi)) >= 0) {

Your proposal is similar to earlier version of Christoph's patch but was
changed since ClassPortInfo attribute does not have PortSelect field
like other PerfMgt attributes which is where this port num would be
placed. In ClassPortInfo attribute, that location would be the
ClassVersion field that would be set to port number in PerfMgt Get query.

-- Hal

> 
>                 if (cpi.capability_mask && IB_PMA_CLASS_CAP_EXT_WIDTH)
> @@ -776,7 +777,7 @@ static int add_port(struct ib_device *device, int port_num,
>                 goto err_put;
>         }
> 
> -   p->pma_table = get_counter_table(device);
> + p->pma_table = get_counter_table(device, port_num);
>         ret = sysfs_create_group(&p->kobj, p->pma_table);
>         if (ret)
>                 goto err_put_gid_attrs;
> 
> 
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
