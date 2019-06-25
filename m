From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC][PATCH] wake_up_var() memory ordering
Date: Tue, 25 Jun 2019 10:11:03 +0200
Message-ID: <20190625081103.GU3436@hirez.programming.kicks-ass.net>
References: <20190624165012.GH3436@hirez.programming.kicks-ass.net>
 <32379.1561449061@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <32379.1561449061-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mediatek/>
List-Post: <mailto:linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "Linux-mediatek" <linux-mediatek-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Martin Brandenburg <martin-gqc3UtWaqJ5Wk0Htik3J/w@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-aio-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, Joonas Lahtinen <joonas.lahtinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Marshall <hubcap-gqc3UtWaqJ5Wk0Htik3J/w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Antti Palosaari <crope-X3B1VOXEql0@public.gmane.org>, Matthias Brugger <matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Paul McKenney <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, devel@lists.o
List-Id: linux-rdma@vger.kernel.org


(sorry for cross-posting to moderated lists btw, I've since
 acquired a patch to get_maintainers.pl that wil exclude them
 in the future)

On Tue, Jun 25, 2019 at 08:51:01AM +0100, David Howells wrote:
> Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> 
> > I tried using wake_up_var() today and accidentally noticed that it
> > didn't imply an smp_mb() and specifically requires it through
> > wake_up_bit() / waitqueue_active().
> 
> Thinking about it again, I'm not sure why you need to add the barrier when
> wake_up() (which this is a wrapper around) is required to impose a barrier at
> the front if there's anything to wake up (ie. the wait queue isn't empty).
> 
> If this is insufficient, does it make sense just to have wake_up*() functions
> do an unconditional release or full barrier right at the front, rather than it
> being conditional on something being woken up?

The curprit is __wake_up_bit()'s usage of waitqueue_active(); it is this
latter (see its comment) that requires the smp_mb().

wake_up_bit() and wake_up_var() are wrappers around __wake_up_bit().

Without this barrier it is possible for the waitqueue_active() load to
be hoisted over the cond=true store and the remote end can miss the
store and we can miss its enqueue and we'll all miss a wakeup and get
stuck.

Adding an smp_mb() (or use wq_has_sleeper()) in __wake_up_bit() would be
nice, but I fear some people will complain about overhead, esp. since
about half the sites don't need the barrier due to being behind
test_and_clear_bit() and the other half using smp_mb__after_atomic()
after some clear_bit*() variant.

There's a few sites that seem to open-code
wait_var_event()/wake_up_var() and those actually need the full
smp_mb(), but then maybe they should be converted to var instread of bit
anyway.

> > @@ -619,9 +614,7 @@ static int dvb_usb_fe_sleep(struct dvb_frontend *fe)
> >  err:
> >  	if (!adap->suspend_resume_active) {
> >  		adap->active_fe = -1;
> 
> I'm wondering if there's a missing barrier here.  Should the clear_bit() on
> the next line be clear_bit_unlock() or clear_bit_release()?

That looks reasonable, but I'd like to hear from the DVB folks on that.

> > -		clear_bit(ADAP_SLEEP, &adap->state_bits);
> > -		smp_mb__after_atomic();
> > -		wake_up_bit(&adap->state_bits, ADAP_SLEEP);
> > +		clear_and_wake_up_bit(ADAP_SLEEP, &adap->state_bits);
> >  	}
> >  
> >  	dev_dbg(&d->udev->dev, "%s: ret=%d\n", __func__, ret);
> > diff --git a/fs/afs/fs_probe.c b/fs/afs/fs_probe.c
> > index cfe62b154f68..377ee07d5f76 100644
> > --- a/fs/afs/fs_probe.c
> > +++ b/fs/afs/fs_probe.c
> > @@ -18,6 +18,7 @@ static bool afs_fs_probe_done(struct afs_server *server)
> >  
> >  	wake_up_var(&server->probe_outstanding);
> >  	clear_bit_unlock(AFS_SERVER_FL_PROBING, &server->flags);
> > +	smp_mb__after_atomic();
> >  	wake_up_bit(&server->flags, AFS_SERVER_FL_PROBING);
> >  	return true;
> >  }
> 
> Looking at this and the dvb one, does it make sense to stick the release
> semantics of clear_bit_unlock() into clear_and_wake_up_bit()?

I was thinking of adding another helper, maybe unlock_and_wake_up_bit()
that included that extra barrier, but maybe making it unconditional
isn't the worst idea.

> Also, should clear_bit_unlock() be renamed to clear_bit_release() (and
> similarly test_and_set_bit_lock() -> test_and_set_bit_acquire()) if we seem to
> be trying to standardise on that terminology.

That definitely makes sense to me, there's only 157 clear_bit_unlock()
and 76 test_and_set_bit_lock() users (note the asymetry of that).
