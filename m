From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/8] ib_mad: incoming sminfo SMPs gets discarded if
 no process_mad function is registered
Date: Fri, 16 Sep 2016 22:40:31 +0200
Message-ID: <1474058431.20134.44.camel@oracle.com>
References: <cover.15d71ac2c57534f1170c2c48374d3841ed75e676.1474049924.git-series.knut.omang@oracle.com>
         <66d69383a3376018d99c025cd188150f6673b209.1474049924.git-series.knut.omang@oracle.com>
         <b57491e1-e36b-c331-8360-557310d15002@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <b57491e1-e36b-c331-8360-557310d15002-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Dag Moxnes <dag.moxnes-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2016-09-16 at 13:28 -0700, Santosh Shilimkar wrote:
> On 9/16/2016 11:31 AM, Knut Omang wrote:
> > From: Dag Moxnes <dag.moxnes-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> >
> > The process_mad function is an optional IB driver entry point
> > allows a driver to intercept or modify MAD traffic.
> >
> > This fix allows MAD traffic to flow down to the device also
> > when MAD traffic is completely handled by the device and
> > no process_mad function is provided.
> >
> > SIF, the new Oracle Infiniband HCA, is the first HCA
> > where the device itself makes all decision wrt MAD processing.
> > Up till now devices either supports MAD, and do then
> > implement the process_mad entry point, or do not
> > support MAD at all, and then do not implement process_mad.
> >
> > SIF introduces a 3rd case: Supports MAD
> > but do not terminate any MAD requests in the driver.
> > This case is not handled well by the current code.
> >
> > The problem is that the handle_outgoing_dr_smp function
> > has an implicit assumption that some packets are handled
> > by the process_mad function itself.
> >
> > There is no way to provide return values from the process_mad
> > function that ensures that packets are always forwarded to the device,
> > so the only viable solution without breaking the API
> > seems to be to not implement process_mad.
> 
> No SOBs ?

is unfortunately recurring for several of the patches due to a missing -ns to format-patch.
Will fix,

Thanks,
Knut
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
