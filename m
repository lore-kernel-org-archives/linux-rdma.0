From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2 38/51] IB/qib: Add qib_sysfs.c
Date: Fri, 9 Apr 2010 18:27:05 -0600
Message-ID: <20100410002705.GQ15629@obsidianresearch.com>
References: <20091203190305.29507.58158.stgit@chromite.mv.qlogic.com> <20091203190624.29507.22110.stgit@chromite.mv.qlogic.com> <adaiq81wtw3.fsf@roland-alpha.cisco.com> <1270762193.2278.25.camel@chromite.mv.qlogic.com> <adask75vdbs.fsf@roland-alpha.cisco.com> <1270858404.2278.64.camel@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1270858404.2278.64.camel-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Apr 09, 2010 at 05:13:24PM -0700, Ralph Campbell wrote:

> For the QSFP data, I hope I can leave it as is since it is
> related to the link state that the other files contain.
> It is a read-only file so no issue with trying to set a value.

There was some flack for other stuff like this a while back.

IMHO, it would be appropriate to have a hex dump of the entire QFSP
EEPROM and leave parsing to userspace, or put the parsed version in
debugfs..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
