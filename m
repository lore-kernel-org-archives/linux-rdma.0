From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH v2 38/51] IB/qib: Add qib_sysfs.c
Date: Thu, 8 Apr 2010 15:12:34 -0700
Message-ID: <20100408151234.43f4bfc6.weiny2@llnl.gov>
References: <20091203190305.29507.58158.stgit@chromite.mv.qlogic.com>
	<20091203190624.29507.22110.stgit@chromite.mv.qlogic.com>
	<adaiq81wtw3.fsf@roland-alpha.cisco.com>
	<1270762193.2278.25.camel@chromite.mv.qlogic.com>
	<adask75vdbs.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adask75vdbs.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma@vger.kernel.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 08 Apr 2010 14:33:59 -0700
Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrote:

>  > This was for debugging and clearly could use a better method.
>  > Some stats are definitely useful and having files per value
>  > would make scripting easier too.
>  > I could add /sys/class/infiniband/qib0/ports/1/diag_counters/*
>  > 
>  > One other place that has multiple values is dumping the QSFP
>  > data from the IB cable.
> 
> You can stick debugging data under debugfs.  Or just kill it for now and
> figure out how to add it back later.

I for one would rather not see this die.  We have debugged some critical
issues using this data.  The sysfs entries above are what Mellanox uses.
Should those also be changed?

Ira

> -- 
> Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
> http://*www.*cisco.com/web/about/doing_business/legal/cri/index.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://*vger.kernel.org/majordomo-info.html
> 


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
