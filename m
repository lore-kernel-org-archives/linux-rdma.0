From: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] libibverbs IB device hotplug support
Date: Thu, 2 Mar 2017 00:32:51 +0200
Message-ID: <CAFgAxU_-jbAoOR2XMYfSgbDMn7FnrthudZJLgeNNTzb9GEUXrg@mail.gmail.com>
References: <CAFgAxU9eQYwBad2+SJw1x+cQMMqzgkz0fpeumG7Rx=o_eQqo2g@mail.gmail.com>
 <1488296882.86943.214.camel@redhat.com> <HE1PR0501MB28123E8F342607E2C2CA4DD9B1560@HE1PR0501MB2812.eurprd05.prod.outlook.com>
 <3389d831-c135-b326-4b96-5f2a746de5ac@redhat.com> <20170301004449.GA13114@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0ECDC6@ORSMSX109.amr.corp.intel.com>
 <CAFgAxU9vObaW4O+byEJ5pV1Ofou4cd05HHWWPC7iTJshyk+LdA@mail.gmail.com> <d92df6b7-207f-f3a3-8bf5-b12cffe20684@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <d92df6b7-207f-f3a3-8bf5-b12cffe20684-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 2, 2017 at 12:07 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 3/1/2017 4:47 PM, Alex Rosenbaum wrote:
>> On Wed, Mar 1, 2017 at 8:00 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>>>>>> I don't think that we should introduce an asych context into
>>>> libibverbs.
>>>>>
>>>>> Why not?
>>>>
>>>> Generally, I dislike the idea of running threads from libraries,
>>>> particularly libraries like ibverbs. So many apps get no benefit from
>>>> the thread, but it sits there connected to udev..
>>>
>>> I thought Doug was referring to reporting the device add/remove event through some event reporting interface, like what the librdmacm already does.  So no threads for that are needed.  IMO, this makes sense.
>>>
>>> I didn't follow his idea for how the device list would be updated and kept in sync between the app and the library.
>>>
>>> If you had device add/remove events, the get_event call could intercept that event and update the device list there.  But I don't know that you try to sync a shared list between the library and the app.
>>
>> In order to provide 'out-of-ibv_context' libibverbs events we'll need
>> a new interface, something like ibv_get_system_event(), to report
>> device changes.
>
> Yep.
>
>> Every time the application calls this API, libibverbs must process all
>> events in queue in order to have an up to date ibv_device list with
>> they way it appears in sysfs.
>
> This is not necessarily true.  It is entirely possible that the library
> has already processed the events themselves internally and the device
> list is already consistent.  You're tying the act of the user calling
> into the library with the library processing work that needs processed.
> These two ought not be tied.
>
>> Then, do we force all these popped events on the user? or can we force
>> him to loop on ibv_get_system_event() until EAGAIN so we're sure the
>> device list is updated?
>
> If the user wants to drain that queue, then that would be just fine.  On
> the other hand, as I wrote in my original implementation proposal, the
> user could also simply call ibv_get_device_list and get the updated
> list, which directly implies that the queue of events need not be popped
> clean in order for the processing work to have already been done.
>
>> Is this hiding yet another fd for the application to block on?
>
> Personally I would use a thread in the library that would block on
> inotify events from the sysfs directory.  Any time it got woke up, it
> would process the remove/add event, update the device list, create a
> notification if the app had registered a notification handler and queue
> that to the app, then go back to sleep on the inotify events in the
> sysfs dir.  The processing of the event and the notification would be
> totally disjoint.  The app need not process events, even if it
> registered and event handler, in order to get the new device list.

I actually did look at inotify() for this problem and agree that this
is can be a good option.
There are some issues with it. You get a few more events then you
really need (some extra context switches). It does not map all sysfs
cleanly, there are some limitation. It will not wakeup on
/sys/class/infiniband_verbs/*, but will catch the
/dev/infiniband/uverbes% new instances.

Then there is a question of which context/thread? library vs applications

>
>> Verbs is built around a cmd_fd per ibv_context. Reporting of new
>> devices hotplug needs a separate channel. It does not seem correct to
>> add yet another such cdev to verbs.
>
> I would have no intention of adding a cdev or anything else kernel
> related to this.  This can be done 100% in user space, and should be.
> That also makes the change backward compatible with earlier kernels.
>
>> I agree the adding this hotplug report capabilities into librdmacm
>> sounds more appropriate.
>> But libibvers will still need to provide the latest ibv_device list
>> snapshot as it appears in sysfs.
>
> Under my proposed implementation it would.
>
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
