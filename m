From: "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: libmlx4 and libmlx5 git trees? Who is handling those?
Date: Mon, 28 Sep 2015 22:08:49 +0000
Message-ID: <9C6B67F36DCAFC479B1CF6A967258A8C7D250B6A@ORSMSX110.amr.corp.intel.com>
References: <alpine.DEB.2.20.1509281036520.30603@east.gentwo.org>
 <56096033.8040000@redhat.com> <20150928171724.GF12415@obsidianresearch.com>
 <alpine.DEB.2.20.1509281220580.31260@east.gentwo.org>
 <9C6B67F36DCAFC479B1CF6A967258A8C7D250932@ORSMSX110.amr.corp.intel.com>
 <20150928173208.GA8083@infradead.org>
 <20150928174215.GB1623@obsidianresearch.com>
 <9C6B67F36DCAFC479B1CF6A967258A8C7D25098A@ORSMSX110.amr.corp.intel.com>
 <20150928190024.GB8358@obsidianresearch.com> <5609A19A.806@redhat.com>
 <20150928211546.GA10311@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150928211546.GA10311-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason wrote,
>I was commenting specifically on the idea that we'd ever release a libverbs that forced a kernel upgrade. I hope we all agree that is not acceptable.

This means that user-space and kernel space packages can be released on separate schedules, so there is no need to tie the two together. That is good. 

>IMHO - we should be talking about getting to the point where we can deliver the kernel rc and uapi rc together to someplace like UNH and vendor internal labs and >expect them to test that pair. Regularly, ideally on the kernel release time line.

I am all for doing more testing earlier, but I am not sure that people (like UNH and the vendor validation teams will sign up to do it. 
This would essentially double their testing effort (and costs), first testing the
user-space packages with the upstream kernel that is under development, but also still having to test what comes out of the distro or OFED. This is because it is 
what is in OFED and/or the distro that their customers will actually run. Very few customers actually run the kernel.org kernel, they run what is in the distro. 
And BTW, UNH gets paid to do testing, so someone would have to cough up the $$ to get them to add this additional testing. 

So it all really comes down to resources and cost and being able to justify that doing more testing of upstream code is worth it. 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
