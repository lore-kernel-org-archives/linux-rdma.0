From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [GIT PULL] ib_srpt: Initial SRP Target merge for v3.2-rc1
Date: Sat, 05 Nov 2011 11:04:03 -0700
Message-ID: <1320516243.5859.184.camel@haakon2.linux-iscsi.org>
References: <1320437452.5859.96.camel@haakon2.linux-iscsi.org>
	 <CAO+b5-pOi_+Y+jcExxEzParHOdU6YB4WaB-onH_PLXugzLKjzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-pOi_+Y+jcExxEzParHOdU6YB4WaB-onH_PLXugzLKjzg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, 2011-11-05 at 08:37 +0100, Bart Van Assche wrote:
> On Fri, Nov 4, 2011 at 9:10 PM, Nicholas A. Bellinger
> <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
> > This is the PULL request for an initial merge of the ib_srpt driver
> > using mainline target infrastructure into v3.2-rc1.
> 
> In case anyone is interested, the most important unaddressed comments
> for this version of ib_srpt are:
> - There are still too many module parameters. This makes ib_srpt
> harder to use than necessary because several of these parameters can
> only be set at module load time.

Can you be more specific here..?  I went through the module parameters
and made the ones that where used in a per-port specific context into
configfs attributes as Roland recommended, but it seems like you are
saying that more should be made into attributes.  Which ones..?

> - The last WQE event can arrive before the queue pair is reset,
> resulting in a hanging session and blocking future logins
> (http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg09678.html).

Yep, was going to get this resolved post merge along with my patch now
in lio-core.git to address active I/O shutdown with ib_srpt.

> - The "ib_srpt: Convert srp_max_rdma_size into per port configfs
> attribute" contradicts the I/O controller concept. This is a bug.
> (http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg09677.html).
> 

As mentioned in the thread, I deferred to Roland's input on that one.
So you're saying this should be made back into a module parameter now,
or what..?

--nab


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
