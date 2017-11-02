From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2 4/8] IB/srpt: Change default behavior from using SRQ
 to using RC
Date: Thu, 2 Nov 2017 18:30:11 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC6266931A@fmsmsx120.amr.corp.intel.com>
References: <20171011172729.16984-1-bart.vanassche@wdc.com>
 <20171011172729.16984-5-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171011172729.16984-5-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Subject: [PATCH v2 4/8] IB/srpt: Change default behavior from using SRQ to
> using RC
> 

Bart, this last of the 4 target patches causes our internal SRP testing to fail.

> From the IB spec:
> 
>     C9-150.2.1: For QPs that are not associated with an SRQ, each HCA
>     receive queue shall generate end-to-end flow control credits. If
>     a QP is associated with an SRQ, the HCA receive queue shall not
>     generate end-to-end flow control credits.
> 

I'm looking at why but...

> Add new configfs attributes that allow to configure which mode to use
> (/sys/kernel/config/target/srpt/$GUID/$GUID/attrib/use_srq). Note:
> only the attribute for port 1 is relevant on multi-port adapters.
> 

It looks like the above work around cannot work.

The use_srq is tested and the  SRQ is allocated when the device is added.

Setting a target relative attribute is too late in the sequence to enable the old SRQ usage.

I hardwired the SRQ creation in srpt_add_one() to verify it works.

I suspect you may want to unconditionally create the SRQ and change the usage at login time based on the target flag?

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
