From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [RFC v1 for accelerated IPoIB 05/25] IB/ipoib: Support ipoib
 acceleration options callbacks
Date: Tue, 14 Mar 2017 16:39:20 +0200
Message-ID: <CAAk-MO8-bnWRu7BDtYDhNePj+76X4Vb7gFNhED8irLNtqR7tCw@mail.gmail.com>
References: <1489429896-10781-1-git-send-email-erezsh@mellanox.com>
 <1489429896-10781-6-git-send-email-erezsh@mellanox.com> <20170313201049.GB2738@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170313201049.GB2738-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 13, 2017 at 10:10 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Mon, Mar 13, 2017 at 08:31:16PM +0200, Erez Shitrit wrote:
>
>> TODO: We added remote qkey to ipoib_send in order to match send op
>> signature.
>> In accel mode this param will be used but in regular mode this param is
>> redundant. Need to think about better solution.
>
> The flow is backwards, in accel mode the xmit ndo should be owend by
> the driver and the driver should call a helper to get all the proper
> AH data, including qkey.
>
>> -static int ipoib_dev_init_default(struct net_device *dev, struct ib_device *ca,
>> -                               int port)
>> +static int ipoib_dev_init_default(struct net_device *dev,
>> +                               struct ib_device *hca, int *qp_num)
>>  {
>> -     struct ipoib_dev_priv *priv = netdev_priv(dev);
>> +     struct ipoib_dev_priv *priv = ipoib_priv(dev);
>> +
>> +     netif_napi_add(dev, &priv->napi, ipoib_poll, NAPI_POLL_WEIGHT);
>
> All these 'default' functions are part of the 'rn driver'. They should
> not be calling ipoib_priv, you said you didn't want ipoib_dev_priv
> leaking into the drivers.

Do you mean in the name of the function?   drma_netdev_init_default
instead of ipoib_dev_init_default ?

>
> These _default funcs should use ipoib_dev_priv and all the members of
> ipoib_dev_priv that are used exclusively by the 'default'
> implementation need to be moved into a dedicated priv struct.
>
> Otherwise the entire scheme become hugely confusing about what in
> ipoib_dev_priv is actually valid in accel mode.

ipoib_dev_priv is used in both modes accel and "default", it keeps all
the control data/flows, the accel mode handle only the data path.

>
> I think it would be much easier to maintain if the _default functions were
> all in a dedicated files, eg rn_ipoib_ud_verbs.c
>
> I also recommend splitting out the bulk rename of ipoib_priv into a
> single patch with a '#define ipoib_priv(dev) netdev_priv(dev)'
> shim. That would make this patch much smaller.

OK.

>
> IHMO you probably don't need to send the mlx5 stuff until the series
> up to here is OK. I think we all understand that mlx5 can implement
> this API?

OK, agree. will check that with our people that handle the mlx5 stuff.

>
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
