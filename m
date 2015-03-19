From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v1 00/10] Add network namespace support in the RDMA-CM
Date: Thu, 19 Mar 2015 17:14:30 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237399E82269@ORSMSX109.amr.corp.intel.com>
References: <1423667204-8807-1-git-send-email-raindel@mellanox.com>
 <54E363E7.5090507@mellanox.com> <550AD952.7060900@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <550AD952.7060900-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > On 02/11/2015 05:06 PM, Shachar Raindel wrote:
> >> RDMA-CM uses IP based addressing and routing to setup RDMA
> >> connections between
> >> hosts. Currently, all of the IP interfaces and addresses used by the
> >> RDMA-CM
> >> must reside in the init_net namespace. This restricts the usage of
> >> containers
> >> with RDMA to only work with host network namespace (aka the kernel
> >> init_net NS
> >> instance).
> >>
> >> This patchset allows using network namespaces with the RDMA-CM.
> >>
> >> Each RDMA-CM and CM id is keeping a reference to a network namespace.
> > [...]
> >
> >
> > Hi Sean,
> >
> > Did you had the chance to look on the patches that do the changes to
> > the cm and cma code?
> >
> 
> Sean, ping... you are the maintainer of the rdma-cm, these patches are
> here for many weeks,  can you please take a look and provide your
> feedback.

I have the patches, but have not had time to look at them in detail at this point.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
