From: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] libibverbs IB device hotplug support
Date: Fri, 3 Mar 2017 14:31:42 +0200
Message-ID: <CAFgAxU_uq-uRs6Bk47WV2wk7r_i8A_27X4AhAVRfEHundc8bZA@mail.gmail.com>
References: <CAFgAxU9eQYwBad2+SJw1x+cQMMqzgkz0fpeumG7Rx=o_eQqo2g@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0ED3C6@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0ED3C6-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 2, 2017 at 6:08 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> Here I suggest to modify the implementation of ibv_get_device_list() so
>> that
>> consecutive calls will re-scan the sysfs in the same manner as done
>> today in
>> order to create a fresh ibv_device list each time. We will remove
>> caching of
>> devices that support plugout, while keeping the ibv_device cache for
>> devices
>> which do not support plugout.
>>
>> For this purpose, the ibv_get_device_list() device scanning logic
>> should be
>> separated from the libibverbs singleton initialization step.
>> User can call ibv_open_device() while holding this list (see man pages)
>> and
>> once ibv_free_device_list() is called libibverbs can release the unused
>> ibv_device objects. Later, on calls to ibv_close_device(), additional
>> ibv_device object should be released. Currently, on
>> ibv_free_device_list(),
>> only the array is freed, while the ibv_device objects are never freed.
>> libibverbs will maintain a ref_count for each verbs_device object.
>> Increase
>> verbs_device->ref_count for every ibv_get_device_list() or
>> ibv_open_device().
>> Decrease it for every ibv_free_device_list() or ibv_close_device().
>> On decrease, if ref_count tested to be zero, libibverbs will call the
>> provider
>> library to release the 'strcut verbs_device' which it allocated.
>> Each provider library should provide a function to release the
>> verbs_device
>>
>> object: 'uninit_device(struct verbs_device* device)'.
>
> Based on the discussion so far, is there any disagreement with just the above functionality?  Ignoring the event reporting aspect, the above makes sense to me as a reasonable first step.
>
> - Sean

Summarize the basic hotplug functionality part we discussed so far:
1. calling ibv_get_device_list() will rescan sysfs and provide an
updated list of ibv_device's
2. optimize by identifying same device incarnation with timestamp
creation of /sys/class/infiniband/%ibdev%/hca_type
3. release struct verbs_device according to usage ref_count
4. implement 'uninit_device(struct verbs_device* device)' for all
provider libraries to release plugout devices

NOTE: consolidating all providers libraries to use the extendible
struct verbs_device and move it into driver private area already
merged by https://github.com/linux-rdma/rdma-core/pull/87

We'll prepare a PR with the above functionality for all providers.
And come back with a separate suggestion for hotplug reporting mechanism.

Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
