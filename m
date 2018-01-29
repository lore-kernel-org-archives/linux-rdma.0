From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Reconnect on RDMA device reset
Date: Mon, 29 Jan 2018 16:46:28 -0500
Message-ID: <80104DB5-2E4D-4226-AF3A-93FE1CD87CB4@oracle.com>
References: <CADZhsQqDFc1NWmsihOwki8_2Zj0HuYKC_N_x0jMnCtU9Rww1UA@mail.gmail.com>
 <f0a14240-1566-1bae-1b9f-21880bc3f3a0@grimberg.me>
 <CADZhsQqvK0LMd9sfxzz+x_5qVnoi4FP0FCFMsTPjpeXyqfXKew@mail.gmail.com>
 <77cef33e-a563-97fc-7ba6-69f220f1be84@grimberg.me>
 <1516904022.27592.187.camel@redhat.com>
 <679C11A4-744C-4574-9F50-2D2C3B0F08B0@oracle.com>
 <92367a43-4c2e-887f-35ff-38fa05d47c49@grimberg.me>
 <EFFF4091-3CBA-474B-B9D7-FF7EDA3B1613@oracle.com>
 <1517261240.27592.245.camel@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1517261240.27592.245.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Oren Duer <oren.duer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> On Jan 29, 2018, at 4:27 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 
> On Mon, 2018-01-29 at 15:11 -0500, Chuck Lever wrote:
>>> On Jan 29, 2018, at 3:01 PM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
>>> 
>>> Hi Chuck,
>>> 
>>>> For NFS/RDMA, I think of the "failover" case where a device is
>>>> removed, then a new one is plugged in (or an existing cold
>>>> replacement is made available) with the same IP configuration.
>>>> On a "hard" NFS mount, we want the upper layers to wait for
>>>> a new suitable device to be made available, and then to use
>>>> it to resend any pending RPCs. The workload should continue
>>>> after a new device is available.
>>> 
>>> Really? so the context is held forever (in case the device never
>>> comes back)?
>> 
>> I didn't say this was the best approach :-) And it certainly can
>> change if we have something better.
> 
> Whether it's the best or not, it's the defined behavior of the "hard"
> mount option.  So if someone doesn't want that, you don't use a hard
> mount ;-)
> 
> Hard mounts are great for situations where you have a high degree of
> faith that even if they server disappears, it will reappear soon.  They
> suck when the server totally dies though, because now all the hard mount
> clients are stuck :-/.

We're working on fixing that.


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
