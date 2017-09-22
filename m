From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: crash in 4.14-rc1 with IPoIB
Date: Fri, 22 Sep 2017 17:06:26 -0400
Message-ID: <1506114386.120853.2.camel@redhat.com>
References: <20170920095339.zhfymeyfbhiyepz5@linux-x5ow.site>
         <20170920163237.GD536@obsidianresearch.com>
         <1506101272.5172.11.camel@redhat.com>
         <20170922194834.GA26479@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170922194834.GA26479-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Thomas Bogendoerfer <tbogendoerfer-l3A5Bk7waGM@public.gmane.org>, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2017-09-22 at 13:48 -0600, Jason Gunthorpe wrote:
> On Fri, Sep 22, 2017 at 01:27:52PM -0400, Doug Ledford wrote:
> > On Wed, 2017-09-20 at 10:32 -0600, Jason Gunthorpe wrote:
> > > On Wed, Sep 20, 2017 at 11:53:39AM +0200, Johannes Thumshirn
> > > wrote:
> > > > I wanted to try out Christoph's NVMe multipathing patchset on
> > > > my
> > > > NVMe OmniPath
> > > > setup and merged it into 4.14-rc1. On bootup I stumbled upon
> > > > that
> > > > splat and no
> > > > RDMA operation was possible:
> > > 
> > > I think this was already found and fixed a month ago?? The oops
> > > is
> > > the same:
> > > 
> > > https://patchwork.kernel.org/patch/9932505/
> > > 
> > > Doug, one of the topics during the LPC was 'what to QA' - it
> > > obviously causes QA problems if known bugs are left to sit on the
> > > mailing list for a month :(
> > 
> > A few things:
> > 
> > 1)  It wasn't a month
> > 2)  I was out on well known, pre-announced PTO
> > 3)  I've got it now
> > 
> > I can't do much else about it.
> 
> Just so we are talking about the same expectation..
> 
> The patch v1 was on Aug 30, you accepted it on Sep 20, as I write
> this
> I don't see it on your k.o. I see it in your github tree, so I know
> it
> is on the way.
> 
> If you push it to k.o at EOD today it will be ~27 days before it gets
> into the hands of anyone doing QA based on your k.o tree.
> 
> If you send a PR on Monday it will be > 28 days before it gets into
> the hands of anyone doing QA from Linus's tree.
> 
> I know this patch unavoidably overlaps with your PTO, but this is
> still essentially an example of the topic we discussed at LPC..
> 
> As a concrete recommendation, pushing this kind of patch to your k.o
> right away on the 20th and skipping the github 0day process might be
> helpful..

Sure, I get that, but I was already out on PTO on the 30th.  What sucks
is that it landed right after I was out.  But I plan to have the pull
request in before EOB today, so the difference between the 20th and
today is neglible.  Especially since lots of people doing QA testing
prefer to take -rc tags, in that case, the difference is non-existent.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57
2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
