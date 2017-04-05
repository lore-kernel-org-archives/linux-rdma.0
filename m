From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-next 6/6] IB/IPoIB: Support acceleration options callbacks
Date: Wed, 5 Apr 2017 14:25:46 +0300
Message-ID: <CAAk-MO-ZP-55ivds9nyJQ7+U4MA-rZNEFxHqcXuJZy_iUb3xpg@mail.gmail.com>
References: <20170404191732.31895-1-leon@kernel.org> <20170404191732.31895-7-leon@kernel.org>
 <20170404194234.GB10780@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170404194234.GB10780-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 4, 2017 at 10:42 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Tue, Apr 04, 2017 at 10:17:32PM +0300, Leon Romanovsky wrote:
>> -/* Keep the refactoring compile able */
>> -#define ipoib_priv netdev_priv
>> +static inline void *ipoib_priv(const struct net_device *dev)
>> +{
>> +     struct rdma_netdev *rn = netdev_priv(dev);
>> +
>> +     return rn->clnt_priv;
>> +}
>
> This should return struct ipoib_dev_priv *
>
>>  static ssize_t show_pkey(struct device *dev,
>>                        struct device_attribute *attr, char *buf)
>>  {
>> -     struct ipoib_dev_priv *priv = netdev_priv(to_net_dev(dev));
>> +     struct ipoib_dev_priv *priv = ipoib_priv(to_net_dev(dev));
>
> Several of these seem to be in the wrong patch

will fix that.
thanks !

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
