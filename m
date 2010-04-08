From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 38/51] IB/qib: Add qib_sysfs.c
Date: Thu, 8 Apr 2010 15:26:41 -0700
Message-ID: <1270765601.2278.31.camel@chromite.mv.qlogic.com>
References: <20091203190305.29507.58158.stgit@chromite.mv.qlogic.com>
	 <20091203190624.29507.22110.stgit@chromite.mv.qlogic.com>
	 <adaiq81wtw3.fsf@roland-alpha.cisco.com>
	 <1270762193.2278.25.camel@chromite.mv.qlogic.com>
	 <20100408220840.GO9769@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100408220840.GO9769-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2010-04-08 at 15:08 -0700, Jason Gunthorpe wrote:
> On Thu, Apr 08, 2010 at 02:29:53PM -0700, Ralph Campbell wrote:
> 
> > One other place that has multiple values is dumping the QSFP
> > data from the IB cable.
> 
> I was going to comment that building your own I2C subsystem is kinda
> strange, can't the in-kernel stuff be used?
> 
> Jason

It is a bit strange but we have had this discussion before with
the ib_ipath driver. Basically, the devices connected to the bus
weren't really I2C compliant. Since we had to support the
non-standard parts, it was easier to have only one set of code
that could handle both.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
