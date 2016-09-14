From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Tue, 13 Sep 2016 22:04:58 -0600
Message-ID: <20160914040458.GA7975@obsidianresearch.com>
References: <53eb35b4-0320-acd9-9969-73f5817c8144@sandisk.com>
 <20160901172355.GA20472@obsidianresearch.com>
 <019b01d2047f$b9694f90$2c3beeb0$@opengridcomputing.com>
 <20160902233231.GA26309@obsidianresearch.com>
 <ef8214f8-d44d-2289-d1ed-a0998e9e05c0@sandisk.com>
 <20160903051222.GA2098@obsidianresearch.com>
 <20160904055441.GI21847@leon.nu>
 <20160904235555.GA21542@obsidianresearch.com>
 <20160905124802.GX21847@leon.nu>
 <20160905174636.GC14403@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160905174636.GC14403-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 05, 2016 at 11:46:36AM -0600, Jason Gunthorpe wrote:
> On Mon, Sep 05, 2016 at 03:48:02PM +0300, Leon Romanovsky wrote:
> 
> > > Folks can decide how much of this stuff should go on into the main
> > > repository later on..
> > 
> > I completely missed that tooling branch. It looks like it misses the
> > Debian image.
> 
> Only 'make' works for Debian. There is no .deb packaging yet.

I have just pushed sample Debian packaging, please let me know what
you think.

The DEB stuff is much closer to production ready than the RPM example,
and illistrates my proposed package split:

ibverbs-providers_11-1_amd64.deb
ibverbs-utils_11-1_amd64.deb
iwpmd_11-1_amd64.deb
libibcm-dev_1.0.11-1_amd64.deb
libibcm1-dbg_1.0.11-1_amd64.deb
libibcm1_1.0.11-1_amd64.deb
libibumad-dev_3.1.11-1_amd64.deb
libibumad3-dbg_3.1.11-1_amd64.deb
libibumad3_3.1.11-1_amd64.deb
libibverbs-dev_1.2.11-1_amd64.deb
libibverbs1-dbg_1.2.11-1_amd64.deb
libibverbs1_1.2.11-1_amd64.deb
librdmacm-dev_1.1.11-1_amd64.deb
librdmacm1-dbg_1.1.11-1_amd64.deb
librdmacm1_1.1.11-1_amd64.deb
rdmacm-utils_11-1_amd64.deb
srptools_11-1_amd64.deb

Debian will be able to gain 5 new providers, iwpmd and a spattering of
newer versions.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
