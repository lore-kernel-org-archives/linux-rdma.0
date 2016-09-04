From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Sun, 4 Sep 2016 11:18:02 +0300
Message-ID: <4b791de5-0d6e-fd94-8a31-2fe833ca72db@grimberg.me>
References: <20160822214352.GB11695@obsidianresearch.com>
 <20160823185441.GA1233@obsidianresearch.com>
 <cabbd0a7-0918-a8dd-d1e5-0b079f0c4604@redhat.com>
 <c84de2a5-6526-c0a6-6535-519add3fbabb@dev.mellanox.co.il>
 <20160828182715.GA12783@obsidianresearch.com>
 <004e01d20203$156edc30$404c9490$@opengridcomputing.com>
 <20160829161902.GB23557@obsidianresearch.com> <20160830060842.GJ594@leon.nu>
 <20160830071716.GA3098@infradead.org> <20160830073521.GM594@leon.nu>
 <20160830163033.GC26778@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160830163033.GC26778-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yarong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> The first step is the 'make it easy step'. Today everything is just
> too hard for developers. When Christoph Hellwig says building our user
> space is too hard *you should listen*. He isn't wrong, and he isn't
> inexperienced at this.
>
> How many potential community members have been dissuaded by that
> simple fact??

I like where this is going. It would also resolve the question
"who is upstream?" that I had a few times in the past with all
the scattered repos online (ofa, github...)

>>> Maintainer overload always is a problem, and it's helped by adding
>>> more maintainers.  And yes, both the kernel RDMA stack and the user
>>> code should have a small maintainer team, but that's a different
>>> discussion.
>>
>> Awesome, let's start from this discussion to clear the ground and move
>> to technical proposals after it.
>
> We've already been over this ground, multiple times over
> years. Consolidation is the techincal direction a lot of people want
> to move toward.

Leon's concerns are justified I think. Mellanox as the most significant
contributor here should not suffer delays from this. But generally if
we build a healthy community, with active maintainers (which share the
load) and clear release cycles, I think we can actually accelerate the
process.

> Whatever maintainership structure is decided on can steward the
> consolidated repo.

I think that having a maintainer per provider makes perfect sense
and as long as you Jason (or anyone else) are committed to merging it
all together and produce standard releases we are pretty much set.

What I think it missing is a release schedule, stable fixes
methodology and merge cycles. I think once we can agree on that
a lot of the concerns will be addressed.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
