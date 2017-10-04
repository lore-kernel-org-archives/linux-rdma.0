From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 0/8] IB/hfi1, core, rdmavt: Driver fixes for
 10/2/2017
Date: Wed, 04 Oct 2017 15:44:21 -0400
Message-ID: <1507146261.46071.8.camel@redhat.com>
References: <20171002180204.31117.12254.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171002180204.31117.12254.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrzej Kacprowski <andrzej.kacprowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Niranjana Vishwanathapura <Niranjana.Vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-10-02 at 11:03 -0700, Dennis Dalessandro wrote:
> Hi Doug,
> There are a couple fixes in here that would have been nice to get
> into the RC
> cycle, including one marked stable. However I think you will find
> them to be
> too many LOC for an rc-4 submission so I have sent them in one series
> for-next.
> Patches 2,3,4 and 5 are the fixes. Patch 2 is small but it's not
> really that
> important to the end user.
> 
> There are some clean ups in here from Don from the 16B changes. One
> takes care
> of some sparse warnings and the other two are from a WARN_ON_ONCE
> that needed
> special cased for OPA.
> 
> Patches can can also be found in my GitHub repo at:
> https://github.com/ddalessa/kernel/tree/for-4.15

Hi Denny,

I didn't process that you mixed for-rc and for-next stuff in a single
thread before I had gone through and looked at the patches and
processed them.  So, this time they all went to for-next.  In the
future, you really need patches you want in for-rc separate from the
patches intended for for-next.

Anyway, applied.  And 2 and 5 are the only ones I would have been
likely to take to for-rc right now, and 2 isn't that important to the
end user as you say, so that just leaves 5, and it's sparse warnings,
so we'll just leave things as they are.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
