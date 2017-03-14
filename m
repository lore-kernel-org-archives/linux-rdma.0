From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [RFC v1 for accelerated IPoIB 25/25] mlx5_ib: skeleton for
 mlx5_ib to support ipoib_ops
Date: Tue, 14 Mar 2017 16:55:13 +0200
Message-ID: <CAAk-MO9Cv7n=euC40vuUsEJ4RqwiVKf3kTS0JrOOwu5e4q-KmA@mail.gmail.com>
References: <1489429896-10781-1-git-send-email-erezsh@mellanox.com>
 <1489429896-10781-26-git-send-email-erezsh@mellanox.com> <20170314060730.GA79937@knc-06.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170314060730.GA79937-wPcXA7LoDC+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Vishwanathapura, Niranjana" <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 14, 2017 at 8:07 AM, Vishwanathapura, Niranjana
<niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> On Mon, Mar 13, 2017 at 08:31:36PM +0200, Erez Shitrit wrote:
>>
>> +int mlx5_ib_dev_init(struct net_device *dev, struct ib_device *hca,
>> +                    int *qp_num)
>> +{
>> +       void *next_priv = ipoib_dev_priv(dev);
>> +       struct rdma_netdev *rn = netdev_priv(dev);
>> +       struct mlx5_ib_dev *ib_dev = to_mdev(hca);
>> +       int ret;
>> +
>> +       ret = mlx5i_attach(ib_dev->mdev, next_priv);
>> +       if (ret) {
>> +               pr_err("Failed resources allocation for device: %s ret:
>> %d\n",
>> +                      dev->name, ret);
>> +               return ret;
>> +       }
>> +
>> +       *qp_num = rn->qp_num;
>> +
>> +       pr_debug("resources allocated for device: %s\n", dev->name);
>> +
>> +       return 0;
>> +}
>> +
>> +void mlx5_ib_dev_cleanup(struct net_device *dev, struct ib_device *hca)
>> +{
>> +       void *next_priv = ipoib_dev_priv(dev);
>> +       struct rdma_netdev *rn = netdev_priv(dev);
>> +       struct mlx5_ib_dev *ib_dev = to_mdev(hca);
>> +       struct mlx5_qp_context context;
>> +       int ret;
>> +
>> +       /* detach qp from flow-steering by reset it */
>> +       ret = mlx5_core_qp_modify(ib_dev->mdev,
>> +                                 MLX5_CMD_OP_2RST_QP, 0, &context,
>> +                                 (struct mlx5_core_qp *)rn->context);
>> +       if (ret)
>> +               pr_err("%s failed (ret: %d) to reset QP\n", __func__,
>> ret);
>> +
>> +       mlx5i_detach(ib_dev->mdev, next_priv);
>> +
>> +       mlx5_ib_clean_qp(ib_dev, (struct mlx5_core_qp *)rn->context);
>> +}
>> +
>
>
> Why can't use ndo_init() and ndo_uninit() here (just like open and stop
> below).
> We really don't need to pass in hca here (or in any other interface
> function) as it is already made available to the driver during
> alloc_rdma_netdev.
> Also, why qp_num is an output parameter in the init function? Ipoib can
> access rn->qp_num which this init function is returning.
>
>> +struct net_device *mlx5_alloc_rdma_netdev(struct ib_device *hca,
>> +                                    u8 port_num,
>> +                                    enum rdma_netdev_t type,
>> +                                    const char *name,
>> +                                    unsigned char name_assign_type,
>> +                                    void (*setup)(struct net_device *))
>> +{
>
>
> Probably need to check the 'type' here as any rdma netdev client can call
> this function (with different rdma_netdev type) and cause driver to
> misbehave.

Agree, will fix that. thanks.

>
>> +void mlx5_free_rdma_netdev(struct net_device *netdev)
>> +{
>> +}
>
>
> May be it is safer and cleaner for this function undo what alloc does here
> (instead of doing it in other places)?

Currently, I don't see a reason for that, will re-check it.

>
>> --
>> 1.8.3.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
