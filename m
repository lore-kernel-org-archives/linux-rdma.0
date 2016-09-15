From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Thu, 15 Sep 2016 14:36:54 -0500
Message-ID: <02a501d20f88$8386bca0$8a9435e0$@opengridcomputing.com>
References: <20160915065242.GO26069@leon.nu> <20160915080600.GA31776@infradead.org> <20160915081149.GT26069@leon.nu> <20160915081327.GA7572@infradead.org> <20160915083945.GU26069@leon.nu> <20160915160427.GC18154@obsidianresearch.com> <01e901d20f6b$7ae067d0$70a13770$@opengridcomputing.com> <20160915163756.GB26069@leon.nu> <20160915164931.GC26111@obsidianresearch.com> <022e01d20f84$a3685870$ea390950$@opengridcomputing.com> <20160915192628.GB437@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160915192628.GB437-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Leon Romanovsky' <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yarong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> > > > Do we want to create rdma-tools after this task will be completed? For
> > example
> > > > with debug and performance tools in it.
> > >
> > > Prolification of repositories is exactly what this is intended to
> > > prevent :(
> >
> > The goal would be to move all the tools/cmds/etc into one repo.  How is that
> > prolification?
> 
> I guess I should wait and see what could end up in there before
> commenting...
> 

I think we should shelf this discussion until we get our current project done...

But... :)

A quick gander at the OFED packages produces this list of possible candidates:

dapl  (perhaps dapl should be in rdma-plumbing?)
fabtests
ibacm
ibpd
ibsim
ibutils
infiniband-diags
infinipath-psm
mstflint
opensm
perftest
qlvnictools
qperf
rds-tools



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
