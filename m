From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] tests/subnet_discover: discover test utility
Date: Thu, 21 Jan 2010 12:38:41 -0800
Message-ID: <20100121123841.43df4cdc.weiny2@llnl.gov>
References: <20090816110200.GS25501@me>
	<20090823120609.GG9547@me>
	<20090826164026.8dcce4b2.weiny2@llnl.gov>
	<20091023234349.GK5764@me>
	<20091220121406.GF5262@me>
	<20091220182809.f7e17fae.weiny2@llnl.gov>
	<20091221073550.GB18524@me>
	<20091228092251.GR26940@me>
	<f0e08f231001110556y7c47cc54oa3cfd5859f9a4e76@mail.gmail.com>
	<20100112093145.GF26089@me>
	<f0e08f231001131211y64489a51nd2621cefdb27ad25@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f0e08f231001131211y64489a51nd2621cefdb27ad25-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey Sasha,

I am finally getting back to this...  Sorry.

On Wed, 13 Jan 2010 15:11:44 -0500
Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Hi Sasha,
> 
> On Tue, Jan 12, 2010 at 4:31 AM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:
> > Hi Hal,
> >
> > On 08:56 Mon 11 Jan     , Hal Rosenstock wrote:
> >> >
> >> > diff --git a/tests/subnet_discover.c b/tests/subnet_discover.c
> >> > index 7f8a85c..42e7aee 100644
> >> > --- a/tests/subnet_discover.c
> >> > +++ b/tests/subnet_discover.c
> >> > @@ -40,6 +40,7 @@ static struct node *node_array[32 * 1024];
> >> >  static unsigned node_count = 0;
> >> >  static unsigned trid_cnt = 0;
> >> >  static unsigned outstanding = 0;
> >> > +static unsigned max_outstanding = 8;
> >>
> >> Any reason why this default is different from the one which OpenSM
> >> uses ? Seems to me it should be the same (or less).
> >
> > In my tests I found that '8' is more optimal number (the tool works
> > faster and without drops) than '4' used in OpenSM.
> >
> > Of course it would be helpful to run this over bigger cluster than
> > what I have to see that the results are consistent.

Here is some test data on a real cluster.

09:49:10 > ibhosts | wc -l
1158

09:49:28 > ibswitches | wc -l
281

09:44:45 > time ./subnet_discover -n 1 > /dev/null

real    0m1.414s
user    0m0.309s
sys     0m0.244s

09:44:55 > time ./subnet_discover -n 2 > /dev/null

real    0m1.025s
user    0m0.284s
sys     0m0.201s

09:45:00 > time ./subnet_discover -n 4 > /dev/null

real    0m0.644s
user    0m0.268s
sys     0m0.228s

09:45:04 > time ./subnet_discover -n 8 > /dev/null

real    0m0.550s
user    0m0.253s
sys     0m0.184s

09:45:08 > time ./subnet_discover -n 12 > /dev/null

real    0m0.524s
user    0m0.207s
sys     0m0.201s

09:45:14 > time ./subnet_discover -n 16 > /dev/null

real    0m0.432s
user    0m0.248s
sys     0m0.144s

09:45:18 > time ./subnet_discover -n 32 > /dev/null

real    0m0.484s
user    0m0.260s
sys     0m0.150s


09:45:57 > time ibnetdiscover  > /dev/null

real    0m3.180s
user    0m0.068s
sys     0m0.672s


What I find most interesting is that your test utility runs nearly 2x faster
even when there is only 1 outstanding MAD.  :-/  ibnetdiscover (libibnetdisc)
does do a lot more with the data but I would not have expected such a
difference.

As a comparison I ran iblinkinfo it would seem that there is something in the
library which takes a lot more time.

09:51:59 > time iblinkinfo > /dev/null

real    0m3.159s
user    0m0.063s
sys     0m0.526s


For further comparison I rebuilt the parallel version of libibnetdisc.

12:39:02 > time ./ibnetdiscover > /dev/null

real    0m2.552s
user    0m0.295s
sys     0m0.863s

This is with 8 threads (ie 8 outstanding SMP's).

I would appear that your algorithm is superior.  I will look at converting
libibnetdisc, test, and submit a patch.  I still don't know why there would be
so much difference when only using 1 outstanding MAD though?  :-/

> 
> This is exactly my concern. Not only cluster size but use cases
> including concurrent diag discover and SM operation where SMPs are
> heavily in use.
> 
> There already have been a number of reports of dropped SMPs on this
> list with the current diags and this change will only make things
> worse IMO.

This is a problem.  I have seen this issue with large systems which are having
trouble.  OpenSM is trying to discover and route.  We are running diags trying
to figure out what is going on.  There is hardware going up and down; bad
switches or nodes which are booting/rebooting.

I plan to go forward with this but having an option for outstanding MAD's is a
good idea.  I don't have an opinion on where it should default.

> 
> Also, the OpenSM default should be at least as large as the diags for this.

I agree.  OpenSM should have some priority in this matter.

Ira

> 
> -- Hal
> 
> > Sasha
> >


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
