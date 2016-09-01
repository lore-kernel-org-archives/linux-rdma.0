From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Thu, 1 Sep 2016 13:36:16 -0500
Message-ID: <019b01d2047f$b9694f90$2c3beeb0$@opengridcomputing.com>
References: <1471889618-1605-1-git-send-email-jgunthorpe@obsidianresearch.com> <4f0876ce-f3c9-83e3-d0ef-0c5656ce9462@grimberg.me> <53eb35b4-0320-acd9-9969-73f5817c8144@sandisk.com> <20160901172355.GA20472@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160901172355.GA20472-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'Bart Van Assche' <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> On Thu, Sep 01, 2016 at 08:56:49AM -0700, Bart Van Assche wrote:
> > On 09/01/2016 08:24 AM, Sagi Grimberg wrote:
> > >Sorry for joining the discussion late. This looks *really* nice.
> > >
> > >FWIW, I think that it is a good starting point to set a real procedure
> > >to *upstream* user-space development. In the long run I think it's a
> > >win for everyone.
> > >
> > >Would it be possible to add srptools in the bundle too?
> > >CC'ing Bart who maintains it.
> >
> > Hello Jason and Sagi,
> >
> > Sorry that I was too busy recently to follow this thread. But I agree with
> > Sagi - if the purpose is to consolidate all RDMA user space code then I
> > think the srptools repo should also be included. The official repo is
> > available at http://git.openfabrics.org/?p=~bvanassche/srptools.git/.git.
> 
> Seems reasonable and on theme.
> 
> What do you want to do with the emulate_udev directory? It doesn't
> even look like it is built..
> 
> So we have nominations for
> 
> srptools http://git.openfabrics.org/?p=~bvanassche/srptools.git/.git.
> perftest git://git.openfabrics.org/~grockah/perftest.git master
> iwpm ?? (Steve Wise: do you have a cannonical link for this, Google isn't
>          helping me?)

git://git.openfabrics.org/~tnikolova/libiwpm

Tatyana, please correct me if I'm wrong.

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
