From: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Status of "ummunot" branch?
Date: Fri, 14 Jun 2013 22:53:24 +0000
Message-ID: <EF66BBEB19BADC41AC8CCF5F684F07FC4F6886C8@xmb-rcd-x01.cisco.com>
References: <20130605181853.GB1946@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65DF6F@xmb-rcd-x01.cisco.com>
 <20130605190529.GA3044@obsidianresearch.com> <51B023B9.9050000@mellanox.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F66B79C@xmb-rcd-x01.cisco.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F66E403@xmb-rcd-x01.cisco.com>
 <20130607235731.GA25942@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F676E59@xmb-rcd-x01.cisco.com>
 <20130610172627.GC2391@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F680A2B@xmb-rcd-x01.cisco.com>
 <20130612214708.GD8625@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130612214708.GD8625-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Content-ID: <899D5EC013E58C489ADFCDB4E99B0B4A-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Jun 12, 2013, at 5:47 PM, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> Someone has to finish the ummunotify rewrite Roland
> started. Realistically MPI is going to be the only user, can someone
> from the MPI world do this?

1. I tried to ask what needed to be done at the beginning of this thread and didn't get much of an answer.

2. We've (all) been asking for this functionality *for years*; I even helped with the first implementation.  Can't the verbs community finish it?  :-)  MPI is probably your biggest customer, after all...

>> ...but this is not how people write applications.  Real apps use
>> malloc (and some direct mmap, and perhaps even some shared memory).
> 
> *shrug* I used MAP_FIXED for some RDMA regions in my IB verbs apps,
> specifically to create specalized high-performance memory
> structures.

But you're not a chemist writing Fortran code to effect n-body simulations.

The target audience for MPI is scientists and engineers who are not (and should not be) network / systems developers.  They're focusing on their formulae and applications -- as they should be.

> It isn't a general purpose technique for non-RDMA apps - but
> especially when combined with ODP it is useful in some places.

I have no doubt that ODP solves problems for someone.  It just doesn't seem to solve the very-long-standing MPI issues with verbs and registration caches.

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to: http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
