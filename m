From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Sat, 23 Sep 2017 10:25:53 -0400
Message-ID: <1506176753.120853.65.camel@redhat.com>
References: <1506114769.120853.7.camel@redhat.com>
         <CA+55aFz2hYPEkweckHKpOU45bHQU7tFLKYoVWaMGduMSP4NCFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFz2hYPEkweckHKpOU45bHQU7tFLKYoVWaMGduMSP4NCFA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2017-09-22 at 17:23 -1000, Linus Torvalds wrote:
> On Fri, Sep 22, 2017 at 11:12 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> wrote:
> > 
> > - Smattering of miscellanous fixes
> > - A five patch series for i40iw that had a patch (5/5) that was
> > larger
> >   than I would like, but I took it because it's needed for large
> > scale
> >   users
> > - An 8 patch series for bnxt_re that landed right as I was leaving
> > on
> >   PTO and so had to wait until now...they are all appropriate fixes
> > for
> >   -rc IMO
> 
> Honestly, I'm not sure if I'm going to pull this. I already got one
> "fix" pull request today that I didn't think was just fixes.
> 
> This looks very similar - fixes mixed in with what looks like
> development and new features that have never worked before.

I disagree...I just went through the list of patches I sent you, and if
there's something there you don't think is a fix, I'm happy to hear
about it.  But from my reading, they are all fixes.  The only one
that's possibly arguable is f16dc0aa5ea2 (i40iw: Add support for port
reuse on active side connections) and I specifically called that one
out and listed the reason I included it.

> I thought we agreed thar rdma wasn't going to continue to be "that
> subsystem"?

I don't think that's the case here.  Please let me know any patches in
this list that you disagree with being fixes.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
