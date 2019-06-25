From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC][PATCH] wake_up_var() memory ordering
Date: Tue, 25 Jun 2019 15:27:36 +0200
Message-ID: <20190625132736.GZ3419@hirez.programming.kicks-ass.net>
References: <20190624165012.GH3436@hirez.programming.kicks-ass.net>
 <CAHc6FU7j5iW7WQoxN_OSfvK4zxv_MxTWJpiNsqFW8TEDMX1rjw@mail.gmail.com>
 <20190625103430.GW3402@hirez.programming.kicks-ass.net>
 <CAHc6FU6zUCdQZ1AfN2KYcPYVKc5bwvc0bD7=-KZpFXws+F9QZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHc6FU6zUCdQZ1AfN2KYcPYVKc5bwvc0bD7=-KZpFXws+F9QZQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mediatek/>
List-Post: <mailto:linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "Linux-mediatek" <linux-mediatek-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Martin Brandenburg <martin-gqc3UtWaqJ5Wk0Htik3J/w@public.gmane.org>, linux-cachefs-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-aio-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>, Joonas Lahtinen <joonas.lahtinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Marshall <hubcap-gqc3UtWaqJ5Wk0Htik3J/w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, cluster-devel <cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Antti Palosaari <crope-X3B1VOXEql0@public.gmane.org>, Matthias Brugger <matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Paul McKenney <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.orgd
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 25, 2019 at 02:12:22PM +0200, Andreas Gruenbacher wrote:

> > Only if we do as David suggested and make clean_and_wake_up_bit()
> > provide the RELEASE barrier.
> 
> (It's clear_and_wake_up_bit, not clean_and_wake_up_bit.)

Yes, typing hard.

> > That is, currently clear_and_wake_up_bit() is
> >
> >         clear_bit()
> >         smp_mb__after_atomic();
> >         wake_up_bit();
> >

> Now I'm confused because clear_and_wake_up_bit() in mainline does use
> clear_bit_unlock(), so it's the exact opposite of what you just said.

Argh; clearly I couldn't read. And then yes, you're right.
