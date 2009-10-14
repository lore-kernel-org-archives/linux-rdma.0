From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH]  link-local address fix for rdma_resolve_addr
Date: Wed, 14 Oct 2009 11:01:55 -0600
Message-ID: <20091014170155.GL5191@obsidianresearch.com>
References: <1255471781.14513.7.camel@wilder.ibm.com>
	<20091013231234.GK5191@obsidianresearch.com>
	<1255537437.14513.28.camel@wilder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1255537437.14513.28.camel-XfwDJb4SXxnMbYB6QlFGEg@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, wilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 14, 2009 at 09:23:57AM -0700, David J. Wilder wrote:

> This new patch should closely emulate tcp_ipv6.c. when both source and
> destination scope_ids are given with link-local address. 

Maybe like this:

        fl.oif = 0;

	if (ipv6_addr_type(&src_in->sin6_addr) & IPV6_ADDR_LINKLOCAL) {
	    if (!src_in->sin6_scope_id)
                return -EINVAL;
            fl.oif = src_in->sin6scope_id;
        }
	if (ipv6_addr_type(&dst_in->sin6_addr) & IPV6_ADDR_LINKLOCAL){
                if (dst_in.sin6_scope_id) {
                        if (fl.oif && fl.oif != dst_in.sin6_scope_id)
			        return -EINVAL;
                        fl.oif = dst_in.sin6_scope_id;
                }
                if (!fl.oif)
			return -EINVAL;
	}


src and dest have to be tested seperately, the TCPv6 versions don't
require them to be both link local.

Don't forget to run checkpatch ;)

Regards,
