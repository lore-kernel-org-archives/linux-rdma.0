From: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] libibverbs IB device hotplug support
Date: Thu, 2 Mar 2017 00:34:58 +0200
Message-ID: <CAFgAxU99=abeeQELhJ-760U+3-_CMb+xG5c0H_R_z6bBfeMTOA@mail.gmail.com>
References: <CAFgAxU9eQYwBad2+SJw1x+cQMMqzgkz0fpeumG7Rx=o_eQqo2g@mail.gmail.com>
 <1488296882.86943.214.camel@redhat.com> <HE1PR0501MB28123E8F342607E2C2CA4DD9B1560@HE1PR0501MB2812.eurprd05.prod.outlook.com>
 <3389d831-c135-b326-4b96-5f2a746de5ac@redhat.com> <20170301004449.GA13114@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0ECDC6@ORSMSX109.amr.corp.intel.com> <cad3d2c6-0c98-9f58-a3bb-81823103bd76@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cad3d2c6-0c98-9f58-a3bb-81823103bd76-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 1, 2017 at 11:56 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 3/1/2017 1:00 PM, Hefty, Sean wrote:
>>>>> I don't think that we should introduce an asych context into
>>> libibverbs.
>>>>
>>>> Why not?
>>>
>>> Generally, I dislike the idea of running threads from libraries,
>>> particularly libraries like ibverbs. So many apps get no benefit
>>> from the thread, but it sits there connected to udev..
>>
>> I thought Doug was referring to reporting the device add/remove event
>> through some event reporting interface, like what the librdmacm
>> already does.  So no threads for that are needed.  IMO, this makes
>> sense.
>
> It can be done without a thread, that's not to say I would necessarily
> do so myself.
>
>> I didn't follow his idea for how the device list would be updated and
>> kept in sync between the app and the library.
>
> There is no requirement that the device list be kept in sync between the
> library and the app, period.
>
> There are three usages for what I suggested:
>
> 1)  The app gets a device list initially just like it does now.  If the
> app never updates that list again, so be it.  This is 100% backward
> compatible.
>
> 2)  The simplified version of hotplug/unplug that has been discussed:
> the app calls ibv_get_device_list.  As proposed by Alex, the library
> would rescan the sysfs directory on this call.  If the device is there,
> great.  If it isn't, great too.  Under my proposed implementation, the
> exact same thing is true.  If the device is there, great.  If there
> isn't a new device in the list already, then great too.  Because the
> initial implementation proposal left if up to the app to determine
> how/when to check for a new device, there was never any guarantee that
> whatever triggered the app to look for the new device meant that it was
> ready to be used in sysfs and would be found by the re-reading of the
> sysfs directory.  So whatever race might be present in my proposed
> implementation would also be present in the original implementation.
>
> 3)  My proposed implementation where an entry point is added for async
> events.  In this case, the library would not pass the event on up until
> the device was ready to be used, so there is no race here.  And there is
> minimal delay from detection to notification and ready for use.
>
>> If you had device add/remove events, the get_event call could
>> intercept that event and update the device list there.  But I don't
>> know that you try to sync a shared list between the library and the
>> app.
>
> No, I wouldn't try that at all.  The inherently racy thing in all of
> this is having the library be responsible for scanning a device, but not
> responsible for detecting that there is a new device to be scanned.
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>

Should we fully define the notification solution (#3 in your list)
before continuing with simple refresh (#2)?

Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
