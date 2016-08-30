From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Tue, 30 Aug 2016 10:10:40 -0600
Message-ID: <20160830161040.GB26778@obsidianresearch.com>
References: <20160822214352.GB11695@obsidianresearch.com>
 <20160823185441.GA1233@obsidianresearch.com>
 <cabbd0a7-0918-a8dd-d1e5-0b079f0c4604@redhat.com>
 <c84de2a5-6526-c0a6-6535-519add3fbabb@dev.mellanox.co.il>
 <20160828182715.GA12783@obsidianresearch.com>
 <765b7e2d-51e0-98aa-60d1-26be35eb7a3d@dev.mellanox.co.il>
 <20160829163453.GC23557@obsidianresearch.com>
 <aaf8d6ba-6dc2-51d9-b014-dcc10114079f@dev.mellanox.co.il>
 <20160829203711.GC3201@obsidianresearch.com>
 <60e502b0-0933-588e-8afe-afead230b2a1@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <60e502b0-0933-588e-8afe-afead230b2a1-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, yarong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 30, 2016 at 11:13:22AM +0300, Yishai Hadas wrote:
> http://git.openfabrics.org/git/?p=~yishaih/libmlx5.git;a=shortlog, in the
> last 7 months there are activities in a monthly basis. When there is some
> GAP it was mostly because of waiting to feature acceptances in libibverbs.
> (e.g. time stamping).

You are looking at authorship date stamps, I was looking when the
patches were finally commited, that is much more gappy than what the
authorship implies.

There were two series in 2016-06, a big gap and few series in 2016-03,
a few in 2016-02, little around 2015-11, and absolutely nothing till
2015-01.

If you were doing 30 patches/month then I'd worry. But you aren't. At
best one-two series a month, almost all linked with a verbs & kernel
series that have to go through Doug anyhow.

> Also most of the commits in libibverbs are coming from Mellanox in
> the last few years. Any new process should consider the ability to
> move more faster here, and for sure *not* to come into a case that
> process is even slower.

Well, building a better community around verbs and it's standard is an
excellent start.

Having a central rallying point (like Sean has developed with
libfabric) is a positive direction.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
