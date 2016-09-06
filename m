From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Tue, 6 Sep 2016 12:15:12 -0600
Message-ID: <20160906181512.GB26743@obsidianresearch.com>
References: <1471889618-1605-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <bb889a58-331c-8ba8-920d-e3a79072dce4@dev.mellanox.co.il>
 <20160906163708.GA3862@obsidianresearch.com>
 <a815efb1-424f-10a6-468e-d94f420a73be@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a815efb1-424f-10a6-468e-d94f420a73be-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 06, 2016 at 01:05:33PM -0400, Hal Rosenstock wrote:
> On 9/6/2016 12:37 PM, Jason Gunthorpe wrote:
> > On Tue, Sep 06, 2016 at 09:59:48AM -0400, Hal Rosenstock wrote:
> > 
> >> It would be nice if history from the original repos was
> >> preserved/propagated into this combined repo. Is there a reason that
> >> wasn't done ?
> >
> > Of course this was done. I talked about it at length in the first
> > email. What are you seeing that makes you think otherwise?
> 
> I was basing my comment based on git log not including all the commits.

??

$ git log  | grep -i commit | wc -l
2421

> > Note that git has all sorts of weirdness with rename handling so this
> > doesn't always work so well.. eg github's single file history doesn't
> > work, but 'git log --follow' mostly does.
> 
> I see git log doesn't show older commits but you can get them with
> --follow one file at a time.

Right, you cannot do 'git log --follow libibumad/' for instance, that
is a documented limitation of git.

You can get around this manually...
$ git log libibumad/ | grep -i commit
[..]
7a47c9614206e790e2e504c22fc698fe96e1bb5b
$ git log 7a47c9614206e790e2e504c22fc698fe96e1bb5b
[now you see the natural commit list from the original libibumad]

The repository is constructed properly, but git's rename handling does
not do everything you might want.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
