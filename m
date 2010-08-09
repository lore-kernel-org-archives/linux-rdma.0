From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: About a shortcoming of the verbs API
Date: Mon, 09 Aug 2010 14:58:25 -0400
Message-ID: <1281380305.4734.9.camel@lap75545.ornl.gov>
References: <AANLkTi=zowawGDjyh+uKve_NiRNMXcrqjAk0hRxGSMOv@mail.gmail.com>
 <AANLkTinHRnt-jvy0xBOAPUDGcfx6=V6rkRT3t0Ja52FP@mail.gmail.com>
 <adamxtejbes.fsf@roland-alpha.cisco.com>
 <AANLkTinYuyCqJ6_wq6GH0vQGAY-mwC=7ZLicBnXO+efB@mail.gmail.com>
 <adafwz4g98j.fsf@roland-alpha.cisco.com>
 <AANLkTimAk0k-q1EKjaXOadoXvKXbEN9nAky0w1rjixxB@mail.gmail.com>
 <20100727182046.GT7920@obsidianresearch.com>
 <AANLkTimc3iS8=8ZQ9u8tOLP4-q_e+o0=AncZj-Mbre2g@mail.gmail.com>
 <adavd7mz8m9.fsf@roland-alpha.cisco.com>
 <AANLkTinKsLNoia96AVDA6fP9Es5_2Rq_wTgY=z6wk_FE@mail.gmail.com>
 <1281365347.4968.5.camel@lap75545.ornl.gov> <4C604CB4.5060705@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <4C604CB4.5060705-d+Crzxg7Rs0@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Linux-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2010-08-09 at 22:45 +0400, Vladislav Bolkhovitin wrote:
> David Dillow, on 08/09/2010 06:49 PM wrote:
> > I'm not sure it makes sense to enable/disable this at runtime -- we
> > don't do it for NAPI, why do it for block devices? I'm not even sure I'd
> > want to see a config option for it in kbuild -- that was done during the
> > transition to NAPI and it lingered forever for some drivers. I'd rather
> > we got it correct, and not give people yet another knob to figure out.
> >
> > I can certainly see a use case for testing the patch's performance,
> > though.
> 
> For the testing it can be done as a local to the corresponding file #ifdef.

Yes, I was suggesting something that would stay local to Bart's tree and
wouldn't be in the upstream submission. Having it accessible from
userspace without a rebuild may be more convenient for him to do initial
performance testing, but it would be better to do the final tests on the
actual code submitted.

Dave
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
