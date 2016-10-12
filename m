From: "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: rdma-core release?
Date: Wed, 12 Oct 2016 19:00:34 +0000
Message-ID: <9C6B67F36DCAFC479B1CF6A967258A8C7DE23BA8@ORSMSX115.amr.corp.intel.com>
References: <20161012105103.GA30534@infradead.org>
 <CALq1K=JEkvN_4tZL9D53c6-EH9E4efay8rmoyBEyB-7Sxr6H-w@mail.gmail.com>
 <59ebde13-0fcd-0640-e750-bb6e57bfb921@redhat.com>
 <00c801d22496$f31798f0$d946cad0$@opengridcomputing.com>
 <20161012163149.GA20174@infradead.org>
 <20161012164759.GB18838@obsidianresearch.com>
 <9C6B67F36DCAFC479B1CF6A967258A8C7DE23B5D@ORSMSX115.amr.corp.intel.com>
 <20161012183548.GA31053@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161012183548.GA31053-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Leon Romanovsky' <leon-2ukJVAZIZ/Y@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason wrote,

>What does OFED do, and what do you want? Closeness to current distro packaging? Closeness to future packaging? Something OFED >specific?

I think this is still a TBD and needs further discussion within the OFA EWG and with Vlad to see what makes the most sense.
We clearly have to comprehend things like upgrading from older versions of OFED and consider things that the Linux distro
might want us to do to make their lives easier, and the answer to that is likely different depending on the Linux distro. 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
