From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2 38/51] IB/qib: Add qib_sysfs.c
Date: Fri, 9 Apr 2010 18:21:37 -0600
Message-ID: <20100410002137.GP15629@obsidianresearch.com>
References: <20091203190305.29507.58158.stgit@chromite.mv.qlogic.com> <20091203190624.29507.22110.stgit@chromite.mv.qlogic.com> <adaiq81wtw3.fsf@roland-alpha.cisco.com> <1270762193.2278.25.camel@chromite.mv.qlogic.com> <20100408220840.GO9769@obsidianresearch.com> <1270765601.2278.31.camel@chromite.mv.qlogic.com> <20100408225002.GS9769@obsidianresearch.com> <1270855886.2278.52.camel@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1270855886.2278.52.camel-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Apr 09, 2010 at 04:31:26PM -0700, Ralph Campbell wrote:

> I would be very reluctant to change this code.
> One device we have doesn't have an i2c address, the "address" is the
> address of memory within the chip, not the address of the chip on the
> bus.

Fair enough.. But mixing not-i2c + QSFP real i2c on the same bus =
too scary for me :)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
