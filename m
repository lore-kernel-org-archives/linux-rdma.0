From: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] libibverbs IB device hotplug support
Date: Wed, 1 Mar 2017 23:47:52 +0200
Message-ID: <CAFgAxU9vObaW4O+byEJ5pV1Ofou4cd05HHWWPC7iTJshyk+LdA@mail.gmail.com>
References: <CAFgAxU9eQYwBad2+SJw1x+cQMMqzgkz0fpeumG7Rx=o_eQqo2g@mail.gmail.com>
 <1488296882.86943.214.camel@redhat.com> <HE1PR0501MB28123E8F342607E2C2CA4DD9B1560@HE1PR0501MB2812.eurprd05.prod.outlook.com>
 <3389d831-c135-b326-4b96-5f2a746de5ac@redhat.com> <20170301004449.GA13114@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0ECDC6@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0ECDC6-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 1, 2017 at 8:00 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> > > I don't think that we should introduce an asych context into
>> libibverbs.
>> >
>> > Why not?
>>
>> Generally, I dislike the idea of running threads from libraries,
>> particularly libraries like ibverbs. So many apps get no benefit from
>> the thread, but it sits there connected to udev..
>
> I thought Doug was referring to reporting the device add/remove event through some event reporting interface, like what the librdmacm already does.  So no threads for that are needed.  IMO, this makes sense.
>
> I didn't follow his idea for how the device list would be updated and kept in sync between the app and the library.
>
> If you had device add/remove events, the get_event call could intercept that event and update the device list there.  But I don't know that you try to sync a shared list between the library and the app.

In order to provide 'out-of-ibv_context' libibverbs events we'll need
a new interface, something like ibv_get_system_event(), to report
device changes.
Every time the application calls this API, libibverbs must process all
events in queue in order to have an up to date ibv_device list with
they way it appears in sysfs.
Then, do we force all these popped events on the user? or can we force
him to loop on ibv_get_system_event() until EAGAIN so we're sure the
device list is updated?
Is this hiding yet another fd for the application to block on?

Verbs is built around a cmd_fd per ibv_context. Reporting of new
devices hotplug needs a separate channel. It does not seem correct to
add yet another such cdev to verbs.

I agree the adding this hotplug report capabilities into librdmacm
sounds more appropriate.
But libibvers will still need to provide the latest ibv_device list
snapshot as it appears in sysfs.

Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
