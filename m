From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V4 for-next 4/4] IB/ipoib: Support SendOnlyFullMember MCG
 for SendOnly join
Date: Wed, 18 May 2016 15:28:04 +0300
Message-ID: <CAAk-MO_1BxGbCkVW4whUb3mywddSacS64YB4YEmM0mKkVYyg8w@mail.gmail.com>
References: <1463401694-19247-1-git-send-email-erezsh@mellanox.com>
	<1463401694-19247-5-git-send-email-erezsh@mellanox.com>
	<20160517201023.GC17141@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160517201023.GC17141-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 17, 2016 at 11:10 PM, ira.weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> On Mon, May 16, 2016 at 03:28:14PM +0300, Erez Shitrit wrote:
>>
>> Check (via an SA query) if the SM supports the new option for SendOnly
>> multicast joins.
>> If the SM supports that option it will use the new join state to create
>> such multicast group.
>> If SendOnlyFullMember is supported, we wouldn't use faked FullMember state
>> join for SendOnly MCG, use the correct state if supported.
>>
>> This check is performed at every invocation of mcast_restart task, to be
>> sure that the driver stays in sync with the current state of the SM.
>>
>> Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>>  drivers/infiniband/ulp/ipoib/ipoib.h           |  2 +
>>  drivers/infiniband/ulp/ipoib/ipoib_main.c      | 72 ++++++++++++++++++++++++++
>>  drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 38 +++++++++-----
>>  3 files changed, 99 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
>> index caec8e9..c51f618 100644
>> --- a/drivers/infiniband/ulp/ipoib/ipoib.h
>> +++ b/drivers/infiniband/ulp/ipoib/ipoib.h
>> @@ -392,6 +392,7 @@ struct ipoib_dev_priv {
>>       struct ipoib_ethtool_st ethtool;
>>       struct timer_list poll_timer;
>>       unsigned max_send_sge;
>> +     bool sm_fullmember_sendonly_support;
>>  };
>>
>>  struct ipoib_ah {
>> @@ -476,6 +477,7 @@ void ipoib_reap_ah(struct work_struct *work);
>>
>>  void ipoib_mark_paths_invalid(struct net_device *dev);
>>  void ipoib_flush_paths(struct net_device *dev);
>> +int ipoib_check_sm_sendonly_fullmember_support(struct ipoib_dev_priv *priv);
>>  struct ipoib_dev_priv *ipoib_intf_alloc(const char *format);
>>
>>  int ipoib_ib_dev_init(struct net_device *dev, struct ib_device *ca, int port);
>> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
>> index 3b630e5..72be933 100644
>> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
>> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
>> @@ -117,6 +117,8 @@ int ipoib_open(struct net_device *dev)
>>
>>       set_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags);
>>
>> +     priv->sm_fullmember_sendonly_support = false;
>> +
>>       if (ipoib_ib_dev_open(dev)) {
>>               if (!test_bit(IPOIB_PKEY_ASSIGNED, &priv->flags))
>>                       return 0;
>> @@ -629,6 +631,76 @@ void ipoib_mark_paths_invalid(struct net_device *dev)
>>       spin_unlock_irq(&priv->lock);
>>  }
>>
>> +struct classport_info_context {
>> +     struct ipoib_dev_priv   *priv;
>> +     struct completion       done;
>> +     struct ib_sa_query      *sa_query;
>> +};
>> +
>> +static void classport_info_query_cb(int status, struct ib_class_port_info *rec,
>> +                                 void *context)
>> +{
>> +     struct classport_info_context *cb_ctx = context;
>> +     struct ipoib_dev_priv *priv;
>> +
>> +     WARN_ON(!context);
>> +
>> +     priv = cb_ctx->priv;
>> +
>> +     if (status) {
>> +             pr_debug("device: %s failed query classport_info status: %d\n",
>> +                      priv->dev->name, status);
>> +             /* keeps the default, will try next mcast_restart */
>> +             priv->sm_fullmember_sendonly_support = false;
>> +             goto out;
>> +     }
>> +     if (ib_get_cpi_capmask2(rec) &
>
> rec may be NULL here from the SA code.

I am not sure it can happened, here is where the mad was returned
successfully (status = 0)
to be on the safe case i will add a check.
Thanks,

>
> Ira
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
