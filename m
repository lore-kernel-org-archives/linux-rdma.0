From: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 4/8] bnxt_re: Free up devices in module_exit path
Date: Thu, 14 Sep 2017 09:23:53 +0530
Message-ID: <CAOBf=mupXRmhNoZOfwhr-Ho7_y-Kts4XmgtHgpMQVosmj=Hpcw@mail.gmail.com>
References: <20170831035735.19595-1-somnath.kotur@broadcom.com>
 <20170831035735.19595-5-somnath.kotur@broadcom.com> <20170913174255.GV3405@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170913174255.GV3405-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Leon,

On Wed, Sep 13, 2017 at 11:12 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Thu, Aug 31, 2017 at 09:27:31AM +0530, Somnath Kotur wrote:
>> Clean up all devices added to the bnxt_re_dev_list in the
>> module_exit entry point.
>>
>> Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>> ---
>>  drivers/infiniband/hw/bnxt_re/main.c | 16 ++++++++++++++++
>>  1 file changed, 16 insertions(+)
>>
>> diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
>> index 82d1cbc..00a3b74 100644
>> --- a/drivers/infiniband/hw/bnxt_re/main.c
>> +++ b/drivers/infiniband/hw/bnxt_re/main.c
>> @@ -1375,6 +1375,22 @@ static int __init bnxt_re_mod_init(void)
>>
>>  static void __exit bnxt_re_mod_exit(void)
>>  {
>> +     struct bnxt_re_dev *rdev;
>> +     LIST_HEAD(to_be_deleted);
>> +
>> +     mutex_lock(&bnxt_re_dev_lock);
>> +     /* Free all adapter allocated resources */
>> +     if (!list_empty(&bnxt_re_dev_list))
>
> Hi Somnath,
>
> How is it possible to have the bnxt_re_dev_list to be empty at this
> stage? Doesn't the call to bnxt_re_mod_exit mean that at least one entry
> exists?
Well, there is a possibility that NETDEV_UNREGISTER got invoked (not
via rmmod , but via the pci-sysfs route)
and this list is empty by the time rmmod of the bnxt_re was invoked.

Thanks
Som
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
