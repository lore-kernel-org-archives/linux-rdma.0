From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: ib-diags and ib_get_err_str
Date: Mon, 08 Aug 2011 02:09:35 -0400
Message-ID: <4E3F7D9F.9050101@dev.mellanox.co.il>
References: <1828884A29C6694DAF28B7E6B8A8237313702643@ORSMSX101.amr.corp.intel.com>	<20110805165122.1b508a84.weiny2@llnl.gov>	<1828884A29C6694DAF28B7E6B8A8237313702677@ORSMSX101.amr.corp.intel.com> <20110805171700.df2f3080.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110805171700.df2f3080.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hal Rosenstock (hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org)" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 8/5/2011 8:17 PM, Ira Weiny wrote:
> On Fri, 5 Aug 2011 16:57:02 -0700
> "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> 
>>> This is picked up by libosmcomp.so
>>  
>> Is this a new library built as part of opensm?
> 
> opensm-libs is the specific package.
> 
> I don't think it is that new.

It's not new. It's built as part of the OpenSM. Mainly osm_helper and
maybe a few other things (common code for perhaps more than OpenSM).

> 
>>
>> I'm trying to update the windows build and haven't followed the changes recently.  Why are the diags dependent on error types outside of what ibmad reports?
> 
> I am not quite sure at the moment.  This function has been used in saquery since the beginning of the git tree.

saquery may have been added some time back in the svn days. AFAIR it was
the first diag which had this dependency. It was decided to use some
code which could be common in SA and SA client which is what saquery is.

  Also there are other needs for libosmcomp (cl_qmap and node name map
support for example.)  Although I would like to see the dependency (on
opensm-libs) removed it will take more than that function.

I don't know how far this dependency goes (did it creep into any other
diags) ? It could be eliminated (perhaps cleaner that way) at the "cost"
of some logically duplicated code.

-- Hal


> Ira
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
