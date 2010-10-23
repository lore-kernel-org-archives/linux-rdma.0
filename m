From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC 0/12] ib-mgmt: port madeye to user space
Date: Fri, 22 Oct 2010 23:48:49 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B809B7EE@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In short, this series ports the kernel madeye debug utility to
user space.  It builds on the updated kernel MAD snooping functionality
patches recently submitted to this list.  In length, the series
adds the following to the ib-mgmt tree:

* Adds the ability to snoop MADs to libibumad.
* Adds new header files to libibumad that define various MAD
  data structures and definitions.  The headers define a minimal
  number of definitions, basically only what was needed for madeye.
* Starts the process of updating libibmad and opensm to use the
  new definitions.  mad.h and ib_types.h are updated to reference
  values in the new header file, but the names of existing defines
  did not change.
* Adds madeye as a new ib-diag.

The kernel and user space patches are both barely tested.  They compile
and run, but I didn't check the results in any detail.  The new header files
define the MAD headers, but do not define any of the data fields, such as
SA attributes.  Those are left for further discussion.

Porting madeye to user space is simply a quick and useful way to verify
that the snooping capability is working.  My ultimate goal is to allow
the IBACM to detect and react to CM timeouts.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
