From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 3/9] selinux lsm IB/core: Implement LSM notification
 system
Date: Fri, 22 Jul 2016 16:50:51 +0000
Message-ID: <AM4PR0501MB2257D075EDB87FF3E6E1376FC40A0@AM4PR0501MB2257.eurprd05.prod.outlook.com>
References: <1468537011-20407-1-git-send-email-danielj@mellanox.com>
 <1468537011-20407-4-git-send-email-danielj@mellanox.com>
 <CAHC9VhSDfd3+qPxxUY9D+DjF=05nunUHkdBY-caQfdPwJCt2Sw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
Content-Language: en-US
List-Post: <mailto:selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
List-Help: <mailto:selinux-request-+05T5uksL2qpZYMLLGbcSA@public.gmane.org?subject=help>
Errors-To: selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
Sender: "Selinux" <selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
To: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org" <chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/22/2016 11:21 AM, Paul Moore wrote:
> On Thu, Jul 14, 2016 at 6:56 PM, Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> v2:
>> - new patch that has the generic notification, replaces selinux and
>>   IB/core patches related to the ib_flush callback. Yuval Shaia and Paul
>>   Moore
>> ---
>>  drivers/infiniband/core/device.c |   46 ++++++++++++++++++++++++++++++
>>  include/linux/security.h         |   10 ++++++
>>  security/security.c              |   58 ++++++++++++++++++++++++++++++++++++++
>>  security/selinux/hooks.c         |    5 ++-
>>  security/selinux/selinuxfs.c     |    2 +
>>  5 files changed, 119 insertions(+), 2 deletions(-)
>>
> Thanks for making this more generic.  I've got some comments below,
> but in the course of reviewing this I realized that the kernel has an
> existing, general purpose notifier mechanism (see
> include/linux/notifier.h); while I've seen the notifier code in the
> network stack, I never realized it was created as a general purpose
> mechanism.  My apologies, I should have noticed this earlier and
> mentioned it.
>
> As far as how that impacts this patch; it seems like we should be good
> citizens and use the general mechanism, I don't see any obvious
> reasons why it wouldn't work.  That said, I do feel bad for not
> realizing this earlier.  If it isn't too annoying, would you mind
> updating this patch *again*?

Sure, I'll can do that for v3.

>> +
>> +static LIST_HEAD(lsm_notifier_list);
>> +static DEFINE_SPINLOCK(lsm_notifier_lock);
>> +static u32 next_callback_id;
> I'd rather see the callback ID named something that makes it obvious
> it is tied to the lsm_notifier_* bits, perhaps lsm_notifier_nextid?

I think this will go away with the switch to the generic notification, but if it stays I'll make the change.

>>  /* Boot-time LSM user choice */
>>  static __initdata char chosen_lsm[SECURITY_NAME_MAX + 1] =
>>         CONFIG_DEFAULT_SECURITY;
>> @@ -98,6 +110,52 @@ int __init security_module_enable(const char *module)
>>         return !strcmp(module, chosen_lsm);
>>  }
>>
>> +void security_lsm_notify(enum lsm_event event, void *data)
>> +{
>> +       struct lsm_notifier_entry *entry;
>> +
>> +       rcu_read_lock();
>> +       list_for_each_entry_rcu(entry, &lsm_notifier_list, list)
>> +               entry->func(event, entry->ctx, data);
>> +       rcu_read_unlock();
>> +}
>> +EXPORT_SYMBOL(security_lsm_notify);
>> +
>> +int security_register_lsm_notifier(lsm_notifier func, void *ctx, u32 *id)
>> +{
>> +       struct lsm_notifier_entry *entry;
>> +
>> +       entry = kzalloc(sizeof(*entry), GFP_KERNEL);
>> +       if (!entry)
>> +               return -ENOMEM;
>> +
>> +       entry->func = func;
>> +       entry->ctx = ctx;
> Do we need ctx?  We do need to ability to pass a blob to the callback
> which will vary based on the event, but I'm not sure the ctx here has
> much value.

You'll see how I used ctx in "[PATCH v2 4/9] IB/core: Enforce security on management datagrams".  Many mad agents can be created and each will register for a callback.  I used the context to store a pointer to the specific mad agent.

>> +       spin_lock(&lsm_notifier_lock);
>> +       entry->callback_id = next_callback_id++;
>> +       *id = entry->callback_id;
>> +       list_add_rcu(&entry->list, &lsm_notifier_list);
>> +       spin_unlock(&lsm_notifier_lock);
>> +
>> +       return 0;
>> +}
>> +EXPORT_SYMBOL(security_register_lsm_notifier);



_______________________________________________
Selinux mailing list
Selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
To unsubscribe, send email to Selinux-leave-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
To get help, send an email containing "help" to Selinux-request-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
