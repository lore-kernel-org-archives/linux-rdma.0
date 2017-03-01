From: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] libibverbs IB device hotplug support
Date: Thu, 2 Mar 2017 00:42:01 +0200
Message-ID: <CAFgAxU9=iv76V62yGzZ5OKz_RLHOsuqUL=PE6H+AOTZmEHwWQw@mail.gmail.com>
References: <CAFgAxU9eQYwBad2+SJw1x+cQMMqzgkz0fpeumG7Rx=o_eQqo2g@mail.gmail.com>
 <20170301001023.GA3001@phlsvsds.ph.intel.com> <CAFgAxU_i+5FtBkdf=t5vdQAvBqDt9aKsFJbAKGN5YWQQ9w-c2A@mail.gmail.com>
 <2807E5FD2F6FDA4886F6618EAC48510E67C5CA68@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E67C5CA68-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Jason Gunthorpe (jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org)" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 2, 2017 at 12:15 AM, Weiny, Ira <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> >>
>> >> ---------------------------------------------------------------------
>> >> -----------
>> > After the call
>> >
>> > Ira
>> >
>>
>> Ira,
>> On the call we discussed that today there is no 'incarnation' value exposed for
>> the uverbs%.
>> You suggested an optimization by using the cdev's file creation timestamp as
>> option for libibverbs to understand that the driver did or did-not restart since
>> mapping of that ibv_device.
>> Main pitfalls with this is if system time is being modified (admin or ntp/ptp). In
>> the rare case that we have a hoplug event and time is rewinded we can
>> accidentally reach a very hard debugging exercise.
>> What do you think?
>
> It was actually Jason who suggested that.

redirecting the credit: "thanks Jason :)"
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
