From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB/IPoIB: Fix kernel panic on multicast flow
Date: Thu, 7 Jan 2016 12:03:59 +0200
Message-ID: <CAAk-MO9P_=B9LD80KERTKSEQeRhf0q3m_ogw+CpmR7Ds360wiw@mail.gmail.com>
References: <1452151688-7695-1-git-send-email-erezsh@mellanox.com>
	<20160107092318.GA4186@yuval-ThinkPad-X220>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160107092318.GA4186@yuval-ThinkPad-X220>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, doront-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 7, 2016 at 11:23 AM, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> On Thu, Jan 07, 2016 at 09:28:08AM +0200, Erez Shitrit wrote:
>>
>> ipoib_mcast_restart_task calls ipoib_mcast_remove_list with the
>> parameter mcast->dev. That mcast is a temporary (used as an iterator)
>> variable that may be uninitialized.
>> There is no need to send the variable dev to the function, as each mcast
> s/send/pass
>> has its dev as a member in the mcast struct.
>>
>> This causes the next panic:
>> RIP: 0010: ipoib_mcast_leave+0x6d/0xf0 [ib_ipoib]
>> RSP: 0018: EFLAGS: 00010246
>> RAX: f0201 RBX: 24e00 RCX: 00000
>> ....
>> ....
>> Stack:
>> Call Trace:
>>       ipoib_mcast_remove_list+0x3a/0x70 [ib_ipoib]
>>       ipoib_mcast_restart_task+0x3bb/0x520 [ib_ipoib]
>>       process_one_work+0x164/0x470
>>       worker_thread+0x11d/0x420
>>       ...
>>
>> Fixes: 5a0e81f6f483 ('IB/IPoIB: factor out common multicast list removal code')
>> Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Reported-by: Doron Tsur <doront-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>>  drivers/infiniband/ulp/ipoib/ipoib.h           | 2 +-
>>  drivers/infiniband/ulp/ipoib/ipoib_main.c      | 3 +--
>>  drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 8 ++++----
>>  3 files changed, 6 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
>> index a924933..a6f3eab 100644
>> --- a/drivers/infiniband/ulp/ipoib/ipoib.h
>> +++ b/drivers/infiniband/ulp/ipoib/ipoib.h
>> @@ -548,7 +548,7 @@ void ipoib_path_iter_read(struct ipoib_path_iter *iter,
>>
>>  int ipoib_mcast_attach(struct net_device *dev, u16 mlid,
>>                      union ib_gid *mgid, int set_qkey);
>> -void ipoib_mcast_remove_list(struct net_device *dev, struct list_head *remove_list);
>> +void ipoib_mcast_remove_list(struct list_head *remove_list);
>>  void ipoib_check_and_add_mcast_sendonly(struct ipoib_dev_priv *priv, u8 *mgid,
>>                               struct list_head *remove_list);
>>
>> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
>> index 0a93cb2..25509bb 100644
>> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
>> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
>> @@ -1150,7 +1150,6 @@ static void __ipoib_reap_neigh(struct ipoib_dev_priv *priv)
>>       unsigned long flags;
>>       int i;
>>       LIST_HEAD(remove_list);
>> -     struct net_device *dev = priv->dev;
> Isn't this one needed later? (in call to __ipoib_mcast_find made in commit
> bd99b2e05c)

There is a later commit (432c55ff) that already takes that code.

>>
>>       if (test_bit(IPOIB_STOP_NEIGH_GC, &priv->flags))
>>               return;
>> @@ -1196,7 +1195,7 @@ static void __ipoib_reap_neigh(struct ipoib_dev_priv *priv)
>>
>>  out_unlock:
>>       spin_unlock_irqrestore(&priv->lock, flags);
>> -     ipoib_mcast_remove_list(dev, &remove_list);
>> +     ipoib_mcast_remove_list(&remove_list);
> I'm having difficulties applying this patch on linux-stable.git 4.4-rc6 and
> linux-next 4.4-rc8.

I sent it against ib-next

>>  }
>>
>>  static void ipoib_reap_neigh(struct work_struct *work)
>> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
>> index ab79b87..050dfa1 100644
>> --- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
>> +++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
>> @@ -723,12 +723,12 @@ void ipoib_check_and_add_mcast_sendonly(struct ipoib_dev_priv *priv, u8 *mgid,
>>       }
>>  }
>>
>> -void ipoib_mcast_remove_list(struct net_device *dev, struct list_head *remove_list)
>> +void ipoib_mcast_remove_list(struct list_head *remove_list)
>>  {
>>       struct ipoib_mcast *mcast, *tmcast;
>>
>>       list_for_each_entry_safe(mcast, tmcast, remove_list, list) {
>> -             ipoib_mcast_leave(dev, mcast);
>> +             ipoib_mcast_leave(mcast->dev, mcast);
>>               ipoib_mcast_free(mcast);
>>       }
>>  }
>> @@ -839,7 +839,7 @@ void ipoib_mcast_dev_flush(struct net_device *dev)
>>               if (test_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags))
>>                       wait_for_completion(&mcast->done);
>>
>> -     ipoib_mcast_remove_list(dev, &remove_list);
>> +     ipoib_mcast_remove_list(&remove_list);
>>  }
>>
>>  static int ipoib_mcast_addr_is_valid(const u8 *addr, const u8 *broadcast)
>> @@ -965,7 +965,7 @@ void ipoib_mcast_restart_task(struct work_struct *work)
>>               if (test_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags))
>>                       wait_for_completion(&mcast->done);
>>
>> -     ipoib_mcast_remove_list(mcast->dev, &remove_list);
>> +     ipoib_mcast_remove_list(&remove_list);
>>
>>       /*
>>        * Double check that we are still up
>> --
>> 1.7.11.3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
