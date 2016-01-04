From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] IB Core: Create get_perf_mad function in sysfs.c
Date: Sun, 3 Jan 2016 22:47:23 -0500
Message-ID: <20160104034723.GD329@phlsvsds.ph.intel.com>
References: <20151217195255.334854705@linux.com> <20151217195312.126391272@linux.com> <5684E027.4040006@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5684E027.4040006-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 31, 2015 at 08:58:31AM +0100, Bart Van Assche wrote:
> On 12/17/2015 08:52 PM, Christoph Lameter wrote:
> >-	in_mad->mad_hdr.attr_id       = cpu_to_be16(0x12); /* PortCounters */
> >+	in_mad->mad_hdr.attr_id       = attr;
> 
> Hello Christoph,
> 
> sparse reports an endianness mismatch for this and similar assignments 
> (make M=drivers/infiniband/core C=2 CF=-D__CHECK_ENDIAN__). Can you have 
> a look at this ?

quick patch sent:

https://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg31257.html

Ira

> 
> Thanks,
> 
> Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
