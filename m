From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] ibsim: fix non-debug path in run_opensm.sh script
Date: Tue, 9 Aug 2011 11:53:35 -0600
Message-ID: <20110809175335.GA3265@obsidianresearch.com>
References: <E1QpTpr-00026L-B8@rvml.edm.orcorp.ca>
 <20110809145727.GB2056@calypso.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110809145727.GB2056-iQai9MGU/dze+A/uUDamNg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Rolf Manderscheid <rvm-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 09, 2011 at 05:57:27PM +0300, Alex Netes wrote:

> This is what I get, when running the commands in the old way:

The construct 'time FOO=x cmd' is a bashism. The script either needs
to use #!/bin/bash or the patch from Rolf to make it work properly on
systems that use a POSIX shell as /bin/sh (ie Debian and dervied)

The difference in time output reflects one being the bash built in and
the other being the shell utils command.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
