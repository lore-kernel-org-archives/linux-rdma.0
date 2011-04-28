From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 0/5] infiniband-diags: ibqueryerrors extend functionality to
 cover bash scripts
Date: Wed, 27 Apr 2011 18:46:39 -0700
Message-ID: <20110427184639.e358871c.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The following 5 patches extend the functionality of ibqueryerrors to cover
some of the functionality of the ib* bash scripts.

ibqueryerrors has been our workhorse for fabric monitoring here at LLNL.
While I am working on better performance management in OpenSM this provides a
scalable "direct" option for querying the fabric.

The main thrust for replicating the shell scripts is the fact that ibqueryerrors
is an order of magnitude faster than the corresponding shell scripts.


For example, on a "small" 141 node cluster.

Gathering the error counters takes 22 seconds vs < 1 second with
ibqueryerrors [*]

hype137@root:time ./ibcheckerrors > /dev/null

real    0m22.797s
user    0m3.284s
sys     0m9.783s
hype137@root:time ./ibqueryerrors > /dev/null

real    0m0.348s
user    0m0.051s
sys     0m0.113s



Gathering all the counter data takes 28 seconds vs < 2 with ibqueryerrors [*]

hype137@root:time ./ibdatacounters > /dev/null

real    0m28.469s
user    0m4.128s
sys     0m11.560s
hype137@root:time ./ibqueryerrors --counters > /dev/null

real    0m1.262s
user    0m0.410s
sys     0m0.643s


In addition, PortCountersExtended are now supported.

Ira

[*] Times shown are representative of single runs but are on the same order of
my testing over many runs.  Other factors such as the number of outstanding
SMP's, system load, or possible fabric issues, may change performance.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
