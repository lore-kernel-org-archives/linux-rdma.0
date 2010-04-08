From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH v2 38/51] IB/qib: Add qib_sysfs.c
Date: Thu, 8 Apr 2010 16:53:09 -0700
Message-ID: <20100408165309.786e25a8.weiny2@llnl.gov>
References: <20091203190305.29507.58158.stgit@chromite.mv.qlogic.com>
	<20091203190624.29507.22110.stgit@chromite.mv.qlogic.com>
	<adaiq81wtw3.fsf@roland-alpha.cisco.com>
	<1270762193.2278.25.camel@chromite.mv.qlogic.com>
	<adask75vdbs.fsf@roland-alpha.cisco.com>
	<20100408151234.43f4bfc6.weiny2@llnl.gov>
	<adapr29ttfh.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adapr29ttfh.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma@vger.kernel.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 08 Apr 2010 16:29:06 -0700
Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrote:

>  > I for one would rather not see this die.  We have debugged some critical
>  > issues using this data.  The sysfs entries above are what Mellanox uses.
>  > Should those also be changed?
> 
> Which sysfs entries?  I don't see any likely looking code in either of
> the Mellanox drivers.

My apologies.  It appears this an OFED thing.[*]

16:31:04 > ls -la /sys/class/infiniband/mlx4_0/diag_counters/
total 0
drwxr-xr-x 2 root root    0 Apr  8 16:31 ./
drwxr-xr-x 4 root root    0 Apr  8 16:31 ../
--w--w--w- 1 root root 4096 Apr  8 16:31 clear_diag
-r--r--r-- 1 root root 4096 Apr  8 16:31 num_baddb
-r--r--r-- 1 root root 4096 Apr  8 16:31 num_cqovf
...

This is with the current RHEL5.4 drivers.

<sigh>

So is there an equivalent for mlx4 in the upstream kernel?  I don't see them.

Do you feel it is appropriate for the port counters to be in sysfs?

16:46:19 > ls -la /sys/class/infiniband/mlx4_0/ports/1/counters/
total 0
drwxr-xr-x 2 root root    0 Apr  8 16:46 ./
drwxr-xr-x 5 root root    0 Apr  6 09:33 ../
-r--r--r-- 1 root root 4096 Apr  8 16:46 VL15_dropped
-r--r--r-- 1 root root 4096 Apr  8 16:46 excessive_buffer_overrun_errors
...

Although these "diag_counters" are internal to the cards they do track counts
which are part of the IB spec like RNR NAK's.  So I am not sure they are
really "debug" in the strictest sense.

I will rephrase my statement, I would like to see these counters included as
they give valuable information about what is going on in a cluster.

Ira

* OFED MUST die!

> 
>  - R.
> 
> -- 
> Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
> http://*www.*cisco.com/web/about/doing_business/legal/cri/index.html
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
