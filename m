From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 38/51] IB/qib: Add qib_sysfs.c
Date: Fri, 9 Apr 2010 17:13:24 -0700
Message-ID: <1270858404.2278.64.camel@chromite.mv.qlogic.com>
References: <20091203190305.29507.58158.stgit@chromite.mv.qlogic.com>
	 <20091203190624.29507.22110.stgit@chromite.mv.qlogic.com>
	 <adaiq81wtw3.fsf@roland-alpha.cisco.com>
	 <1270762193.2278.25.camel@chromite.mv.qlogic.com>
	 <adask75vdbs.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adask75vdbs.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2010-04-08 at 14:33 -0700, Roland Dreier wrote:
> > This was for debugging and clearly could use a better method.
>  > Some stats are definitely useful and having files per value
>  > would make scripting easier too.
>  > I could add /sys/class/infiniband/qib0/ports/1/diag_counters/*
>  > 
>  > One other place that has multiple values is dumping the QSFP
>  > data from the IB cable.
> 
> You can stick debugging data under debugfs.  Or just kill it for now and
> figure out how to add it back later.

OK. I replaced the /sys/class/infiniband/qib0/stats file with

% ls /sys/class/infiniband/qib0/ports/1/diag_counters/
dmawait     pkt_drops        rc_dupreq   rc_seqnak    rnr_naks
loop_pkts   rc_acks          rc_qacks    rc_timeouts  seq_naks
other_naks  rc_delayed_comp  rc_resends  rdma_seq     unaligned

These are all simple counter values.

For the QSFP data, I hope I can leave it as is since it is
related to the link state that the other files contain.
It is a read-only file so no issue with trying to set a value.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
