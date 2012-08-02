From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: Kernel panic under 3.2.14 Xen dom0 and SCST trunk
Date: Thu, 02 Aug 2012 16:12:08 -0400
Message-ID: <1343938328.25205.17.camel@frustration.ornl.gov>
References: <CAOzFzEjjbofQZyubdpH10WKeoE3-grMVdEOqJhJtbRtMdgCr=Q@mail.gmail.com>
	 <CAOzFzEjDHpTROUcKg9cOZkNSX1LnShSombgt26+VOptVdy5i-Q@mail.gmail.com>
	 <501A5EB0.4060904@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <501A5EB0.4060904-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2012-08-02 at 11:04 +0000, Bart Van Assche wrote:
> On 07/24/12 15:43, Joseph Glanville wrote:
> > [35404.804723] BUG: unable to handle kernel NULL pointer dereference at (null)
> 
> I've been able to reproduce this ib_srp crash. Apparently if an SRP
> response is received after srp_reset_host() has been invoked
> srp_process_rsp() tries to call scmnd->scsi_done(scmnd) with scsi_done
> == NULL, hence the kernel oops. A candidate fix is available in this
> (rebased) tree: http://github.com/bvanassche/linux/tree/srp-ha.

Hmm, I stopped looking at the thread when I noted the same points Roland
did -- it looked like it was in the target rather than the initiator,
and that ib_srp wasn't loaded (though it could have been built-in).

I think I'm good with your fix, given a few minor changes:
      * rebase it to mainline (I tried it quickly, got conflicts that
        should be simple to resolve)
      * s/srp_remove_req/srp_claim_req/ as it doesn't remove the
        request. This isn't an issue you introduced; it should probably
        have been renamed some time ago.
      * in srp_remove_req(), the test for (scmnd && req->scmnd == scmnd)
        should probably be marked likely()
      * Similarly, the !scmnd test in srp_process_rsp() should be
        unlikely()
      * The reclamation of credits should be moved to srp_free_req(),
        since we could see the case where a credit is available without
        a corresponding request structure.
      * Get rid of the BUG_ON in srp_process_rsp(); in the past, I would
        have probably added it myself, but Andrew Morton called me on
        one I had tried to add, and he was right -- it doesn't add
        anything.
      * I wonder if srp_free_req() is the right name, but I think I'm
        deep in bike-shedding territory here.

It'd be nice if we could avoid taking the lock twice in quick succession
during normal operations, but that's something for later.

We should get this into 3.6, and send it to stable as well. I can make
the changes if you'd like, just let me know.

Thanks,

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
