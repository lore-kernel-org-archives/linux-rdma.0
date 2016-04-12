From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 05/18] xprtrdma: Avoid using Write list for small NFS READ requests
Date: Tue, 12 Apr 2016 14:08:25 -0400
Message-ID: <609A9E12-B1A8-4662-B64B-67CB46333D14@oracle.com>
References: <20160411200323.20531.8893.stgit@manet.1015granger.net> <20160411201050.20531.53651.stgit@manet.1015granger.net> <033901d19431$b3725d20$1a571760$@opengridcomputing.com> <65CBC59F-3005-44FE-8C70-9DDBC8507C9E@oracle.com> <20160412141533.GA16218@infradead.org> <06326E24-7170-4D09-A841-08ED31D143FF@oracle.com> <20160412170121.GA2052@infradead.org>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160412170121.GA2052-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Apr 12, 2016, at 1:01 PM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> 
> On Tue, Apr 12, 2016 at 10:49:24AM -0400, Chuck Lever wrote:
>>>> No, pre-4.2 Linux servers have a bug that can be fixed by
>>>> applying the above commit, which shouldn't be difficult to
>>>> backport.
>>>> 
>>>> Clients have always been allowed to send NFS READ this way.
>>> 
>>> But the clients might be out in a the wild.  I think we'll need at
>>> least a mount option to work around them.
>> 
>> Huh?
>> 
>> I'm talking about non-Linux clients. RFC 5666 allows
>> this behavior, it always has. The Linux server before
>> 9d11b51ce7c1 is broken, full stop.
> 
> You are deliverately breaking exsisting and fairly recent clients.

How am I breaking existing clients? Before 4.7, our
client works with a broken Linux NFS server and it
works with a fixed one.

_New_ clients won't work with broken servers.


> I see why we want to do this, but there needs to be an options
> that things keep working.  The idea of upgrading your client from
> 4.6 to 4.7 and NFS simply not working anymore with the developer
> knowing it and not providing a workaround is simply not an option.

I don't understand why this approach was reasonable in
the past, but is now suddenly not workable.

We have a workaround: Use NFS/TCP on IPoIB.


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
