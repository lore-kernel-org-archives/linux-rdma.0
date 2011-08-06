From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: ib-diags and ib_get_err_str
Date: Fri, 5 Aug 2011 17:17:00 -0700
Message-ID: <20110805171700.df2f3080.weiny2@llnl.gov>
References: <1828884A29C6694DAF28B7E6B8A8237313702643@ORSMSX101.amr.corp.intel.com>
	<20110805165122.1b508a84.weiny2@llnl.gov>
	<1828884A29C6694DAF28B7E6B8A8237313702677@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237313702677-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hal Rosenstock (hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org)" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 5 Aug 2011 16:57:02 -0700
"Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> > This is picked up by libosmcomp.so
>  
> Is this a new library built as part of opensm?

opensm-libs is the specific package.

I don't think it is that new.

> 
> I'm trying to update the windows build and haven't followed the changes recently.  Why are the diags dependent on error types outside of what ibmad reports?

I am not quite sure at the moment.  This function has been used in saquery since the beginning of the git tree.  Also there are other needs for libosmcomp (cl_qmap and node name map support for example.)  Although I would like to see the dependency (on opensm-libs) removed it will take more than that function.

Ira

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
