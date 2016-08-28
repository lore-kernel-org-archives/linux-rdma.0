From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Sun, 28 Aug 2016 19:14:31 +0300
Message-ID: <c84de2a5-6526-c0a6-6535-519add3fbabb@dev.mellanox.co.il>
References: <1471889618-1605-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <01dc01d1fcb0$a1dd3ed0$e597bc70$@opengridcomputing.com>
 <20160822214352.GB11695@obsidianresearch.com>
 <20160823185441.GA1233@obsidianresearch.com>
 <cabbd0a7-0918-a8dd-d1e5-0b079f0c4604@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cabbd0a7-0918-a8dd-d1e5-0b079f0c4604-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, yarong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org"yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 8/25/2016 5:20 PM, Doug Ledford wrote:
> On 8/23/2016 2:54 PM, Jason Gunthorpe wrote:
>> On Mon, Aug 22, 2016 at 03:43:52PM -0600, Jason Gunthorpe wrote:
>>
>>> The full install to / is still a small TODO, it is part and parcel
>>> with doing the packaging, in my mind.
>>
>> I just pushed a basic starting point rpm spec file, it still needs to
>> be split into multiple subpackages, but it is installable with all the
>> usual paths.
>
> You can do that, but I routinely tell upstream maintainers that we don't
> touch their spec files.  Every distro modifies the spec file so heavily
> for their own custom installation that it just doesn't make much sense
> to worry about it at the upstream level.  Build one that can be used
> when running rpmbuild -ta and that's all you need.
>

It's not just an issue of a vendor specific spec file that should stay 
unchanged.

Today each vendor manages its code and is not exposed to bugs/issues in 
other vendors. Moving to a consolidate rpm might cause that any bug fix 
in one component will force a new release of all other stuff without any 
real reason. Introducing such a dependency might even delay/block a 
release without any justification.

I believe that we agree that each maintainer should be independent to 
review/accept relevant code to his component and make sure that his code 
is fully tested and ready for a release in any given time.

Put all code in one big umbrella letting only one person to accept code 
is not a good idea which might slow the process of accepting new code 
and features.

We can't expect one person to know all vendor's details and have time to 
manage all of that.

In addition, need to consider that there are few distros which have 
releases in different times, the flexibility to take a specific 
component based on its readiness and importance is a vital
point that must be saved as done today.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
