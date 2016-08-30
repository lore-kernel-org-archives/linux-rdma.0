From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Mon, 29 Aug 2016 21:27:38 -0400
Message-ID: <20160830012738.GH6803@redhat.com>
References: <01dc01d1fcb0$a1dd3ed0$e597bc70$@opengridcomputing.com>
 <20160822214352.GB11695@obsidianresearch.com>
 <20160823185441.GA1233@obsidianresearch.com>
 <cabbd0a7-0918-a8dd-d1e5-0b079f0c4604@redhat.com>
 <20160825173916.GC20612@obsidianresearch.com>
 <20160825195246.GI1916@redhat.com>
 <20160825201306.GA5421@obsidianresearch.com>
 <20160826154206.GK1916@redhat.com>
 <20160826222725.GA8553@obsidianresearch.com>
 <5421f173-384d-faef-0eab-518db6dad0e5@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5421f173-384d-faef-0eab-518db6dad0e5-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 26, 2016 at 11:00:22PM -0400, Doug Ledford wrote:
> On 8/26/2016 6:27 PM, Jason Gunthorpe wrote:
...
> > 3) Version numbers. What version numbers do we give to the sub
> >    packages? I guess this is very distro specific.
> 
> You can not give different versions to sub-packages.  Or, allow me to be
> more precise:  You can't use the Version: tag on sub-packages, it resets
> the version of the entire package overall when you do.  The last
> Version: tag in the spec file ends up being the version applied to
> everything.  This impacts the %{version} macro usage in the spec file.
> The only way to put versions on sub-packages is to make it part of the
> sub-package's name.

I'm not so sure about that. Check out our linux-firmware package and
sub-packages. There are several firmwares with their own Version: tags in
their sub-package definitions, and the base linux-firmware package still
comes out of there with the intended original Version: from the top of the
spec. I suppose %{version} maybe does get stomped on, but the solution
I've seen used is to simply set an extra %global and use that where you
would have used %{version} in the spec.

That said, I tend to agree with what Doug is saying... If this is all one
big tree, then it's one big release, and should have one big consistent
version number, most likely. Otherwise, it's a massive headache and a bit
of a mess to maintain, package-wise, like he said.

-- 
Jarod Wilson
jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
