From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Thu, 8 Sep 2016 11:20:29 +0300
Message-ID: <ab854d44-5634-a25f-4606-cce318c3c797@grimberg.me>
References: <20160829161902.GB23557@obsidianresearch.com>
 <20160830060842.GJ594@leon.nu> <20160830071716.GA3098@infradead.org>
 <20160830073521.GM594@leon.nu> <20160830163033.GC26778@obsidianresearch.com>
 <4b791de5-0d6e-fd94-8a31-2fe833ca72db@grimberg.me>
 <20160906070102.GA23248@infradead.org>
 <20160906183405.GA27914@obsidianresearch.com>
 <cd964412-11f3-d1ca-ef76-830a24cb8e68@grimberg.me>
 <924d7775-0d24-e1ca-b0ee-226df053089a@dev.mellanox.co.il>
 <20160907155849.GE2878@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160907155849.GE2878-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yarong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


>>> I think that Yishai and Doug maintaining libibverbs as a team would be
>>> great. Having said that, we'll need to understand if they are fine with
>>> it.
>>
>> Yes, I'm fine with taking responsibility and maintain libibverbs.
>> I believe that it will reduce burden from Doug and escalate the
>> development/acceptance process in the user space area.
>
> The suggestion from Leon is that within the maintainer team Doug would
> deal primarily with all the user facing changes (eg libibverbs) and
> other team members would deal with the internal things like provider
> updates.
>
> No one is suggesting to transfer libibverbs away from Doug's stewardship.

I wasn't suggesting taking anything from Doug either. Personally I
think that maintainer teams make sense also for a single
repository/subsystem, it has several successful examples around the
kernel.

Given that the patch traffic for libibverbs should be significantly
larger than the individual device drivers, maybe it makes sense
to share the load here (especially given that Doug has the RDMA kernel
tree which have seen increasingly growing activity).

Having said that, Doug as the current libibverbs maintainer should
decide if he wants any help. Either way we can probably see how things
roll when the process is applied...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
