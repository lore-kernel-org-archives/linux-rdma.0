From: 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 08/32] iwpmd: use proper ANSI-C prototypes for
        functions without arguments
Date: Thu, 13 Oct 2016 20:09:59 +0200
Message-ID: <20161013180959.GA28057@lst.de>
References: <1476381095-20041-1-git-send-email-hch@lst.de> <1476381095-20041-9-git-send-email-hch@lst.de> <01c201d2257c$83313be0$8993b3a0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <01c201d2257c$83313be0$8993b3a0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 13, 2016 at 01:06:25PM -0500, Steve Wise wrote:
> Is this fixing some warning?

Yes, this fixes warnings when running the code through sparse:

../iwpmd/iwarp_pm_common.c:215:27: warning: non-ANSI function declaration of
function 'create_netlink_socket'
../iwpmd/iwarp_pm_server.c:90:33: warning: non-ANSI function declaration of
function 'iwpm_mapping_reqs_handler'
../iwpmd/iwarp_pm_server.c:142:33: warning: non-ANSI function declaration of
function 'iwpm_pending_msgs_handler'
../iwpmd/iwarp_pm_server.c:1282:30: warning: non-ANSI function declaration of
function 'iwarp_port_mapper'
../iwpmd/iwarp_pm_server.c:1359:35: warning: non-ANSI function declaration of
function 'daemonize_iwpm_server'
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
