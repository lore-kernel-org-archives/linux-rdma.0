From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Tue, 30 Aug 2016 10:47:50 -0600
Message-ID: <20160830164750.GD26778@obsidianresearch.com>
References: <cabbd0a7-0918-a8dd-d1e5-0b079f0c4604@redhat.com>
 <20160825173916.GC20612@obsidianresearch.com>
 <20160825195246.GI1916@redhat.com>
 <20160825201306.GA5421@obsidianresearch.com>
 <8ef70f6c-e26d-191d-9a9a-2e0bf47fb227@redhat.com>
 <20160828132804.GN594@leon.nu>
 <20160828183627.GC12783@obsidianresearch.com>
 <20160829062918.GR594@leon.nu>
 <20160829160009.GA23557@obsidianresearch.com>
 <20160830054352.GI594@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160830054352.GI594-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 30, 2016 at 08:43:52AM +0300, Leon Romanovsky wrote:

> Everyone works hard, especially they, and the question is do the distro
> people want to revise their process. The change of upstream process to
> suit their needs is a nice solution, but it needs to be beneficial to
> everyone.

Well, we agree distros get an easier time.

Developers get an easier time because they can test and build our
software without enormous hassle (you do build-test *every* provider
when you change verbs, right?)

They can also submit patches without having to deal with the 15 trees,
MIA maintainers, and unclear process we have today. They get help
following best-practices when working on their providers.

Vendors get more reliable access to *ALL* the distros. It is a
travesty that only Fedora & derived actually have a complete up to date
stack. (kudos to Doug&team for dealing with this mess for so long)

End users could actully build from source, and maybe become
contributors! Wouldn't that be something...

> Current proposal is not good to vendors, who are responsible for
> upstreaming their work.

You are focusing on this really unjustified fear that 'things will
slow down' and missing the bigger picture.

> I disagree that removing old, unsupported libraries from the graves is
> called progress.

Which libraries are these? Granted libibcm is deprecated, but all
other libraries are active or support a still existing kernel driver.
I already ignored all the user space libraries for the kernel drivers
we removed.

If anything what we have here is a substantially *finished* code base
that needs long term maintenance support to keep everything working.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
