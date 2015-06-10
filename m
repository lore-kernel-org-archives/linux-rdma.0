From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next V2 0/9] Add completion timestamping support
Date: Wed, 10 Jun 2015 11:45:51 +0300
Message-ID: <5577F93F.9030405@mellanox.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1506092018190.6681-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/10/2015 4:26 AM, Christoph Lameter wrote:
>> >I have no problem with a bare metal interface exposing this.  But pretendin=
>> >g that it's generic and that this is the one and only way that this could b=
>> >e implemented doesn't make it so.
> This is a way it was implemented and its usable. Shooting for pie in the
> sky does not bring us anything. Nor ideas of requirements from a new
> experimental API that does not support the basic features that we need
> and seems to be on its way to mess up the latencies of access to RDMA operations.

Doug,

What's your maintainer say here?

The current proposal has:

1. raw HCA clock completion generation time-stamp for CQEs
2. HCA clock frequency in KHZ
3. mask telling how many bits are relevant from the 64bit time-stamp

This is fairly simple, practical and very much usable to FSI 
applications and users, and can be extended later if someone comes up 
with better/other combination of the frequency/mask. Have a GO?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
