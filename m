From: "Ruhl, Michael J" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v3 3/4] ibacm: Fix a retry loop calculation race
 condition
Date: Wed, 15 Nov 2017 19:20:02 +0000
Message-ID: <14063C7AD467DE4B82DEDB5C278E86639F0C2EBA@FMSMSX108.amr.corp.intel.com>
References: <20171114164006.24557.72093.stgit@phlsvslse11.ph.intel.com>
 <20171114164337.24557.45231.stgit@phlsvslse11.ph.intel.com>
 <20171114235522.GE25894@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114235522.GE25894-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Jason Gunthorpe
> Sent: Tuesday, November 14, 2017 6:55 PM
> To: Ruhl, Michael J <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH v3 3/4] ibacm: Fix a retry loop calculation race condition
> 
> On Tue, Nov 14, 2017 at 11:43:47AM -0500, Michael J. Ruhl wrote:
> 
> > diff --git a/ibacm/prov/acmp/src/acmp.c b/ibacm/prov/acmp/src/acmp.c
> > index d707b8e..884fc48 100644
> > +++ b/ibacm/prov/acmp/src/acmp.c
> > @@ -1579,10 +1579,12 @@ static void *acmp_retry_handler(void *context)
> >  		pthread_mutex_unlock(&acmp_dev_lock);
> >
> >  		acmp_process_timeouts();
> > -		wait = (int) (next_expire - time_stamp_ms());
> > -		if (wait > 0 && atomic_get(&wait_cnt)) {
> > -			pthread_testcancel();
> > -			event_wait(&timeout_event, wait);
> > +		if (next_expire != -1) {
> > +			wait = (int) (next_expire - time_stamp_ms());
> 
> This (int) cast is also wrong..
> 
> If you want to do signed subtraction then you need to cast the
> arguments to '-' not the result, and since time_stamp_ms() is u64,
> casting it to int will truncate.
> 
> wait needs to be int64_t, next_expire should be int64_t and then no
> casts are needed.

Hmm, I think that the truncate is what is happening when delay issue (caused by the race condition) occurs.
I need to explore this some more, your suggested change my obviate the issue.

> All of time_stamp_* should return int64_t
> 
> And the #define time_stamp_* should not be macros, but inline
> functions returning int64_t to make the return type guarenteed and
> clear.
> 
> This isn't really related to this series, but if you send a followup
> patch it would be nice since it has been now been noticed :)

I will do this in a follow on patch, but need more time to test so it will not be in this series.

Thanks for the comments!

Mike


> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
