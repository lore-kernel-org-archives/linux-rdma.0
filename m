From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/iser: fix max_sectors calculation
Date: Thu, 28 Apr 2016 23:21:45 +0300
Message-ID: <CAJ3xEMjFbtjD4mBHFcd8-msqATgtOpj-fsUh0P-8v1ZZekBXuA@mail.gmail.com>
References: <1461013588-8825-1-git-send-email-hch@lst.de>
	<CAJ3xEMh1kd_tXVrS73j46ns5syrw2WDTovqVpP0snbLru_fbQw@mail.gmail.com>
	<20160428075508.GA18285@lst.de>
	<CAJ3xEMj-HX=dRe8zew3VDZ6X_oodzfxX8SwnROCh1T6cfVNTYg@mail.gmail.com>
	<20160428162802.GA29690@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160428162802.GA29690-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 28, 2016 at 7:28 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Thu, Apr 28, 2016 at 01:51:21PM +0300, Or Gerlitz wrote:
>> On Thu, Apr 28, 2016 at 10:55 AM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
>> > I haven't used that explicit language, but:  go fuck yourself, seriously.
>>
>> Christoph, I wrote you on both cases this was a nit comment.
>>
>> I understand now that you are not willing to accept nits as feedback on
>> your fixes, and that you are really nervous on me, happens.
>
> I wondered when this would finally blow up..

> I would also prefer the nit picking on commit language to stop. It is
> not a welcoming environment for new contributors, and it is a pain to
> those who are doing the bulk of the work.

So you are a native English speaker that prefers to have commit
change-logs with spelling mistakes vs. see a nit reviewer comment
followed by a respin by the submitter? your taste, I don't think this
is the way to go, the change-log stays there for ever and there's no
reason on earth not to fix spelling if we can do that throughout the
review. And, yes, I do think that new comers and old suffers need to
run spelling on their change-logs before submitting.

> Get Doug to fix stuff up to match your preferences or let it go.

How about you get Doug to merge for-next code prior to ten days into
the merge window? we are 10K KM from having that.

> It is *really* not OK to ask Sagi to not ack such commits when the
> code is OK. Sagi is doing a fine job.

I disagree. We have some conventions for that driver commits, and we
have the right to keep them. If Christoph prefers that we will do the
final touch, sure, we can do that.

And hey, thanks for writing that without cursing [1] me.

Or.

[1] being a non native English speaker, I wasn't sure if that the
right word, I mean, not telling go fuck yourself or alike on every 2nd
sentence emitted to the world
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
