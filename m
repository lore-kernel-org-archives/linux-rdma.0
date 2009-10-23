From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: Multi-threaded diags (Was: Re: [PATCH 4/5]
 infiniband-diags/libibnetdisc: Introduce a context object.)
Date: Sat, 24 Oct 2009 01:43:49 +0200
Message-ID: <20091023234349.GK5764@me>
References: <20090813204306.dffc3237.weiny2@llnl.gov>
 <20090816110200.GS25501@me>
 <20090817083023.da17378b.weiny2@llnl.gov>
 <20090823120609.GG9547@me>
 <20090826164026.8dcce4b2.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090826164026.8dcce4b2.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 16:40 Wed 26 Aug     , Ira Weiny wrote:
> 
> Of course!  :-)  But first I would like to mention some numbers from the
> prototype code I have.  When running on a small fabric the additional overhead
> of thread creation actually slows down the scan.  :-(
> 
> Current master:         Threaded version:
> real    0m0.101s         0m0.266s
> user    0m0.000s         0m0.000s
> sys     0m0.011s         0m0.014s
> 
> 
> But, as expected, on a large system (1152 nodes) there is a decent speed up.
> 
> Current Master:         Threaded version:
> real    0m3.046s         0m1.748s
> user    0m0.073s         0m0.331s
> sys     0m0.158s         0m0.822s
> 
> However, the biggest speed up comes when there are errors on the fabric.  This
> is the same 1152 node cluster with just 14 "bad" ports on the fabric.  This is
> of course because the scan continues "around" the bad ports.
> 
> Current Master:         Threaded version:
> real    0m33.051s        0m5.609s
> user    0m0.071s         0m0.353s
> sys     0m0.156s         0m1.113s
> 
> Since you are usually running these tools when things are bad I think there is
> a big gain here.  Even running with a faster timeout of 200ms results in a big
> difference.
> 
> Current Master:        Threaded version:
> real    0m9.149s        0m2.223s
> user    0m0.016s        0m0.374s
> sys     0m0.372s        0m1.056s
> 
> With that in mind...

Good. So what do you think due to which factor most of this performance
gain was achieved? Due to using multiple threads or due to SMP queries
parallelism? I would suspect that it is a parallelism.

> > implemented with libibnetdisc: goals (in particular is it support for
> > multithreaded apps or just multithreaded discovery function), interaction
> > with caller application, etc.?
> 
> My initial goal was to make the libibnetdisc safe for multithreaded apps

Ok.

> and
> make a multithreaded discovery function.

And this is not the same as above. I would really suggest before doing
multithreaded implementation to check just single threaded but parallel
querying first. Somehow I believe that an impressive numbers could be
shown there and also without multithreaded overhead and complexity.

> However, since libibmad itself is
> not thread safe, and you expressed a desire to keep it that way[*], I reduced
> that goal to just making the discovery function multithreaded (using
> mad_[send|receive]_via).
> 
> Although I don't like this restriction I can see it as a valid design decision
> as long as it is documented that the discover function is not thread safe in
> regards to the ibmad_port object.  This is because the ibnd_discover_fabric
> uses libibmad calls and would require a complicated API to allow the user app
> to synchronize with those calls.
> 
> In order to make things thread safe for the user apps as well as the library I
> can see 3 options.
> 
>    1) make libibmad thread safe (which you were hesitant to do)
> 
>    2) add a thread safe interface to libibmad.  User apps will need to know to
>       use this interface while using libibnetdisc and libibnetdisc will use
>       this interface.

Why should it be related to libibmad? Make libibnetdisc by itself thread
safe and that is all (see below).

>    3) Create a wrapper lib which is thread safe.  In this case the apps and
>       libibnetdisc would call into this wrapper lib and we would have to
>       change the API to libibnetdisc.

4) Instead of bothering with slow (blocked) libibmad rpc use umad_send()
and umad_recv() directly in parallel hop by hop fabric discovery.

(And following my personal experience it is ended in smaller and simpler
code using umad directly instead of rpc for applications which slightly
more complex than 'smpquery' style tools).

> [*] http://lists.openfabrics.org/pipermail/general/2009-July/060677.html
> 
>    "madrpc() is too primitive interface for such applications. There would be
>    better to use umad_send/recv() directly or may be mad_send_via().  Example
>    is mcast_storm.c distributed with ibsim."

Another option is adding a new thread safe API. But I don't really see
how it is related to libibnetdisc discussion.

> [$] It is my opinion that mad_rpc is _not_ primitive.  In my mind it _is_
>    the wrapper around the primitive umad_send/recv calls.  If you are
>    interested perhaps I can try to explain what I wanted to do in the library
>    to make it thread safe more clearly.  The point I might not have made clear
>    was that I don't think the library will have to do any threading on it's
>    own, just some locks and storing of responses.  Of course the down side to
>    this is the libibmad code would be slightly slower.  But I don't think by
>    very much.

I don't like a lock introduction there - right, it is unneeded overhead
(and dependencies) for single threaded tools. And again -  I have nothing
against thread safe rpc++ API, but would prefer instead of locking use
reenrant states.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
