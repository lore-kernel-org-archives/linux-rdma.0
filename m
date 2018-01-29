From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Reconnect on RDMA device reset
Date: Mon, 29 Jan 2018 15:11:05 -0500
Message-ID: <EFFF4091-3CBA-474B-B9D7-FF7EDA3B1613@oracle.com>
References: <CADZhsQqDFc1NWmsihOwki8_2Zj0HuYKC_N_x0jMnCtU9Rww1UA@mail.gmail.com>
 <f0a14240-1566-1bae-1b9f-21880bc3f3a0@grimberg.me>
 <CADZhsQqvK0LMd9sfxzz+x_5qVnoi4FP0FCFMsTPjpeXyqfXKew@mail.gmail.com>
 <77cef33e-a563-97fc-7ba6-69f220f1be84@grimberg.me>
 <1516904022.27592.187.camel@redhat.com>
 <679C11A4-744C-4574-9F50-2D2C3B0F08B0@oracle.com>
 <92367a43-4c2e-887f-35ff-38fa05d47c49@grimberg.me>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <92367a43-4c2e-887f-35ff-38fa05d47c49-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Oren Duer <oren.duer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> On Jan 29, 2018, at 3:01 PM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
> 
> Hi Chuck,
> 
>> For NFS/RDMA, I think of the "failover" case where a device is
>> removed, then a new one is plugged in (or an existing cold
>> replacement is made available) with the same IP configuration.
>> On a "hard" NFS mount, we want the upper layers to wait for
>> a new suitable device to be made available, and then to use
>> it to resend any pending RPCs. The workload should continue
>> after a new device is available.
> 
> Really? so the context is held forever (in case the device never
> comes back)?

I didn't say this was the best approach :-) And it certainly can
change if we have something better.

But yes, with a hard mount, the NFS and RPC client stack keeps
the pending RPCs around and continues to attempt reconnection
with the NFS server.

The idea is that after an unplug, another device with the proper
IP configuration can be made available, and then rdma_resolve_addr()
can figure out how to reconnect.

The associated NFS workload will be suspended until it can reconnect.

Now on the NFS server (target) an unplug results in connection
abort. Any context at the transport layer is gone, though the NFS
server maintains duplicate reply caches that can hold RPC replies
for some time. Those are all bounded in size.

The clients continue to attempt to reconnect until there is another
device available that can allow the server to accept connections.


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
