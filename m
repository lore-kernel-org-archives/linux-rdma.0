From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH for-next V2 0/9] Add completion timestamping support
Date: Thu, 11 Jun 2015 19:48:52 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FEE106@ORSMSX109.amr.corp.intel.com>
References: <1433074457-26437-1-git-send-email-ogerlitz@mellanox.com>
 <1433098827.114391.179.camel@redhat.com>
 <CAAKD3BBo9A5AV9Uv-q1TgSQ6hs-oSUn5QsUT+5+6mk1RwW7AUA@mail.gmail.com>
 <1433157904.114391.188.camel@redhat.com>
 <20150601164322.GA14391@obsidianresearch.com>
 <1433255724.114391.225.camel@redhat.com>
 <20150602180844.GD17776@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FE4F16@ORSMSX109.amr.corp.intel.com>
 <20150604164759.GC27699@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FE4F98@ORSMSX109.amr.corp.intel.com>
 <alpine.DEB.2.11.1506060318570.29860@east.gentwo.org>
 <1828884A29C6694DAF28B7E6B8A82373A8FE5AB8@ORSMSX109.amr.corp.intel.com>
 <alpine.DEB.2.11.1506092018190.6681@east.gentwo.org>
 <1828884A29C6694DAF28B7E6B8A82373A8FE6746@ORSMSX109.amr.corp.intel.com>
 <alpine.DEB.2.11.1506111010580.18426@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1506111010580.18426-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Intel is supporting multicast in hardware. Its just a bad implementation
> (broadcast and filtering MC groups in the HCA or what was that?) and there
> is no plan to fix the issues despite the problem being known for quite
> some time. Also does this mean that libfabric only to supports the
> features needed by Intel?

Libfabric supports whatever features apps require and the participating vendors want to provide.  However, I, personally, have a limited amount of time to my day and will focus my effort on either what my management requires of me or areas that are most interesting.  Libfabric is specifically designed to be vendor, transport, and implementation neutral.

> I would be interested to see some measurements. AFAICT the Intel solutions
> are based on historically inferior IB technology from Qlogic which has
> never been able in my lab tests to compete latency wise with other
> vendors. I have heard these latency claims repeatedly from Qlogic
> personnel over the years.

You are referring to hardware latency.  Libfabric is software.  No amount of software is going to overcome hardware limitations.  The entire reason multicast support was removed from libfabric 1.0 was that the proposed API would have introduced latency by adding a branch into the code path.

> This is a well designed solution and its easy to use.

I fundamentally disagree with the practice of ad-hoc API design.  I stated this on the mail list probably 3 years ago.  I see nothing wrong with allowing and encouraging vendor specific extensions.

> It would help libfabric if you would work with other vendors and
> industries to include support for their needs. MPI is not the only
> applications that are running on the fabrics. I understand that is
> historically the only area in which Qlogic hardware was able to compete
> but I think you need to move beyond that. APIs should be as general as
> possible abstracting hardware as much as possible. A viable libfabric
> needs to be easy to use, low overhead as well as covering the requirements
> of multiple vendors and use cases.

Libfabric included requirements from multiple users and applications - MPI, SHMEM, PGAS, DBMS, and sockets all provided input.  It chose to target MPI as an initial priority, but it is not limited to MPI at all.  It also works with other vendors, including vendors that do not support the verbs interfaces -- Cisco, Cray, Intel PSM, plus others.  I, personally, ensured that libfabric would layer well over verbs based hardware.  That doesn't mean that I'm obligated to provide optimized providers over everyone's hardware.

The goal was not to spend 3 years working on a new API, but to get something usable within a short timeframe that could be extended.  OFIWG could have taken a different approach, but this was what the community (not Intel) selected.

As a company, Intel has many products.  A competitor in one area of the company may be a partner in another.  Xeon is by far the most important to this discussion.  It's why Intel dedicated developers to enabling high performance networking in Linux for over 10 years -- even before Intel had any products in those spaces.  And it's why Intel continues to fund development.  Sure, Intel now has IB and Omni-Path Architecture products, but they also have iWarp and Ethernet.  Intel MPI runs over a bunch of different fabrics.  Libfabric doesn't just need to work well over Intel NICs, it needs to work well over Intel platforms.

Returning to this thread, if I had to add time stamps to libfabric, I would still add 2 time stamps into a new completion structure.  Those time stamps would be selected using a method similar to what Doug stated in an earlier email.  The app would use an enum to select what the time stamps would capture.  However, I would lean more to having those values specified as part of the endpoint attributes, rather than the CQ.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
