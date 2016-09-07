From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Wed, 7 Sep 2016 11:21:33 +0300
Message-ID: <cd964412-11f3-d1ca-ef76-830a24cb8e68@grimberg.me>
References: <c84de2a5-6526-c0a6-6535-519add3fbabb@dev.mellanox.co.il>
 <20160828182715.GA12783@obsidianresearch.com>
 <004e01d20203$156edc30$404c9490$@opengridcomputing.com>
 <20160829161902.GB23557@obsidianresearch.com> <20160830060842.GJ594@leon.nu>
 <20160830071716.GA3098@infradead.org> <20160830073521.GM594@leon.nu>
 <20160830163033.GC26778@obsidianresearch.com>
 <4b791de5-0d6e-fd94-8a31-2fe833ca72db@grimberg.me>
 <20160906070102.GA23248@infradead.org>
 <20160906183405.GA27914@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160906183405.GA27914-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yarong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


>>> What I think it missing is a release schedule, stable fixes
>>> methodology and merge cycles. I think once we can agree on that
>>> a lot of the concerns will be addressed.
>>
>> So let's keep the maintainers as-is, e.g. each previous project
>> keepts it's own maintainer similar to driver maintainers in the
>> kernel.
>
> This is certainly what I imagined. Nobody else has the domain
> expertise for these sub components.
>
> However, there is a lot of work just to keep everything ticking over,
> compilers change, build tooling changes, distros need hand holding,
> boring patches need accepting. That is where all maintainers should see
> value in this approach.

Fully agree.

>> We'll add Jason as a global maintainer for the build system or any
>> non-controverial fixes and we should be much better setup than the
>> current situation.
>
> I was hoping a team including Doug would handle the general patch
> stream. Most of the patch flow today is for libibverbs and related
> anyhow. If Leon wants to handle the boring patches and provider pulls
> then that seems like a good combination.

I actually think Yishai would be perfect for this job (should he accept
it). Yishai has been feeding Doug from his libibverbs repo for some time
now and I've been using it for tech previews.

I think that Yishai and Doug maintaining libibverbs as a team would be
great. Having said that, we'll need to understand if they are fine with
it.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
