From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv7 2/3] IB/core: added support to use rdma cgroup controller
Date: Tue, 1 Mar 2016 19:13:05 +0530
Message-ID: <CAG53R5XiVgi5iWONFON5_qUvW6k-vdJQx+_8DEkZSF5i3Tp=dQ@mail.gmail.com>
References: <1456668821-25799-1-git-send-email-pandit.parav@gmail.com>
	<1456668821-25799-3-git-send-email-pandit.parav@gmail.com>
	<56D55CE6.7030103@mellanox.com>
	<CAG53R5UrM7WAuamCEynDRKV0YMJsJUe=SEYfTrueQD0rtx71bA@mail.gmail.com>
	<56D577CC.1070107@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <56D577CC.1070107@mellanox.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Haggai Eran <haggaie@mellanox.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Tejun Heo <tj@kernel.org>, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 1, 2016 at 4:36 PM, Haggai Eran <haggaie@mellanox.com> wrote:
> On 01/03/2016 11:22, Parav Pandit wrote:
>> On Tue, Mar 1, 2016 at 2:42 PM, Haggai Eran <haggaie@mellanox.com> wrote:
>>> On 28/02/2016 16:13, Parav Pandit wrote:
>>>> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
>>>> index 00da80e..54ea8ce 100644
>>>> --- a/drivers/infiniband/core/device.c
>>>> +++ b/drivers/infiniband/core/device.c
>>>> @@ -343,28 +343,38 @@ int ib_register_device(struct ib_device *device,
>>>>
>>>>       ret = read_port_immutable(device);
>>>>       if (ret) {
>>>> -             printk(KERN_WARNING "Couldn't create per port immutable data %s\n",
>>>> -                    device->name);
>>>> +             pr_warn("Couldn't create per port immutable data %s\n",
>>>> +                     device->name);
>>>>               goto out;
>>>
>>> This change doesn't belong in the patch.
>> I agree, but few warnings are with pr_warn and few with printk just
>> make code look uneven.
>> So I changed printk to pr_warn in same function instead of spinning
>> complete new patch.
> Still, I think it would be better to have such cosmetic changes in a
> separate patch, so that we have a cleaner git history. You can send
> this extra patch separately from this patchset so that Doug can take
> it independently.
o.k.
