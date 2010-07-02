From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: When IBoE will be merged to upstream?
Date: Fri, 2 Jul 2010 01:35:36 -0600
Message-ID: <20100702073536.GB7958@obsidianresearch.com>
References: <AANLkTikXzoaRl61ivsc7fm8EdO9Ucz4iGGfclFOQl3kK@mail.gmail.com> <adabpb1s58c.fsf@roland-alpha.cisco.com> <E113D394D7C5DB4F8FF691FA7EE9DB4439A78AFE88@MTLMAIL.mtl.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF259E7DE3D0@orsmsx501.amr.corp.intel.com> <E113D394D7C5DB4F8FF691FA7EE9DB4439A78AFF16@MTLMAIL.mtl.com> <20100624203701.GA4630@obsidianresearch.com> <E113D394D7C5DB4F8FF691FA7EE9DB4439A78B0042@MTLMAIL.mtl.com> <20100625155755.GC4630@obsidianresearch.com> <E113D394D7C5DB4F8FF691FA7EE9DB4439BA54B70E@MTLMAIL.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <E113D394D7C5DB4F8FF691FA7EE9DB4439BA54B70E-WQlSmcKwN8Te+A/uUDamNg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Aleksey Senin <aleksey-192fA4vuk7xBDLzU/O5InQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "monis-smomgflXvOZWk0Htik3J/w@public.gmane.org" <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org" <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org" <yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org" <alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 01, 2010 at 02:50:55PM +0300, Liran Liss wrote:

> We have a specification, we have an implementation, and we have
> clean way of passing RoCE L2 information to user-space via address
> handles.  I don't see any substantial reason to change the basic
> approach.

Actually, we have a spec that omits how to do the L3 to L2 address
mapping - and there is much disagreement on this point. Since no
standard was reached then agreement will have to be reached at least
with the Linux maintainers before I think anything can realistically
be merged.

The basic approach must be something people can agree on, and it seem
pretty clear to me at least that the current approach is not agreeable
to many people.

All three of your points are all entirely avoidable if you simply
stick to the idea that the L3 address is a GID and not an IP, and rely
on IPoIB like RDMA-CM mechanisms to go from IP to GID to L2 MAC/VLAN.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
