From: James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v7 8/9] selinux: Add IB Port SMP access vector
Date: Mon, 22 May 2017 10:32:43 +1000 (AEST)
Message-ID: <alpine.LRH.2.20.1705221032250.3502@namei.org>
References: <1495198139-69993-1-git-send-email-danielj@mellanox.com> <1495198139-69993-9-git-send-email-danielj@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1495198139-69993-9-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 19 May 2017, Dan Jurgens wrote:

> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Add a type for Infiniband ports and an access vector for subnet
> management packets. Implement the ib_port_smp hook to check that the
> caller has permission to send and receive SMPs on the end port specified
> by the device name and port. Add interface to query the SID for a IB
> port, which walks the IB_PORT ocontexts to find an entry for the
> given name and port.
> 
> Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>


Reviewed-by: James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>


-- 
James Morris
<jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
