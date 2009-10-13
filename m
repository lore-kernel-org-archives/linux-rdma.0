From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH]  link-local address fix for rdma_resolve_addr
Date: Tue, 13 Oct 2009 17:12:34 -0600
Message-ID: <20091013231234.GK5191@obsidianresearch.com>
References: <1255471781.14513.7.camel@wilder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1255471781.14513.7.camel-XfwDJb4SXxnMbYB6QlFGEg@public.gmane.org>
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
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, wilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 13, 2009 at 03:09:40PM -0700, David J. Wilder wrote:
> Here is a patch to addr6_resolve_remote() to correctly handle link-local address.
> It should cover all the conditions Jason described. 

Looks pretty good to me, definitely on the right track.

Hmm..

Actually, upon comparing to tcp_ipv6.c, I'd say one more behavior is
necessary. The code in tcp_ipv6 allows the destination to not specify
a scope id if an interface has already been set. Looks like the two
ways to set an interface ID are to use bind() or SO_BINDTODEVICE..

Specifying a source address to RDMA CM is similar to bind(), so if the
source address is link local it must specify a sin6_scope_id and the
dest address can specify 0, or the same value.

How af_inet6 handles bind():

                        if (addr_type & IPV6_ADDR_LINKLOCAL) {
                                if (addr_len >= sizeof(struct sockaddr_in6) &&
                                    addr->sin6_scope_id) {
                                        /* Override any existing binding, if another one
                                         * is supplied by user.
                                         */
                                        sk->sk_bound_dev_if = addr->sin6_scope_id;
                                }

                                /* Binding to link-local address requires an interface */
                                if (!sk->sk_bound_dev_if) {
                                        err = -EINVAL;
                                        goto out;
                                }
                                dev = dev_get_by_index(net, sk->sk_bound_dev_if);
                                if (!dev) {
                                        err = -ENODEV;
                                        goto out;
                                }
                        }

How tcp_ipv6 checks the destination address:
        if (addr_type&IPV6_ADDR_LINKLOCAL) {
                if (addr_len >= sizeof(struct sockaddr_in6) &&
                    usin->sin6_scope_id) {
                        /* If interface is set while binding, indices
                         * must coincide.
                         */
                        if (sk->sk_bound_dev_if &&
                            sk->sk_bound_dev_if != usin->sin6_scope_id)
                                return -EINVAL;

                        sk->sk_bound_dev_if = usin->sin6_scope_id;
                }

                /* Connect to link-local address requires an interface */
                if (!sk->sk_bound_dev_if)
                        return -EINVAL;
        }

Jason
