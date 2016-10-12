From: "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: rdma-core release?
Date: Wed, 12 Oct 2016 18:17:45 +0000
Message-ID: <9C6B67F36DCAFC479B1CF6A967258A8C7DE23B5D@ORSMSX115.amr.corp.intel.com>
References: <20161012105103.GA30534@infradead.org>
 <CALq1K=JEkvN_4tZL9D53c6-EH9E4efay8rmoyBEyB-7Sxr6H-w@mail.gmail.com>
 <59ebde13-0fcd-0640-e750-bb6e57bfb921@redhat.com>
 <00c801d22496$f31798f0$d946cad0$@opengridcomputing.com>
 <20161012163149.GA20174@infradead.org>
 <20161012164759.GB18838@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161012164759.GB18838-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Leon Romanovsky' <leon-2ukJVAZIZ/Y@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason wrote,
>One of the best ways to get it tested is to get it to go through the full OFED process.

>Woody, what could we do to help make that happen? Do you know of any blocker?

>I think this will be the best for everyone. I also predict that OFED will be under pressure to quickly take up the new drivers that will land in >4.9, and their user space will live in rdma-core.

>I also propose we give someone from the OFED team repo access and they can maintain a public branch for ofed-4.8 with any backported >fixes.

>Jason

We have just started work on OFED-4.8, so there is still a possibility to move to the new tree as the basis for the user-space code that
that goes into OFED. I think that Vlad (who is the OFED integration engineer) was waiting till things were a little more finalized
and wait till all packaging was flushed out before moving to the new code base. I think it would be desirable if there were some kind of official release tar ball or at least official release git tag that is recommended by you guys that we should use in OFED. 
Currently the way OFED handles user-space packages is that we wait till the maintainer of a user-space package produces a release for their user-space component, which is a tar ball with the spec files that can be used to produce SRPMS. 

I have not followed this really closely, but have you guys finalized how the packaging in SRPMs will/should work ? Or is that an exercise left up to the Linux distros and/or OFED to decide on ?

In any case, Vlad is on vacation for a couple weeks, so he probably cannot re-look at this until after Nov 1 when he returns, so you have some time to decide on how you want to handle releases for this.
woody

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
