From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Status of "ummunot" branch?
Date: Fri, 14 Jun 2013 17:11:17 -0600
Message-ID: <20130614231117.GA21525@obsidianresearch.com>
References: <20130605190529.GA3044@obsidianresearch.com>
 <51B023B9.9050000@mellanox.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F66B79C@xmb-rcd-x01.cisco.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F66E403@xmb-rcd-x01.cisco.com>
 <20130607235731.GA25942@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F676E59@xmb-rcd-x01.cisco.com>
 <20130610172627.GC2391@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F680A2B@xmb-rcd-x01.cisco.com>
 <20130612214708.GD8625@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F6886C8@xmb-rcd-x01.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <EF66BBEB19BADC41AC8CCF5F684F07FC4F6886C8-nsZYYkk5h5QQ2GdVW7+PtKBKnGwkPULj@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 14, 2013 at 10:53:24PM +0000, Jeff Squyres (jsquyres) wrote:
> On Jun 12, 2013, at 5:47 PM, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> 
> > Someone has to finish the ummunotify rewrite Roland
> > started. Realistically MPI is going to be the only user, can someone
> > from the MPI world do this?
> 
> 1. I tried to ask what needed to be done at the beginning of this
> thread and didn't get much of an answer.

AFAIK, only Roland knows the state of his rewrite, hopefully he will
comment.. I told you everything I know about what happened with the
last attempt :|

> 2. We've (all) been asking for this functionality *for years*; I
> even helped with the first implementation.  Can't the verbs
> community finish it?  :-) MPI is probably your biggest customer,
> after all...

There isn't much of a verbs community, to be honest. Unless you can
get a vendor to commit resources to the project, I wouldn't expect
much.

> I have no doubt that ODP solves problems for someone.  It just
> doesn't seem to solve the very-long-standing MPI issues with verbs
> and registration caches.

As we've discussed it helps write a registration cache.

The 'All of address space' varient that Haggai mentioned should also
be very interesting.

But this is all future stuff.

FWIW, I agree with you that ummunot is something MPI really needs to
function.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
