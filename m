From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 38/51] IB/qib: Add qib_sysfs.c
Date: Thu, 8 Apr 2010 16:42:44 -0700
Message-ID: <1270770164.2278.43.camel@chromite.mv.qlogic.com>
References: <20091203190305.29507.58158.stgit@chromite.mv.qlogic.com>
	 <20091203190624.29507.22110.stgit@chromite.mv.qlogic.com>
	 <adaiq81wtw3.fsf@roland-alpha.cisco.com>
	 <1270762193.2278.25.camel@chromite.mv.qlogic.com>
	 <adask75vdbs.fsf@roland-alpha.cisco.com>
	 <20100408151234.43f4bfc6.weiny2@llnl.gov>
	 <adapr29ttfh.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adapr29ttfh.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2010-04-08 at 16:29 -0700, Roland Dreier wrote:
> > I for one would rather not see this die.  We have debugged some critical
>  > issues using this data.  The sysfs entries above are what Mellanox uses.
>  > Should those also be changed?
> 
> Which sysfs entries?  I don't see any likely looking code in either of
> the Mellanox drivers.
> 
>  - R.

I think Ira means:

# ls /sys/class/infiniband/mlx4_0/diag_counters/
clear_diag    rq_num_lqpoe    rq_num_udsdprd  sq_num_lqpoe   sq_num_rree
num_baddb     rq_num_mce      rq_num_wrfe     sq_num_mwbe    sq_num_rsync
num_cqovf     rq_num_oos      sq_num_bre      sq_num_oos     sq_num_tree
num_eqovf     rq_num_rae      sq_num_ieecne   sq_num_rabrte  sq_num_wrfe
rq_num_lae    rq_num_rire     sq_num_ieecse   sq_num_rae
rq_num_leeoe  rq_num_rnr      sq_num_leeoe    sq_num_rire
rq_num_lle    rq_num_rsync    sq_num_lle      sq_num_rnr
rq_num_lpe    rq_num_ucsdprd  sq_num_lpe      sq_num_roe


I couldn't find where these entries are added in the kernel.org code.
It is in the OFED tree though.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
