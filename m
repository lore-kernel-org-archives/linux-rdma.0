From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Thu, 15 Sep 2016 11:39:05 -0500
Message-ID: <01fe01d20f6f$ac5ba780$0512f680$@opengridcomputing.com>
References: <6d47ca96-25eb-8358-879d-fc646ddda9cb@grimberg.me> <20160906110729.GM21847@leon.nu> <20160915061753.GD4869@infradead.org> <20160915065242.GO26069@leon.nu> <20160915080600.GA31776@infradead.org> <20160915081149.GT26069@leon.nu> <20160915081327.GA7572@infradead.org> <20160915083945.GU26069@leon.nu> <20160915160427.GC18154@obsidianresearch.com> <01e901d20f6b$7ae067d0$70a13770$@opengridcomputing.com> <20160915163756.GB26069@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160915163756.GB26069-2ukJVAZIZ/Y@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Leon Romanovsky' <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yarong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> On Thu, Sep 15, 2016 at 11:09:04AM -0500, Steve Wise wrote:
> > > On Thu, Sep 15, 2016 at 11:39:45AM +0300, Leon Romanovsky wrote:
> > >
> > > > Easy option is to include "rdma" word in the name and enjoy built-in
> > > > UI to release packages [1].
> > >
> > > I think we should do this, I agree with Christoph, if you go through
> > > the github gui and pick the clone path in 'Clone or Download' then the
> > > resulting clone should be called rdma-user/
> > >
> >
> > Ditto.  And I like rdma-user over rdma-userspace...
> 
> Looks nice.
> 
> Do we want to create rdma-tools after this task will be completed? For example
> with debug and performance tools in it.

I think so.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
